1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         assembly {
277             size := extcodesize(account)
278         }
279         return size > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 interface IERC721Receiver {
475     /**
476      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
477      * by `operator` from `from`, this function is called.
478      *
479      * It must return its Solidity selector to confirm the token transfer.
480      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
481      *
482      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
483      */
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Interface of the ERC165 standard, as defined in the
501  * https://eips.ethereum.org/EIPS/eip-165[EIP].
502  *
503  * Implementers can declare support of contract interfaces, which can then be
504  * queried by others ({ERC165Checker}).
505  *
506  * For an implementation, see {ERC165}.
507  */
508 interface IERC165 {
509     /**
510      * @dev Returns true if this contract implements the interface defined by
511      * `interfaceId`. See the corresponding
512      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
513      * to learn more about how these ids are created.
514      *
515      * This function call must use less than 30 000 gas.
516      */
517     function supportsInterface(bytes4 interfaceId) external view returns (bool);
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
532  * for the additional interface id that will be supported. For example:
533  *
534  * ```solidity
535  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
537  * }
538  * ```
539  *
540  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
541  */
542 abstract contract ERC165 is IERC165 {
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         return interfaceId == type(IERC165).interfaceId;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Required interface of an ERC721 compliant contract.
561  */
562 interface IERC721 is IERC165 {
563     /**
564      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
570      */
571     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
575      */
576     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
577 
578     /**
579      * @dev Returns the number of tokens in ``owner``'s account.
580      */
581     function balanceOf(address owner) external view returns (uint256 balance);
582 
583     /**
584      * @dev Returns the owner of the `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function ownerOf(uint256 tokenId) external view returns (address owner);
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
594      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must exist and be owned by `from`.
601      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
603      *
604      * Emits a {Transfer} event.
605      */
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Transfers `tokenId` token from `from` to `to`.
614      *
615      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      *
624      * Emits a {Transfer} event.
625      */
626     function transferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
634      * The approval is cleared when the token is transferred.
635      *
636      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
637      *
638      * Requirements:
639      *
640      * - The caller must own the token or be an approved operator.
641      * - `tokenId` must exist.
642      *
643      * Emits an {Approval} event.
644      */
645     function approve(address to, uint256 tokenId) external;
646 
647     /**
648      * @dev Returns the account approved for `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function getApproved(uint256 tokenId) external view returns (address operator);
655 
656     /**
657      * @dev Approve or remove `operator` as an operator for the caller.
658      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
659      *
660      * Requirements:
661      *
662      * - The `operator` cannot be the caller.
663      *
664      * Emits an {ApprovalForAll} event.
665      */
666     function setApprovalForAll(address operator, bool _approved) external;
667 
668     /**
669      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
670      *
671      * See {setApprovalForAll}
672      */
673     function isApprovedForAll(address owner, address operator) external view returns (bool);
674 
675     /**
676      * @dev Safely transfers `tokenId` token from `from` to `to`.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must exist and be owned by `from`.
683      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
684      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
685      *
686      * Emits a {Transfer} event.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId,
692         bytes calldata data
693     ) external;
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: contracts/ERC721A.sol
726 
727 
728 // Creator: Chiru Labs
729 
730 pragma solidity ^0.8.0;
731 
732 
733 
734 
735 
736 
737 
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
744  *
745  * Does not support burning tokens to address(0).
746  *
747  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
748  */
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     struct TokenOwnership {
754         address addr;
755         uint64 startTimestamp;
756     }
757 
758     struct AddressData {
759         uint128 balance;
760         uint128 numberMinted;
761     }
762 
763     uint256 internal currentIndex;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to ownership details
772     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
773     mapping(uint256 => TokenOwnership) internal _ownerships;
774 
775     // Mapping owner address to address data
776     mapping(address => AddressData) private _addressData;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     function totalSupply() public view returns (uint256) {
790         return currentIndex;
791     }
792 
793     /**
794      * @dev See {IERC165-supportsInterface}.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
797         return
798         interfaceId == type(IERC721).interfaceId ||
799         interfaceId == type(IERC721Metadata).interfaceId ||
800         super.supportsInterface(interfaceId);
801     }
802 
803     /**
804      * @dev See {IERC721-balanceOf}.
805      */
806     function balanceOf(address owner) public view override returns (uint256) {
807         require(owner != address(0), 'ERC721A: balance query for the zero address');
808         return uint256(_addressData[owner].balance);
809     }
810 
811     function _numberMinted(address owner) internal view returns (uint256) {
812         require(owner != address(0), 'ERC721A: number minted query for the zero address');
813         return uint256(_addressData[owner].numberMinted);
814     }
815 
816     /**
817      * Gas spent here starts off proportional to the maximum mint batch size.
818      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
819      */
820     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
821         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
822 
823     unchecked {
824         for (uint256 curr = tokenId; curr >= 0; curr--) {
825             TokenOwnership memory ownership = _ownerships[curr];
826             if (ownership.addr != address(0)) {
827                 return ownership;
828             }
829         }
830     }
831 
832         revert('ERC721A: unable to determine the owner of token');
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return ownershipOf(tokenId).addr;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public override {
879         address owner = ERC721A.ownerOf(tokenId);
880         require(to != owner, 'ERC721A: approval to current owner');
881 
882         require(
883             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
884             'ERC721A: approve caller is not owner nor approved for all'
885         );
886 
887         _approve(to, tokenId, owner);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view override returns (address) {
894         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public override {
903         require(operator != _msgSender(), 'ERC721A: approve to caller');
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public override {
947         _transfer(from, to, tokenId);
948         require(
949             _checkOnERC721Received(from, to, tokenId, _data),
950             'ERC721A: transfer to non ERC721Receiver implementer'
951         );
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return tokenId < currentIndex;
963     }
964 
965     function _safeMint(address to, uint256 quantity) internal {
966         _safeMint(to, quantity, '');
967     }
968 
969     /**
970      * @dev Safely mints `quantity` tokens and transfers them to `to`.
971      *
972      * Requirements:
973      *
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
975      * - `quantity` must be greater than 0.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeMint(
980         address to,
981         uint256 quantity,
982         bytes memory _data
983     ) internal {
984         _mint(to, quantity, _data, true);
985     }
986 
987     /**
988      * @dev Mints `quantity` tokens and transfers them to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `quantity` must be greater than 0.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(
998         address to,
999         uint256 quantity,
1000         bytes memory _data,
1001         bool safe
1002     ) internal {
1003         uint256 startTokenId = currentIndex;
1004         require(to != address(0), 'ERC721A: mint to the zero address');
1005         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1006 
1007         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1008 
1009         // Overflows are incredibly unrealistic.
1010         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1011         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1012     unchecked {
1013         _addressData[to].balance += uint128(quantity);
1014         _addressData[to].numberMinted += uint128(quantity);
1015 
1016         _ownerships[startTokenId].addr = to;
1017         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1018 
1019         uint256 updatedIndex = startTokenId;
1020 
1021         for (uint256 i; i < quantity; i++) {
1022             emit Transfer(address(0), to, updatedIndex);
1023             if (safe) {
1024                 require(
1025                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1026                     'ERC721A: transfer to non ERC721Receiver implementer'
1027                 );
1028             }
1029 
1030             updatedIndex++;
1031         }
1032 
1033         currentIndex = updatedIndex;
1034     }
1035 
1036         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1037     }
1038 
1039     /**
1040      * @dev Transfers `tokenId` from `from` to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) private {
1054         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1055 
1056         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1057         getApproved(tokenId) == _msgSender() ||
1058         isApprovedForAll(prevOwnership.addr, _msgSender()));
1059 
1060         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1061 
1062         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1063         require(to != address(0), 'ERC721A: transfer to the zero address');
1064 
1065         _beforeTokenTransfers(from, to, tokenId, 1);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId, prevOwnership.addr);
1069 
1070         // Underflow of the sender's balance is impossible because we check for
1071         // ownership above and the recipient's balance can't realistically overflow.
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1073     unchecked {
1074         _addressData[from].balance -= 1;
1075         _addressData[to].balance += 1;
1076 
1077         _ownerships[tokenId].addr = to;
1078         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1079 
1080         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1081         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1082         uint256 nextTokenId = tokenId + 1;
1083         if (_ownerships[nextTokenId].addr == address(0)) {
1084             if (_exists(nextTokenId)) {
1085                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1086                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1087             }
1088         }
1089     }
1090 
1091         emit Transfer(from, to, tokenId);
1092         _afterTokenTransfers(from, to, tokenId, 1);
1093     }
1094 
1095     /**
1096      * @dev Approve `to` to operate on `tokenId`
1097      *
1098      * Emits a {Approval} event.
1099      */
1100     function _approve(
1101         address to,
1102         uint256 tokenId,
1103         address owner
1104     ) private {
1105         _tokenApprovals[tokenId] = to;
1106         emit Approval(owner, to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1111      * The call is not executed if the target address is not a contract.
1112      *
1113      * @param from address representing the previous owner of the given token ID
1114      * @param to target address that will receive the tokens
1115      * @param tokenId uint256 ID of the token to be transferred
1116      * @param _data bytes optional data to send along with the call
1117      * @return bool whether the call correctly returned the expected magic value
1118      */
1119     function _checkOnERC721Received(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) private returns (bool) {
1125         if (to.isContract()) {
1126             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1127                 return retval == IERC721Receiver(to).onERC721Received.selector;
1128             } catch (bytes memory reason) {
1129                 if (reason.length == 0) {
1130                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1131                 } else {
1132                     assembly {
1133                         revert(add(32, reason), mload(reason))
1134                     }
1135                 }
1136             }
1137         } else {
1138             return true;
1139         }
1140     }
1141 
1142     /**
1143      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1144      *
1145      * startTokenId - the first token id to be transferred
1146      * quantity - the amount to be transferred
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` will be minted for `to`.
1153      */
1154     function _beforeTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 
1161     /**
1162      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1163      * minting.
1164      *
1165      * startTokenId - the first token id to be transferred
1166      * quantity - the amount to be transferred
1167      *
1168      * Calling conditions:
1169      *
1170      * - when `from` and `to` are both non-zero.
1171      * - `from` and `to` are never both zero.
1172      */
1173     function _afterTokenTransfers(
1174         address from,
1175         address to,
1176         uint256 startTokenId,
1177         uint256 quantity
1178     ) internal virtual {}
1179 }
1180 // File: contracts/AzukiX.sol
1181 
1182 
1183 
1184 pragma solidity ^0.8.4;
1185 
1186 
1187 
1188 
1189 contract AzukiX is ERC721A, Ownable, ReentrancyGuard {
1190     using Strings for uint256;
1191 
1192     uint256 public PRICE;
1193     uint256 public MAX_SUPPLY;
1194     string private BASE_URI;
1195     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1196     uint256 public MAX_MINT_AMOUNT_PER_TX;
1197     bool public IS_SALE_ACTIVE;
1198     uint256 public FREE_MINT_IS_ALLOWED_UNTIL; // Free mint is allowed until x mint
1199     bool public METADATA_FROZEN;
1200 
1201     mapping(address => uint256) private freeMintCountMap;
1202 
1203     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintAllowance, uint256 maxMintPerTx, bool isSaleActive, uint256 freeMintIsAllowedUntil) ERC721A("AzukiX", "AzukiX") {
1204         PRICE = price;
1205         MAX_SUPPLY = maxSupply;
1206         BASE_URI = baseUri;
1207         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1208         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1209         IS_SALE_ACTIVE = isSaleActive;
1210         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1211     }
1212 
1213     /** FREE MINT **/
1214 
1215     function updateFreeMintCount(address minter, uint256 count) private {
1216         freeMintCountMap[minter] += count;
1217     }
1218 
1219     /** GETTERS **/
1220 
1221     function _baseURI() internal view virtual override returns (string memory) {
1222         return BASE_URI;
1223     }
1224 
1225     /** SETTERS **/
1226 
1227     function setPrice(uint256 customPrice) external onlyOwner {
1228         PRICE = customPrice;
1229     }
1230 
1231     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1232         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1233         require(newMaxSupply >= currentIndex, "Invalid new max supply");
1234         MAX_SUPPLY = newMaxSupply;
1235     }
1236 
1237     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1238         require(!METADATA_FROZEN, "Metadata frozen!");
1239         BASE_URI = customBaseURI_;
1240     }
1241 
1242     function setFreeMintAllowance(uint256 freeMintAllowance) external onlyOwner {
1243         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1244     }
1245 
1246     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1247         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1248     }
1249 
1250     function setSaleActive(bool saleIsActive) external onlyOwner {
1251         IS_SALE_ACTIVE = saleIsActive;
1252     }
1253 
1254     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1255         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1256     }
1257 
1258     function freezeMetadata() external onlyOwner {
1259         METADATA_FROZEN = true;
1260     }
1261 
1262     /** MINT **/
1263 
1264     modifier mintCompliance(uint256 _mintAmount) {
1265         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount!");
1266         require(currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1267         _;
1268     }
1269 
1270     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1271         require(IS_SALE_ACTIVE, "Sale is not active!");
1272 
1273         uint256 price = PRICE * _mintAmount;
1274 
1275         if (currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1276             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET - freeMintCountMap[msg.sender];
1277             if (remainingFreeMint > 0) {
1278                 if (_mintAmount >= remainingFreeMint) {
1279                     price -= remainingFreeMint * PRICE;
1280                     updateFreeMintCount(msg.sender, remainingFreeMint);
1281                 } else {
1282                     price -= _mintAmount * PRICE;
1283                     updateFreeMintCount(msg.sender, _mintAmount);
1284                 }
1285             }
1286         }
1287 
1288         require(msg.value >= price, "Insufficient funds!");
1289 
1290         _safeMint(msg.sender, _mintAmount);
1291     }
1292 
1293     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1294         _safeMint(_to, _mintAmount);
1295     }
1296 
1297     /** PAYOUT **/
1298 
1299     address private constant payoutAddress =
1300     0x45fbD2C83775A53d86e46DdAc56E7ADc7402233e;
1301 
1302     function withdraw() public onlyOwner nonReentrant {
1303         uint256 balance = address(this).balance;
1304 
1305         Address.sendValue(payable(payoutAddress), balance);
1306     }
1307 }