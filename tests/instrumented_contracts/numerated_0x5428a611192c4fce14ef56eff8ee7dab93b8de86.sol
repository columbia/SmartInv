1 // Sources flattened with hardhat v2.9.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 // SPDX-License-Identifier: MIT
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
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
174 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
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
202 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
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
346 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 interface IERC721Receiver {
358     /**
359      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
360      * by `operator` from `from`, this function is called.
361      *
362      * It must return its Solidity selector to confirm the token transfer.
363      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
364      *
365      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
366      */
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 
375 
376 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
377 
378 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
384  * @dev See https://eips.ethereum.org/EIPS/eip-721
385  */
386 interface IERC721Metadata is IERC721 {
387     /**
388      * @dev Returns the token collection name.
389      */
390     function name() external view returns (string memory);
391 
392     /**
393      * @dev Returns the token collection symbol.
394      */
395     function symbol() external view returns (string memory);
396 
397     /**
398      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
399      */
400     function tokenURI(uint256 tokenId) external view returns (string memory);
401 }
402 
403 
404 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
405 
406 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
407 
408 pragma solidity ^0.8.1;
409 
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * [IMPORTANT]
418      * ====
419      * It is unsafe to assume that an address for which this function returns
420      * false is an externally-owned account (EOA) and not a contract.
421      *
422      * Among others, `isContract` will return false for the following
423      * types of addresses:
424      *
425      *  - an externally-owned account
426      *  - a contract in construction
427      *  - an address where a contract will be created
428      *  - an address where a contract lived, but was destroyed
429      * ====
430      *
431      * [IMPORTANT]
432      * ====
433      * You shouldn't rely on `isContract` to protect against flash loan attacks!
434      *
435      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
436      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
437      * constructor.
438      * ====
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies on extcodesize/address.code.length, which returns 0
442         // for contracts in construction, since the code is only stored at the end
443         // of the constructor execution.
444 
445         return account.code.length > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain `call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.call{value: value}(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
552         return functionStaticCall(target, data, "Address: low-level static call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal view returns (bytes memory) {
566         require(isContract(target), "Address: static call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.staticcall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(isContract(target), "Address: delegate call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
601      * revert reason using the provided one.
602      *
603      * _Available since v4.3._
604      */
605     function verifyCallResult(
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) internal pure returns (bytes memory) {
610         if (success) {
611             return returndata;
612         } else {
613             // Look for revert reason and bubble it up if present
614             if (returndata.length > 0) {
615                 // The easiest way to bubble the revert reason is using memory via assembly
616 
617                 assembly {
618                     let returndata_size := mload(returndata)
619                     revert(add(32, returndata), returndata_size)
620                 }
621             } else {
622                 revert(errorMessage);
623             }
624         }
625     }
626 }
627 
628 
629 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
630 
631 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @dev String operations.
637  */
638 library Strings {
639     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
643      */
644     function toString(uint256 value) internal pure returns (string memory) {
645         // Inspired by OraclizeAPI's implementation - MIT licence
646         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
647 
648         if (value == 0) {
649             return "0";
650         }
651         uint256 temp = value;
652         uint256 digits;
653         while (temp != 0) {
654             digits++;
655             temp /= 10;
656         }
657         bytes memory buffer = new bytes(digits);
658         while (value != 0) {
659             digits -= 1;
660             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
661             value /= 10;
662         }
663         return string(buffer);
664     }
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
668      */
669     function toHexString(uint256 value) internal pure returns (string memory) {
670         if (value == 0) {
671             return "0x00";
672         }
673         uint256 temp = value;
674         uint256 length = 0;
675         while (temp != 0) {
676             length++;
677             temp >>= 8;
678         }
679         return toHexString(value, length);
680     }
681 
682     /**
683      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
684      */
685     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
686         bytes memory buffer = new bytes(2 * length + 2);
687         buffer[0] = "0";
688         buffer[1] = "x";
689         for (uint256 i = 2 * length + 1; i > 1; --i) {
690             buffer[i] = _HEX_SYMBOLS[value & 0xf];
691             value >>= 4;
692         }
693         require(value == 0, "Strings: hex length insufficient");
694         return string(buffer);
695     }
696 }
697 
698 
699 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Implementation of the {IERC165} interface.
707  *
708  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
709  * for the additional interface id that will be supported. For example:
710  *
711  * ```solidity
712  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
713  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
714  * }
715  * ```
716  *
717  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
718  */
719 abstract contract ERC165 is IERC165 {
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         return interfaceId == type(IERC165).interfaceId;
725     }
726 }
727 
728 
729 // File erc721a/contracts/ERC721A.sol@v3.1.0
730 
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 
738 
739 
740 
741 error ApprovalCallerNotOwnerNorApproved();
742 error ApprovalQueryForNonexistentToken();
743 error ApproveToCaller();
744 error ApprovalToCurrentOwner();
745 error BalanceQueryForZeroAddress();
746 error MintToZeroAddress();
747 error MintZeroQuantity();
748 error OwnerQueryForNonexistentToken();
749 error TransferCallerNotOwnerNorApproved();
750 error TransferFromIncorrectOwner();
751 error TransferToNonERC721ReceiverImplementer();
752 error TransferToZeroAddress();
753 error URIQueryForNonexistentToken();
754 
755 /**
756  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
757  * the Metadata extension. Built to optimize for lower gas during batch mints.
758  *
759  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
760  *
761  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
762  *
763  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
764  */
765 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Compiler will pack this into a single 256bit word.
770     struct TokenOwnership {
771         // The address of the owner.
772         address addr;
773         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
774         uint64 startTimestamp;
775         // Whether the token has been burned.
776         bool burned;
777     }
778 
779     // Compiler will pack this into a single 256bit word.
780     struct AddressData {
781         // Realistically, 2**64-1 is more than enough.
782         uint64 balance;
783         // Keeps track of mint count with minimal overhead for tokenomics.
784         uint64 numberMinted;
785         // Keeps track of burn count with minimal overhead for tokenomics.
786         uint64 numberBurned;
787         // For miscellaneous variable(s) pertaining to the address
788         // (e.g. number of whitelist mint slots used).
789         // If there are multiple variables, please pack them into a uint64.
790         uint64 aux;
791     }
792 
793     // The tokenId of the next token to be minted.
794     uint256 internal _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 internal _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
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
821         _currentIndex = _startTokenId();
822     }
823 
824     /**
825      * To change the starting tokenId, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
833      */
834     function totalSupply() public view returns (uint256) {
835         // Counter underflow is impossible as _burnCounter cannot be incremented
836         // more than _currentIndex - _startTokenId() times
837         unchecked {
838             return _currentIndex - _burnCounter - _startTokenId();
839         }
840     }
841 
842     /**
843      * Returns the total amount of tokens minted in the contract.
844      */
845     function _totalMinted() internal view returns (uint256) {
846         // Counter underflow is impossible as _currentIndex does not decrement,
847         // and it is initialized to _startTokenId()
848         unchecked {
849             return _currentIndex - _startTokenId();
850         }
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view override returns (uint256) {
867         if (owner == address(0)) revert BalanceQueryForZeroAddress();
868         return uint256(_addressData[owner].balance);
869     }
870 
871     /**
872      * Returns the number of tokens minted by `owner`.
873      */
874     function _numberMinted(address owner) internal view returns (uint256) {
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     /**
879      * Returns the number of tokens burned by or on behalf of `owner`.
880      */
881     function _numberBurned(address owner) internal view returns (uint256) {
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         return _addressData[owner].aux;
890     }
891 
892     /**
893      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      * If there are multiple variables, please pack them into a uint64.
895      */
896     function _setAux(address owner, uint64 aux) internal {
897         _addressData[owner].aux = aux;
898     }
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         uint256 curr = tokenId;
906 
907         unchecked {
908             if (_startTokenId() <= curr && curr < _currentIndex) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (!ownership.burned) {
911                     if (ownership.addr != address(0)) {
912                         return ownership;
913                     }
914                     // Invariant:
915                     // There will always be an ownership that has an address and is not burned
916                     // before an ownership that does not have an address and is not burned.
917                     // Hence, curr will not underflow.
918                     while (true) {
919                         curr--;
920                         ownership = _ownerships[curr];
921                         if (ownership.addr != address(0)) {
922                             return ownership;
923                         }
924                     }
925                 }
926             }
927         }
928         revert OwnerQueryForNonexistentToken();
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view override returns (address) {
935         return _ownershipOf(tokenId).addr;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
956         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
957 
958         string memory baseURI = _baseURI();
959         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return '';
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public override {
975         address owner = ERC721A.ownerOf(tokenId);
976         if (to == owner) revert ApprovalToCurrentOwner();
977 
978         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
979             revert ApprovalCallerNotOwnerNorApproved();
980         }
981 
982         _approve(to, tokenId, owner);
983     }
984 
985     /**
986      * @dev See {IERC721-getApproved}.
987      */
988     function getApproved(uint256 tokenId) public view override returns (address) {
989         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
990 
991         return _tokenApprovals[tokenId];
992     }
993 
994     /**
995      * @dev See {IERC721-setApprovalForAll}.
996      */
997     function setApprovalForAll(address operator, bool approved) public virtual override {
998         if (operator == _msgSender()) revert ApproveToCaller();
999 
1000         _operatorApprovals[_msgSender()][operator] = approved;
1001         emit ApprovalForAll(_msgSender(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-transferFrom}.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         _transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         safeTransferFrom(from, to, tokenId, '');
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes memory _data
1041     ) public virtual override {
1042         _transfer(from, to, tokenId);
1043         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1044             revert TransferToNonERC721ReceiverImplementer();
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns whether `tokenId` exists.
1050      *
1051      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1052      *
1053      * Tokens start existing when they are minted (`_mint`),
1054      */
1055     function _exists(uint256 tokenId) internal view returns (bool) {
1056         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1057             !_ownerships[tokenId].burned;
1058     }
1059 
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, '');
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data
1078     ) internal {
1079         _mint(to, quantity, _data, true);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data,
1096         bool safe
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (safe && to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex != end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex != end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) private {
1151         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1152 
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154 
1155         bool isApprovedOrOwner = (_msgSender() == from ||
1156             isApprovedForAll(from, _msgSender()) ||
1157             getApproved(tokenId) == _msgSender());
1158 
1159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             TokenOwnership storage currSlot = _ownerships[tokenId];
1175             currSlot.addr = to;
1176             currSlot.startTimestamp = uint64(block.timestamp);
1177 
1178             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1179             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180             uint256 nextTokenId = tokenId + 1;
1181             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1182             if (nextSlot.addr == address(0)) {
1183                 // This will suffice for checking _exists(nextTokenId),
1184                 // as a burned slot cannot contain the zero address.
1185                 if (nextTokenId != _currentIndex) {
1186                     nextSlot.addr = from;
1187                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1188                 }
1189             }
1190         }
1191 
1192         emit Transfer(from, to, tokenId);
1193         _afterTokenTransfers(from, to, tokenId, 1);
1194     }
1195 
1196     /**
1197      * @dev This is equivalent to _burn(tokenId, false)
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1215 
1216         address from = prevOwnership.addr;
1217 
1218         if (approvalCheck) {
1219             bool isApprovedOrOwner = (_msgSender() == from ||
1220                 isApprovedForAll(from, _msgSender()) ||
1221                 getApproved(tokenId) == _msgSender());
1222 
1223             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, from);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             AddressData storage addressData = _addressData[from];
1236             addressData.balance -= 1;
1237             addressData.numberBurned += 1;
1238 
1239             // Keep track of who burned the token, and the timestamp of burning.
1240             TokenOwnership storage currSlot = _ownerships[tokenId];
1241             currSlot.addr = from;
1242             currSlot.startTimestamp = uint64(block.timestamp);
1243             currSlot.burned = true;
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1249             if (nextSlot.addr == address(0)) {
1250                 // This will suffice for checking _exists(nextTokenId),
1251                 // as a burned slot cannot contain the zero address.
1252                 if (nextTokenId != _currentIndex) {
1253                     nextSlot.addr = from;
1254                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(from, address(0), tokenId);
1260         _afterTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1263         unchecked {
1264             _burnCounter++;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Approve `to` to operate on `tokenId`
1270      *
1271      * Emits a {Approval} event.
1272      */
1273     function _approve(
1274         address to,
1275         uint256 tokenId,
1276         address owner
1277     ) private {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(owner, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkContractOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1298             return retval == IERC721Receiver(to).onERC721Received.selector;
1299         } catch (bytes memory reason) {
1300             if (reason.length == 0) {
1301                 revert TransferToNonERC721ReceiverImplementer();
1302             } else {
1303                 assembly {
1304                     revert(add(32, reason), mload(reason))
1305                 }
1306             }
1307         }
1308     }
1309 
1310     /**
1311      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1312      * And also called before burning one token.
1313      *
1314      * startTokenId - the first token id to be transferred
1315      * quantity - the amount to be transferred
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, `tokenId` will be burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _beforeTokenTransfers(
1326         address from,
1327         address to,
1328         uint256 startTokenId,
1329         uint256 quantity
1330     ) internal virtual {}
1331 
1332     /**
1333      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1334      * minting.
1335      * And also called after one token has been burned.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` has been minted for `to`.
1345      * - When `to` is zero, `tokenId` has been burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _afterTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 }
1355 
1356 
1357 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
1358 
1359 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 /**
1364  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1365  *
1366  * These functions can be used to verify that a message was signed by the holder
1367  * of the private keys of a given address.
1368  */
1369 library ECDSA {
1370     enum RecoverError {
1371         NoError,
1372         InvalidSignature,
1373         InvalidSignatureLength,
1374         InvalidSignatureS,
1375         InvalidSignatureV
1376     }
1377 
1378     function _throwError(RecoverError error) private pure {
1379         if (error == RecoverError.NoError) {
1380             return; // no error: do nothing
1381         } else if (error == RecoverError.InvalidSignature) {
1382             revert("ECDSA: invalid signature");
1383         } else if (error == RecoverError.InvalidSignatureLength) {
1384             revert("ECDSA: invalid signature length");
1385         } else if (error == RecoverError.InvalidSignatureS) {
1386             revert("ECDSA: invalid signature 's' value");
1387         } else if (error == RecoverError.InvalidSignatureV) {
1388             revert("ECDSA: invalid signature 'v' value");
1389         }
1390     }
1391 
1392     /**
1393      * @dev Returns the address that signed a hashed message (`hash`) with
1394      * `signature` or error string. This address can then be used for verification purposes.
1395      *
1396      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1397      * this function rejects them by requiring the `s` value to be in the lower
1398      * half order, and the `v` value to be either 27 or 28.
1399      *
1400      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1401      * verification to be secure: it is possible to craft signatures that
1402      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1403      * this is by receiving a hash of the original message (which may otherwise
1404      * be too long), and then calling {toEthSignedMessageHash} on it.
1405      *
1406      * Documentation for signature generation:
1407      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1408      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1409      *
1410      * _Available since v4.3._
1411      */
1412     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1413         // Check the signature length
1414         // - case 65: r,s,v signature (standard)
1415         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1416         if (signature.length == 65) {
1417             bytes32 r;
1418             bytes32 s;
1419             uint8 v;
1420             // ecrecover takes the signature parameters, and the only way to get them
1421             // currently is to use assembly.
1422             assembly {
1423                 r := mload(add(signature, 0x20))
1424                 s := mload(add(signature, 0x40))
1425                 v := byte(0, mload(add(signature, 0x60)))
1426             }
1427             return tryRecover(hash, v, r, s);
1428         } else if (signature.length == 64) {
1429             bytes32 r;
1430             bytes32 vs;
1431             // ecrecover takes the signature parameters, and the only way to get them
1432             // currently is to use assembly.
1433             assembly {
1434                 r := mload(add(signature, 0x20))
1435                 vs := mload(add(signature, 0x40))
1436             }
1437             return tryRecover(hash, r, vs);
1438         } else {
1439             return (address(0), RecoverError.InvalidSignatureLength);
1440         }
1441     }
1442 
1443     /**
1444      * @dev Returns the address that signed a hashed message (`hash`) with
1445      * `signature`. This address can then be used for verification purposes.
1446      *
1447      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1448      * this function rejects them by requiring the `s` value to be in the lower
1449      * half order, and the `v` value to be either 27 or 28.
1450      *
1451      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1452      * verification to be secure: it is possible to craft signatures that
1453      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1454      * this is by receiving a hash of the original message (which may otherwise
1455      * be too long), and then calling {toEthSignedMessageHash} on it.
1456      */
1457     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1458         (address recovered, RecoverError error) = tryRecover(hash, signature);
1459         _throwError(error);
1460         return recovered;
1461     }
1462 
1463     /**
1464      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1465      *
1466      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1467      *
1468      * _Available since v4.3._
1469      */
1470     function tryRecover(
1471         bytes32 hash,
1472         bytes32 r,
1473         bytes32 vs
1474     ) internal pure returns (address, RecoverError) {
1475         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1476         uint8 v = uint8((uint256(vs) >> 255) + 27);
1477         return tryRecover(hash, v, r, s);
1478     }
1479 
1480     /**
1481      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1482      *
1483      * _Available since v4.2._
1484      */
1485     function recover(
1486         bytes32 hash,
1487         bytes32 r,
1488         bytes32 vs
1489     ) internal pure returns (address) {
1490         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1491         _throwError(error);
1492         return recovered;
1493     }
1494 
1495     /**
1496      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1497      * `r` and `s` signature fields separately.
1498      *
1499      * _Available since v4.3._
1500      */
1501     function tryRecover(
1502         bytes32 hash,
1503         uint8 v,
1504         bytes32 r,
1505         bytes32 s
1506     ) internal pure returns (address, RecoverError) {
1507         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1508         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1509         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1510         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1511         //
1512         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1513         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1514         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1515         // these malleable signatures as well.
1516         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1517             return (address(0), RecoverError.InvalidSignatureS);
1518         }
1519         if (v != 27 && v != 28) {
1520             return (address(0), RecoverError.InvalidSignatureV);
1521         }
1522 
1523         // If the signature is valid (and not malleable), return the signer address
1524         address signer = ecrecover(hash, v, r, s);
1525         if (signer == address(0)) {
1526             return (address(0), RecoverError.InvalidSignature);
1527         }
1528 
1529         return (signer, RecoverError.NoError);
1530     }
1531 
1532     /**
1533      * @dev Overload of {ECDSA-recover} that receives the `v`,
1534      * `r` and `s` signature fields separately.
1535      */
1536     function recover(
1537         bytes32 hash,
1538         uint8 v,
1539         bytes32 r,
1540         bytes32 s
1541     ) internal pure returns (address) {
1542         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1543         _throwError(error);
1544         return recovered;
1545     }
1546 
1547     /**
1548      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1549      * produces hash corresponding to the one signed with the
1550      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1551      * JSON-RPC method as part of EIP-191.
1552      *
1553      * See {recover}.
1554      */
1555     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1556         // 32 is the length in bytes of hash,
1557         // enforced by the type signature above
1558         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1559     }
1560 
1561     /**
1562      * @dev Returns an Ethereum Signed Message, created from `s`. This
1563      * produces hash corresponding to the one signed with the
1564      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1565      * JSON-RPC method as part of EIP-191.
1566      *
1567      * See {recover}.
1568      */
1569     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1570         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1571     }
1572 
1573     /**
1574      * @dev Returns an Ethereum Signed Typed Data, created from a
1575      * `domainSeparator` and a `structHash`. This produces hash corresponding
1576      * to the one signed with the
1577      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1578      * JSON-RPC method as part of EIP-712.
1579      *
1580      * See {recover}.
1581      */
1582     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1583         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1584     }
1585 }
1586 
1587 
1588 // File contracts/library/AddressString.sol
1589 
1590 
1591 pragma solidity >=0.5.0;
1592 
1593 library AddressString {
1594     // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)
1595     function toAsciiString(address addr) internal pure returns (string memory) {
1596         bytes memory s = new bytes(42);
1597         uint160 addrNum = uint160(addr);
1598         s[0] = '0';
1599         s[1] = 'X';
1600         for (uint256 i = 0; i < 40 / 2; i++) {
1601             // shift right and truncate all but the least significant byte to extract the byte at position 19-i
1602             uint8 b = uint8(addrNum >> (8 * (19 - i)));
1603             // first hex character is the most significant 4 bits
1604             uint8 hi = b >> 4;
1605             // second hex character is the least significant 4 bits
1606             uint8 lo = b - (hi << 4);
1607             s[2 * i + 2] = char(hi);
1608             s[2 * i + 3] = char(lo);
1609         }
1610         return string(s);
1611     }
1612 
1613     // hi and lo are only 4 bits and between 0 and 16
1614     // this method converts those values to the unicode/ascii code point for the hex representation
1615     // uses upper case for the characters
1616     function char(uint8 b) private pure returns (bytes1 c) {
1617         if (b < 10) {
1618             return bytes1(b + 0x30);
1619         } else {
1620             return bytes1(b + 0x37);
1621         }
1622     }
1623 }
1624 
1625 
1626 // File contracts/exv.nft.battlepass.sol
1627 
1628 pragma solidity ^0.8.4;
1629 
1630 
1631 
1632 
1633 
1634 contract BattlePass is Ownable, ERC721A, ReentrancyGuard {
1635   uint256 public immutable maxPerAddressDuringMint;
1636   uint256 public immutable amountForDevs;
1637   uint256 public immutable collectionSize;
1638   uint256 public immutable maxBatchSize;
1639 
1640   struct SaleConfig {
1641     uint32 whitelistSaleStartTime;
1642     uint32 publicSaleStartTime;
1643     uint64 priceWei;
1644     address whitelistSigner;
1645   }
1646 
1647   SaleConfig public config;
1648 
1649   constructor() 
1650   ERC721A("Exverse pass", "EXVPASS")
1651   {
1652     amountForDevs = 50;
1653     maxBatchSize = 5;
1654     collectionSize = 2000;
1655     maxPerAddressDuringMint = 1;
1656     config.priceWei = 0.1 ether;
1657   }
1658 
1659   modifier callerIsUser() {
1660     require(tx.origin == msg.sender, "The caller is another contract");
1661     _;
1662   }
1663 
1664 
1665   function _startTokenId() internal override view virtual returns (uint256) {
1666       return 1;
1667   }
1668 
1669   function whitelistMint(
1670       uint256 quantity,
1671       bytes memory signature
1672   )
1673     external
1674     payable
1675     callerIsUser
1676   {
1677     uint256 price = uint256(config.priceWei);
1678     uint256 whitelistSaleStartTime = uint256(config.whitelistSaleStartTime);
1679 
1680     require(
1681       isSaleOn(price, whitelistSaleStartTime),
1682       "whitelist sale has not begun yet"
1683     );
1684 
1685     require(
1686       totalSupply() + quantity <= collectionSize,
1687       "not enough remaining reserved for sale to support desired mint amount"
1688     );
1689 
1690     require(
1691       numberMinted(msg.sender) + quantity <= 1,
1692       "can not mint this many"
1693     );
1694 
1695     bytes memory data = abi.encodePacked(
1696         AddressString.toAsciiString(msg.sender),
1697         ":1"
1698     );
1699     bytes32 hash = ECDSA.toEthSignedMessageHash(data);
1700     address signer = ECDSA.recover(hash, signature);
1701 
1702     require(
1703         signer == config.whitelistSigner,
1704         "wrong sig"
1705     );
1706 
1707     uint256 totalCost = price * quantity;
1708     _safeMint(msg.sender, quantity);
1709     refundIfOver(totalCost);
1710   }
1711 
1712   function mint(uint256 quantity)
1713     external
1714     payable
1715     callerIsUser
1716   {
1717     uint256 publicPrice = uint256(config.priceWei);
1718     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1719 
1720     require(
1721       isSaleOn(publicPrice, publicSaleStartTime),
1722       "sale has not begun yet"
1723     );
1724     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1725     require(
1726       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1727       "can not mint this many"
1728     );
1729     _safeMint(msg.sender, quantity);
1730     refundIfOver(publicPrice * quantity);
1731   }
1732 
1733   function refundIfOver(uint256 price)
1734     private
1735   {
1736     require(msg.value >= price, "Need to send more ETH.");
1737     if (msg.value > price) {
1738       payable(msg.sender).transfer(msg.value - price);
1739     }
1740   }
1741 
1742   function isSaleOn(uint256 _price, uint256 _startTime)
1743     public
1744     view
1745     returns (bool)
1746   {
1747     return _price != 0 && _startTime != 0 && block.timestamp >= _startTime;
1748   }
1749 
1750 
1751   function setPrice(uint64 price)
1752     external
1753     onlyOwner
1754   {
1755     config.priceWei = price;
1756   }
1757 
1758 
1759   function setWhitelistSaleConfig(uint32 timestamp, address signer)
1760     external
1761     onlyOwner
1762   {
1763     config.whitelistSaleStartTime = timestamp;
1764     config.whitelistSigner = signer;
1765   }
1766 
1767   function setPublicSaleConfig(uint32 timestamp)
1768     external
1769     onlyOwner 
1770   {
1771       config.publicSaleStartTime = timestamp;
1772   }
1773 
1774   // For marketing etc.
1775   function reserve(uint256 quantity)
1776     external
1777     onlyOwner
1778   {
1779     require(
1780       totalSupply() + quantity <= amountForDevs,
1781       "too many already minted before dev mint"
1782     );
1783     require(
1784       quantity % maxBatchSize == 0,
1785       "can only mint a multiple of the maxBatchSize"
1786     );
1787     uint256 numChunks = quantity / maxBatchSize;
1788     for (uint256 i = 0; i < numChunks; i++) {
1789       _safeMint(msg.sender, maxBatchSize);
1790     }
1791   }
1792 
1793   // // metadata URI
1794   string private _baseTokenURI;
1795 
1796   function _baseURI()
1797     internal
1798     view
1799     virtual
1800     override
1801     returns (string memory)
1802   {
1803     return _baseTokenURI;
1804   }
1805 
1806   function setBaseURI(string calldata baseURI)
1807     external
1808     onlyOwner
1809   {
1810     _baseTokenURI = baseURI;
1811   }
1812 
1813   function withdraw()
1814     external
1815     onlyOwner
1816     nonReentrant
1817   {
1818     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1819     require(success, "Transfer failed.");
1820   }
1821 
1822   function numberMinted(address owner)
1823     public
1824     view
1825     returns (uint256)
1826   {
1827     return _numberMinted(owner);
1828   }
1829 
1830   function getOwnershipData(uint256 tokenId)
1831     external
1832     view
1833     returns (TokenOwnership memory)
1834   {
1835     return _ownershipOf(tokenId);
1836   }
1837 
1838   function totalMinted()
1839     public
1840     view
1841     returns (uint256)
1842   {
1843       // Counter underflow is impossible as _currentIndex does not decrement,
1844       // and it is initialized to _startTokenId()
1845       unchecked {
1846           return _currentIndex - _startTokenId();
1847       }
1848   }
1849 }
1850 
1851 
1852 // File contracts/mocks/ERC721ReceiverMock.sol
1853 
1854 // Creators: Chiru Labs
1855 
1856 pragma solidity ^0.8.4;
1857 
1858 contract ERC721ReceiverMock is IERC721Receiver {
1859     enum Error {
1860         None,
1861         RevertWithMessage,
1862         RevertWithoutMessage,
1863         Panic
1864     }
1865 
1866     bytes4 private immutable _retval;
1867 
1868     event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);
1869 
1870     constructor(bytes4 retval) {
1871         _retval = retval;
1872     }
1873 
1874     function onERC721Received(
1875         address operator,
1876         address from,
1877         uint256 tokenId,
1878         bytes memory data
1879     ) public override returns (bytes4) {
1880         emit Received(operator, from, tokenId, data, 20000);
1881         return _retval;
1882     }
1883 }
1884 
1885 
1886 // File contracts/mocks/StartTokenIdHelper.sol
1887 
1888 // Creators: Chiru Labs
1889 
1890 pragma solidity ^0.8.4;
1891 
1892 /**
1893  * This Helper is used to return a dynmamic value in the overriden _startTokenId() function.
1894  * Extending this Helper before the ERC721A contract give us access to the herein set `startTokenId`
1895  * to be returned by the overriden `_startTokenId()` function of ERC721A in the ERC721AStartTokenId mocks.
1896  */
1897 contract StartTokenIdHelper {
1898     uint256 public immutable startTokenId;
1899 
1900     constructor(uint256 startTokenId_) {
1901         startTokenId = startTokenId_;
1902     }
1903 }