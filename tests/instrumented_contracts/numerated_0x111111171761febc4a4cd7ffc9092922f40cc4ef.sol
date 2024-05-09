1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 // SPDX-License-Identifier: MIT
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Contract module that helps prevent reentrant calls to a function.
116  *
117  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
118  * available, which can be applied to functions to make sure there are no nested
119  * (reentrant) calls to them.
120  *
121  * Note that because there is a single `nonReentrant` guard, functions marked as
122  * `nonReentrant` may not call one another. This can be worked around by making
123  * those functions `private`, and then adding `external` `nonReentrant` entry
124  * points to them.
125  *
126  * TIP: If you would like to learn more about reentrancy and alternative ways
127  * to protect against it, check out our blog post
128  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
129  */
130 abstract contract ReentrancyGuard {
131     // Booleans are more expensive than uint256 or any type that takes up a full
132     // word because each write operation emits an extra SLOAD to first read the
133     // slot's contents, replace the bits taken up by the boolean, and then write
134     // back. This is the compiler's defense against contract upgrades and
135     // pointer aliasing, and it cannot be disabled.
136 
137     // The values being non-zero value makes deployment a bit more expensive,
138     // but in exchange the refund on every call to nonReentrant will be lower in
139     // amount. Since refunds are capped to a percentage of the total
140     // transaction's gas, it is best to keep them low in cases like this one, to
141     // increase the likelihood of the full refund coming into effect.
142     uint256 private constant _NOT_ENTERED = 1;
143     uint256 private constant _ENTERED = 2;
144 
145     uint256 private _status;
146 
147     constructor() {
148         _status = _NOT_ENTERED;
149     }
150 
151     /**
152      * @dev Prevents a contract from calling itself, directly or indirectly.
153      * Calling a `nonReentrant` function from another `nonReentrant`
154      * function is not supported. It is possible to prevent this from happening
155      * by making the `nonReentrant` function external, and making it call a
156      * `private` function that does the actual work.
157      */
158     modifier nonReentrant() {
159         // On the first call to nonReentrant, _notEntered will be true
160         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
161 
162         // Any calls to nonReentrant after this point will fail
163         _status = _ENTERED;
164 
165         _;
166 
167         // By storing the original value once again, a refund is triggered (see
168         // https://eips.ethereum.org/EIPS/eip-2200)
169         _status = _NOT_ENTERED;
170     }
171 }
172 
173 
174 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC165 standard, as defined in the
182  * https://eips.ethereum.org/EIPS/eip-165[EIP].
183  *
184  * Implementers can declare support of contract interfaces, which can then be
185  * queried by others ({ERC165Checker}).
186  *
187  * For an implementation, see {ERC165}.
188  */
189 interface IERC165 {
190     /**
191      * @dev Returns true if this contract implements the interface defined by
192      * `interfaceId`. See the corresponding
193      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
194      * to learn more about how these ids are created.
195      *
196      * This function call must use less than 30 000 gas.
197      */
198     function supportsInterface(bytes4 interfaceId) external view returns (bool);
199 }
200 
201 
202 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Required interface of an ERC721 compliant contract.
210  */
211 interface IERC721 is IERC165 {
212     /**
213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
219      */
220     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
224      */
225     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
226 
227     /**
228      * @dev Returns the number of tokens in ``owner``'s account.
229      */
230     function balanceOf(address owner) external view returns (uint256 balance);
231 
232     /**
233      * @dev Returns the owner of the `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function ownerOf(uint256 tokenId) external view returns (address owner);
240 
241     /**
242      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
243      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
244      *
245      * Requirements:
246      *
247      * - `from` cannot be the zero address.
248      * - `to` cannot be the zero address.
249      * - `tokenId` token must exist and be owned by `from`.
250      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
252      *
253      * Emits a {Transfer} event.
254      */
255     function safeTransferFrom(
256         address from,
257         address to,
258         uint256 tokenId
259     ) external;
260 
261     /**
262      * @dev Transfers `tokenId` token from `from` to `to`.
263      *
264      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must be owned by `from`.
271      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transferFrom(
276         address from,
277         address to,
278         uint256 tokenId
279     ) external;
280 
281     /**
282      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
283      * The approval is cleared when the token is transferred.
284      *
285      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
286      *
287      * Requirements:
288      *
289      * - The caller must own the token or be an approved operator.
290      * - `tokenId` must exist.
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address to, uint256 tokenId) external;
295 
296     /**
297      * @dev Returns the account approved for `tokenId` token.
298      *
299      * Requirements:
300      *
301      * - `tokenId` must exist.
302      */
303     function getApproved(uint256 tokenId) external view returns (address operator);
304 
305     /**
306      * @dev Approve or remove `operator` as an operator for the caller.
307      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
308      *
309      * Requirements:
310      *
311      * - The `operator` cannot be the caller.
312      *
313      * Emits an {ApprovalForAll} event.
314      */
315     function setApprovalForAll(address operator, bool _approved) external;
316 
317     /**
318      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
319      *
320      * See {setApprovalForAll}
321      */
322     function isApprovedForAll(address owner, address operator) external view returns (bool);
323 
324     /**
325      * @dev Safely transfers `tokenId` token from `from` to `to`.
326      *
327      * Requirements:
328      *
329      * - `from` cannot be the zero address.
330      * - `to` cannot be the zero address.
331      * - `tokenId` token must exist and be owned by `from`.
332      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
334      *
335      * Emits a {Transfer} event.
336      */
337     function safeTransferFrom(
338         address from,
339         address to,
340         uint256 tokenId,
341         bytes calldata data
342     ) external;
343 }
344 
345 
346 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @title ERC721 token receiver interface
355  * @dev Interface for any contract that wants to support safeTransfers
356  * from ERC721 asset contracts.
357  */
358 interface IERC721Receiver {
359     /**
360      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
361      * by `operator` from `from`, this function is called.
362      *
363      * It must return its Solidity selector to confirm the token transfer.
364      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
365      *
366      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
367      */
368     function onERC721Received(
369         address operator,
370         address from,
371         uint256 tokenId,
372         bytes calldata data
373     ) external returns (bytes4);
374 }
375 
376 
377 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
386  * @dev See https://eips.ethereum.org/EIPS/eip-721
387  */
388 interface IERC721Metadata is IERC721 {
389     /**
390      * @dev Returns the token collection name.
391      */
392     function name() external view returns (string memory);
393 
394     /**
395      * @dev Returns the token collection symbol.
396      */
397     function symbol() external view returns (string memory);
398 
399     /**
400      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
401      */
402     function tokenURI(uint256 tokenId) external view returns (string memory);
403 }
404 
405 
406 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
407 
408 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
414  * @dev See https://eips.ethereum.org/EIPS/eip-721
415  */
416 interface IERC721Enumerable is IERC721 {
417     /**
418      * @dev Returns the total amount of tokens stored by the contract.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     /**
423      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
424      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
425      */
426     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
427 
428     /**
429      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
430      * Use along with {totalSupply} to enumerate all tokens.
431      */
432     function tokenByIndex(uint256 index) external view returns (uint256);
433 }
434 
435 
436 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Collection of functions related to the address type
444  */
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * [IMPORTANT]
450      * ====
451      * It is unsafe to assume that an address for which this function returns
452      * false is an externally-owned account (EOA) and not a contract.
453      *
454      * Among others, `isContract` will return false for the following
455      * types of addresses:
456      *
457      *  - an externally-owned account
458      *  - a contract in construction
459      *  - an address where a contract will be created
460      *  - an address where a contract lived, but was destroyed
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies on extcodesize, which returns 0 for contracts in
465         // construction, since the code is only stored at the end of the
466         // constructor execution.
467 
468         uint256 size;
469         assembly {
470             size := extcodesize(account)
471         }
472         return size > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 
656 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev String operations.
665  */
666 library Strings {
667     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
668 
669     /**
670      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
671      */
672     function toString(uint256 value) internal pure returns (string memory) {
673         // Inspired by OraclizeAPI's implementation - MIT licence
674         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
675 
676         if (value == 0) {
677             return "0";
678         }
679         uint256 temp = value;
680         uint256 digits;
681         while (temp != 0) {
682             digits++;
683             temp /= 10;
684         }
685         bytes memory buffer = new bytes(digits);
686         while (value != 0) {
687             digits -= 1;
688             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
689             value /= 10;
690         }
691         return string(buffer);
692     }
693 
694     /**
695      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
696      */
697     function toHexString(uint256 value) internal pure returns (string memory) {
698         if (value == 0) {
699             return "0x00";
700         }
701         uint256 temp = value;
702         uint256 length = 0;
703         while (temp != 0) {
704             length++;
705             temp >>= 8;
706         }
707         return toHexString(value, length);
708     }
709 
710     /**
711      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
712      */
713     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
714         bytes memory buffer = new bytes(2 * length + 2);
715         buffer[0] = "0";
716         buffer[1] = "x";
717         for (uint256 i = 2 * length + 1; i > 1; --i) {
718             buffer[i] = _HEX_SYMBOLS[value & 0xf];
719             value >>= 4;
720         }
721         require(value == 0, "Strings: hex length insufficient");
722         return string(buffer);
723     }
724 }
725 
726 
727 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Implementation of the {IERC165} interface.
736  *
737  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
738  * for the additional interface id that will be supported. For example:
739  *
740  * ```solidity
741  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
743  * }
744  * ```
745  *
746  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
747  */
748 abstract contract ERC165 is IERC165 {
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         return interfaceId == type(IERC165).interfaceId;
754     }
755 }
756 
757 
758 // File contracts/ERC721A.sol
759 
760 // Creator: Chiru Labs
761 
762 pragma solidity ^0.8.4;
763 
764 
765 
766 
767 
768 
769 
770 
771 error ApprovalCallerNotOwnerNorApproved();
772 error ApprovalQueryForNonexistentToken();
773 error ApproveToCaller();
774 error ApprovalToCurrentOwner();
775 error BalanceQueryForZeroAddress();
776 error MintedQueryForZeroAddress();
777 error BurnedQueryForZeroAddress();
778 error AuxQueryForZeroAddress();
779 error MintToZeroAddress();
780 error MintZeroQuantity();
781 error OwnerIndexOutOfBounds();
782 error OwnerQueryForNonexistentToken();
783 error TokenIndexOutOfBounds();
784 error TransferCallerNotOwnerNorApproved();
785 error TransferFromIncorrectOwner();
786 error TransferToNonERC721ReceiverImplementer();
787 error TransferToZeroAddress();
788 error URIQueryForNonexistentToken();
789 
790 /**
791  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
792  * the Metadata extension. Built to optimize for lower gas during batch mints.
793  *
794  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
795  *
796  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
797  *
798  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
799  */
800 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
801     using Address for address;
802     using Strings for uint256;
803 
804     // Compiler will pack this into a single 256bit word.
805     struct TokenOwnership {
806         // The address of the owner.
807         address addr;
808         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
809         uint64 startTimestamp;
810         // Whether the token has been burned.
811         bool burned;
812     }
813 
814     // Compiler will pack this into a single 256bit word.
815     struct AddressData {
816         // Realistically, 2**64-1 is more than enough.
817         uint64 balance;
818         // Keeps track of mint count with minimal overhead for tokenomics.
819         uint64 numberMinted;
820         // Keeps track of burn count with minimal overhead for tokenomics.
821         uint64 numberBurned;
822         // For miscellaneous variable(s) pertaining to the address
823         // (e.g. number of whitelist mint slots used). 
824         // If there are multiple variables, please pack them into a uint64.
825         uint64 aux;
826     }
827 
828     // The tokenId of the next token to be minted.
829     uint256 internal _currentIndex;
830 
831     // The number of tokens burned.
832     uint256 internal _burnCounter;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to ownership details
841     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
842     mapping(uint256 => TokenOwnership) internal _ownerships;
843 
844     // Mapping owner address to address data
845     mapping(address => AddressData) private _addressData;
846 
847     // Mapping from token ID to approved address
848     mapping(uint256 => address) private _tokenApprovals;
849 
850     // Mapping from owner to operator approvals
851     mapping(address => mapping(address => bool)) private _operatorApprovals;
852 
853     constructor(string memory name_, string memory symbol_) {
854         _name = name_;
855         _symbol = symbol_;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-totalSupply}.
860      */
861     function totalSupply() public view returns (uint256) {
862         // Counter underflow is impossible as _burnCounter cannot be incremented
863         // more than _currentIndex times
864         unchecked {
865             return _currentIndex - _burnCounter;    
866         }
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC721).interfaceId ||
875             interfaceId == type(IERC721Metadata).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         if (owner == address(0)) revert BalanceQueryForZeroAddress();
884         return uint256(_addressData[owner].balance);
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         if (owner == address(0)) revert MintedQueryForZeroAddress();
892         return uint256(_addressData[owner].numberMinted);
893     }
894 
895     /**
896      * Returns the number of tokens burned by or on behalf of `owner`.
897      */
898     function _numberBurned(address owner) internal view returns (uint256) {
899         if (owner == address(0)) revert BurnedQueryForZeroAddress();
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         if (owner == address(0)) revert AuxQueryForZeroAddress();
908         return _addressData[owner].aux;
909     }
910 
911     /**
912      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
913      * If there are multiple variables, please pack them into a uint64.
914      */
915     function _setAux(address owner, uint64 aux) internal {
916         if (owner == address(0)) revert AuxQueryForZeroAddress();
917         _addressData[owner].aux = aux;
918     }
919 
920     /**
921      * Gas spent here starts off proportional to the maximum mint batch size.
922      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
923      */
924     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
925         uint256 curr = tokenId;
926 
927         unchecked {
928             if (curr < _currentIndex) {
929                 TokenOwnership memory ownership = _ownerships[curr];
930                 if (!ownership.burned) {
931                     if (ownership.addr != address(0)) {
932                         return ownership;
933                     }
934                     // Invariant: 
935                     // There will always be an ownership that has an address and is not burned 
936                     // before an ownership that does not have an address and is not burned.
937                     // Hence, curr will not underflow.
938                     while (true) {
939                         curr--;
940                         ownership = _ownerships[curr];
941                         if (ownership.addr != address(0)) {
942                             return ownership;
943                         }
944                     }
945                 }
946             }
947         }
948         revert OwnerQueryForNonexistentToken();
949     }
950 
951     /**
952      * @dev See {IERC721-ownerOf}.
953      */
954     function ownerOf(uint256 tokenId) public view override returns (address) {
955         return ownershipOf(tokenId).addr;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-name}.
960      */
961     function name() public view virtual override returns (string memory) {
962         return _name;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-symbol}.
967      */
968     function symbol() public view virtual override returns (string memory) {
969         return _symbol;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-tokenURI}.
974      */
975     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
976         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
977 
978         string memory baseURI = _baseURI();
979         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
980     }
981 
982     /**
983      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
984      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
985      * by default, can be overriden in child contracts.
986      */
987     function _baseURI() internal view virtual returns (string memory) {
988         return '';
989     }
990 
991     /**
992      * @dev See {IERC721-approve}.
993      */
994     function approve(address to, uint256 tokenId) public override {
995         address owner = ERC721A.ownerOf(tokenId);
996         if (to == owner) revert ApprovalToCurrentOwner();
997 
998         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
999             revert ApprovalCallerNotOwnerNorApproved();
1000         }
1001 
1002         _approve(to, tokenId, owner);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId) public view override returns (address) {
1009         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1010 
1011         return _tokenApprovals[tokenId];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public override {
1018         if (operator == _msgSender()) revert ApproveToCaller();
1019 
1020         _operatorApprovals[_msgSender()][operator] = approved;
1021         emit ApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-transferFrom}.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         _transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         safeTransferFrom(from, to, tokenId, '');
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) public virtual override {
1062         _transfer(from, to, tokenId);
1063         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1064             revert TransferToNonERC721ReceiverImplementer();
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns whether `tokenId` exists.
1070      *
1071      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1072      *
1073      * Tokens start existing when they are minted (`_mint`),
1074      */
1075     function _exists(uint256 tokenId) internal view returns (bool) {
1076         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1077     }
1078 
1079     function _safeMint(address to, uint256 quantity) internal {
1080         _safeMint(to, quantity, '');
1081     }
1082 
1083     /**
1084      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
1097     ) internal {
1098         _mint(to, quantity, _data, true);
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data,
1115         bool safe
1116     ) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120 
1121         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1122 
1123         // Overflows are incredibly unrealistic.
1124         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1125         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1126         unchecked {
1127             _addressData[to].balance += uint64(quantity);
1128             _addressData[to].numberMinted += uint64(quantity);
1129 
1130             _ownerships[startTokenId].addr = to;
1131             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1132 
1133             uint256 updatedIndex = startTokenId;
1134 
1135             for (uint256 i; i < quantity; i++) {
1136                 emit Transfer(address(0), to, updatedIndex);
1137                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1138                     revert TransferToNonERC721ReceiverImplementer();
1139                 }
1140                 updatedIndex++;
1141             }
1142 
1143             _currentIndex = updatedIndex;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) private {
1163         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1164 
1165         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1166             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1167             getApproved(tokenId) == _msgSender());
1168 
1169         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1170         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1171         if (to == address(0)) revert TransferToZeroAddress();
1172 
1173         _beforeTokenTransfers(from, to, tokenId, 1);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId, prevOwnership.addr);
1177 
1178         // Underflow of the sender's balance is impossible because we check for
1179         // ownership above and the recipient's balance can't realistically overflow.
1180         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1181         unchecked {
1182             _addressData[from].balance -= 1;
1183             _addressData[to].balance += 1;
1184 
1185             _ownerships[tokenId].addr = to;
1186             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1187 
1188             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1189             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1190             uint256 nextTokenId = tokenId + 1;
1191             if (_ownerships[nextTokenId].addr == address(0)) {
1192                 // This will suffice for checking _exists(nextTokenId),
1193                 // as a burned slot cannot contain the zero address.
1194                 if (nextTokenId < _currentIndex) {
1195                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1196                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1197                 }
1198             }
1199         }
1200 
1201         emit Transfer(from, to, tokenId);
1202         _afterTokenTransfers(from, to, tokenId, 1);
1203     }
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId) internal virtual {
1216         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1217 
1218         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1219 
1220         // Clear approvals from the previous owner
1221         _approve(address(0), tokenId, prevOwnership.addr);
1222 
1223         // Underflow of the sender's balance is impossible because we check for
1224         // ownership above and the recipient's balance can't realistically overflow.
1225         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1226         unchecked {
1227             _addressData[prevOwnership.addr].balance -= 1;
1228             _addressData[prevOwnership.addr].numberBurned += 1;
1229 
1230             // Keep track of who burned the token, and the timestamp of burning.
1231             _ownerships[tokenId].addr = prevOwnership.addr;
1232             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1233             _ownerships[tokenId].burned = true;
1234 
1235             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1236             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1237             uint256 nextTokenId = tokenId + 1;
1238             if (_ownerships[nextTokenId].addr == address(0)) {
1239                 // This will suffice for checking _exists(nextTokenId),
1240                 // as a burned slot cannot contain the zero address.
1241                 if (nextTokenId < _currentIndex) {
1242                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1243                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1244                 }
1245             }
1246         }
1247 
1248         emit Transfer(prevOwnership.addr, address(0), tokenId);
1249         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1250 
1251         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1252         unchecked { 
1253             _burnCounter++;
1254         }
1255     }
1256 
1257     /**
1258      * @dev Approve `to` to operate on `tokenId`
1259      *
1260      * Emits a {Approval} event.
1261      */
1262     function _approve(
1263         address to,
1264         uint256 tokenId,
1265         address owner
1266     ) private {
1267         _tokenApprovals[tokenId] = to;
1268         emit Approval(owner, to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1273      * The call is not executed if the target address is not a contract.
1274      *
1275      * @param from address representing the previous owner of the given token ID
1276      * @param to target address that will receive the tokens
1277      * @param tokenId uint256 ID of the token to be transferred
1278      * @param _data bytes optional data to send along with the call
1279      * @return bool whether the call correctly returned the expected magic value
1280      */
1281     function _checkOnERC721Received(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory _data
1286     ) private returns (bool) {
1287         if (to.isContract()) {
1288             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1289                 return retval == IERC721Receiver(to).onERC721Received.selector;
1290             } catch (bytes memory reason) {
1291                 if (reason.length == 0) {
1292                     revert TransferToNonERC721ReceiverImplementer();
1293                 } else {
1294                     assembly {
1295                         revert(add(32, reason), mload(reason))
1296                     }
1297                 }
1298             }
1299         } else {
1300             return true;
1301         }
1302     }
1303 
1304     /**
1305      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1306      * And also called before burning one token.
1307      *
1308      * startTokenId - the first token id to be transferred
1309      * quantity - the amount to be transferred
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` will be minted for `to`.
1316      * - When `to` is zero, `tokenId` will be burned by `from`.
1317      * - `from` and `to` are never both zero.
1318      */
1319     function _beforeTokenTransfers(
1320         address from,
1321         address to,
1322         uint256 startTokenId,
1323         uint256 quantity
1324     ) internal virtual {}
1325 
1326     /**
1327      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1328      * minting.
1329      * And also called after one token has been burned.
1330      *
1331      * startTokenId - the first token id to be transferred
1332      * quantity - the amount to be transferred
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` has been minted for `to`.
1339      * - When `to` is zero, `tokenId` has been burned by `from`.
1340      * - `from` and `to` are never both zero.
1341      */
1342     function _afterTokenTransfers(
1343         address from,
1344         address to,
1345         uint256 startTokenId,
1346         uint256 quantity
1347     ) internal virtual {}
1348 }
1349 
1350 
1351 // File contracts/MerkleProof.sol
1352 
1353 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1354 
1355 pragma solidity ^0.8.0;
1356 
1357 /**
1358  * @dev These functions deal with verification of Merkle Trees proofs.
1359  *
1360  * The proofs can be generated using the JavaScript library
1361  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1362  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1363  *
1364  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1365  */
1366 library MerkleProof {
1367     /**
1368      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1369      * defined by `root`. For this, a `proof` must be provided, containing
1370      * sibling hashes on the branch from the leaf to the root of the tree. Each
1371      * pair of leaves and each pair of pre-images are assumed to be sorted.
1372      */
1373     function verify(
1374         bytes32[] memory proof,
1375         bytes32 root,
1376         bytes32 leaf
1377     ) internal pure returns (bool) {
1378         return processProof(proof, leaf) == root;
1379     }
1380 
1381     /**
1382      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1383      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1384      * hash matches the root of the tree. When processing the proof, the pairs
1385      * of leafs & pre-images are assumed to be sorted.
1386      *
1387      * _Available since v4.4._
1388      */
1389     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1390         bytes32 computedHash = leaf;
1391         for (uint256 i = 0; i < proof.length; i++) {
1392             bytes32 proofElement = proof[i];
1393             if (computedHash <= proofElement) {
1394                 // Hash(current computed hash + current element of the proof)
1395                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1396             } else {
1397                 // Hash(current element of the proof + current computed hash)
1398                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1399             }
1400         }
1401         return computedHash;
1402     }
1403 }
1404 
1405 
1406 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.2
1407 
1408 
1409 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 // CAUTION
1414 // This version of SafeMath should only be used with Solidity 0.8 or later,
1415 // because it relies on the compiler's built in overflow checks.
1416 
1417 /**
1418  * @dev Wrappers over Solidity's arithmetic operations.
1419  *
1420  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1421  * now has built in overflow checking.
1422  */
1423 library SafeMath {
1424     /**
1425      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1426      *
1427      * _Available since v3.4._
1428      */
1429     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1430         unchecked {
1431             uint256 c = a + b;
1432             if (c < a) return (false, 0);
1433             return (true, c);
1434         }
1435     }
1436 
1437     /**
1438      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1439      *
1440      * _Available since v3.4._
1441      */
1442     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1443         unchecked {
1444             if (b > a) return (false, 0);
1445             return (true, a - b);
1446         }
1447     }
1448 
1449     /**
1450      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1451      *
1452      * _Available since v3.4._
1453      */
1454     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1455         unchecked {
1456             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1457             // benefit is lost if 'b' is also tested.
1458             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1459             if (a == 0) return (true, 0);
1460             uint256 c = a * b;
1461             if (c / a != b) return (false, 0);
1462             return (true, c);
1463         }
1464     }
1465 
1466     /**
1467      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1468      *
1469      * _Available since v3.4._
1470      */
1471     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1472         unchecked {
1473             if (b == 0) return (false, 0);
1474             return (true, a / b);
1475         }
1476     }
1477 
1478     /**
1479      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1480      *
1481      * _Available since v3.4._
1482      */
1483     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1484         unchecked {
1485             if (b == 0) return (false, 0);
1486             return (true, a % b);
1487         }
1488     }
1489 
1490     /**
1491      * @dev Returns the addition of two unsigned integers, reverting on
1492      * overflow.
1493      *
1494      * Counterpart to Solidity's `+` operator.
1495      *
1496      * Requirements:
1497      *
1498      * - Addition cannot overflow.
1499      */
1500     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1501         return a + b;
1502     }
1503 
1504     /**
1505      * @dev Returns the subtraction of two unsigned integers, reverting on
1506      * overflow (when the result is negative).
1507      *
1508      * Counterpart to Solidity's `-` operator.
1509      *
1510      * Requirements:
1511      *
1512      * - Subtraction cannot overflow.
1513      */
1514     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1515         return a - b;
1516     }
1517 
1518     /**
1519      * @dev Returns the multiplication of two unsigned integers, reverting on
1520      * overflow.
1521      *
1522      * Counterpart to Solidity's `*` operator.
1523      *
1524      * Requirements:
1525      *
1526      * - Multiplication cannot overflow.
1527      */
1528     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1529         return a * b;
1530     }
1531 
1532     /**
1533      * @dev Returns the integer division of two unsigned integers, reverting on
1534      * division by zero. The result is rounded towards zero.
1535      *
1536      * Counterpart to Solidity's `/` operator.
1537      *
1538      * Requirements:
1539      *
1540      * - The divisor cannot be zero.
1541      */
1542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1543         return a / b;
1544     }
1545 
1546     /**
1547      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1548      * reverting when dividing by zero.
1549      *
1550      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1551      * opcode (which leaves remaining gas untouched) while Solidity uses an
1552      * invalid opcode to revert (consuming all remaining gas).
1553      *
1554      * Requirements:
1555      *
1556      * - The divisor cannot be zero.
1557      */
1558     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1559         return a % b;
1560     }
1561 
1562     /**
1563      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1564      * overflow (when the result is negative).
1565      *
1566      * CAUTION: This function is deprecated because it requires allocating memory for the error
1567      * message unnecessarily. For custom revert reasons use {trySub}.
1568      *
1569      * Counterpart to Solidity's `-` operator.
1570      *
1571      * Requirements:
1572      *
1573      * - Subtraction cannot overflow.
1574      */
1575     function sub(
1576         uint256 a,
1577         uint256 b,
1578         string memory errorMessage
1579     ) internal pure returns (uint256) {
1580         unchecked {
1581             require(b <= a, errorMessage);
1582             return a - b;
1583         }
1584     }
1585 
1586     /**
1587      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1588      * division by zero. The result is rounded towards zero.
1589      *
1590      * Counterpart to Solidity's `/` operator. Note: this function uses a
1591      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1592      * uses an invalid opcode to revert (consuming all remaining gas).
1593      *
1594      * Requirements:
1595      *
1596      * - The divisor cannot be zero.
1597      */
1598     function div(
1599         uint256 a,
1600         uint256 b,
1601         string memory errorMessage
1602     ) internal pure returns (uint256) {
1603         unchecked {
1604             require(b > 0, errorMessage);
1605             return a / b;
1606         }
1607     }
1608 
1609     /**
1610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1611      * reverting with custom message when dividing by zero.
1612      *
1613      * CAUTION: This function is deprecated because it requires allocating memory for the error
1614      * message unnecessarily. For custom revert reasons use {tryMod}.
1615      *
1616      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1617      * opcode (which leaves remaining gas untouched) while Solidity uses an
1618      * invalid opcode to revert (consuming all remaining gas).
1619      *
1620      * Requirements:
1621      *
1622      * - The divisor cannot be zero.
1623      */
1624     function mod(
1625         uint256 a,
1626         uint256 b,
1627         string memory errorMessage
1628     ) internal pure returns (uint256) {
1629         unchecked {
1630             require(b > 0, errorMessage);
1631             return a % b;
1632         }
1633     }
1634 }
1635 
1636 
1637 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.2
1638 
1639 
1640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1641 
1642 pragma solidity ^0.8.0;
1643 
1644 
1645 
1646 
1647 
1648 
1649 
1650 /**
1651  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1652  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1653  * {ERC721Enumerable}.
1654  */
1655 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1656     using Address for address;
1657     using Strings for uint256;
1658 
1659     // Token name
1660     string private _name;
1661 
1662     // Token symbol
1663     string private _symbol;
1664 
1665     // Mapping from token ID to owner address
1666     mapping(uint256 => address) private _owners;
1667 
1668     // Mapping owner address to token count
1669     mapping(address => uint256) private _balances;
1670 
1671     // Mapping from token ID to approved address
1672     mapping(uint256 => address) private _tokenApprovals;
1673 
1674     // Mapping from owner to operator approvals
1675     mapping(address => mapping(address => bool)) private _operatorApprovals;
1676 
1677     /**
1678      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1679      */
1680     constructor(string memory name_, string memory symbol_) {
1681         _name = name_;
1682         _symbol = symbol_;
1683     }
1684 
1685     /**
1686      * @dev See {IERC165-supportsInterface}.
1687      */
1688     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1689         return
1690             interfaceId == type(IERC721).interfaceId ||
1691             interfaceId == type(IERC721Metadata).interfaceId ||
1692             super.supportsInterface(interfaceId);
1693     }
1694 
1695     /**
1696      * @dev See {IERC721-balanceOf}.
1697      */
1698     function balanceOf(address owner) public view virtual override returns (uint256) {
1699         require(owner != address(0), "ERC721: balance query for the zero address");
1700         return _balances[owner];
1701     }
1702 
1703     /**
1704      * @dev See {IERC721-ownerOf}.
1705      */
1706     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1707         address owner = _owners[tokenId];
1708         require(owner != address(0), "ERC721: owner query for nonexistent token");
1709         return owner;
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-name}.
1714      */
1715     function name() public view virtual override returns (string memory) {
1716         return _name;
1717     }
1718 
1719     /**
1720      * @dev See {IERC721Metadata-symbol}.
1721      */
1722     function symbol() public view virtual override returns (string memory) {
1723         return _symbol;
1724     }
1725 
1726     /**
1727      * @dev See {IERC721Metadata-tokenURI}.
1728      */
1729     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1730         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1731 
1732         string memory baseURI = _baseURI();
1733         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1734     }
1735 
1736     /**
1737      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1738      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1739      * by default, can be overriden in child contracts.
1740      */
1741     function _baseURI() internal view virtual returns (string memory) {
1742         return "";
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-approve}.
1747      */
1748     function approve(address to, uint256 tokenId) public virtual override {
1749         address owner = ERC721.ownerOf(tokenId);
1750         require(to != owner, "ERC721: approval to current owner");
1751 
1752         require(
1753             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1754             "ERC721: approve caller is not owner nor approved for all"
1755         );
1756 
1757         _approve(to, tokenId);
1758     }
1759 
1760     /**
1761      * @dev See {IERC721-getApproved}.
1762      */
1763     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1764         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1765 
1766         return _tokenApprovals[tokenId];
1767     }
1768 
1769     /**
1770      * @dev See {IERC721-setApprovalForAll}.
1771      */
1772     function setApprovalForAll(address operator, bool approved) public virtual override {
1773         _setApprovalForAll(_msgSender(), operator, approved);
1774     }
1775 
1776     /**
1777      * @dev See {IERC721-isApprovedForAll}.
1778      */
1779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1780         return _operatorApprovals[owner][operator];
1781     }
1782 
1783     /**
1784      * @dev See {IERC721-transferFrom}.
1785      */
1786     function transferFrom(
1787         address from,
1788         address to,
1789         uint256 tokenId
1790     ) public virtual override {
1791         //solhint-disable-next-line max-line-length
1792         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1793 
1794         _transfer(from, to, tokenId);
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-safeTransferFrom}.
1799      */
1800     function safeTransferFrom(
1801         address from,
1802         address to,
1803         uint256 tokenId
1804     ) public virtual override {
1805         safeTransferFrom(from, to, tokenId, "");
1806     }
1807 
1808     /**
1809      * @dev See {IERC721-safeTransferFrom}.
1810      */
1811     function safeTransferFrom(
1812         address from,
1813         address to,
1814         uint256 tokenId,
1815         bytes memory _data
1816     ) public virtual override {
1817         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1818         _safeTransfer(from, to, tokenId, _data);
1819     }
1820 
1821     /**
1822      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1823      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1824      *
1825      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1826      *
1827      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1828      * implement alternative mechanisms to perform token transfer, such as signature-based.
1829      *
1830      * Requirements:
1831      *
1832      * - `from` cannot be the zero address.
1833      * - `to` cannot be the zero address.
1834      * - `tokenId` token must exist and be owned by `from`.
1835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1836      *
1837      * Emits a {Transfer} event.
1838      */
1839     function _safeTransfer(
1840         address from,
1841         address to,
1842         uint256 tokenId,
1843         bytes memory _data
1844     ) internal virtual {
1845         _transfer(from, to, tokenId);
1846         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1847     }
1848 
1849     /**
1850      * @dev Returns whether `tokenId` exists.
1851      *
1852      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1853      *
1854      * Tokens start existing when they are minted (`_mint`),
1855      * and stop existing when they are burned (`_burn`).
1856      */
1857     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1858         return _owners[tokenId] != address(0);
1859     }
1860 
1861     /**
1862      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1863      *
1864      * Requirements:
1865      *
1866      * - `tokenId` must exist.
1867      */
1868     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1869         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1870         address owner = ERC721.ownerOf(tokenId);
1871         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1872     }
1873 
1874     /**
1875      * @dev Safely mints `tokenId` and transfers it to `to`.
1876      *
1877      * Requirements:
1878      *
1879      * - `tokenId` must not exist.
1880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1881      *
1882      * Emits a {Transfer} event.
1883      */
1884     function _safeMint(address to, uint256 tokenId) internal virtual {
1885         _safeMint(to, tokenId, "");
1886     }
1887 
1888     /**
1889      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1890      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1891      */
1892     function _safeMint(
1893         address to,
1894         uint256 tokenId,
1895         bytes memory _data
1896     ) internal virtual {
1897         _mint(to, tokenId);
1898         require(
1899             _checkOnERC721Received(address(0), to, tokenId, _data),
1900             "ERC721: transfer to non ERC721Receiver implementer"
1901         );
1902     }
1903 
1904     /**
1905      * @dev Mints `tokenId` and transfers it to `to`.
1906      *
1907      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1908      *
1909      * Requirements:
1910      *
1911      * - `tokenId` must not exist.
1912      * - `to` cannot be the zero address.
1913      *
1914      * Emits a {Transfer} event.
1915      */
1916     function _mint(address to, uint256 tokenId) internal virtual {
1917         require(to != address(0), "ERC721: mint to the zero address");
1918         require(!_exists(tokenId), "ERC721: token already minted");
1919 
1920         _beforeTokenTransfer(address(0), to, tokenId);
1921 
1922         _balances[to] += 1;
1923         _owners[tokenId] = to;
1924 
1925         emit Transfer(address(0), to, tokenId);
1926     }
1927 
1928     /**
1929      * @dev Destroys `tokenId`.
1930      * The approval is cleared when the token is burned.
1931      *
1932      * Requirements:
1933      *
1934      * - `tokenId` must exist.
1935      *
1936      * Emits a {Transfer} event.
1937      */
1938     function _burn(uint256 tokenId) internal virtual {
1939         address owner = ERC721.ownerOf(tokenId);
1940 
1941         _beforeTokenTransfer(owner, address(0), tokenId);
1942 
1943         // Clear approvals
1944         _approve(address(0), tokenId);
1945 
1946         _balances[owner] -= 1;
1947         delete _owners[tokenId];
1948 
1949         emit Transfer(owner, address(0), tokenId);
1950     }
1951 
1952     /**
1953      * @dev Transfers `tokenId` from `from` to `to`.
1954      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1955      *
1956      * Requirements:
1957      *
1958      * - `to` cannot be the zero address.
1959      * - `tokenId` token must be owned by `from`.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _transfer(
1964         address from,
1965         address to,
1966         uint256 tokenId
1967     ) internal virtual {
1968         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1969         require(to != address(0), "ERC721: transfer to the zero address");
1970 
1971         _beforeTokenTransfer(from, to, tokenId);
1972 
1973         // Clear approvals from the previous owner
1974         _approve(address(0), tokenId);
1975 
1976         _balances[from] -= 1;
1977         _balances[to] += 1;
1978         _owners[tokenId] = to;
1979 
1980         emit Transfer(from, to, tokenId);
1981     }
1982 
1983     /**
1984      * @dev Approve `to` to operate on `tokenId`
1985      *
1986      * Emits a {Approval} event.
1987      */
1988     function _approve(address to, uint256 tokenId) internal virtual {
1989         _tokenApprovals[tokenId] = to;
1990         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1991     }
1992 
1993     /**
1994      * @dev Approve `operator` to operate on all of `owner` tokens
1995      *
1996      * Emits a {ApprovalForAll} event.
1997      */
1998     function _setApprovalForAll(
1999         address owner,
2000         address operator,
2001         bool approved
2002     ) internal virtual {
2003         require(owner != operator, "ERC721: approve to caller");
2004         _operatorApprovals[owner][operator] = approved;
2005         emit ApprovalForAll(owner, operator, approved);
2006     }
2007 
2008     /**
2009      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2010      * The call is not executed if the target address is not a contract.
2011      *
2012      * @param from address representing the previous owner of the given token ID
2013      * @param to target address that will receive the tokens
2014      * @param tokenId uint256 ID of the token to be transferred
2015      * @param _data bytes optional data to send along with the call
2016      * @return bool whether the call correctly returned the expected magic value
2017      */
2018     function _checkOnERC721Received(
2019         address from,
2020         address to,
2021         uint256 tokenId,
2022         bytes memory _data
2023     ) private returns (bool) {
2024         if (to.isContract()) {
2025             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2026                 return retval == IERC721Receiver.onERC721Received.selector;
2027             } catch (bytes memory reason) {
2028                 if (reason.length == 0) {
2029                     revert("ERC721: transfer to non ERC721Receiver implementer");
2030                 } else {
2031                     assembly {
2032                         revert(add(32, reason), mload(reason))
2033                     }
2034                 }
2035             }
2036         } else {
2037             return true;
2038         }
2039     }
2040 
2041     /**
2042      * @dev Hook that is called before any token transfer. This includes minting
2043      * and burning.
2044      *
2045      * Calling conditions:
2046      *
2047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2048      * transferred to `to`.
2049      * - When `from` is zero, `tokenId` will be minted for `to`.
2050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2051      * - `from` and `to` are never both zero.
2052      *
2053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2054      */
2055     function _beforeTokenTransfer(
2056         address from,
2057         address to,
2058         uint256 tokenId
2059     ) internal virtual {}
2060 }
2061 
2062 
2063 // File contracts/CherubFields.sol
2064 
2065 
2066 pragma solidity ^0.8.0;
2067 
2068 
2069 
2070 
2071 
2072 
2073 contract CherubFields is Ownable, ERC721A, ReentrancyGuard {
2074     using SafeMath for uint256;
2075 
2076     uint256 public immutable maxPerAddressDuringMint;
2077     uint256 public immutable MAX_AMOUNT;
2078     bytes32 public merkleRoot;
2079 
2080     mapping(address => uint8) public mintedWhitelist;
2081     mapping(address => bool) public mintedSharedToken;
2082 
2083     uint256 public NFTPrice = 0.077 ether;
2084 
2085     bool public saleIsActive = false;
2086     bool public isWhitelistActive = false;
2087     bool public isSharedHolderSaleActive = false;
2088 
2089     uint8 public availableTokensPerWhitelist = 3;
2090 
2091     address projectWallet = 0x4cF1bEaaec25AF63282ca93b6DDD36a8D63D373E;
2092     address devWallet = 0x38c0245C7C67576d1E73f3A11c6af76fE8d11dEA;
2093     address artWallet = 0x9e9161363Ff2f51246030fAF9A94049a42835c17;
2094 
2095     constructor(bytes32 merkleRoot_) ERC721A("Cherub Fields", "CHERUB") {
2096         MAX_AMOUNT = 1111;
2097         maxPerAddressDuringMint = 10;
2098         merkleRoot = merkleRoot_;
2099     }
2100 
2101     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
2102         _safeMint(msg.sender, numberOfTokens);
2103         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2104     }
2105 
2106     function whitelistMint(
2107         bytes32[] calldata _merkleProof,
2108         uint8 numberOfTokens
2109     ) external payable {
2110         require(isWhitelistActive, "Whitelist is not active");
2111         require(
2112             NFTPrice.mul(numberOfTokens) <= msg.value,
2113             "Ether value sent is not correct"
2114         );
2115 
2116         uint8 mintedSoFar = mintedWhitelist[msg.sender] + numberOfTokens;
2117         require(
2118             mintedSoFar <= availableTokensPerWhitelist,
2119             "You can't mint that many"
2120         );
2121 
2122         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2123         require(
2124             MerkleProof.verify(_merkleProof, merkleRoot, leaf) == true,
2125             "Incorrect Merkle Proof"
2126         );
2127 
2128         mintedWhitelist[msg.sender] = mintedSoFar;
2129 
2130         _safeMint(msg.sender, numberOfTokens);
2131 
2132         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2133     }
2134 
2135     function mintNFTAsSharedOwner() public payable {
2136         require(
2137             isSharedHolderSaleActive,
2138             "Sale must be active to mint a Cherub"
2139         );
2140         require(NFTPrice <= msg.value, "Ether value sent is not correct");
2141         require(
2142             isSharedOwner(msg.sender),
2143             "This wallet does not contain the right NFTs."
2144         );
2145 
2146         require(
2147             mintedSharedToken[msg.sender] == false,
2148             "You can't mint that many"
2149         );
2150         mintedSharedToken[msg.sender] = true;
2151 
2152         _safeMint(msg.sender, 1);
2153 
2154         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2155     }
2156 
2157     function mintNFT(uint256 numberOfTokens) public payable {
2158         require(saleIsActive, "Sale must be active to mint a Cherub");
2159         require(
2160             numberOfTokens <= maxPerAddressDuringMint,
2161             "You can't mint that many at once"
2162         );
2163         require(
2164             NFTPrice.mul(numberOfTokens) <= msg.value,
2165             "Ether value sent is not correct"
2166         );
2167 
2168         _safeMint(msg.sender, numberOfTokens);
2169 
2170         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2171     }
2172 
2173     function flipSaleState() public onlyOwner {
2174         saleIsActive = !saleIsActive;
2175     }
2176 
2177     function flipWhitelistState() public onlyOwner {
2178         isWhitelistActive = !isWhitelistActive;
2179     }
2180 
2181     function flipSharedHolderState() public onlyOwner {
2182         isSharedHolderSaleActive = !isSharedHolderSaleActive;
2183     }
2184 
2185     function isSharedOwner(address addr) public view returns (bool) {
2186         address milady =  0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
2187         address tubby =   0xCa7cA7BcC765F77339bE2d648BA53ce9c8a262bD;
2188         address adworld = 0x62eb144FE92Ddc1B10bCAde03A0C09f6FBffBffb;
2189 
2190         return
2191             ERC721(milady).balanceOf(addr) > 0 ||
2192             ERC721(adworld).balanceOf(addr) > 0 ||
2193             ERC721(tubby).balanceOf(addr) > 0;
2194     }
2195 
2196     // // metadata URI
2197     string private _baseTokenURI;
2198 
2199     function _baseURI() internal view virtual override returns (string memory) {
2200         return _baseTokenURI;
2201     }
2202 
2203     function setBaseURI(string calldata baseURI) external onlyOwner {
2204         _baseTokenURI = baseURI;
2205     }
2206 
2207     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
2208         merkleRoot = merkleRoot_;
2209     }
2210 
2211     function withdrawMoney() external onlyOwner nonReentrant {
2212         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2213         require(success, "Transfer failed.");
2214     }
2215 
2216     function numberMinted(address owner) public view returns (uint256) {
2217         return _numberMinted(owner);
2218     }
2219 
2220     function getOwnershipData(uint256 tokenId)
2221         external
2222         view
2223         returns (TokenOwnership memory)
2224     {
2225         return ownershipOf(tokenId);
2226     }
2227 
2228     function setMintPrice(uint256 newPrice) external onlyOwner {
2229         NFTPrice = newPrice;
2230     }
2231 
2232     function withdrawAll() public payable onlyOwner {
2233         uint256 project = (address(this).balance * 6000) / 10000;
2234         uint256 dev = (address(this).balance * 2500) / 10000;
2235         uint256 art = (address(this).balance * 1500) / 10000;
2236 
2237         require(payable(projectWallet).send(project));
2238         require(payable(devWallet).send(dev));
2239         require(payable(artWallet).send(art));
2240     }
2241 }