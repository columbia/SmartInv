1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
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
137 // File: @openzeppelin/contracts/utils/Context.sol
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
164 // File: @openzeppelin/contracts/access/Ownable.sol
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
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Enumerable is IERC721 {
709     /**
710      * @dev Returns the total amount of tokens stored by the contract.
711      */
712     function totalSupply() external view returns (uint256);
713 
714     /**
715      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
716      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
717      */
718     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
719 
720     /**
721      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
722      * Use along with {totalSupply} to enumerate all tokens.
723      */
724     function tokenByIndex(uint256 index) external view returns (uint256);
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
737  * @dev See https://eips.ethereum.org/EIPS/eip-721
738  */
739 interface IERC721Metadata is IERC721 {
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() external view returns (string memory);
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() external view returns (string memory);
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) external view returns (string memory);
754 }
755 
756 // File: ERC721A.sol
757 
758 
759 
760 pragma solidity ^0.8.0;
761 
762 
763 
764 
765 
766 
767 
768 
769 
770 /**
771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
772  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
773  *
774  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
775  *
776  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
777  *
778  * Does not support burning tokens to address(0).
779  */
780 contract ERC721A is
781     Context,
782     ERC165,
783     IERC721,
784     IERC721Metadata,
785     IERC721Enumerable
786 {
787     using Address for address;
788     using Strings for uint256;
789 
790     struct TokenOwnership {
791         address addr;
792         uint64 startTimestamp;
793     }
794 
795     struct AddressData {
796         uint128 balance;
797         uint128 numberMinted;
798     }
799 
800     uint256 private currentIndex = 0;
801 
802     uint256 internal immutable collectionSize;
803     uint256 internal immutable maxBatchSize;
804 
805     // Token name
806     string private _name;
807 
808     // Token symbol
809     string private _symbol;
810 
811     // Mapping from token ID to ownership details
812     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
813     mapping(uint256 => TokenOwnership) private _ownerships;
814 
815     // Mapping owner address to address data
816     mapping(address => AddressData) private _addressData;
817 
818     // Mapping from token ID to approved address
819     mapping(uint256 => address) private _tokenApprovals;
820 
821     // Mapping from owner to operator approvals
822     mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824     /**
825      * @dev
826      * `maxBatchSize` refers to how much a minter can mint at a time.
827      * `collectionSize_` refers to how many tokens are in the collection.
828      */
829     constructor(
830         string memory name_,
831         string memory symbol_,
832         uint256 maxBatchSize_,
833         uint256 collectionSize_
834     ) {
835         require(
836             collectionSize_ > 0,
837             "ERC721A: collection must have a nonzero supply"
838         );
839         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
840         _name = name_;
841         _symbol = symbol_;
842         maxBatchSize = maxBatchSize_;
843         collectionSize = collectionSize_;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-totalSupply}.
848      */
849     function totalSupply() public view override returns (uint256) {
850         return currentIndex;
851     }
852 
853     /**
854      * @dev See {IERC721Enumerable-tokenByIndex}.
855      */
856     function tokenByIndex(uint256 index)
857         public
858         view
859         override
860         returns (uint256)
861     {
862         require(index < totalSupply(), "ERC721A: global index out of bounds");
863         return index;
864     }
865 
866     /**
867      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
868      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
869      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
870      */
871     function tokenOfOwnerByIndex(address owner, uint256 index)
872         public
873         view
874         override
875         returns (uint256)
876     {
877         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
878         uint256 numMintedSoFar = totalSupply();
879         uint256 tokenIdsIdx = 0;
880         address currOwnershipAddr = address(0);
881         for (uint256 i = 0; i < numMintedSoFar; i++) {
882             TokenOwnership memory ownership = _ownerships[i];
883             if (ownership.addr != address(0)) {
884                 currOwnershipAddr = ownership.addr;
885             }
886             if (currOwnershipAddr == owner) {
887                 if (tokenIdsIdx == index) {
888                     return i;
889                 }
890                 tokenIdsIdx++;
891             }
892         }
893         revert("ERC721A: unable to get token of owner by index");
894     }
895 
896     /**
897      * @dev See {IERC165-supportsInterface}.
898      */
899     function supportsInterface(bytes4 interfaceId)
900         public
901         view
902         virtual
903         override(ERC165, IERC165)
904         returns (bool)
905     {
906         return
907             interfaceId == type(IERC721).interfaceId ||
908             interfaceId == type(IERC721Metadata).interfaceId ||
909             interfaceId == type(IERC721Enumerable).interfaceId ||
910             super.supportsInterface(interfaceId);
911     }
912 
913     /**
914      * @dev See {IERC721-balanceOf}.
915      */
916     function balanceOf(address owner) public view override returns (uint256) {
917         require(
918             owner != address(0),
919             "ERC721A: balance query for the zero address"
920         );
921         return uint256(_addressData[owner].balance);
922     }
923 
924     function _numberMinted(address owner) internal view returns (uint256) {
925         require(
926             owner != address(0),
927             "ERC721A: number minted query for the zero address"
928         );
929         return uint256(_addressData[owner].numberMinted);
930     }
931 
932     function ownershipOf(uint256 tokenId)
933         internal
934         view
935         returns (TokenOwnership memory)
936     {
937         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
938 
939         uint256 lowestTokenToCheck;
940         if (tokenId >= maxBatchSize) {
941             lowestTokenToCheck = tokenId - maxBatchSize + 1;
942         }
943 
944         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
945             TokenOwnership memory ownership = _ownerships[curr];
946             if (ownership.addr != address(0)) {
947                 return ownership;
948             }
949         }
950 
951         revert("ERC721A: unable to determine the owner of token");
952     }
953 
954     /**
955      * @dev See {IERC721-ownerOf}.
956      */
957     function ownerOf(uint256 tokenId) public view override returns (address) {
958         return ownershipOf(tokenId).addr;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-name}.
963      */
964     function name() public view virtual override returns (string memory) {
965         return _name;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-symbol}.
970      */
971     function symbol() public view virtual override returns (string memory) {
972         return _symbol;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-tokenURI}.
977      */
978     function tokenURI(uint256 tokenId)
979         public
980         view
981         virtual
982         override
983         returns (string memory)
984     {
985         require(
986             _exists(tokenId),
987             "ERC721Metadata: URI query for nonexistent token"
988         );
989 
990         string memory baseURI = _baseURI();
991         return
992             bytes(baseURI).length > 0
993                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
994                 : "";
995     }
996 
997     /**
998      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
999      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1000      * by default, can be overriden in child contracts.
1001      */
1002     function _baseURI() internal view virtual returns (string memory) {
1003         return "";
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-approve}.
1008      */
1009     function approve(address to, uint256 tokenId) public override {
1010         address owner = ERC721A.ownerOf(tokenId);
1011         require(to != owner, "ERC721A: approval to current owner");
1012 
1013         require(
1014             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1015             "ERC721A: approve caller is not owner nor approved for all"
1016         );
1017 
1018         _approve(to, tokenId, owner);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-getApproved}.
1023      */
1024     function getApproved(uint256 tokenId)
1025         public
1026         view
1027         override
1028         returns (address)
1029     {
1030         require(
1031             _exists(tokenId),
1032             "ERC721A: approved query for nonexistent token"
1033         );
1034 
1035         return _tokenApprovals[tokenId];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-setApprovalForAll}.
1040      */
1041     function setApprovalForAll(address operator, bool approved)
1042         public
1043         override
1044     {
1045         require(operator != _msgSender(), "ERC721A: approve to caller");
1046 
1047         _operatorApprovals[_msgSender()][operator] = approved;
1048         emit ApprovalForAll(_msgSender(), operator, approved);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-isApprovedForAll}.
1053      */
1054     function isApprovedForAll(address owner, address operator)
1055         public
1056         view
1057         virtual
1058         override
1059         returns (bool)
1060     {
1061         return _operatorApprovals[owner][operator];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-transferFrom}.
1066      */
1067     function transferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) public override {
1083         safeTransferFrom(from, to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) public virtual override {
1095         _transfer(from, to, tokenId);
1096         require(
1097             _checkOnERC721Received(from, to, tokenId, _data),
1098             "ERC721A: transfer to non ERC721Receiver implementer"
1099         );
1100     }
1101 
1102     /**
1103      * @dev Returns whether `tokenId` exists.
1104      *
1105      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1106      *
1107      * Tokens start existing when they are minted (`_mint`),
1108      */
1109     function _exists(uint256 tokenId) internal view returns (bool) {
1110         return tokenId < currentIndex;
1111     }
1112 
1113     function _safeMint(address to, uint256 quantity) internal {
1114         _safeMint(to, quantity, "");
1115     }
1116 
1117     /**
1118      * @dev Mints `quantity` tokens and transfers them to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - there must be `quantity` tokens remaining unminted in the total collection.
1123      * - `to` cannot be the zero address.
1124      * - `quantity` cannot be larger than the max batch size.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeMint(
1129         address to,
1130         uint256 quantity,
1131         bytes memory _data
1132     ) internal {
1133         uint256 startTokenId = currentIndex;
1134         require(to != address(0), "ERC721A: mint to the zero address");
1135         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1136         require(!_exists(startTokenId), "ERC721A: token already minted");
1137         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         AddressData memory addressData = _addressData[to];
1142         _addressData[to] = AddressData(
1143             addressData.balance + uint128(quantity),
1144             addressData.numberMinted + uint128(quantity)
1145         );
1146         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1147 
1148         uint256 updatedIndex = startTokenId;
1149 
1150         for (uint256 i = 0; i < quantity; i++) {
1151             emit Transfer(address(0), to, updatedIndex);
1152             require(
1153                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1154                 "ERC721A: transfer to non ERC721Receiver implementer"
1155             );
1156             updatedIndex++;
1157         }
1158 
1159         currentIndex = updatedIndex;
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) private {
1178         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1179 
1180         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1181             getApproved(tokenId) == _msgSender() ||
1182             isApprovedForAll(prevOwnership.addr, _msgSender()));
1183 
1184         require(
1185             isApprovedOrOwner,
1186             "ERC721A: transfer caller is not owner nor approved"
1187         );
1188 
1189         require(
1190             prevOwnership.addr == from,
1191             "ERC721A: transfer from incorrect owner"
1192         );
1193         require(to != address(0), "ERC721A: transfer to the zero address");
1194 
1195         _beforeTokenTransfers(from, to, tokenId, 1);
1196 
1197         // Clear approvals from the previous owner
1198         _approve(address(0), tokenId, prevOwnership.addr);
1199 
1200         _addressData[from].balance -= 1;
1201         _addressData[to].balance += 1;
1202         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1203 
1204         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1205         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206         uint256 nextTokenId = tokenId + 1;
1207         if (_ownerships[nextTokenId].addr == address(0)) {
1208             if (_exists(nextTokenId)) {
1209                 _ownerships[nextTokenId] = TokenOwnership(
1210                     prevOwnership.addr,
1211                     prevOwnership.startTimestamp
1212                 );
1213             }
1214         }
1215 
1216         emit Transfer(from, to, tokenId);
1217         _afterTokenTransfers(from, to, tokenId, 1);
1218     }
1219 
1220     /**
1221      * @dev Approve `to` to operate on `tokenId`
1222      *
1223      * Emits a {Approval} event.
1224      */
1225     function _approve(
1226         address to,
1227         uint256 tokenId,
1228         address owner
1229     ) private {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(owner, to, tokenId);
1232     }
1233 
1234     uint256 public nextOwnerToExplicitlySet = 0;
1235 
1236     /**
1237      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1238      */
1239     function _setOwnersExplicit(uint256 quantity) internal {
1240         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1241         require(quantity > 0, "quantity must be nonzero");
1242         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1243         if (endIndex > collectionSize - 1) {
1244             endIndex = collectionSize - 1;
1245         }
1246         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1247         require(_exists(endIndex), "not enough minted yet for this cleanup");
1248         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1249             if (_ownerships[i].addr == address(0)) {
1250                 TokenOwnership memory ownership = ownershipOf(i);
1251                 _ownerships[i] = TokenOwnership(
1252                     ownership.addr,
1253                     ownership.startTimestamp
1254                 );
1255             }
1256         }
1257         nextOwnerToExplicitlySet = endIndex + 1;
1258     }
1259 
1260     /**
1261      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1262      * The call is not executed if the target address is not a contract.
1263      *
1264      * @param from address representing the previous owner of the given token ID
1265      * @param to target address that will receive the tokens
1266      * @param tokenId uint256 ID of the token to be transferred
1267      * @param _data bytes optional data to send along with the call
1268      * @return bool whether the call correctly returned the expected magic value
1269      */
1270     function _checkOnERC721Received(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) private returns (bool) {
1276         if (to.isContract()) {
1277             try
1278                 IERC721Receiver(to).onERC721Received(
1279                     _msgSender(),
1280                     from,
1281                     tokenId,
1282                     _data
1283                 )
1284             returns (bytes4 retval) {
1285                 return retval == IERC721Receiver(to).onERC721Received.selector;
1286             } catch (bytes memory reason) {
1287                 if (reason.length == 0) {
1288                     revert(
1289                         "ERC721A: transfer to non ERC721Receiver implementer"
1290                     );
1291                 } else {
1292                     assembly {
1293                         revert(add(32, reason), mload(reason))
1294                     }
1295                 }
1296             }
1297         } else {
1298             return true;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      */
1314     function _beforeTokenTransfers(
1315         address from,
1316         address to,
1317         uint256 startTokenId,
1318         uint256 quantity
1319     ) internal virtual {}
1320 
1321     /**
1322      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1323      * minting.
1324      *
1325      * startTokenId - the first token id to be transferred
1326      * quantity - the amount to be transferred
1327      *
1328      * Calling conditions:
1329      *
1330      * - when `from` and `to` are both non-zero.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _afterTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 }
1340 // File: Shroomates.sol
1341 
1342 
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 //@@@@@@@*..,@@@@@@@@@@@@@@@@@@....*.@@@@@@@@**@*@@@@@@@@@@@@..*@@,,@(..@@@@@@
1347 //@&..............@@@@......@@@......@%@@@@@.........@@@@@@@..............@@@@
1348 //@@......#.......@%@@@....../@......@%@@@@@.........@@@@@@@*......@@%....@%@@
1349 //@@,,,,,@@&@@@@@@@@@@@.@#...........@%@@@@....@.%@..@%@@@@@@.....@@@@...@@%@@
1350 //@@*&***@%@(***,,@@@@@,,,,,,,,,,,,,@@%@@@#,@,,@@@,@,,@@@@@@@,*,*********%@&@@
1351 //@@/(%///@@@/////@@@@@@///&////****@@@@@@/*////*/////@@&@@@@///////////@@@@@@
1352 //@@/&///////////&@&@@@//////@#////(@@@@@/////@#(/@/////@@@@@/@////@//////@@@@
1353 //@@@@(//////////@@%@@@%//////@@@///@@@@@//%///(@@@/////#@@@@////@@@@/////@@@@
1354 //@@@@@@/&@@#/@@@%@@@@@@@@@@/@%@@@/@@@%@@@@&@@@&%@@@@(@@&%@@@@///@@@@@//@@%@@@
1355 //@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@(@%@@@@@@@@@%@@@@@@&@&@@@@@@@@%@@@@@@@@@@@@@
1356 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1357 //@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1358 //@@@@(.......@@@@@@@@@@@....%...*@@@@@@@...........@@@@**@@...........@@@@
1359 //@@@@(..%...@@@@@@@@@@@.........@@@@@@@@@.....@.....@@@*,@@...........@@@@
1360 //@@@@..,....*@@@@@@@@@@@...@.(.*.@&@@@@@@....#@....(.@@@,@(.....@@.(.%@@@@
1361 //@@@@%,,,,,,@@@@@@@@@@@,,,,@@@@,,,@@@@@@@,,,,,,,,,,,*@@**@%,,..,.,,,@@&@@@
1362 //@@@@*******@%@@@@@@@@***(**/****(**&@@@@****@/@&&****@@@@@@@@&/,,,,,,@@@@
1363 //@@@@@(@////(/&@/@@@@@////**%*******@@@@@@***#@@*&***%@@@@@@@@@@****%*@&@@
1364 //@@@@%/////@/////(@&@%/////(@@@//////@@@@///////////@#@@@@///////////@@%@@
1365 //@@@@//%@(//////@@%@@@@@#//@@%@@/#@/@@@@@//@%/(/@@@/@%@/@@///////&@/@@&@@@
1366 //@@@@@@@@@@@@@@//@@@@@@@@/@%@@@@@@/@@@@@@@@@@@@/(%@@@@@/,@%/@@@//@@%@@@@@@
1367 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@/@%@@@@@@@@@@@@@@@@@@@@@@@@
1368 //%%%%%%%%%%%%%%%&%%%%&&&&&&%%&&&&&&&&&&&&%&&&&&&&&%&&&&&&%&%&&&&&&&&&&&&&&&%&&&%%
1369 //%&%%%%%%%%%%%%%%%%%%&%%%%&&%&%@@&@@%&&&&&&&&&&%%%%%%%%&%%&&&&&&&&&&&&&&%%%%%%&&%
1370 //%%%%%%%%%%%%%%%%%%%%%%@@@%   &@@@@@     @@@@ .&&%%%&&%%%%%&&%&&&%&%%&%%&%%%%&%%&
1371 //%%%%%%%%%%%%%%%%%%,    @@@/   *@@@@@     @@@#   @.   @&&%%&%&%%%&%%%%%%%%%%&&%%%
1372 //%%%%%%%%%%%%%%& &@@. ...@@@@....@@@@@.     .@   @@.   @@@.&&%%&%%&&%&&&&&&&%%%%%
1373 //%%%%%%%%%%%%@@@&.(@@.....@@@@@....@@@@,........  .@.  .@@@. %%&&%&%%&&&&&&%%%%%%
1374 //%%%%%%&%%%&  ,@@@@@@*.....@@@@@(...#@@@@@#.........@#  &@@@   (%&&&%&%%%%%%%%%%%
1375 //%%%%%%%%%&. ...@@@@@@....,*@@@@@@*...#@@@@@@@.......,#. @@@@    @@%%%%%%%%%%%%%%
1376 //%%%%%%%%%@@,.....@@@%%%%&%%%&%%%%&%%%%@&@@@@@@@@(........@@@.   #@@&%%%%%%%%%%%%
1377 //&&&&&%%%%@@@,....@&%%%&%%%%%%%%%%%%%%%%%%%%@@@@@@@@&......@@@    @@& #%%%%%%%%%%
1378 //%%%%%%%%%@@@@,..,%&%%%%&%%%%%&%&%%&%%&%%%%&%%&%@@@@@@@....%@@,.  @@&  &%%%%%%%%%
1379 //&&%%%%%%%&@@@@...@&%%%%%%&%&%%&%%%&%%%%%%%%&%%%%%&@@@@@#..*@@...,@@    @%%%%%%%%
1380 //%&%&%%%%%%%@@@@...@&%&%&%&*&%%*&%&%%%%%@%&%%%%%%%%%&&@@@@..@#...@@    @@@%%%%%%%
1381 //%%%%%%%%%%%%@@@,....%&%&%/ #%%%,,,,,,*,/,&%&%%%%&%%%%%@@@@.@*..@..  *@@@ @%%%%%%
1382 //%%%%%%%%%%%%%%@(......&&*%&/,,,,  (  ,,,,((,%%%%&&%%%%&%(@@@&......@@@  @@%%%%%%
1383 //%%%%%%%%%%%%%%%%(....@&*&%,,,,,,(&&/,*#/  //%&(@%%&&%%%%%@@@@*....@@   @@@%%%%%%
1384 //*#%&&%%%%%%%%%%%%%%,..,@%(,,,,,@@@@*.#/ %//,#./%%%%%%%%%%%#@@@...(@@  @@,%%%%%%%
1385 //#/****/**%%%%%%%%%%%%%( *.(,,,,,(%(@@*/////,&,@&&%%&&%%%%%&.@@@..(@@ /@. @%%%%%%
1386 //////*****///%&%%%%%%.%@%*,,,,,,,,,***////,,&&&&&%&%&&%%%%%%.,@@@.,@% &@ @%%%%%%%
1387 //////********//////&,,   ,,,,,,,,&/*.&&%/,&%%/%%&&&&%&&%&%&(..%@@,.@,  /%%%%%%%%%
1388 ///////%***///***/(,,,,,,,,,,,,,,,***////,% .&@@.@@@@@@@@@@@&...@@/.@  %%%%%%%%%%%
1389 ///////**#**%%***%,,,%.#&&/,,,,,,***#    *%%%&*@@.*@@/...,@@@#..%@& .%%%%%%%%%%%%%
1390 //((/////*(///**,,,,,, (&&,,,,,/  .&. %@%@&  .&%%%%%%&@#. .@@@. #%%%%%%%%%%%%%%%%%
1391 //(***////**.@&,#,,,,,,,%..*,*/%@##. . ,.@%%****/******&%%%%%%%%%%%%%&#**(&/*&&&#*
1392 ///********/%/@*%.,,.&,,#* (,,,/@@**///*,//%/(*******%**/*&%%%%%%&%***//**////////
1393 /////******@.%&@/,,.%*,,,,,*%#,***/////*,///(********///////*****************(/***
1394 //&#//**********/(./*,,,,/@&,,,**//////,,**//////////////*****************//(((/**
1395 ///**/////////*****&#& #,,,,,,*//(////,,&***/*///////*********//////***////(((///*
1396 //***//****(((//****    &,,/*& %@*  @,,&********//*******(#**//********//(((((//**
1397 //***/*****/((((/%(*****/&#&/*%@@%@ %,**********//*******//*************/((((//***
1398 ///*******/(((((((//*******(,,,,*,&%//#%********////((////**************(((*******
1399 ///******//((((((((((///******///////(//#//((////////******************/((********
1400 
1401 
1402 
1403 
1404 interface IGnarCoin {
1405     function burn(address _from, uint256 _amount) external;
1406 
1407     function updateReward(address _from, address _to) external;
1408 }
1409 
1410 contract Shroomates is ERC721A, Ownable, ReentrancyGuard {
1411     using Strings for uint256;
1412     using Address for address;
1413 
1414     string private baseURI;
1415     uint256 public maxSupply = 7777;
1416     uint256 public maxBuyable = 7700;
1417     uint256 public immutable maxPerAddressDuringMint;
1418     uint256 public price;
1419 
1420     uint256 public buffer;
1421 
1422     mapping(address => uint256) public genBalance;
1423     struct ShroomData {
1424         string name;
1425     }
1426 
1427     modifier ShroomOwner(uint256 ShroomId) {
1428         require(
1429             ownerOf(ShroomId) == msg.sender,
1430             "Cannot interact with a ShroomMate you do not own"
1431         );
1432         _;
1433     }
1434 
1435     IGnarCoin public GnarCoin;
1436 
1437     uint256 public constant NAME_CHANGE_PRICE = 150 ether;
1438 
1439     mapping(uint256 => ShroomData) public shroomData;
1440 
1441     event NameChanged(uint256 ShroomId, string ShroomName);
1442 
1443     constructor(
1444         string memory name,
1445         string memory symbol,
1446         uint256 maxBatchSize_,
1447         uint256 collectionSize_,
1448         uint256 mintPrice_
1449     )
1450         //double check with gnar on these settings
1451         ERC721A(name, symbol, maxBatchSize_, collectionSize_)
1452     {
1453         maxPerAddressDuringMint = maxBatchSize_;
1454         price = mintPrice_;
1455     }
1456 
1457     function changeName(uint256 ShroomId, string memory newName)
1458         external
1459         ShroomOwner(ShroomId)
1460     {
1461         bytes memory n = bytes(newName);
1462         require(n.length > 0 && n.length < 25, "Invalid name length");
1463         require(
1464             sha256(n) != sha256(bytes(shroomData[ShroomId].name)),
1465             "New name is same as current name"
1466         );
1467 
1468         // GnarCoin.burn(msg.sender, NAME_CHANGE_PRICE);
1469         shroomData[ShroomId].name = newName;
1470         emit NameChanged(ShroomId, newName);
1471     }
1472 
1473     function setGnarCoin(address GnarCoinAddress) external onlyOwner {
1474         GnarCoin = IGnarCoin(GnarCoinAddress);
1475     }
1476 
1477     function mint(uint256 numberOfMints) public payable {
1478         uint256 maxSupplyBuff = maxBuyable + buffer;
1479         require(
1480             totalSupply() + numberOfMints <= maxSupplyBuff,
1481             "Purchase would exceed max supply of ShroomMate"
1482         );
1483         //this line will make sure the user cannot buy anymore than {maxBatchSize_}
1484         require(
1485             numberMinted(msg.sender) + numberOfMints <= maxPerAddressDuringMint,
1486             "Limit number of mints to an amount set on contract configuration"
1487         );
1488         require(
1489             msg.value >= price * numberOfMints,
1490             "Ether value sent is below the price"
1491         );
1492         _safeMint(msg.sender, numberOfMints);
1493         genBalance[msg.sender]++;
1494     }
1495 
1496     function gift(uint256 numberOfMints, address _to) public onlyOwner {
1497         require(
1498             totalSupply() + numberOfMints <= maxSupply,
1499             "Purchase would exceed max supply of ShroomMate"
1500         );
1501         buffer++;
1502         _safeMint(_to, numberOfMints);
1503         genBalance[msg.sender]++;
1504     }
1505 
1506     function walletOfOwner(address owner)
1507         external
1508         view
1509         returns (uint256[] memory)
1510     {
1511         uint256 tokenCount = balanceOf(owner);
1512         uint256[] memory tokensId = new uint256[](tokenCount);
1513         for (uint256 i; i < tokenCount; i++) {
1514             tokensId[i] = tokenOfOwnerByIndex(owner, i);
1515         }
1516         return tokensId;
1517     }
1518 
1519     function transferFrom(
1520         address from,
1521         address to,
1522         uint256 tokenId
1523     ) public override {
1524         if (tokenId < maxSupply) {
1525             GnarCoin.updateReward(from, to);
1526             genBalance[from]--;
1527             genBalance[to]++;
1528         }
1529         ERC721A.transferFrom(from, to, tokenId);
1530     }
1531 
1532     function safeTransferFrom(
1533         address from,
1534         address to,
1535         uint256 tokenId,
1536         bytes memory data
1537     ) public override {
1538         if (tokenId < maxSupply) {
1539             GnarCoin.updateReward(from, to);
1540             genBalance[from]--;
1541             genBalance[to]++;
1542         }
1543         ERC721A.safeTransferFrom(from, to, tokenId, data);
1544     }
1545 
1546     function withdraw() public onlyOwner {
1547         uint256 balance = address(this).balance;
1548         payable(msg.sender).transfer(balance);
1549     }
1550 
1551     function setPrice(uint256 newPrice) public onlyOwner {
1552         price = newPrice;
1553     }
1554 
1555     function setBaseURI(string memory uri) public onlyOwner {
1556         baseURI = uri;
1557     }
1558 
1559     function _baseURI() internal view override returns (string memory) {
1560         return baseURI;
1561     }
1562 
1563     function numberMinted(address owner) public view returns (uint256) {
1564         return _numberMinted(owner);
1565     }
1566 }