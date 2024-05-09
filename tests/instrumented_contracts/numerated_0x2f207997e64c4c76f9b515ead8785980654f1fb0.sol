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
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         _checkOwner();
209         _;
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if the sender is not the owner.
221      */
222     function _checkOwner() internal view virtual {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/security/Pausable.sol
258 
259 
260 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 
265 /**
266  * @dev Contract module which allows children to implement an emergency stop
267  * mechanism that can be triggered by an authorized account.
268  *
269  * This module is used through inheritance. It will make available the
270  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
271  * the functions of your contract. Note that they will not be pausable by
272  * simply including this module, only once the modifiers are put in place.
273  */
274 abstract contract Pausable is Context {
275     /**
276      * @dev Emitted when the pause is triggered by `account`.
277      */
278     event Paused(address account);
279 
280     /**
281      * @dev Emitted when the pause is lifted by `account`.
282      */
283     event Unpaused(address account);
284 
285     bool private _paused;
286 
287     /**
288      * @dev Initializes the contract in unpaused state.
289      */
290     constructor() {
291         _paused = false;
292     }
293 
294     /**
295      * @dev Modifier to make a function callable only when the contract is not paused.
296      *
297      * Requirements:
298      *
299      * - The contract must not be paused.
300      */
301     modifier whenNotPaused() {
302         _requireNotPaused();
303         _;
304     }
305 
306     /**
307      * @dev Modifier to make a function callable only when the contract is paused.
308      *
309      * Requirements:
310      *
311      * - The contract must be paused.
312      */
313     modifier whenPaused() {
314         _requirePaused();
315         _;
316     }
317 
318     /**
319      * @dev Returns true if the contract is paused, and false otherwise.
320      */
321     function paused() public view virtual returns (bool) {
322         return _paused;
323     }
324 
325     /**
326      * @dev Throws if the contract is paused.
327      */
328     function _requireNotPaused() internal view virtual {
329         require(!paused(), "Pausable: paused");
330     }
331 
332     /**
333      * @dev Throws if the contract is not paused.
334      */
335     function _requirePaused() internal view virtual {
336         require(paused(), "Pausable: not paused");
337     }
338 
339     /**
340      * @dev Triggers stopped state.
341      *
342      * Requirements:
343      *
344      * - The contract must not be paused.
345      */
346     function _pause() internal virtual whenNotPaused {
347         _paused = true;
348         emit Paused(_msgSender());
349     }
350 
351     /**
352      * @dev Returns to normal state.
353      *
354      * Requirements:
355      *
356      * - The contract must be paused.
357      */
358     function _unpause() internal virtual whenPaused {
359         _paused = false;
360         emit Unpaused(_msgSender());
361     }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Address.sol
365 
366 
367 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
368 
369 pragma solidity ^0.8.1;
370 
371 /**
372  * @dev Collection of functions related to the address type
373  */
374 library Address {
375     /**
376      * @dev Returns true if `account` is a contract.
377      *
378      * [IMPORTANT]
379      * ====
380      * It is unsafe to assume that an address for which this function returns
381      * false is an externally-owned account (EOA) and not a contract.
382      *
383      * Among others, `isContract` will return false for the following
384      * types of addresses:
385      *
386      *  - an externally-owned account
387      *  - a contract in construction
388      *  - an address where a contract will be created
389      *  - an address where a contract lived, but was destroyed
390      * ====
391      *
392      * [IMPORTANT]
393      * ====
394      * You shouldn't rely on `isContract` to protect against flash loan attacks!
395      *
396      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
397      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
398      * constructor.
399      * ====
400      */
401     function isContract(address account) internal view returns (bool) {
402         // This method relies on extcodesize/address.code.length, which returns 0
403         // for contracts in construction, since the code is only stored at the end
404         // of the constructor execution.
405 
406         return account.code.length > 0;
407     }
408 
409     /**
410      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
411      * `recipient`, forwarding all available gas and reverting on errors.
412      *
413      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
414      * of certain opcodes, possibly making contracts go over the 2300 gas limit
415      * imposed by `transfer`, making them unable to receive funds via
416      * `transfer`. {sendValue} removes this limitation.
417      *
418      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
419      *
420      * IMPORTANT: because control is transferred to `recipient`, care must be
421      * taken to not create reentrancy vulnerabilities. Consider using
422      * {ReentrancyGuard} or the
423      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
424      */
425     function sendValue(address payable recipient, uint256 amount) internal {
426         require(address(this).balance >= amount, "Address: insufficient balance");
427 
428         (bool success, ) = recipient.call{value: amount}("");
429         require(success, "Address: unable to send value, recipient may have reverted");
430     }
431 
432     /**
433      * @dev Performs a Solidity function call using a low level `call`. A
434      * plain `call` is an unsafe replacement for a function call: use this
435      * function instead.
436      *
437      * If `target` reverts with a revert reason, it is bubbled up by this
438      * function (like regular Solidity function calls).
439      *
440      * Returns the raw returned data. To convert to the expected return value,
441      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
442      *
443      * Requirements:
444      *
445      * - `target` must be a contract.
446      * - calling `target` with `data` must not revert.
447      *
448      * _Available since v3.1._
449      */
450     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionCall(target, data, "Address: low-level call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
456      * `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         return functionCallWithValue(target, data, 0, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but also transferring `value` wei to `target`.
471      *
472      * Requirements:
473      *
474      * - the calling contract must have an ETH balance of at least `value`.
475      * - the called Solidity function must be `payable`.
476      *
477      * _Available since v3.1._
478      */
479     function functionCallWithValue(
480         address target,
481         bytes memory data,
482         uint256 value
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
489      * with `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 value,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         require(address(this).balance >= value, "Address: insufficient balance for call");
500         require(isContract(target), "Address: call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.call{value: value}(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
513         return functionStaticCall(target, data, "Address: low-level static call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a static call.
519      *
520      * _Available since v3.3._
521      */
522     function functionStaticCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal view returns (bytes memory) {
527         require(isContract(target), "Address: static call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.staticcall(data);
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but performing a delegate call.
536      *
537      * _Available since v3.4._
538      */
539     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         require(isContract(target), "Address: delegate call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.delegatecall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
562      * revert reason using the provided one.
563      *
564      * _Available since v4.3._
565      */
566     function verifyCallResult(
567         bool success,
568         bytes memory returndata,
569         string memory errorMessage
570     ) internal pure returns (bytes memory) {
571         if (success) {
572             return returndata;
573         } else {
574             // Look for revert reason and bubble it up if present
575             if (returndata.length > 0) {
576                 // The easiest way to bubble the revert reason is using memory via assembly
577                 /// @solidity memory-safe-assembly
578                 assembly {
579                     let returndata_size := mload(returndata)
580                     revert(add(32, returndata), returndata_size)
581                 }
582             } else {
583                 revert(errorMessage);
584             }
585         }
586     }
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
590 
591 
592 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @title ERC721 token receiver interface
598  * @dev Interface for any contract that wants to support safeTransfers
599  * from ERC721 asset contracts.
600  */
601 interface IERC721Receiver {
602     /**
603      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
604      * by `operator` from `from`, this function is called.
605      *
606      * It must return its Solidity selector to confirm the token transfer.
607      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
608      *
609      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
610      */
611     function onERC721Received(
612         address operator,
613         address from,
614         uint256 tokenId,
615         bytes calldata data
616     ) external returns (bytes4);
617 }
618 
619 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Interface of the ERC165 standard, as defined in the
628  * https://eips.ethereum.org/EIPS/eip-165[EIP].
629  *
630  * Implementers can declare support of contract interfaces, which can then be
631  * queried by others ({ERC165Checker}).
632  *
633  * For an implementation, see {ERC165}.
634  */
635 interface IERC165 {
636     /**
637      * @dev Returns true if this contract implements the interface defined by
638      * `interfaceId`. See the corresponding
639      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
640      * to learn more about how these ids are created.
641      *
642      * This function call must use less than 30 000 gas.
643      */
644     function supportsInterface(bytes4 interfaceId) external view returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Implementation of the {IERC165} interface.
657  *
658  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
659  * for the additional interface id that will be supported. For example:
660  *
661  * ```solidity
662  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
664  * }
665  * ```
666  *
667  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
668  */
669 abstract contract ERC165 is IERC165 {
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674         return interfaceId == type(IERC165).interfaceId;
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Required interface of an ERC721 compliant contract.
688  */
689 interface IERC721 is IERC165 {
690     /**
691      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
692      */
693     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
694 
695     /**
696      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
697      */
698     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
699 
700     /**
701      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
702      */
703     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
704 
705     /**
706      * @dev Returns the number of tokens in ``owner``'s account.
707      */
708     function balanceOf(address owner) external view returns (uint256 balance);
709 
710     /**
711      * @dev Returns the owner of the `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function ownerOf(uint256 tokenId) external view returns (address owner);
718 
719     /**
720      * @dev Safely transfers `tokenId` token from `from` to `to`.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must exist and be owned by `from`.
727      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId,
736         bytes calldata data
737     ) external;
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
741      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759     /**
760      * @dev Transfers `tokenId` token from `from` to `to`.
761      *
762      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      *
771      * Emits a {Transfer} event.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) external;
778 
779     /**
780      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
781      * The approval is cleared when the token is transferred.
782      *
783      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
784      *
785      * Requirements:
786      *
787      * - The caller must own the token or be an approved operator.
788      * - `tokenId` must exist.
789      *
790      * Emits an {Approval} event.
791      */
792     function approve(address to, uint256 tokenId) external;
793 
794     /**
795      * @dev Approve or remove `operator` as an operator for the caller.
796      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
797      *
798      * Requirements:
799      *
800      * - The `operator` cannot be the caller.
801      *
802      * Emits an {ApprovalForAll} event.
803      */
804     function setApprovalForAll(address operator, bool _approved) external;
805 
806     /**
807      * @dev Returns the account approved for `tokenId` token.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function getApproved(uint256 tokenId) external view returns (address operator);
814 
815     /**
816      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
817      *
818      * See {setApprovalForAll}
819      */
820     function isApprovedForAll(address owner, address operator) external view returns (bool);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
824 
825 
826 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
833  * @dev See https://eips.ethereum.org/EIPS/eip-721
834  */
835 interface IERC721Enumerable is IERC721 {
836     /**
837      * @dev Returns the total amount of tokens stored by the contract.
838      */
839     function totalSupply() external view returns (uint256);
840 
841     /**
842      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
843      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
844      */
845     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
846 
847     /**
848      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
849      * Use along with {totalSupply} to enumerate all tokens.
850      */
851     function tokenByIndex(uint256 index) external view returns (uint256);
852 }
853 
854 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
855 
856 
857 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 
862 /**
863  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
864  * @dev See https://eips.ethereum.org/EIPS/eip-721
865  */
866 interface IERC721Metadata is IERC721 {
867     /**
868      * @dev Returns the token collection name.
869      */
870     function name() external view returns (string memory);
871 
872     /**
873      * @dev Returns the token collection symbol.
874      */
875     function symbol() external view returns (string memory);
876 
877     /**
878      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
879      */
880     function tokenURI(uint256 tokenId) external view returns (string memory);
881 }
882 
883 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
884 
885 
886 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
887 
888 pragma solidity ^0.8.0;
889 
890 
891 
892 
893 
894 
895 
896 
897 /**
898  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
899  * the Metadata extension, but not including the Enumerable extension, which is available separately as
900  * {ERC721Enumerable}.
901  */
902 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
903     using Address for address;
904     using Strings for uint256;
905 
906     // Token name
907     string private _name;
908 
909     // Token symbol
910     string private _symbol;
911 
912     // Mapping from token ID to owner address
913     mapping(uint256 => address) private _owners;
914 
915     // Mapping owner address to token count
916     mapping(address => uint256) private _balances;
917 
918     // Mapping from token ID to approved address
919     mapping(uint256 => address) private _tokenApprovals;
920 
921     // Mapping from owner to operator approvals
922     mapping(address => mapping(address => bool)) private _operatorApprovals;
923 
924     /**
925      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
926      */
927     constructor(string memory name_, string memory symbol_) {
928         _name = name_;
929         _symbol = symbol_;
930     }
931 
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
936         return
937             interfaceId == type(IERC721).interfaceId ||
938             interfaceId == type(IERC721Metadata).interfaceId ||
939             super.supportsInterface(interfaceId);
940     }
941 
942     /**
943      * @dev See {IERC721-balanceOf}.
944      */
945     function balanceOf(address owner) public view virtual override returns (uint256) {
946         require(owner != address(0), "ERC721: address zero is not a valid owner");
947         return _balances[owner];
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
954         address owner = _owners[tokenId];
955         require(owner != address(0), "ERC721: invalid token ID");
956         return owner;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-name}.
961      */
962     function name() public view virtual override returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-symbol}.
968      */
969     function symbol() public view virtual override returns (string memory) {
970         return _symbol;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-tokenURI}.
975      */
976     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
977         _requireMinted(tokenId);
978 
979         string memory baseURI = _baseURI();
980         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
981     }
982 
983     /**
984      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
985      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
986      * by default, can be overridden in child contracts.
987      */
988     function _baseURI() internal view virtual returns (string memory) {
989         return "";
990     }
991 
992     /**
993      * @dev See {IERC721-approve}.
994      */
995     function approve(address to, uint256 tokenId) public virtual override {
996         address owner = ERC721.ownerOf(tokenId);
997         require(to != owner, "ERC721: approval to current owner");
998 
999         require(
1000             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1001             "ERC721: approve caller is not token owner nor approved for all"
1002         );
1003 
1004         _approve(to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-getApproved}.
1009      */
1010     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1011         _requireMinted(tokenId);
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved) public virtual override {
1020         _setApprovalForAll(_msgSender(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-transferFrom}.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         //solhint-disable-next-line max-line-length
1039         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1040 
1041         _transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         safeTransferFrom(from, to, tokenId, "");
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory data
1063     ) public virtual override {
1064         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1065         _safeTransfer(from, to, tokenId, data);
1066     }
1067 
1068     /**
1069      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1070      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1071      *
1072      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1073      *
1074      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1075      * implement alternative mechanisms to perform token transfer, such as signature-based.
1076      *
1077      * Requirements:
1078      *
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must exist and be owned by `from`.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeTransfer(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory data
1091     ) internal virtual {
1092         _transfer(from, to, tokenId);
1093         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1094     }
1095 
1096     /**
1097      * @dev Returns whether `tokenId` exists.
1098      *
1099      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1100      *
1101      * Tokens start existing when they are minted (`_mint`),
1102      * and stop existing when they are burned (`_burn`).
1103      */
1104     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1105         return _owners[tokenId] != address(0);
1106     }
1107 
1108     /**
1109      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      */
1115     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1116         address owner = ERC721.ownerOf(tokenId);
1117         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1118     }
1119 
1120     /**
1121      * @dev Safely mints `tokenId` and transfers it to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must not exist.
1126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _safeMint(address to, uint256 tokenId) internal virtual {
1131         _safeMint(to, tokenId, "");
1132     }
1133 
1134     /**
1135      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1136      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1137      */
1138     function _safeMint(
1139         address to,
1140         uint256 tokenId,
1141         bytes memory data
1142     ) internal virtual {
1143         _mint(to, tokenId);
1144         require(
1145             _checkOnERC721Received(address(0), to, tokenId, data),
1146             "ERC721: transfer to non ERC721Receiver implementer"
1147         );
1148     }
1149 
1150     /**
1151      * @dev Mints `tokenId` and transfers it to `to`.
1152      *
1153      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must not exist.
1158      * - `to` cannot be the zero address.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _mint(address to, uint256 tokenId) internal virtual {
1163         require(to != address(0), "ERC721: mint to the zero address");
1164         require(!_exists(tokenId), "ERC721: token already minted");
1165 
1166         _beforeTokenTransfer(address(0), to, tokenId);
1167 
1168         _balances[to] += 1;
1169         _owners[tokenId] = to;
1170 
1171         emit Transfer(address(0), to, tokenId);
1172 
1173         _afterTokenTransfer(address(0), to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Destroys `tokenId`.
1178      * The approval is cleared when the token is burned.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         address owner = ERC721.ownerOf(tokenId);
1188 
1189         _beforeTokenTransfer(owner, address(0), tokenId);
1190 
1191         // Clear approvals
1192         _approve(address(0), tokenId);
1193 
1194         _balances[owner] -= 1;
1195         delete _owners[tokenId];
1196 
1197         emit Transfer(owner, address(0), tokenId);
1198 
1199         _afterTokenTransfer(owner, address(0), tokenId);
1200     }
1201 
1202     /**
1203      * @dev Transfers `tokenId` from `from` to `to`.
1204      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `tokenId` token must be owned by `from`.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _transfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) internal virtual {
1218         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1219         require(to != address(0), "ERC721: transfer to the zero address");
1220 
1221         _beforeTokenTransfer(from, to, tokenId);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId);
1225 
1226         _balances[from] -= 1;
1227         _balances[to] += 1;
1228         _owners[tokenId] = to;
1229 
1230         emit Transfer(from, to, tokenId);
1231 
1232         _afterTokenTransfer(from, to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev Approve `to` to operate on `tokenId`
1237      *
1238      * Emits an {Approval} event.
1239      */
1240     function _approve(address to, uint256 tokenId) internal virtual {
1241         _tokenApprovals[tokenId] = to;
1242         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1243     }
1244 
1245     /**
1246      * @dev Approve `operator` to operate on all of `owner` tokens
1247      *
1248      * Emits an {ApprovalForAll} event.
1249      */
1250     function _setApprovalForAll(
1251         address owner,
1252         address operator,
1253         bool approved
1254     ) internal virtual {
1255         require(owner != operator, "ERC721: approve to caller");
1256         _operatorApprovals[owner][operator] = approved;
1257         emit ApprovalForAll(owner, operator, approved);
1258     }
1259 
1260     /**
1261      * @dev Reverts if the `tokenId` has not been minted yet.
1262      */
1263     function _requireMinted(uint256 tokenId) internal view virtual {
1264         require(_exists(tokenId), "ERC721: invalid token ID");
1265     }
1266 
1267     /**
1268      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1269      * The call is not executed if the target address is not a contract.
1270      *
1271      * @param from address representing the previous owner of the given token ID
1272      * @param to target address that will receive the tokens
1273      * @param tokenId uint256 ID of the token to be transferred
1274      * @param data bytes optional data to send along with the call
1275      * @return bool whether the call correctly returned the expected magic value
1276      */
1277     function _checkOnERC721Received(
1278         address from,
1279         address to,
1280         uint256 tokenId,
1281         bytes memory data
1282     ) private returns (bool) {
1283         if (to.isContract()) {
1284             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1285                 return retval == IERC721Receiver.onERC721Received.selector;
1286             } catch (bytes memory reason) {
1287                 if (reason.length == 0) {
1288                     revert("ERC721: transfer to non ERC721Receiver implementer");
1289                 } else {
1290                     /// @solidity memory-safe-assembly
1291                     assembly {
1292                         revert(add(32, reason), mload(reason))
1293                     }
1294                 }
1295             }
1296         } else {
1297             return true;
1298         }
1299     }
1300 
1301     /**
1302      * @dev Hook that is called before any token transfer. This includes minting
1303      * and burning.
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` will be minted for `to`.
1310      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1311      * - `from` and `to` are never both zero.
1312      *
1313      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1314      */
1315     function _beforeTokenTransfer(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) internal virtual {}
1320 
1321     /**
1322      * @dev Hook that is called after any transfer of tokens. This includes
1323      * minting and burning.
1324      *
1325      * Calling conditions:
1326      *
1327      * - when `from` and `to` are both non-zero.
1328      * - `from` and `to` are never both zero.
1329      *
1330      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1331      */
1332     function _afterTokenTransfer(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) internal virtual {}
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1340 
1341 
1342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 
1348 /**
1349  * @dev ERC721 token with pausable token transfers, minting and burning.
1350  *
1351  * Useful for scenarios such as preventing trades until the end of an evaluation
1352  * period, or having an emergency switch for freezing all token transfers in the
1353  * event of a large bug.
1354  */
1355 abstract contract ERC721Pausable is ERC721, Pausable {
1356     /**
1357      * @dev See {ERC721-_beforeTokenTransfer}.
1358      *
1359      * Requirements:
1360      *
1361      * - the contract must not be paused.
1362      */
1363     function _beforeTokenTransfer(
1364         address from,
1365         address to,
1366         uint256 tokenId
1367     ) internal virtual override {
1368         super._beforeTokenTransfer(from, to, tokenId);
1369 
1370         require(!paused(), "ERC721Pausable: token transfer while paused");
1371     }
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1375 
1376 
1377 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 
1382 /**
1383  * @dev ERC721 token with storage based token URI management.
1384  */
1385 abstract contract ERC721URIStorage is ERC721 {
1386     using Strings for uint256;
1387 
1388     // Optional mapping for token URIs
1389     mapping(uint256 => string) private _tokenURIs;
1390 
1391     /**
1392      * @dev See {IERC721Metadata-tokenURI}.
1393      */
1394     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1395         _requireMinted(tokenId);
1396 
1397         string memory _tokenURI = _tokenURIs[tokenId];
1398         string memory base = _baseURI();
1399 
1400         // If there is no base URI, return the token URI.
1401         if (bytes(base).length == 0) {
1402             return _tokenURI;
1403         }
1404         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1405         if (bytes(_tokenURI).length > 0) {
1406             return string(abi.encodePacked(base, _tokenURI));
1407         }
1408 
1409         return super.tokenURI(tokenId);
1410     }
1411 
1412     /**
1413      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1420         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1421         _tokenURIs[tokenId] = _tokenURI;
1422     }
1423 
1424     /**
1425      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1426      * token-specific URI was set for the token, and if so, it deletes the token URI from
1427      * the storage mapping.
1428      */
1429     function _burn(uint256 tokenId) internal virtual override {
1430         super._burn(tokenId);
1431 
1432         if (bytes(_tokenURIs[tokenId]).length != 0) {
1433             delete _tokenURIs[tokenId];
1434         }
1435     }
1436 }
1437 
1438 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1439 
1440 
1441 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 
1446 
1447 /**
1448  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1449  * enumerability of all the token ids in the contract as well as all token ids owned by each
1450  * account.
1451  */
1452 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1453     // Mapping from owner to list of owned token IDs
1454     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1455 
1456     // Mapping from token ID to index of the owner tokens list
1457     mapping(uint256 => uint256) private _ownedTokensIndex;
1458 
1459     // Array with all token ids, used for enumeration
1460     uint256[] private _allTokens;
1461 
1462     // Mapping from token id to position in the allTokens array
1463     mapping(uint256 => uint256) private _allTokensIndex;
1464 
1465     /**
1466      * @dev See {IERC165-supportsInterface}.
1467      */
1468     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1469         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1474      */
1475     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1476         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1477         return _ownedTokens[owner][index];
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-totalSupply}.
1482      */
1483     function totalSupply() public view virtual override returns (uint256) {
1484         return _allTokens.length;
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Enumerable-tokenByIndex}.
1489      */
1490     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1491         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1492         return _allTokens[index];
1493     }
1494 
1495     /**
1496      * @dev Hook that is called before any token transfer. This includes minting
1497      * and burning.
1498      *
1499      * Calling conditions:
1500      *
1501      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1502      * transferred to `to`.
1503      * - When `from` is zero, `tokenId` will be minted for `to`.
1504      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      *
1508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1509      */
1510     function _beforeTokenTransfer(
1511         address from,
1512         address to,
1513         uint256 tokenId
1514     ) internal virtual override {
1515         super._beforeTokenTransfer(from, to, tokenId);
1516 
1517         if (from == address(0)) {
1518             _addTokenToAllTokensEnumeration(tokenId);
1519         } else if (from != to) {
1520             _removeTokenFromOwnerEnumeration(from, tokenId);
1521         }
1522         if (to == address(0)) {
1523             _removeTokenFromAllTokensEnumeration(tokenId);
1524         } else if (to != from) {
1525             _addTokenToOwnerEnumeration(to, tokenId);
1526         }
1527     }
1528 
1529     /**
1530      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1531      * @param to address representing the new owner of the given token ID
1532      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1533      */
1534     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1535         uint256 length = ERC721.balanceOf(to);
1536         _ownedTokens[to][length] = tokenId;
1537         _ownedTokensIndex[tokenId] = length;
1538     }
1539 
1540     /**
1541      * @dev Private function to add a token to this extension's token tracking data structures.
1542      * @param tokenId uint256 ID of the token to be added to the tokens list
1543      */
1544     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1545         _allTokensIndex[tokenId] = _allTokens.length;
1546         _allTokens.push(tokenId);
1547     }
1548 
1549     /**
1550      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1551      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1552      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1553      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1554      * @param from address representing the previous owner of the given token ID
1555      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1556      */
1557     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1558         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1559         // then delete the last slot (swap and pop).
1560 
1561         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1562         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1563 
1564         // When the token to delete is the last token, the swap operation is unnecessary
1565         if (tokenIndex != lastTokenIndex) {
1566             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1567 
1568             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1569             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1570         }
1571 
1572         // This also deletes the contents at the last position of the array
1573         delete _ownedTokensIndex[tokenId];
1574         delete _ownedTokens[from][lastTokenIndex];
1575     }
1576 
1577     /**
1578      * @dev Private function to remove a token from this extension's token tracking data structures.
1579      * This has O(1) time complexity, but alters the order of the _allTokens array.
1580      * @param tokenId uint256 ID of the token to be removed from the tokens list
1581      */
1582     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1583         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1584         // then delete the last slot (swap and pop).
1585 
1586         uint256 lastTokenIndex = _allTokens.length - 1;
1587         uint256 tokenIndex = _allTokensIndex[tokenId];
1588 
1589         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1590         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1591         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1592         uint256 lastTokenId = _allTokens[lastTokenIndex];
1593 
1594         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1595         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1596 
1597         // This also deletes the contents at the last position of the array
1598         delete _allTokensIndex[tokenId];
1599         _allTokens.pop();
1600     }
1601 }
1602 
1603 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1604 
1605 
1606 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1607 
1608 pragma solidity ^0.8.0;
1609 
1610 /**
1611  * @dev Interface of the ERC20 standard as defined in the EIP.
1612  */
1613 interface IERC20 {
1614     /**
1615      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1616      * another (`to`).
1617      *
1618      * Note that `value` may be zero.
1619      */
1620     event Transfer(address indexed from, address indexed to, uint256 value);
1621 
1622     /**
1623      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1624      * a call to {approve}. `value` is the new allowance.
1625      */
1626     event Approval(address indexed owner, address indexed spender, uint256 value);
1627 
1628     /**
1629      * @dev Returns the amount of tokens in existence.
1630      */
1631     function totalSupply() external view returns (uint256);
1632 
1633     /**
1634      * @dev Returns the amount of tokens owned by `account`.
1635      */
1636     function balanceOf(address account) external view returns (uint256);
1637 
1638     /**
1639      * @dev Moves `amount` tokens from the caller's account to `to`.
1640      *
1641      * Returns a boolean value indicating whether the operation succeeded.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function transfer(address to, uint256 amount) external returns (bool);
1646 
1647     /**
1648      * @dev Returns the remaining number of tokens that `spender` will be
1649      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1650      * zero by default.
1651      *
1652      * This value changes when {approve} or {transferFrom} are called.
1653      */
1654     function allowance(address owner, address spender) external view returns (uint256);
1655 
1656     /**
1657      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1658      *
1659      * Returns a boolean value indicating whether the operation succeeded.
1660      *
1661      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1662      * that someone may use both the old and the new allowance by unfortunate
1663      * transaction ordering. One possible solution to mitigate this race
1664      * condition is to first reduce the spender's allowance to 0 and set the
1665      * desired value afterwards:
1666      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1667      *
1668      * Emits an {Approval} event.
1669      */
1670     function approve(address spender, uint256 amount) external returns (bool);
1671 
1672     /**
1673      * @dev Moves `amount` tokens from `from` to `to` using the
1674      * allowance mechanism. `amount` is then deducted from the caller's
1675      * allowance.
1676      *
1677      * Returns a boolean value indicating whether the operation succeeded.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function transferFrom(
1682         address from,
1683         address to,
1684         uint256 amount
1685     ) external returns (bool);
1686 }
1687 
1688 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1689 
1690 
1691 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1692 
1693 pragma solidity ^0.8.0;
1694 
1695 // CAUTION
1696 // This version of SafeMath should only be used with Solidity 0.8 or later,
1697 // because it relies on the compiler's built in overflow checks.
1698 
1699 /**
1700  * @dev Wrappers over Solidity's arithmetic operations.
1701  *
1702  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1703  * now has built in overflow checking.
1704  */
1705 library SafeMath {
1706     /**
1707      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1708      *
1709      * _Available since v3.4._
1710      */
1711     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1712         unchecked {
1713             uint256 c = a + b;
1714             if (c < a) return (false, 0);
1715             return (true, c);
1716         }
1717     }
1718 
1719     /**
1720      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1721      *
1722      * _Available since v3.4._
1723      */
1724     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1725         unchecked {
1726             if (b > a) return (false, 0);
1727             return (true, a - b);
1728         }
1729     }
1730 
1731     /**
1732      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1733      *
1734      * _Available since v3.4._
1735      */
1736     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1737         unchecked {
1738             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1739             // benefit is lost if 'b' is also tested.
1740             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1741             if (a == 0) return (true, 0);
1742             uint256 c = a * b;
1743             if (c / a != b) return (false, 0);
1744             return (true, c);
1745         }
1746     }
1747 
1748     /**
1749      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1750      *
1751      * _Available since v3.4._
1752      */
1753     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1754         unchecked {
1755             if (b == 0) return (false, 0);
1756             return (true, a / b);
1757         }
1758     }
1759 
1760     /**
1761      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1762      *
1763      * _Available since v3.4._
1764      */
1765     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1766         unchecked {
1767             if (b == 0) return (false, 0);
1768             return (true, a % b);
1769         }
1770     }
1771 
1772     /**
1773      * @dev Returns the addition of two unsigned integers, reverting on
1774      * overflow.
1775      *
1776      * Counterpart to Solidity's `+` operator.
1777      *
1778      * Requirements:
1779      *
1780      * - Addition cannot overflow.
1781      */
1782     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1783         return a + b;
1784     }
1785 
1786     /**
1787      * @dev Returns the subtraction of two unsigned integers, reverting on
1788      * overflow (when the result is negative).
1789      *
1790      * Counterpart to Solidity's `-` operator.
1791      *
1792      * Requirements:
1793      *
1794      * - Subtraction cannot overflow.
1795      */
1796     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1797         return a - b;
1798     }
1799 
1800     /**
1801      * @dev Returns the multiplication of two unsigned integers, reverting on
1802      * overflow.
1803      *
1804      * Counterpart to Solidity's `*` operator.
1805      *
1806      * Requirements:
1807      *
1808      * - Multiplication cannot overflow.
1809      */
1810     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1811         return a * b;
1812     }
1813 
1814     /**
1815      * @dev Returns the integer division of two unsigned integers, reverting on
1816      * division by zero. The result is rounded towards zero.
1817      *
1818      * Counterpart to Solidity's `/` operator.
1819      *
1820      * Requirements:
1821      *
1822      * - The divisor cannot be zero.
1823      */
1824     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1825         return a / b;
1826     }
1827 
1828     /**
1829      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1830      * reverting when dividing by zero.
1831      *
1832      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1833      * opcode (which leaves remaining gas untouched) while Solidity uses an
1834      * invalid opcode to revert (consuming all remaining gas).
1835      *
1836      * Requirements:
1837      *
1838      * - The divisor cannot be zero.
1839      */
1840     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1841         return a % b;
1842     }
1843 
1844     /**
1845      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1846      * overflow (when the result is negative).
1847      *
1848      * CAUTION: This function is deprecated because it requires allocating memory for the error
1849      * message unnecessarily. For custom revert reasons use {trySub}.
1850      *
1851      * Counterpart to Solidity's `-` operator.
1852      *
1853      * Requirements:
1854      *
1855      * - Subtraction cannot overflow.
1856      */
1857     function sub(
1858         uint256 a,
1859         uint256 b,
1860         string memory errorMessage
1861     ) internal pure returns (uint256) {
1862         unchecked {
1863             require(b <= a, errorMessage);
1864             return a - b;
1865         }
1866     }
1867 
1868     /**
1869      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1870      * division by zero. The result is rounded towards zero.
1871      *
1872      * Counterpart to Solidity's `/` operator. Note: this function uses a
1873      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1874      * uses an invalid opcode to revert (consuming all remaining gas).
1875      *
1876      * Requirements:
1877      *
1878      * - The divisor cannot be zero.
1879      */
1880     function div(
1881         uint256 a,
1882         uint256 b,
1883         string memory errorMessage
1884     ) internal pure returns (uint256) {
1885         unchecked {
1886             require(b > 0, errorMessage);
1887             return a / b;
1888         }
1889     }
1890 
1891     /**
1892      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1893      * reverting with custom message when dividing by zero.
1894      *
1895      * CAUTION: This function is deprecated because it requires allocating memory for the error
1896      * message unnecessarily. For custom revert reasons use {tryMod}.
1897      *
1898      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1899      * opcode (which leaves remaining gas untouched) while Solidity uses an
1900      * invalid opcode to revert (consuming all remaining gas).
1901      *
1902      * Requirements:
1903      *
1904      * - The divisor cannot be zero.
1905      */
1906     function mod(
1907         uint256 a,
1908         uint256 b,
1909         string memory errorMessage
1910     ) internal pure returns (uint256) {
1911         unchecked {
1912             require(b > 0, errorMessage);
1913             return a % b;
1914         }
1915     }
1916 }
1917 
1918 // File: @openzeppelin/contracts/utils/Counters.sol
1919 
1920 
1921 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1922 
1923 pragma solidity ^0.8.0;
1924 
1925 /**
1926  * @title Counters
1927  * @author Matt Condon (@shrugs)
1928  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1929  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1930  *
1931  * Include with `using Counters for Counters.Counter;`
1932  */
1933 library Counters {
1934     struct Counter {
1935         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1936         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1937         // this feature: see https://github.com/ethereum/solidity/issues/4637
1938         uint256 _value; // default: 0
1939     }
1940 
1941     function current(Counter storage counter) internal view returns (uint256) {
1942         return counter._value;
1943     }
1944 
1945     function increment(Counter storage counter) internal {
1946         unchecked {
1947             counter._value += 1;
1948         }
1949     }
1950 
1951     function decrement(Counter storage counter) internal {
1952         uint256 value = counter._value;
1953         require(value > 0, "Counter: decrement overflow");
1954         unchecked {
1955             counter._value = value - 1;
1956         }
1957     }
1958 
1959     function reset(Counter storage counter) internal {
1960         counter._value = 0;
1961     }
1962 }
1963 
1964 // File: nft.sol
1965 
1966 
1967 
1968 pragma solidity ^0.8.4;
1969 
1970 
1971 
1972 
1973 
1974 
1975 
1976 
1977 
1978 
1979 
1980 
1981 
1982 interface ILending {
1983 
1984     function mint(uint mintAmount) external returns (uint);
1985 
1986     function redeem(uint redeemTokens) external returns (uint);
1987 
1988     function borrow(uint borrowAmount) external returns (uint);
1989 
1990     function repayBorrow(uint repayAmount) external returns (uint);
1991 
1992     function borrowBalanceCurrent(address account) external returns (uint);
1993 
1994     function balanceOf(address owner) external view returns (uint);
1995 
1996 }
1997 
1998 
1999 
2000 interface IComptroller {
2001 
2002     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
2003 
2004 }
2005 
2006 
2007 
2008 contract Whitelist is Ownable {
2009 
2010     mapping(address => bool) public whitelist;
2011 
2012 
2013 
2014     event WhitelistedAddressAdded(address addr);
2015 
2016     event WhitelistedAddressRemoved(address addr);
2017 
2018 
2019 
2020     modifier onlyWhitelisted() {
2021 
2022         require(whitelist[msg.sender], 'no whitelist');
2023 
2024         _;
2025 
2026     }
2027 
2028 
2029 
2030     function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
2031 
2032         if (!whitelist[addr]) {
2033 
2034             whitelist[addr] = true;
2035 
2036             emit WhitelistedAddressAdded(addr);
2037 
2038             success = true;
2039 
2040         }
2041 
2042     }
2043 
2044 
2045 
2046     function addAddressesToWhitelist(address[] memory addrs) onlyOwner public returns(bool success) {
2047 
2048         for (uint256 i = 0; i < addrs.length; i++) {
2049 
2050             if (addAddressToWhitelist(addrs[i])) {
2051 
2052                 success = true;
2053 
2054             }
2055 
2056         }
2057 
2058         return success;
2059 
2060     }
2061 
2062 
2063 
2064     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
2065 
2066         if (whitelist[addr]) {
2067 
2068             whitelist[addr] = false;
2069 
2070             emit WhitelistedAddressRemoved(addr);
2071 
2072             success = true;
2073 
2074         }
2075 
2076         return success;
2077 
2078     }
2079 
2080 
2081 
2082     function removeAddressesFromWhitelist(address[] memory addrs) onlyOwner public returns(bool success) {
2083 
2084         for (uint256 i = 0; i < addrs.length; i++) {
2085 
2086             if (removeAddressFromWhitelist(addrs[i])) {
2087 
2088                 success = true;
2089 
2090             }
2091 
2092         }
2093 
2094         return success;
2095 
2096     }
2097 
2098 }
2099 
2100 
2101 
2102 contract FeeSplitter is Whitelist {
2103 
2104     using SafeMath for uint256;
2105 
2106 
2107 
2108     /////////////////////////////////
2109 
2110     // CONFIGURABLES AND VARIABLES //
2111 
2112     /////////////////////////////////
2113 
2114 
2115 
2116     mapping (IERC20 => address[]) public feeCollectors;
2117 
2118     mapping (IERC20 => uint256[]) public feeRates;
2119 
2120 
2121 
2122     //////////////////////////////
2123 
2124     // CONSTRUCTOR AND FALLBACK //
2125 
2126     //////////////////////////////
2127 
2128     
2129 
2130     constructor(address _dev) {
2131 
2132         transferOwnership(_dev);
2133 
2134     }
2135 
2136     
2137 
2138     // FALLBACK FUNCTION: PAYABLE
2139 
2140     receive () external payable {
2141 
2142         
2143 
2144     }
2145 
2146 
2147 
2148     // Distribute collected fees between all set collectors, at set rates
2149 
2150     function distribute(IERC20 token) public {
2151 
2152         uint256 balance = token.balanceOf(address(this));
2153 
2154         require (balance > 0, "Nothing to pay");
2155 
2156 
2157 
2158         address[] memory collectors = feeCollectors[token];
2159 
2160         uint256[] memory rates = feeRates[token];
2161 
2162 
2163 
2164         for (uint256 i = 0; i < collectors.length; i++) {
2165 
2166             address collector = collectors[i];
2167 
2168             uint256 rate = rates[i];
2169 
2170 
2171 
2172             if (rate > 0) {
2173 
2174                 uint256 feeAmount = rate * balance / 10000;
2175 
2176                 token.transfer(collector, feeAmount);
2177 
2178             }
2179 
2180         }
2181 
2182     }
2183 
2184 
2185 
2186     ////////////////////////////////////////////////
2187 
2188     // FUNCTIONS RESTRICTED TO THE CONTRACT OWNER //
2189 
2190     ////////////////////////////////////////////////
2191 
2192 
2193 
2194     // Set collectors and rates for a token
2195 
2196     function setDistribution(IERC20 token, address[] memory collectors, uint256[] memory rates) onlyWhitelisted() public {
2197 
2198 
2199 
2200         uint256 totalRate;
2201 
2202 
2203 
2204         for (uint256 i = 0; i < rates.length; i++) {
2205 
2206             totalRate = totalRate + rates[i];
2207 
2208         }
2209 
2210 
2211 
2212         require (totalRate == 10000, "Total fee rate must be 100%");
2213 
2214         
2215 
2216         if (token.balanceOf(address(this)) > 0) {
2217 
2218             distribute(token);
2219 
2220         }
2221 
2222 
2223 
2224         feeCollectors[token] = collectors;
2225 
2226         feeRates[token] = rates;
2227 
2228     }
2229 
2230 }
2231 
2232 
2233 
2234 contract MintableNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Whitelist, ReentrancyGuard {
2235 
2236     using SafeMath for uint256;
2237 
2238     using Strings for uint256;
2239 
2240     using Counters for Counters.Counter;
2241 
2242 
2243 
2244     Counters.Counter private _tokenIds;
2245 
2246 
2247 
2248     ///////////////////////////////
2249 
2250     // CONFIGURABLES & VARIABLES //
2251 
2252     ///////////////////////////////
2253 
2254 
2255 
2256     IERC20 public token;
2257 
2258 
2259 
2260     address public feeSplitter;
2261 
2262 
2263 
2264     bool public initialMinted;
2265 
2266 
2267 
2268     string public baseURI;
2269 
2270     string public baseExtension = ".json";
2271 
2272 
2273 
2274     uint8 public mintablePerUser;
2275 
2276     uint8 public reservedItems;
2277 
2278 
2279 
2280     uint256 public itemPrice;
2281 
2282     uint256 public maxMintableItems;
2283 
2284 
2285 
2286     mapping(address => uint256) public mintedTotalOf;
2287 
2288 
2289 
2290     /////////////////////
2291 
2292     // CONTRACT EVENTS //
2293 
2294     /////////////////////
2295 
2296 
2297 
2298     event onMintItem(address indexed recipient, uint256 itemId, uint256 timestamp);
2299 
2300     event onLaunch(address indexed caller, address indexed recipient, uint256 timestamp);
2301 
2302 
2303 
2304     ////////////////////////////
2305 
2306     // CONSTRUCTOR & FALLBACK //
2307 
2308     ////////////////////////////
2309 
2310 
2311 
2312     constructor(
2313 
2314         string memory _name,
2315 
2316         string memory _symbol,
2317 
2318         address _token, 
2319 
2320         uint8 _reservedItems, 
2321 
2322         uint8 _mintablePerUser,
2323 
2324         uint256 _maxMintableItems, 
2325 
2326         uint256 _pricePerItem,
2327 
2328         string memory _uri
2329 
2330     ) ERC721(_name, _symbol) {
2331 
2332 
2333 
2334         feeSplitter = address(new FeeSplitter(msg.sender));
2335 
2336 
2337 
2338         addAddressToWhitelist(address(0));
2339 
2340         addAddressToWhitelist(msg.sender);
2341 
2342 
2343 
2344         _tokenIds.increment();
2345 
2346 
2347 
2348         token = IERC20(_token);
2349 
2350 
2351 
2352         itemPrice = _pricePerItem;
2353 
2354         reservedItems = _reservedItems;
2355 
2356         mintablePerUser = _mintablePerUser;
2357 
2358         maxMintableItems = _maxMintableItems;
2359 
2360 
2361 
2362         baseURI = _uri;
2363 
2364     }
2365 
2366 
2367 
2368     ////////////////////////////
2369 
2370     // PUBLIC WRITE FUNCTIONS //
2371 
2372     ////////////////////////////
2373 
2374 
2375 
2376     // Mint an NFT, paying Wrapped Ether
2377 
2378     function mintItem() external nonReentrant whenNotPaused returns (uint256 _id) {
2379 
2380         require(initialMinted == true, "ONLY_WHEN_LAUNCHED");
2381 
2382 
2383 
2384         // Find Total Supply of NFTs
2385 
2386         uint256 supply = totalSupply();
2387 
2388         require(supply + 1 <= maxMintableItems, "NFT::LIMIT_REACHED");
2389 
2390 
2391 
2392         // Set Recipient of item
2393 
2394         address _recipient = msg.sender;
2395 
2396 
2397 
2398         // If the caller is not a whitelisted address
2399 
2400         if (!whitelist[_recipient]) {
2401 
2402 
2403 
2404             // Require payment of the mint fee
2405 
2406             require(token.transferFrom(msg.sender, address(feeSplitter), itemPrice), "MUST_PAY_MINT_FEE");
2407 
2408 
2409 
2410             // Enforce item limits
2411 
2412             require(mintedTotalOf[_recipient] + 1 <= mintablePerUser, "MINT_MAX_REACHED");
2413 
2414             
2415 
2416             // Increase minted count for minter
2417 
2418             mintedTotalOf[_recipient]++;
2419 
2420         }
2421 
2422 
2423 
2424         // Get the item ID as it is minted
2425 
2426         uint256 _itemId = mintItem(_recipient);
2427 
2428 
2429 
2430         // Let 'em know!
2431 
2432         emit onMintItem(_recipient, _itemId, block.timestamp);
2433 
2434         return _itemId;
2435 
2436     }
2437 
2438 
2439 
2440     //////////////////////////
2441 
2442     // RESTRICTED FUNCTIONS //
2443 
2444     //////////////////////////
2445 
2446 
2447 
2448     // OWNER: Launch the NFTs
2449 
2450     function launch() public onlyOwner returns (bool _success) {
2451 
2452         require(initialMinted == false, "ONLY_ONCE_ALLOWED");
2453 
2454 
2455 
2456         address _addr = msg.sender;
2457 
2458 
2459 
2460         // Mint the reserved items to the DAO wallet
2461 
2462         for(uint i = 0; i < reservedItems; i++){
2463 
2464             mintItem(_addr);
2465 
2466         }
2467 
2468 
2469 
2470         // Mark function used
2471 
2472         initialMinted = true;
2473 
2474 
2475 
2476         // Let 'em know!
2477 
2478         emit onLaunch(_addr, _addr, block.timestamp);
2479 
2480         return true;
2481 
2482     }
2483 
2484 
2485 
2486     function setMintPrice(uint256 _amount) public onlyOwner returns (bool _success) {
2487 
2488         require(_amount > 0, "INVALID_AMOUNT");
2489 
2490 
2491 
2492         itemPrice = _amount;
2493 
2494 
2495 
2496         return true;
2497 
2498     }
2499 
2500 
2501 
2502     // OWNER: Set Base URI
2503 
2504     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2505 
2506         baseURI = _newBaseURI;
2507 
2508     }
2509 
2510 
2511 
2512     // OWNER: Set URI Extension
2513 
2514     function setURIExtension(string memory _newExtension) public onlyOwner {
2515 
2516         baseExtension = _newExtension;
2517 
2518     }
2519 
2520 
2521 
2522     // OWNER: Pause minting
2523 
2524     function pause() public onlyOwner {
2525 
2526         _pause();
2527 
2528     }
2529 
2530 
2531 
2532     // OWNER: Unpause minting
2533 
2534     function unpause() public onlyOwner {
2535 
2536         _unpause();
2537 
2538     }
2539 
2540 
2541 
2542     ///////////////////////////
2543 
2544     // PUBLIC VIEW FUNCTIONS //
2545 
2546     ///////////////////////////
2547 
2548 
2549 
2550     // Next Mintable Item's tokenId
2551 
2552     function nextItem() public view returns (uint256) {
2553 
2554         return (_tokenIds.current());
2555 
2556     }
2557 
2558 
2559 
2560     // Get mintable items remaining
2561 
2562     function remainingItems() public view returns (uint256) {
2563 
2564         return (maxMintableItems - totalSupply());
2565 
2566     }
2567 
2568 
2569 
2570     // Wallet of NFT Holder
2571 
2572     function itemsOf(address _owner) public view returns (uint256[] memory) {
2573 
2574         uint256 ownerTokenCount = balanceOf(_owner);
2575 
2576         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2577 
2578         
2579 
2580         for (uint256 i; i < ownerTokenCount; i++) {
2581 
2582             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2583 
2584         }
2585 
2586 
2587 
2588         return tokenIds;
2589 
2590     }
2591 
2592 
2593 
2594     // Token URI by Item ID
2595 
2596     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
2597 
2598         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2599 
2600 
2601 
2602         string memory currentBaseURI = _baseURI();
2603 
2604     
2605 
2606         return bytes(currentBaseURI).length > 0
2607 
2608             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2609 
2610             : "";
2611 
2612     }
2613 
2614 
2615 
2616     //////////////////////////////////
2617 
2618     // INTERNAL & PRIVATE FUNCTIONS //
2619 
2620     //////////////////////////////////
2621 
2622 
2623 
2624     // Mint NFT item into collection, providing conditions are met
2625 
2626     function mintItem(address to) internal returns (uint256 tokenId) {
2627 
2628         tokenId = _tokenIds.current();
2629 
2630 
2631 
2632         // Increment token ids
2633 
2634         _tokenIds.increment();
2635 
2636         
2637 
2638         // Mint item
2639 
2640         _safeMint(to, tokenId);
2641 
2642     }
2643 
2644 
2645 
2646     ////////////////////////
2647 
2648     // OVERRIDE FUNCTIONS //
2649 
2650     ////////////////////////
2651 
2652 
2653 
2654     function _baseURI() internal view virtual override returns (string memory) {
2655 
2656         return baseURI;
2657 
2658     }
2659 
2660 
2661 
2662     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
2663 
2664         super._burn(tokenId);
2665 
2666     }
2667 
2668 
2669 
2670     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
2671 
2672         super._beforeTokenTransfer(from, to, tokenId);
2673 
2674     }
2675 
2676 
2677 
2678     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
2679 
2680         return super.supportsInterface(interfaceId);
2681 
2682     }
2683 
2684 }