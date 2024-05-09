1 // SPDX-License-Identifier: MIT
2 
3 
4 // Broke Ape Club Smart Contract. Max 3 free mints per wallet, you can mint more the free claim for 0.004 ETH each!
5 
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Address.sol
77 
78 
79 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
80 
81 pragma solidity ^0.8.1;
82 
83 /**
84  * @dev Collection of functions related to the address type
85  */
86 library Address {
87     /**
88      * @dev Returns true if `account` is a contract.
89      *
90      * [IMPORTANT]
91      * ====
92      * It is unsafe to assume that an address for which this function returns
93      * false is an externally-owned account (EOA) and not a contract.
94      *
95      * Among others, `isContract` will return false for the following
96      * types of addresses:
97      *
98      *  - an externally-owned account
99      *  - a contract in construction
100      *  - an address where a contract will be created
101      *  - an address where a contract lived, but was destroyed
102      * ====
103      *
104      * [IMPORTANT]
105      * ====
106      * You shouldn't rely on `isContract` to protect against flash loan attacks!
107      *
108      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
109      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
110      * constructor.
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize/address.code.length, which returns 0
115         // for contracts in construction, since the code is only stored at the end
116         // of the constructor execution.
117 
118         return account.code.length > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain `call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but also transferring `value` wei to `target`.
183      *
184      * Requirements:
185      *
186      * - the calling contract must have an ETH balance of at least `value`.
187      * - the called Solidity function must be `payable`.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.call{value: value}(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
225         return functionStaticCall(target, data, "Address: low-level static call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.staticcall(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(isContract(target), "Address: delegate call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
274      * revert reason using the provided one.
275      *
276      * _Available since v4.3._
277      */
278     function verifyCallResult(
279         bool success,
280         bytes memory returndata,
281         string memory errorMessage
282     ) internal pure returns (bytes memory) {
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 assembly {
291                     let returndata_size := mload(returndata)
292                     revert(add(32, returndata), returndata_size)
293                 }
294             } else {
295                 revert(errorMessage);
296             }
297         }
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @title ERC721 token receiver interface
310  * @dev Interface for any contract that wants to support safeTransfers
311  * from ERC721 asset contracts.
312  */
313 interface IERC721Receiver {
314     /**
315      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
316      * by `operator` from `from`, this function is called.
317      *
318      * It must return its Solidity selector to confirm the token transfer.
319      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
320      *
321      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
322      */
323     function onERC721Received(
324         address operator,
325         address from,
326         uint256 tokenId,
327         bytes calldata data
328     ) external returns (bytes4);
329 }
330 
331 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC165 standard, as defined in the
340  * https://eips.ethereum.org/EIPS/eip-165[EIP].
341  *
342  * Implementers can declare support of contract interfaces, which can then be
343  * queried by others ({ERC165Checker}).
344  *
345  * For an implementation, see {ERC165}.
346  */
347 interface IERC165 {
348     /**
349      * @dev Returns true if this contract implements the interface defined by
350      * `interfaceId`. See the corresponding
351      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
352      * to learn more about how these ids are created.
353      *
354      * This function call must use less than 30 000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 }
358 
359 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev Implementation of the {IERC165} interface.
369  *
370  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
371  * for the additional interface id that will be supported. For example:
372  *
373  * ```solidity
374  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
376  * }
377  * ```
378  *
379  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
380  */
381 abstract contract ERC165 is IERC165 {
382     /**
383      * @dev See {IERC165-supportsInterface}.
384      */
385     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386         return interfaceId == type(IERC165).interfaceId;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Required interface of an ERC721 compliant contract.
400  */
401 interface IERC721 is IERC165 {
402     /**
403      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
409      */
410     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
414      */
415     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
416 
417     /**
418      * @dev Returns the number of tokens in ``owner``'s account.
419      */
420     function balanceOf(address owner) external view returns (uint256 balance);
421 
422     /**
423      * @dev Returns the owner of the `tokenId` token.
424      *
425      * Requirements:
426      *
427      * - `tokenId` must exist.
428      */
429     function ownerOf(uint256 tokenId) external view returns (address owner);
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId,
448         bytes calldata data
449     ) external;
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
453      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Transfers `tokenId` token from `from` to `to`.
473      *
474      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must be owned by `from`.
481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
493      * The approval is cleared when the token is transferred.
494      *
495      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
496      *
497      * Requirements:
498      *
499      * - The caller must own the token or be an approved operator.
500      * - `tokenId` must exist.
501      *
502      * Emits an {Approval} event.
503      */
504     function approve(address to, uint256 tokenId) external;
505 
506     /**
507      * @dev Approve or remove `operator` as an operator for the caller.
508      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
509      *
510      * Requirements:
511      *
512      * - The `operator` cannot be the caller.
513      *
514      * Emits an {ApprovalForAll} event.
515      */
516     function setApprovalForAll(address operator, bool _approved) external;
517 
518     /**
519      * @dev Returns the account approved for `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function getApproved(uint256 tokenId) external view returns (address operator);
526 
527     /**
528      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
529      *
530      * See {setApprovalForAll}
531      */
532     function isApprovedForAll(address owner, address operator) external view returns (bool);
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
545  * @dev See https://eips.ethereum.org/EIPS/eip-721
546  */
547 interface IERC721Metadata is IERC721 {
548     /**
549      * @dev Returns the token collection name.
550      */
551     function name() external view returns (string memory);
552 
553     /**
554      * @dev Returns the token collection symbol.
555      */
556     function symbol() external view returns (string memory);
557 
558     /**
559      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
560      */
561     function tokenURI(uint256 tokenId) external view returns (string memory);
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
565 
566 
567 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
574  * @dev See https://eips.ethereum.org/EIPS/eip-721
575  */
576 interface IERC721Enumerable is IERC721 {
577     /**
578      * @dev Returns the total amount of tokens stored by the contract.
579      */
580     function totalSupply() external view returns (uint256);
581 
582     /**
583      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
584      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
585      */
586     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
587 
588     /**
589      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
590      * Use along with {totalSupply} to enumerate all tokens.
591      */
592     function tokenByIndex(uint256 index) external view returns (uint256);
593 }
594 
595 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
596 
597 
598 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev Contract module that helps prevent reentrant calls to a function.
604  *
605  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
606  * available, which can be applied to functions to make sure there are no nested
607  * (reentrant) calls to them.
608  *
609  * Note that because there is a single `nonReentrant` guard, functions marked as
610  * `nonReentrant` may not call one another. This can be worked around by making
611  * those functions `private`, and then adding `external` `nonReentrant` entry
612  * points to them.
613  *
614  * TIP: If you would like to learn more about reentrancy and alternative ways
615  * to protect against it, check out our blog post
616  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
617  */
618 abstract contract ReentrancyGuard {
619     // Booleans are more expensive than uint256 or any type that takes up a full
620     // word because each write operation emits an extra SLOAD to first read the
621     // slot's contents, replace the bits taken up by the boolean, and then write
622     // back. This is the compiler's defense against contract upgrades and
623     // pointer aliasing, and it cannot be disabled.
624 
625     // The values being non-zero value makes deployment a bit more expensive,
626     // but in exchange the refund on every call to nonReentrant will be lower in
627     // amount. Since refunds are capped to a percentage of the total
628     // transaction's gas, it is best to keep them low in cases like this one, to
629     // increase the likelihood of the full refund coming into effect.
630     uint256 private constant _NOT_ENTERED = 1;
631     uint256 private constant _ENTERED = 2;
632 
633     uint256 private _status;
634 
635     constructor() {
636         _status = _NOT_ENTERED;
637     }
638 
639     /**
640      * @dev Prevents a contract from calling itself, directly or indirectly.
641      * Calling a `nonReentrant` function from another `nonReentrant`
642      * function is not supported. It is possible to prevent this from happening
643      * by making the `nonReentrant` function external, and making it call a
644      * `private` function that does the actual work.
645      */
646     modifier nonReentrant() {
647         // On the first call to nonReentrant, _notEntered will be true
648         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
649 
650         // Any calls to nonReentrant after this point will fail
651         _status = _ENTERED;
652 
653         _;
654 
655         // By storing the original value once again, a refund is triggered (see
656         // https://eips.ethereum.org/EIPS/eip-2200)
657         _status = _NOT_ENTERED;
658     }
659 }
660 
661 // File: @openzeppelin/contracts/utils/Context.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Provides information about the current execution context, including the
670  * sender of the transaction and its data. While these are generally available
671  * via msg.sender and msg.data, they should not be accessed in such a direct
672  * manner, since when dealing with meta-transactions the account sending and
673  * paying for execution may not be the actual sender (as far as an application
674  * is concerned).
675  *
676  * This contract is only required for intermediate, library-like contracts.
677  */
678 abstract contract Context {
679     function _msgSender() internal view virtual returns (address) {
680         return msg.sender;
681     }
682 
683     function _msgData() internal view virtual returns (bytes calldata) {
684         return msg.data;
685     }
686 }
687 
688 // File: @openzeppelin/contracts/access/Ownable.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @dev Contract module which provides a basic access control mechanism, where
698  * there is an account (an owner) that can be granted exclusive access to
699  * specific functions.
700  *
701  * By default, the owner account will be the one that deploys the contract. This
702  * can later be changed with {transferOwnership}.
703  *
704  * This module is used through inheritance. It will make available the modifier
705  * `onlyOwner`, which can be applied to your functions to restrict their use to
706  * the owner.
707  */
708 abstract contract Ownable is Context {
709     address private _owner;
710 
711     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
712 
713     /**
714      * @dev Initializes the contract setting the deployer as the initial owner.
715      */
716     constructor() {
717         _transferOwnership(_msgSender());
718     }
719 
720     /**
721      * @dev Returns the address of the current owner.
722      */
723     function owner() public view virtual returns (address) {
724         return _owner;
725     }
726 
727     /**
728      * @dev Throws if called by any account other than the owner.
729      */
730     modifier onlyOwner() {
731         require(owner() == _msgSender(), "Ownable: caller is not the owner");
732         _;
733     }
734 
735     /**
736      * @dev Leaves the contract without owner. It will not be possible to call
737      * `onlyOwner` functions anymore. Can only be called by the current owner.
738      *
739      * NOTE: Renouncing ownership will leave the contract without an owner,
740      * thereby removing any functionality that is only available to the owner.
741      */
742     function renounceOwnership() public virtual onlyOwner {
743         _transferOwnership(address(0));
744     }
745 
746     /**
747      * @dev Transfers ownership of the contract to a new account (`newOwner`).
748      * Can only be called by the current owner.
749      */
750     function transferOwnership(address newOwner) public virtual onlyOwner {
751         require(newOwner != address(0), "Ownable: new owner is the zero address");
752         _transferOwnership(newOwner);
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Internal function without access restriction.
758      */
759     function _transferOwnership(address newOwner) internal virtual {
760         address oldOwner = _owner;
761         _owner = newOwner;
762         emit OwnershipTransferred(oldOwner, newOwner);
763     }
764 }
765 
766 // File:
767 
768 
769 pragma solidity ^0.8.0;
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
785  *
786  * Does not support burning tokens to address(0).
787  *
788  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
789  */
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
791     using Address for address;
792     using Strings for uint256;
793 
794     struct TokenOwnership {
795         address addr;
796         uint64 startTimestamp;
797     }
798 
799     struct AddressData {
800         uint128 balance;
801         uint128 numberMinted;
802     }
803 
804     uint256 internal currentIndex;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      */
833     function totalSupply() public view override returns (uint256) {
834         return currentIndex;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenByIndex}.
839      */
840     function tokenByIndex(uint256 index) public view override returns (uint256) {
841         require(index < totalSupply(), "ERC721A: global index out of bounds");
842         return index;
843     }
844 
845     /**
846      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
847      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
848      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
849      */
850     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
851         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
852         uint256 numMintedSoFar = totalSupply();
853         uint256 tokenIdsIdx;
854         address currOwnershipAddr;
855 
856         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
857         unchecked {
858             for (uint256 i; i < numMintedSoFar; i++) {
859                 TokenOwnership memory ownership = _ownerships[i];
860                 if (ownership.addr != address(0)) {
861                     currOwnershipAddr = ownership.addr;
862                 }
863                 if (currOwnershipAddr == owner) {
864                     if (tokenIdsIdx == index) {
865                         return i;
866                     }
867                     tokenIdsIdx++;
868                 }
869             }
870         }
871 
872         revert("ERC721A: unable to get token of owner by index");
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             interfaceId == type(IERC721Enumerable).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * @dev See {IERC721-balanceOf}.
888      */
889     function balanceOf(address owner) public view override returns (uint256) {
890         require(owner != address(0), "ERC721A: balance query for the zero address");
891         return uint256(_addressData[owner].balance);
892     }
893 
894     function _numberMinted(address owner) internal view returns (uint256) {
895         require(owner != address(0), "ERC721A: number minted query for the zero address");
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
905 
906         unchecked {
907             for (uint256 curr = tokenId; curr >= 0; curr--) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (ownership.addr != address(0)) {
910                     return ownership;
911                 }
912             }
913         }
914 
915         revert("ERC721A: unable to determine the owner of token");
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return ownershipOf(tokenId).addr;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function _baseURI() internal view virtual returns (string memory) {
955         return "";
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public override {
962         address owner = ERC721A.ownerOf(tokenId);
963         require(to != owner, "ERC721A: approval to current owner");
964 
965         require(
966             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
967             "ERC721A: approve caller is not owner nor approved for all"
968         );
969 
970         _approve(to, tokenId, owner);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public override {
986         require(operator != _msgSender(), "ERC721A: approve to caller");
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
1018         safeTransferFrom(from, to, tokenId, "");
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
1029     ) public override {
1030         _transfer(from, to, tokenId);
1031         require(
1032             _checkOnERC721Received(from, to, tokenId, _data),
1033             "ERC721A: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      */
1044     function _exists(uint256 tokenId) internal view returns (bool) {
1045         return tokenId < currentIndex;
1046     }
1047 
1048     function _safeMint(address to, uint256 quantity) internal {
1049         _safeMint(to, quantity, "");
1050     }
1051 
1052     /**
1053      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 quantity,
1065         bytes memory _data
1066     ) internal {
1067         _mint(to, quantity, _data, true);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _mint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data,
1084         bool safe
1085     ) internal {
1086         uint256 startTokenId = currentIndex;
1087         require(to != address(0), "ERC721A: mint to the zero address");
1088         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1089 
1090         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1094         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint128(quantity);
1097             _addressData[to].numberMinted += uint128(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103 
1104             for (uint256 i; i < quantity; i++) {
1105                 emit Transfer(address(0), to, updatedIndex);
1106                 if (safe) {
1107                     require(
1108                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1109                         "ERC721A: transfer to non ERC721Receiver implementer"
1110                     );
1111                 }
1112 
1113                 updatedIndex++;
1114             }
1115 
1116             currentIndex = updatedIndex;
1117         }
1118 
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _transfer(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) private {
1137         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1138 
1139         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1140             getApproved(tokenId) == _msgSender() ||
1141             isApprovedForAll(prevOwnership.addr, _msgSender()));
1142 
1143         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1144 
1145         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1146         require(to != address(0), "ERC721A: transfer to the zero address");
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 if (_exists(nextTokenId)) {
1168                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1169                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, to, tokenId);
1175         _afterTokenTransfers(from, to, tokenId, 1);
1176     }
1177 
1178     /**
1179      * @dev Approve `to` to operate on `tokenId`
1180      *
1181      * Emits a {Approval} event.
1182      */
1183     function _approve(
1184         address to,
1185         uint256 tokenId,
1186         address owner
1187     ) private {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(owner, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1210                 return retval == IERC721Receiver(to).onERC721Received.selector;
1211             } catch (bytes memory reason) {
1212                 if (reason.length == 0) {
1213                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1214                 } else {
1215                     assembly {
1216                         revert(add(32, reason), mload(reason))
1217                     }
1218                 }
1219             }
1220         } else {
1221             return true;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1246      * minting.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _afterTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 }
1263 
1264 contract BrokeApeClub  is ERC721A, Ownable, ReentrancyGuard {
1265     string public baseURI           = "ipfs/";
1266     uint   public price             = 0.004 ether;
1267     uint   public maxPerTx          = 3;
1268     uint   public maxPerFree        = 3;
1269     uint   public totalFree         = 7777;
1270     uint   public maxSupply         = 7777;
1271     bool   public mintEnabled       = false;
1272 
1273     mapping(address => uint256) private _mintedFreeAmount;
1274 
1275     constructor() ERC721A("BrokeApeClub", "BAC"){}
1276 
1277 
1278     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1279         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1280         string memory currentBaseURI = _baseURI();
1281         return bytes(currentBaseURI).length > 0
1282             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1283             : "";
1284     }
1285 
1286     function mint(uint256 count) external payable {
1287         uint256 cost = price;
1288         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1289             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1290 
1291         if (isFree) {
1292             cost = 0;
1293             _mintedFreeAmount[msg.sender] += count;
1294         }
1295 
1296         require(msg.value >= count * cost, "Please send the exact amount.");
1297         require(totalSupply() + count <= maxSupply, "No more");
1298         require(mintEnabled, "Minting is not live yet..");
1299         require(count <= maxPerTx, "Max per TX reached.");
1300 
1301         _safeMint(msg.sender, count);
1302     }
1303 
1304     function toggleMinting() external onlyOwner {
1305       mintEnabled = !mintEnabled;
1306     }
1307 
1308     function _baseURI() internal view virtual override returns (string memory) {
1309         return baseURI;
1310     }
1311 
1312     function setBaseUri(string memory baseuri_) public onlyOwner {
1313         baseURI = baseuri_;
1314     }
1315 
1316     function setPrice(uint256 price_) external onlyOwner {
1317         price = price_;
1318     }
1319 
1320     function withdraw() external onlyOwner nonReentrant {
1321         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1322         require(success, "Transfer failed.");
1323     }
1324 
1325 
1326 }