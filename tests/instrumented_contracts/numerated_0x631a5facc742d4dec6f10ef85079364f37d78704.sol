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
756 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
757 
758 
759 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
760 
761 pragma solidity ^0.8.0;
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
772  * the Metadata extension, but not including the Enumerable extension, which is available separately as
773  * {ERC721Enumerable}.
774  */
775 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
776     using Address for address;
777     using Strings for uint256;
778 
779     // Token name
780     string private _name;
781 
782     // Token symbol
783     string private _symbol;
784 
785     // Mapping from token ID to owner address
786     mapping(uint256 => address) private _owners;
787 
788     // Mapping owner address to token count
789     mapping(address => uint256) private _balances;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     /**
798      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
799      */
800     constructor(string memory name_, string memory symbol_) {
801         _name = name_;
802         _symbol = symbol_;
803     }
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner) public view virtual override returns (uint256) {
819         require(owner != address(0), "ERC721: balance query for the zero address");
820         return _balances[owner];
821     }
822 
823     /**
824      * @dev See {IERC721-ownerOf}.
825      */
826     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
827         address owner = _owners[tokenId];
828         require(owner != address(0), "ERC721: owner query for nonexistent token");
829         return owner;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-name}.
834      */
835     function name() public view virtual override returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-symbol}.
841      */
842     function symbol() public view virtual override returns (string memory) {
843         return _symbol;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-tokenURI}.
848      */
849     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
850         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
851 
852         string memory baseURI = _baseURI();
853         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
854     }
855 
856     /**
857      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
858      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
859      * by default, can be overriden in child contracts.
860      */
861     function _baseURI() internal view virtual returns (string memory) {
862         return "";
863     }
864 
865     /**
866      * @dev See {IERC721-approve}.
867      */
868     function approve(address to, uint256 tokenId) public virtual override {
869         address owner = ERC721.ownerOf(tokenId);
870         require(to != owner, "ERC721: approval to current owner");
871 
872         require(
873             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
874             "ERC721: approve caller is not owner nor approved for all"
875         );
876 
877         _approve(to, tokenId);
878     }
879 
880     /**
881      * @dev See {IERC721-getApproved}.
882      */
883     function getApproved(uint256 tokenId) public view virtual override returns (address) {
884         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public virtual override {
893         _setApprovalForAll(_msgSender(), operator, approved);
894     }
895 
896     /**
897      * @dev See {IERC721-isApprovedForAll}.
898      */
899     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
900         return _operatorApprovals[owner][operator];
901     }
902 
903     /**
904      * @dev See {IERC721-transferFrom}.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         //solhint-disable-next-line max-line-length
912         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
913 
914         _transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public virtual override {
925         safeTransferFrom(from, to, tokenId, "");
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public virtual override {
937         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
938         _safeTransfer(from, to, tokenId, _data);
939     }
940 
941     /**
942      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
943      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
944      *
945      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
946      *
947      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
948      * implement alternative mechanisms to perform token transfer, such as signature-based.
949      *
950      * Requirements:
951      *
952      * - `from` cannot be the zero address.
953      * - `to` cannot be the zero address.
954      * - `tokenId` token must exist and be owned by `from`.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeTransfer(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) internal virtual {
965         _transfer(from, to, tokenId);
966         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
967     }
968 
969     /**
970      * @dev Returns whether `tokenId` exists.
971      *
972      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
973      *
974      * Tokens start existing when they are minted (`_mint`),
975      * and stop existing when they are burned (`_burn`).
976      */
977     function _exists(uint256 tokenId) internal view virtual returns (bool) {
978         return _owners[tokenId] != address(0);
979     }
980 
981     /**
982      * @dev Returns whether `spender` is allowed to manage `tokenId`.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      */
988     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
989         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
990         address owner = ERC721.ownerOf(tokenId);
991         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
992     }
993 
994     /**
995      * @dev Safely mints `tokenId` and transfers it to `to`.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeMint(address to, uint256 tokenId) internal virtual {
1005         _safeMint(to, tokenId, "");
1006     }
1007 
1008     /**
1009      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1010      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1011      */
1012     function _safeMint(
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) internal virtual {
1017         _mint(to, tokenId);
1018         require(
1019             _checkOnERC721Received(address(0), to, tokenId, _data),
1020             "ERC721: transfer to non ERC721Receiver implementer"
1021         );
1022     }
1023 
1024     /**
1025      * @dev Mints `tokenId` and transfers it to `to`.
1026      *
1027      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must not exist.
1032      * - `to` cannot be the zero address.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _mint(address to, uint256 tokenId) internal virtual {
1037         require(to != address(0), "ERC721: mint to the zero address");
1038         require(!_exists(tokenId), "ERC721: token already minted");
1039 
1040         _beforeTokenTransfer(address(0), to, tokenId);
1041 
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(address(0), to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Destroys `tokenId`.
1050      * The approval is cleared when the token is burned.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must exist.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _burn(uint256 tokenId) internal virtual {
1059         address owner = ERC721.ownerOf(tokenId);
1060 
1061         _beforeTokenTransfer(owner, address(0), tokenId);
1062 
1063         // Clear approvals
1064         _approve(address(0), tokenId);
1065 
1066         _balances[owner] -= 1;
1067         delete _owners[tokenId];
1068 
1069         emit Transfer(owner, address(0), tokenId);
1070     }
1071 
1072     /**
1073      * @dev Transfers `tokenId` from `from` to `to`.
1074      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1075      *
1076      * Requirements:
1077      *
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must be owned by `from`.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {
1088         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1089         require(to != address(0), "ERC721: transfer to the zero address");
1090 
1091         _beforeTokenTransfer(from, to, tokenId);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId);
1095 
1096         _balances[from] -= 1;
1097         _balances[to] += 1;
1098         _owners[tokenId] = to;
1099 
1100         emit Transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev Approve `to` to operate on `tokenId`
1105      *
1106      * Emits a {Approval} event.
1107      */
1108     function _approve(address to, uint256 tokenId) internal virtual {
1109         _tokenApprovals[tokenId] = to;
1110         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev Approve `operator` to operate on all of `owner` tokens
1115      *
1116      * Emits a {ApprovalForAll} event.
1117      */
1118     function _setApprovalForAll(
1119         address owner,
1120         address operator,
1121         bool approved
1122     ) internal virtual {
1123         require(owner != operator, "ERC721: approve to caller");
1124         _operatorApprovals[owner][operator] = approved;
1125         emit ApprovalForAll(owner, operator, approved);
1126     }
1127 
1128     /**
1129      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1130      * The call is not executed if the target address is not a contract.
1131      *
1132      * @param from address representing the previous owner of the given token ID
1133      * @param to target address that will receive the tokens
1134      * @param tokenId uint256 ID of the token to be transferred
1135      * @param _data bytes optional data to send along with the call
1136      * @return bool whether the call correctly returned the expected magic value
1137      */
1138     function _checkOnERC721Received(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) private returns (bool) {
1144         if (to.isContract()) {
1145             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1146                 return retval == IERC721Receiver.onERC721Received.selector;
1147             } catch (bytes memory reason) {
1148                 if (reason.length == 0) {
1149                     revert("ERC721: transfer to non ERC721Receiver implementer");
1150                 } else {
1151                     assembly {
1152                         revert(add(32, reason), mload(reason))
1153                     }
1154                 }
1155             }
1156         } else {
1157             return true;
1158         }
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before any token transfer. This includes minting
1163      * and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1171      * - `from` and `to` are never both zero.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _beforeTokenTransfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual {}
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 /**
1192  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1193  * enumerability of all the token ids in the contract as well as all token ids owned by each
1194  * account.
1195  */
1196 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1197     // Mapping from owner to list of owned token IDs
1198     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1199 
1200     // Mapping from token ID to index of the owner tokens list
1201     mapping(uint256 => uint256) private _ownedTokensIndex;
1202 
1203     // Array with all token ids, used for enumeration
1204     uint256[] private _allTokens;
1205 
1206     // Mapping from token id to position in the allTokens array
1207     mapping(uint256 => uint256) private _allTokensIndex;
1208 
1209     /**
1210      * @dev See {IERC165-supportsInterface}.
1211      */
1212     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1213         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1218      */
1219     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1220         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1221         return _ownedTokens[owner][index];
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Enumerable-totalSupply}.
1226      */
1227     function totalSupply() public view virtual override returns (uint256) {
1228         return _allTokens.length;
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Enumerable-tokenByIndex}.
1233      */
1234     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1235         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1236         return _allTokens[index];
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before any token transfer. This includes minting
1241      * and burning.
1242      *
1243      * Calling conditions:
1244      *
1245      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1246      * transferred to `to`.
1247      * - When `from` is zero, `tokenId` will be minted for `to`.
1248      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1249      * - `from` cannot be the zero address.
1250      * - `to` cannot be the zero address.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _beforeTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) internal virtual override {
1259         super._beforeTokenTransfer(from, to, tokenId);
1260 
1261         if (from == address(0)) {
1262             _addTokenToAllTokensEnumeration(tokenId);
1263         } else if (from != to) {
1264             _removeTokenFromOwnerEnumeration(from, tokenId);
1265         }
1266         if (to == address(0)) {
1267             _removeTokenFromAllTokensEnumeration(tokenId);
1268         } else if (to != from) {
1269             _addTokenToOwnerEnumeration(to, tokenId);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1275      * @param to address representing the new owner of the given token ID
1276      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1277      */
1278     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1279         uint256 length = ERC721.balanceOf(to);
1280         _ownedTokens[to][length] = tokenId;
1281         _ownedTokensIndex[tokenId] = length;
1282     }
1283 
1284     /**
1285      * @dev Private function to add a token to this extension's token tracking data structures.
1286      * @param tokenId uint256 ID of the token to be added to the tokens list
1287      */
1288     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1289         _allTokensIndex[tokenId] = _allTokens.length;
1290         _allTokens.push(tokenId);
1291     }
1292 
1293     /**
1294      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1295      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1296      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1297      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1298      * @param from address representing the previous owner of the given token ID
1299      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1300      */
1301     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1302         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1303         // then delete the last slot (swap and pop).
1304 
1305         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1306         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1307 
1308         // When the token to delete is the last token, the swap operation is unnecessary
1309         if (tokenIndex != lastTokenIndex) {
1310             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1311 
1312             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1313             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1314         }
1315 
1316         // This also deletes the contents at the last position of the array
1317         delete _ownedTokensIndex[tokenId];
1318         delete _ownedTokens[from][lastTokenIndex];
1319     }
1320 
1321     /**
1322      * @dev Private function to remove a token from this extension's token tracking data structures.
1323      * This has O(1) time complexity, but alters the order of the _allTokens array.
1324      * @param tokenId uint256 ID of the token to be removed from the tokens list
1325      */
1326     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1327         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1328         // then delete the last slot (swap and pop).
1329 
1330         uint256 lastTokenIndex = _allTokens.length - 1;
1331         uint256 tokenIndex = _allTokensIndex[tokenId];
1332 
1333         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1334         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1335         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1336         uint256 lastTokenId = _allTokens[lastTokenIndex];
1337 
1338         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340 
1341         // This also deletes the contents at the last position of the array
1342         delete _allTokensIndex[tokenId];
1343         _allTokens.pop();
1344     }
1345 }
1346 
1347 // File: contracts/rescuedogz.sol
1348 
1349 
1350 pragma solidity ^0.8.8;
1351 
1352 
1353 
1354 
1355 /* 
1356      ____                             ____
1357     |  _ \ ___  ___  ___ _   _  ___  |  _ \  ___   __ _ ____
1358     | |_) / _ \/ __|/ __| | | |/ _ \ | | | |/ _ \ / _` |_  /
1359     |  _ <  __/\__ \ (__| |_| |  __/ | |_| | (_) | (_| |/ /
1360     |_| \_\___||___/\___|\__,_|\___| |____/ \___/ \__, /___|
1361                                                   |___/
1362 
1363                       www.rescuedogz.io
1364 */
1365 
1366 contract RescueDogz is ERC721Enumerable, Ownable, ReentrancyGuard {
1367     string baseTokenURI;
1368     uint256 private reserved = 100;
1369     uint256 private price = 0.03 ether;
1370     bool public paused = false;
1371 
1372     // Set provenance hash
1373     string public DOGZ_PROVENANCE = "";
1374 
1375     mapping(address => uint256) public addressMintedBalance;
1376 
1377     // withdraw addresses
1378     address designer = 0x8dc42ab1229D5ea9372a69BC4a42aFc1D01Ae801;
1379     address developer = 0x68D4b5EED105d26ADad7d3FD33523AC00cfAfd3b;
1380 
1381     constructor(string memory baseURI) ERC721("Rescue Dogz", "DOGZ")  {
1382         setBaseURI(baseURI);
1383 
1384         _safeMint(designer, 0);
1385         _safeMint(developer, 1);
1386     }
1387 
1388     // Set provenance hash
1389     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1390         DOGZ_PROVENANCE = provenanceHash;
1391     }
1392 
1393     // Minting process
1394     function mint(uint256 mintQty) public payable nonReentrant {
1395         uint256 supply = totalSupply();
1396         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1397         require(!paused,                                   "Sale is paused");
1398         require(mintQty > 0,                               "Mint at least 1 NFT");
1399         require(mintQty <= 10,                             "You can mint a maximum of 10");
1400         require(supply + mintQty < 10000 - reserved,       "Exceeds maximum supply");
1401 
1402         // The first 500 are free
1403         if (supply < 500) {
1404             if (supply < 250) {
1405                 require(ownerMintedCount + mintQty <= 1,   "Max NFT per address exceeded for the first 250");
1406             }
1407             else {
1408                 require(ownerMintedCount + mintQty <= 2,   "Max NFT per address exceeded for the first 500");
1409             }
1410 
1411             require(mintQty == 1,                          "Limited to 1 per mint at launch time");
1412             require(msg.value >= 0.00 ether * mintQty,     "Ether sent is not correct");
1413         }
1414 
1415         // There is a fee for 500+
1416         if (supply >= 500) {
1417             require(ownerMintedCount + mintQty <= 10,      "Exceeds max NFT per address");
1418             require(msg.value >= price * mintQty,          "Ether sent is not correct");
1419         }
1420 
1421         // Mint
1422         for(uint256 i; i < mintQty; i++){
1423             addressMintedBalance[msg.sender]++;
1424             _safeMint(msg.sender, supply + i);
1425         }
1426     }
1427 
1428     // Retrieve tokens belonging to address
1429     function walletOfOwner(address owner) public view returns(uint256[] memory) {
1430         uint256 tokenCount = balanceOf(owner);
1431 
1432         uint256[] memory tokensId = new uint256[](tokenCount);
1433         for(uint256 i; i < tokenCount; i++){
1434             tokensId[i] = tokenOfOwnerByIndex(owner, i);
1435         }
1436         return tokensId;
1437     }
1438 
1439     function setPrice(uint256 newPrice) public onlyOwner {
1440         price = newPrice;
1441     }
1442 
1443     function _baseURI() internal view virtual override returns (string memory) {
1444         return baseTokenURI;
1445     }
1446 
1447     function setBaseURI(string memory baseURI) public onlyOwner {
1448         baseTokenURI = baseURI;
1449     }
1450 
1451     function getPrice() public view returns (uint256){
1452         uint256 supply = totalSupply();
1453         uint256 currentPrice = (supply < 500) ? 0.0 ether : price;
1454         return currentPrice;
1455     }
1456 
1457     function giveAway(address to, uint256 amount) external nonReentrant onlyOwner {
1458         require(amount <= reserved, "Exceeds reserved supply");
1459 
1460         uint256 supply = totalSupply();
1461         for(uint256 i; i < amount; i++){
1462             _safeMint(to, supply + i);
1463         }
1464 
1465         reserved -= amount;
1466     }
1467 
1468     function pause(bool val) public onlyOwner {
1469         paused = val;
1470     }
1471 
1472     function withdrawAll() public payable onlyOwner {
1473         uint256 half_amount = address(this).balance / 2;
1474         require(payable(designer).send(half_amount));
1475         require(payable(developer).send(half_amount));
1476     }
1477 }