1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 }
589 
590 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Contract module that helps prevent reentrant calls to a function.
599  *
600  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
601  * available, which can be applied to functions to make sure there are no nested
602  * (reentrant) calls to them.
603  *
604  * Note that because there is a single `nonReentrant` guard, functions marked as
605  * `nonReentrant` may not call one another. This can be worked around by making
606  * those functions `private`, and then adding `external` `nonReentrant` entry
607  * points to them.
608  *
609  * TIP: If you would like to learn more about reentrancy and alternative ways
610  * to protect against it, check out our blog post
611  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
612  */
613 abstract contract ReentrancyGuard {
614     // Booleans are more expensive than uint256 or any type that takes up a full
615     // word because each write operation emits an extra SLOAD to first read the
616     // slot's contents, replace the bits taken up by the boolean, and then write
617     // back. This is the compiler's defense against contract upgrades and
618     // pointer aliasing, and it cannot be disabled.
619 
620     // The values being non-zero value makes deployment a bit more expensive,
621     // but in exchange the refund on every call to nonReentrant will be lower in
622     // amount. Since refunds are capped to a percentage of the total
623     // transaction's gas, it is best to keep them low in cases like this one, to
624     // increase the likelihood of the full refund coming into effect.
625     uint256 private constant _NOT_ENTERED = 1;
626     uint256 private constant _ENTERED = 2;
627 
628     uint256 private _status;
629 
630     constructor() {
631         _status = _NOT_ENTERED;
632     }
633 
634     /**
635      * @dev Prevents a contract from calling itself, directly or indirectly.
636      * Calling a `nonReentrant` function from another `nonReentrant`
637      * function is not supported. It is possible to prevent this from happening
638      * by making the `nonReentrant` function external, and making it call a
639      * `private` function that does the actual work.
640      */
641     modifier nonReentrant() {
642         // On the first call to nonReentrant, _notEntered will be true
643         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
644 
645         // Any calls to nonReentrant after this point will fail
646         _status = _ENTERED;
647 
648         _;
649 
650         // By storing the original value once again, a refund is triggered (see
651         // https://eips.ethereum.org/EIPS/eip-2200)
652         _status = _NOT_ENTERED;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/Context.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Provides information about the current execution context, including the
665  * sender of the transaction and its data. While these are generally available
666  * via msg.sender and msg.data, they should not be accessed in such a direct
667  * manner, since when dealing with meta-transactions the account sending and
668  * paying for execution may not be the actual sender (as far as an application
669  * is concerned).
670  *
671  * This contract is only required for intermediate, library-like contracts.
672  */
673 abstract contract Context {
674     function _msgSender() internal view virtual returns (address) {
675         return msg.sender;
676     }
677 
678     function _msgData() internal view virtual returns (bytes calldata) {
679         return msg.data;
680     }
681 }
682 
683 // File: @openzeppelin/contracts/access/Ownable.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev Contract module which provides a basic access control mechanism, where
693  * there is an account (an owner) that can be granted exclusive access to
694  * specific functions.
695  *
696  * By default, the owner account will be the one that deploys the contract. This
697  * can later be changed with {transferOwnership}.
698  *
699  * This module is used through inheritance. It will make available the modifier
700  * `onlyOwner`, which can be applied to your functions to restrict their use to
701  * the owner.
702  */
703 abstract contract Ownable is Context {
704     address private _owner;
705 
706     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
707 
708     /**
709      * @dev Initializes the contract setting the deployer as the initial owner.
710      */
711     constructor() {
712         _transferOwnership(_msgSender());
713     }
714 
715     /**
716      * @dev Returns the address of the current owner.
717      */
718     function owner() public view virtual returns (address) {
719         return _owner;
720     }
721 
722     /**
723      * @dev Throws if called by any account other than the owner.
724      */
725     modifier onlyOwner() {
726         require(owner() == _msgSender(), "Ownable: caller is not the owner");
727         _;
728     }
729 
730     /**
731      * @dev Leaves the contract without owner. It will not be possible to call
732      * `onlyOwner` functions anymore. Can only be called by the current owner.
733      *
734      * NOTE: Renouncing ownership will leave the contract without an owner,
735      * thereby removing any functionality that is only available to the owner.
736      */
737     function renounceOwnership() public virtual onlyOwner {
738         _transferOwnership(address(0));
739     }
740 
741     /**
742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
743      * Can only be called by the current owner.
744      */
745     function transferOwnership(address newOwner) public virtual onlyOwner {
746         require(newOwner != address(0), "Ownable: new owner is the zero address");
747         _transferOwnership(newOwner);
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Internal function without access restriction.
753      */
754     function _transferOwnership(address newOwner) internal virtual {
755         address oldOwner = _owner;
756         _owner = newOwner;
757         emit OwnershipTransferred(oldOwner, newOwner);
758     }
759 }
760 
761 // File: contracts/ERC721E.sol
762 
763 
764 
765 pragma solidity ^0.8.12;
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 error AllOwnershipsHaveBeenSet();
777 error QuantityMustBeNonZero();
778 error NoTokensMintedYet();
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
785  *
786  * Does not support burning tokens to address(0).
787  *
788  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
789  */
790 contract ERC721E is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
791     using Address for address;
792     using Strings for uint256;
793     uint96 royaltyFeesInBips;
794     address royaltyReceiver;
795     string public contractURI;
796 
797     struct TokenOwnership {
798         address addr;
799         uint64 startTimestamp;
800     }
801 
802     struct AddressData {
803         uint128 balance;
804         uint128 numberMinted;
805     }
806 
807     uint256 internal currentIndex;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     constructor(string memory name_, string memory symbol_, uint96 _royaltyFeesInBips, string memory _contractURI) {
829         _name = name_;
830         _symbol = symbol_;
831         royaltyFeesInBips = _royaltyFeesInBips;
832         contractURI = _contractURI;
833         royaltyReceiver = msg.sender;
834     }
835 
836     modifier callerIsUser() {
837         require(tx.origin == msg.sender, "The caller is another contract");
838         _;
839     }
840 
841     /**
842      * @dev See {IERC721Enumerable-totalSupply}.
843      */
844     function totalSupply() public view override returns (uint256) {
845         return currentIndex;
846     }
847 
848     /**
849      * @dev See {IERC721Enumerable-tokenByIndex}.
850      */
851     function tokenByIndex(uint256 index) public view override returns (uint256) {
852         require(index < totalSupply(), 'ERC721E: global index out of bounds');
853         return index;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
858      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
859      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
860      */
861     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
862         require(index < balanceOf(owner), 'ERC721E: owner index out of bounds');
863         uint256 numMintedSoFar = totalSupply();
864         uint256 tokenIdsIdx;
865         address currOwnershipAddr = address(0);
866         for (uint256 i = 0; i < numMintedSoFar; i++) {
867             TokenOwnership memory ownership = _ownerships[i];
868             if (ownership.addr != address(0)) {
869                 currOwnershipAddr = ownership.addr;
870             }
871             if (currOwnershipAddr == owner) {
872                 if (tokenIdsIdx == index) {
873                     return i;
874                 }
875                 tokenIdsIdx++;
876             }
877         }
878         revert('ERC721E: unable to get token of owner by index');
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      */
884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             interfaceId == type(IERC721Enumerable).interfaceId ||
889             interfaceId == 0x2a55205a ||
890             super.supportsInterface(interfaceId);
891     }
892 
893     /**
894      * @dev See {IERC721-balanceOf}.
895      */
896     function balanceOf(address owner) public view override returns (uint256) {
897         require(owner != address(0), 'ERC721E: balance query for the zero address');
898         return uint256(_addressData[owner].balance);
899     }
900 
901     function _numberMinted(address owner) internal view returns (uint256) {
902         require(owner != address(0), 'ERC721E: number minted query for the zero address');
903         return uint256(_addressData[owner].numberMinted);
904     }
905 
906     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
907         require(_exists(tokenId), 'ERC721E: owner query for nonexistent token');
908 
909         for (uint256 curr = tokenId; ; curr--) {
910             TokenOwnership memory ownership = _ownerships[curr];
911             if (ownership.addr != address(0)) {
912                 return ownership;
913             }
914         }
915 
916         revert('ERC721E: unable to determine the owner of token');
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view override returns (address) {
923         return ownershipOf(tokenId).addr;
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
944         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
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
963         address owner = ERC721E.ownerOf(tokenId);
964         require(to != owner, 'ERC721E: approval to current owner');
965 
966         require(
967             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
968             'ERC721E: approve caller is not owner nor approved for all'
969         );
970 
971         _approve(to, tokenId, owner);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view override returns (address) {
978         require(_exists(tokenId), 'ERC721E: approved query for nonexistent token');
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved) public override {
987         require(operator != _msgSender(), 'ERC721E: approve to caller');
988 
989         _operatorApprovals[_msgSender()][operator] = approved;
990         emit ApprovalForAll(_msgSender(), operator, approved);
991     }
992 
993     /**
994      * @dev See {IERC721-isApprovedForAll}.
995      */
996     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
997         return _operatorApprovals[owner][operator];
998     }
999 
1000     /**
1001      * @dev See {IERC721-transferFrom}.
1002      */
1003     function transferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public override {
1008         _transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public override {
1019         safeTransferFrom(from, to, tokenId, '');
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public override {
1031         _transfer(from, to, tokenId);
1032         require(
1033             _checkOnERC721Received(from, to, tokenId, _data),
1034             'ERC721E: transfer to non ERC721Receiver implementer'
1035         );
1036     }
1037 
1038     /**
1039      * @dev Returns whether `tokenId` exists.
1040      *
1041      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1042      *
1043      * Tokens start existing when they are minted (`_mint`),
1044      */
1045     function _exists(uint256 tokenId) internal view returns (bool) {
1046         return tokenId < currentIndex;
1047     }
1048 
1049     function _safeMint(address to, uint256 quantity) internal {
1050         _safeMint(to, quantity, '');
1051     }
1052 
1053     /**
1054      * @dev Mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `quantity` cannot be larger than the max batch size.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 quantity,
1066         bytes memory _data
1067     ) internal {
1068         uint256 startTokenId = currentIndex;
1069         require(to != address(0), 'ERC721E: mint to the zero address');
1070         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1071         require(!_exists(startTokenId), 'ERC721E: token already minted');
1072         require(quantity > 0, 'ERC721E: quantity must be greater 0');
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         _addressData[to].balance += uint128(quantity);
1077         _addressData[to].numberMinted += uint128(quantity);
1078 
1079         _ownerships[startTokenId].addr = to;
1080         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1081 
1082         uint256 updatedIndex = startTokenId;
1083 
1084         for (uint256 i = 0; i < quantity; i++) {
1085             emit Transfer(address(0), to, updatedIndex);
1086             require(
1087                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1088                 'ERC721E: transfer to non ERC721Receiver implementer'
1089             );
1090             updatedIndex++;
1091         }
1092 
1093         currentIndex = updatedIndex;
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1113 
1114         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1115             getApproved(tokenId) == _msgSender() ||
1116             isApprovedForAll(prevOwnership.addr, _msgSender()));
1117 
1118         require(isApprovedOrOwner, 'ERC721E: transfer caller is not owner nor approved');
1119 
1120         require(prevOwnership.addr == from, 'ERC721E: transfer from incorrect owner');
1121         require(to != address(0), 'ERC721E: transfer to the zero address');
1122 
1123         _beforeTokenTransfers(from, to, tokenId, 1);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId, prevOwnership.addr);
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         unchecked {
1131             _addressData[from].balance -= 1;
1132             _addressData[to].balance += 1;
1133         }
1134 
1135         _ownerships[tokenId].addr = to;
1136         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1137 
1138         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1139         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1140         uint256 nextTokenId = tokenId + 1;
1141         if (_ownerships[nextTokenId].addr == address(0)) {
1142             if (_exists(nextTokenId)) {
1143                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1144                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1145             }
1146         }
1147 
1148         emit Transfer(from, to, tokenId);
1149         _afterTokenTransfers(from, to, tokenId, 1);
1150     }
1151 
1152     /**
1153      * @dev Approve `to` to operate on `tokenId`
1154      *
1155      * Emits a {Approval} event.
1156      */
1157     function _approve(
1158         address to,
1159         uint256 tokenId,
1160         address owner
1161     ) private {
1162         _tokenApprovals[tokenId] = to;
1163         emit Approval(owner, to, tokenId);
1164     }
1165 
1166     uint256 public nextOwnerToExplicitlySet;
1167 
1168     /**
1169      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1170      */
1171     function _setOwnersExplicit(uint256 quantity) internal {
1172         require(quantity > 0, 'quantity must be greater than zero');
1173         require(currentIndex > 0, 'no tokens minted yet');
1174         require(nextOwnerToExplicitlySet < currentIndex, 'all ownerships have been set');
1175 
1176         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1177         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1178         // Set the end index to be the last token index
1179         if (endIndex > currentIndex - 1) {
1180             endIndex = currentIndex - 1;
1181         }
1182 
1183         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1184             if (_ownerships[i].addr == address(0)) {
1185                 TokenOwnership memory ownership = ownershipOf(i);
1186                 _ownerships[i].addr = ownership.addr;
1187                 _ownerships[i].startTimestamp = ownership.startTimestamp;
1188             }
1189         }
1190         nextOwnerToExplicitlySet = endIndex + 1;
1191     }   
1192 
1193     /**
1194      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1195      * The call is not executed if the target address is not a contract.
1196      *
1197      * @param from address representing the previous owner of the given token ID
1198      * @param to target address that will receive the tokens
1199      * @param tokenId uint256 ID of the token to be transferred
1200      * @param _data bytes optional data to send along with the call
1201      * @return bool whether the call correctly returned the expected magic value
1202      */
1203     function _checkOnERC721Received(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) private returns (bool) {
1209         if (to.isContract()) {
1210             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1211                 return retval == IERC721Receiver(to).onERC721Received.selector;
1212             } catch (bytes memory reason) {
1213                 if (reason.length == 0) {
1214                     revert('ERC721E: transfer to non ERC721Receiver implementer');
1215                 } else {
1216                     assembly {
1217                         revert(add(32, reason), mload(reason))
1218                     }
1219                 }
1220             }
1221         } else {
1222             return true;
1223         }
1224     }
1225 
1226     /**
1227      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1228      *
1229      * startTokenId - the first token id to be transferred
1230      * quantity - the amount to be transferred
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      */
1238     function _beforeTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1247      * minting.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _afterTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 
1264     address public signerAddress;
1265 
1266   /*
1267    * @dev Requires msg.sender to have valid access message.
1268    * @param _v ECDSA signature parameter v.
1269    * @param _r ECDSA signature parameters r.
1270    * @param _s ECDSA signature parameters s.
1271    */
1272   modifier onlyValidAccess(
1273       bytes32 _r,
1274       bytes32 _s,
1275       uint8 _v
1276   ) {
1277       require(isValidAccessMessage(msg.sender, _r, _s, _v));
1278       _;
1279   }
1280 
1281   function setSignerAddress(address newAddress) external onlyOwner {
1282       signerAddress = newAddress;
1283   }
1284 
1285   /*
1286    * @dev Verifies if message was signed by owner to give access to _add for this contract.
1287    *      Assumes Geth signature prefix.
1288    * @param _add Address of agent with access
1289    * @param _v ECDSA signature parameter v.
1290    * @param _r ECDSA signature parameters r.
1291    * @param _s ECDSA signature parameters s.
1292    * @return Validity of access message for a given address.
1293    */
1294   function isValidAccessMessage(
1295       address _add,
1296       bytes32 _r,
1297       bytes32 _s,
1298       uint8 _v
1299   ) public view returns (bool) {
1300       bytes32 digest = keccak256(abi.encode(2, _add));
1301       address signer = ecrecover(digest, _v, _r, _s);
1302       require(signer != address(0), 'ECDSA: invalid signature'); // Added check for zero address
1303       require(signerAddress == signer, "Signature does not match");
1304 	  return signer == signerAddress;
1305   }
1306 
1307   function royaltyInfo(
1308         uint256 _tokenId,
1309         uint256 _salePrice
1310     ) external view returns (
1311         address receiver,
1312         uint256 royaltyAmount
1313     ) {
1314         return (royaltyReceiver, calculateRoyalty(_salePrice)); 
1315     }
1316 
1317   function calculateRoyalty(uint256 _salePrice) view public returns (uint256) {
1318       return (_salePrice / 10000) * royaltyFeesInBips;
1319   }
1320 
1321   function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1322       royaltyReceiver = _receiver;
1323       royaltyFeesInBips = _royaltyFeesInBips;
1324   }
1325 
1326   function setContractURI(string calldata _contractURI) public onlyOwner {
1327       contractURI = _contractURI;
1328   }
1329 }
1330 
1331 // File: contracts/Eloms.sol
1332 
1333 
1334 
1335 //     ▄████████  ▄█        ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████ 
1336 //    ███    ███ ███       ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ 
1337 //    ███    █▀  ███       ███    ███ ███   ███   ███   ███    █▀  
1338 //   ▄███▄▄▄     ███       ███    ███ ███   ███   ███   ███        
1339 //  ▀▀███▀▀▀     ███       ███    ███ ███   ███   ███ ▀███████████ 
1340 //    ███    █▄  ███       ███    ███ ███   ███   ███          ███ 
1341 //    ███    ███ ███▌    ▄ ███    ███ ███   ███   ███    ▄█    ███ 
1342 //    ██████████ █████▄▄██  ▀██████▀   ▀█   ███   █▀   ▄████████▀  
1343 //               ▀                                                 
1344 
1345 pragma solidity ^0.8.12;
1346 
1347 
1348 
1349 
1350 
1351 contract Eloms is ERC721E, ReentrancyGuard {
1352   using Strings for uint256;
1353   string public provenanceHash;
1354   string private _baseTokenURI;
1355 
1356 
1357   // Sale Params
1358   uint256 public tokensMaxPerTx = 2;
1359   uint256 public tokensMaxPerWallet = 2;
1360   uint256 public tokensReserved = 420;
1361   uint256 public tokensMaxSupply = 4420;
1362   uint256 public cost = 0 ether;
1363   bool public isPublicSaleActive = false;
1364 
1365   constructor() ERC721E("Eloms", "ELOMS", 750, "https://elomsmetadata.s3.us-east-2.amazonaws.com/contractURI.json") {
1366   }
1367 
1368   function mintElom(uint256 quantity) external payable nonReentrant {
1369     require(quantity > 0, "QUANTITY SHOULD BE MORE THAN 0");
1370     require(isPublicSaleActive, "PUBLIC SALE NOT ACTIVE");
1371     require(quantity + numberMinted(msg.sender) <= tokensMaxPerWallet, "EXCEEDING MAX TOKENS PER WALLET");
1372     require(totalSupply() + quantity + tokensReserved <= tokensMaxSupply, "EXCEEDING MAX SUPPLY");
1373     require(msg.value >= cost * quantity, "INSUFFICIENT ETH");
1374     _safeMint(msg.sender, quantity, "");
1375   }
1376 
1377   function TeamMint(address[] calldata recipient, uint[] calldata quantity) external onlyOwner{
1378     require(recipient.length == quantity.length, "RECIPIENT AND QUANTITY NOT EQUAL LENGTH");
1379     uint256 totalQuantity = 0;
1380     for(uint256 i; i < quantity.length; i++){
1381       totalQuantity += quantity[i];
1382     }
1383     require(totalQuantity <= tokensReserved, "EXCEEDING REMAINING RESERVED SUPPLY");
1384     require(totalQuantity + totalSupply()  <= tokensMaxSupply, "EXCEEDING MAX SUPPLY");
1385     for(uint256 i; i < recipient.length; i++){
1386       tokensReserved -= quantity[i];
1387       _safeMint(recipient[i], quantity[i], "");
1388     }
1389   }
1390 
1391   // Withdrawal functions
1392   function emergencyWithdraw() external onlyOwner {
1393     address w1 = payable(0x2A03b32C24c40B435C65933ee574424Aa86b92AE);
1394     (bool success, ) = w1.call{value: address(this).balance}("");
1395     require(success, "Transaction Unsuccessful");
1396   }
1397 
1398   // Token URI
1399   function _baseURI() internal view virtual override returns (string memory) {
1400     return _baseTokenURI;
1401   }
1402 
1403   function setBaseURI(string calldata baseURI) external onlyOwner {
1404     _baseTokenURI = baseURI;
1405   }
1406 
1407   // Getters
1408   function numberMinted(address owner) public view returns (uint256) {
1409     return _numberMinted(owner);
1410   }
1411   
1412   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1413     return ownershipOf(tokenId);
1414   }
1415 
1416   // Setters
1417   function settokensReserved(uint256 _newMax) external onlyOwner {
1418     tokensReserved = _newMax;
1419   }
1420 
1421   function settokensMaxPerWallet(uint256 _newMax) external onlyOwner {
1422     tokensMaxPerWallet = _newMax;
1423   }
1424 
1425   function settokensMaxSupply(uint256 _newMax) external onlyOwner {
1426     tokensMaxSupply = _newMax;
1427   }
1428 
1429   function setPublicSaleStatus(bool _newState) public onlyOwner {
1430     isPublicSaleActive = _newState;
1431   }
1432 
1433   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1434     _setOwnersExplicit(quantity);
1435   }
1436 
1437   receive() external payable {}
1438   fallback() external payable {}
1439 }