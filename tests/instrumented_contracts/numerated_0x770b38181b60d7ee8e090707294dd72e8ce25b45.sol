1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 
6  
7 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev String operations.
82  */
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85     uint8 private constant _ADDRESS_LENGTH = 20;
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
89      */
90     function toString(uint256 value) internal pure returns (string memory) {
91         // Inspired by OraclizeAPI's implementation - MIT licence
92         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
93 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
114      */
115     function toHexString(uint256 value) internal pure returns (string memory) {
116         if (value == 0) {
117             return "0x00";
118         }
119         uint256 temp = value;
120         uint256 length = 0;
121         while (temp != 0) {
122             length++;
123             temp >>= 8;
124         }
125         return toHexString(value, length);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
130      */
131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
132         bytes memory buffer = new bytes(2 * length + 2);
133         buffer[0] = "0";
134         buffer[1] = "x";
135         for (uint256 i = 2 * length + 1; i > 1; --i) {
136             buffer[i] = _HEX_SYMBOLS[value & 0xf];
137             value >>= 4;
138         }
139         require(value == 0, "Strings: hex length insufficient");
140         return string(buffer);
141     }
142 
143     /**
144      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
145      */
146     function toHexString(address addr) internal pure returns (string memory) {
147         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Context.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 abstract contract Context {
169     function _msgSender() internal view virtual returns (address) {
170         return msg.sender;
171     }
172 
173     function _msgData() internal view virtual returns (bytes calldata) {
174         return msg.data;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/access/Ownable.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * By default, the owner account will be the one that deploys the contract. This
192  * can later be changed with {transferOwnership}.
193  *
194  * This module is used through inheritance. It will make available the modifier
195  * `onlyOwner`, which can be applied to your functions to restrict their use to
196  * the owner.
197  */
198 abstract contract Ownable is Context {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     /**
204      * @dev Initializes the contract setting the deployer as the initial owner.
205      */
206     constructor() {
207         _transferOwnership(_msgSender());
208     }
209 
210     /**
211      * @dev Throws if called by any account other than the owner.
212      */
213     modifier onlyOwner() {
214         _checkOwner();
215         _;
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view virtual returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if the sender is not the owner.
227      */
228     function _checkOwner() internal view virtual {
229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
230     }
231 
232     /**
233      * @dev Leaves the contract without owner. It will not be possible to call
234      * `onlyOwner` functions anymore. Can only be called by the current owner.
235      *
236      * NOTE: Renouncing ownership will leave the contract without an owner,
237      * thereby removing any functionality that is only available to the owner.
238      */
239     function renounceOwnership() public virtual onlyOwner {
240         _transferOwnership(address(0));
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public virtual onlyOwner {
248         require(newOwner != address(0), "Ownable: new owner is the zero address");
249         _transferOwnership(newOwner);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Internal function without access restriction.
255      */
256     function _transferOwnership(address newOwner) internal virtual {
257         address oldOwner = _owner;
258         _owner = newOwner;
259         emit OwnershipTransferred(oldOwner, newOwner);
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
267 
268 pragma solidity ^0.8.1;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      *
291      * [IMPORTANT]
292      * ====
293      * You shouldn't rely on `isContract` to protect against flash loan attacks!
294      *
295      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
296      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
297      * constructor.
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize/address.code.length, which returns 0
302         // for contracts in construction, since the code is only stored at the end
303         // of the constructor execution.
304 
305         return account.code.length > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
412         return functionStaticCall(target, data, "Address: low-level static call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal view returns (bytes memory) {
426         require(isContract(target), "Address: static call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476                 /// @solidity memory-safe-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
489 
490 
491 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @title ERC721 token receiver interface
497  * @dev Interface for any contract that wants to support safeTransfers
498  * from ERC721 asset contracts.
499  */
500 interface IERC721Receiver {
501     /**
502      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
503      * by `operator` from `from`, this function is called.
504      *
505      * It must return its Solidity selector to confirm the token transfer.
506      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
507      *
508      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
509      */
510     function onERC721Received(
511         address operator,
512         address from,
513         uint256 tokenId,
514         bytes calldata data
515     ) external returns (bytes4);
516 }
517 
518 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Interface of the ERC165 standard, as defined in the
527  * https://eips.ethereum.org/EIPS/eip-165[EIP].
528  *
529  * Implementers can declare support of contract interfaces, which can then be
530  * queried by others ({ERC165Checker}).
531  *
532  * For an implementation, see {ERC165}.
533  */
534 interface IERC165 {
535     /**
536      * @dev Returns true if this contract implements the interface defined by
537      * `interfaceId`. See the corresponding
538      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
539      * to learn more about how these ids are created.
540      *
541      * This function call must use less than 30 000 gas.
542      */
543     function supportsInterface(bytes4 interfaceId) external view returns (bool);
544 }
545 
546 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Implementation of the {IERC165} interface.
556  *
557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
558  * for the additional interface id that will be supported. For example:
559  *
560  * ```solidity
561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
563  * }
564  * ```
565  *
566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
567  */
568 abstract contract ERC165 is IERC165 {
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573         return interfaceId == type(IERC165).interfaceId;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
578 
579 
580 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Required interface of an ERC721 compliant contract.
587  */
588 interface IERC721 is IERC165 {
589     /**
590      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
591      */
592     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
596      */
597     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
601      */
602     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
603 
604     /**
605      * @dev Returns the number of tokens in ``owner``'s account.
606      */
607     function balanceOf(address owner) external view returns (uint256 balance);
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) external view returns (address owner);
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes calldata data
636     ) external;
637 
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Transfers `tokenId` token from `from` to `to`.
660      *
661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
680      * The approval is cleared when the token is transferred.
681      *
682      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
683      *
684      * Requirements:
685      *
686      * - The caller must own the token or be an approved operator.
687      * - `tokenId` must exist.
688      *
689      * Emits an {Approval} event.
690      */
691     function approve(address to, uint256 tokenId) external;
692 
693     /**
694      * @dev Approve or remove `operator` as an operator for the caller.
695      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
696      *
697      * Requirements:
698      *
699      * - The `operator` cannot be the caller.
700      *
701      * Emits an {ApprovalForAll} event.
702      */
703     function setApprovalForAll(address operator, bool _approved) external;
704 
705     /**
706      * @dev Returns the account approved for `tokenId` token.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must exist.
711      */
712     function getApproved(uint256 tokenId) external view returns (address operator);
713 
714     /**
715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
716      *
717      * See {setApprovalForAll}
718      */
719     function isApprovedForAll(address owner, address operator) external view returns (bool);
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Metadata is IERC721 {
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 }
750 
751 // File: erc721a/contracts/IERC721A.sol
752 
753 
754 // ERC721A Contracts v4.2.3
755 // Creator: Chiru Labs
756 
757 pragma solidity ^0.8.4;
758 
759 /**
760  * @dev Interface of ERC721A.
761  */
762 interface IERC721A {
763     /**
764      * The caller must own the token or be an approved operator.
765      */
766     error ApprovalCallerNotOwnerNorApproved();
767 
768     /**
769      * The token does not exist.
770      */
771     error ApprovalQueryForNonexistentToken();
772 
773     /**
774      * Cannot query the balance for the zero address.
775      */
776     error BalanceQueryForZeroAddress();
777 
778     /**
779      * Cannot mint to the zero address.
780      */
781     error MintToZeroAddress();
782 
783     /**
784      * The quantity of tokens minted must be more than zero.
785      */
786     error MintZeroQuantity();
787 
788     /**
789      * The token does not exist.
790      */
791     error OwnerQueryForNonexistentToken();
792 
793     /**
794      * The caller must own the token or be an approved operator.
795      */
796     error TransferCallerNotOwnerNorApproved();
797 
798     /**
799      * The token must be owned by `from`.
800      */
801     error TransferFromIncorrectOwner();
802 
803     /**
804      * Cannot safely transfer to a contract that does not implement the
805      * ERC721Receiver interface.
806      */
807     error TransferToNonERC721ReceiverImplementer();
808 
809     /**
810      * Cannot transfer to the zero address.
811      */
812     error TransferToZeroAddress();
813 
814     /**
815      * The token does not exist.
816      */
817     error URIQueryForNonexistentToken();
818 
819     /**
820      * The `quantity` minted with ERC2309 exceeds the safety limit.
821      */
822     error MintERC2309QuantityExceedsLimit();
823 
824     /**
825      * The `extraData` cannot be set on an unintialized ownership slot.
826      */
827     error OwnershipNotInitializedForExtraData();
828 
829     // =============================================================
830     //                            STRUCTS
831     // =============================================================
832 
833     struct TokenOwnership {
834         // The address of the owner.
835         address addr;
836         // Stores the start time of ownership with minimal overhead for tokenomics.
837         uint64 startTimestamp;
838         // Whether the token has been burned.
839         bool burned;
840         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
841         uint24 extraData;
842     }
843 
844     // =============================================================
845     //                         TOKEN COUNTERS
846     // =============================================================
847 
848     /**
849      * @dev Returns the total number of tokens in existence.
850      * Burned tokens will reduce the count.
851      * To get the total number of tokens minted, please see {_totalMinted}.
852      */
853     function totalSupply() external view returns (uint256);
854 
855     // =============================================================
856     //                            IERC165
857     // =============================================================
858 
859     /**
860      * @dev Returns true if this contract implements the interface defined by
861      * `interfaceId`. See the corresponding
862      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
863      * to learn more about how these ids are created.
864      *
865      * This function call must use less than 30000 gas.
866      */
867     function supportsInterface(bytes4 interfaceId) external view returns (bool);
868 
869     // =============================================================
870     //                            IERC721
871     // =============================================================
872 
873     /**
874      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
875      */
876     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
877 
878     /**
879      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
880      */
881     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
882 
883     /**
884      * @dev Emitted when `owner` enables or disables
885      * (`approved`) `operator` to manage all of its assets.
886      */
887     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
888 
889     /**
890      * @dev Returns the number of tokens in `owner`'s account.
891      */
892     function balanceOf(address owner) external view returns (uint256 balance);
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) external view returns (address owner);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`,
905      * checking first that contract recipients are aware of the ERC721 protocol
906      * to prevent tokens from being forever locked.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be have been allowed to move
914      * this token by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement
916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes calldata data
925     ) external payable;
926 
927     /**
928      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) external payable;
935 
936     /**
937      * @dev Transfers `tokenId` from `from` to `to`.
938      *
939      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
940      * whenever possible.
941      *
942      * Requirements:
943      *
944      * - `from` cannot be the zero address.
945      * - `to` cannot be the zero address.
946      * - `tokenId` token must be owned by `from`.
947      * - If the caller is not `from`, it must be approved to move this token
948      * by either {approve} or {setApprovalForAll}.
949      *
950      * Emits a {Transfer} event.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) external payable;
957 
958     /**
959      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
960      * The approval is cleared when the token is transferred.
961      *
962      * Only a single account can be approved at a time, so approving the
963      * zero address clears previous approvals.
964      *
965      * Requirements:
966      *
967      * - The caller must own the token or be an approved operator.
968      * - `tokenId` must exist.
969      *
970      * Emits an {Approval} event.
971      */
972     function approve(address to, uint256 tokenId) external payable;
973 
974     /**
975      * @dev Approve or remove `operator` as an operator for the caller.
976      * Operators can call {transferFrom} or {safeTransferFrom}
977      * for any token owned by the caller.
978      *
979      * Requirements:
980      *
981      * - The `operator` cannot be the caller.
982      *
983      * Emits an {ApprovalForAll} event.
984      */
985     function setApprovalForAll(address operator, bool _approved) external;
986 
987     /**
988      * @dev Returns the account approved for `tokenId` token.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      */
994     function getApproved(uint256 tokenId) external view returns (address operator);
995 
996     /**
997      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
998      *
999      * See {setApprovalForAll}.
1000      */
1001     function isApprovedForAll(address owner, address operator) external view returns (bool);
1002 
1003     // =============================================================
1004     //                        IERC721Metadata
1005     // =============================================================
1006 
1007     /**
1008      * @dev Returns the token collection name.
1009      */
1010     function name() external view returns (string memory);
1011 
1012     /**
1013      * @dev Returns the token collection symbol.
1014      */
1015     function symbol() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1019      */
1020     function tokenURI(uint256 tokenId) external view returns (string memory);
1021 
1022     // =============================================================
1023     //                           IERC2309
1024     // =============================================================
1025 
1026     /**
1027      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1028      * (inclusive) is transferred from `from` to `to`, as defined in the
1029      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1030      *
1031      * See {_mintERC2309} for more details.
1032      */
1033     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1034 }
1035 
1036 // File: erc721a/contracts/ERC721A.sol
1037 
1038 
1039 // ERC721A Contracts v4.2.3
1040 // Creator: Chiru Labs
1041 
1042 pragma solidity ^0.8.4;
1043 
1044 
1045 /**
1046  * @dev Interface of ERC721 token receiver.
1047  */
1048 interface ERC721A__IERC721Receiver {
1049     function onERC721Received(
1050         address operator,
1051         address from,
1052         uint256 tokenId,
1053         bytes calldata data
1054     ) external returns (bytes4);
1055 }
1056 
1057 /**
1058  * @title ERC721A
1059  *
1060  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1061  * Non-Fungible Token Standard, including the Metadata extension.
1062  * Optimized for lower gas during batch mints.
1063  *
1064  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1065  * starting from `_startTokenId()`.
1066  *
1067  * Assumptions:
1068  *
1069  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1070  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1071  */
1072 contract ERC721A is IERC721A {
1073     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1074     struct TokenApprovalRef {
1075         address value;
1076     }
1077 
1078     // =============================================================
1079     //                           CONSTANTS
1080     // =============================================================
1081 
1082     // Mask of an entry in packed address data.
1083     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1084 
1085     // The bit position of `numberMinted` in packed address data.
1086     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1087 
1088     // The bit position of `numberBurned` in packed address data.
1089     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1090 
1091     // The bit position of `aux` in packed address data.
1092     uint256 private constant _BITPOS_AUX = 192;
1093 
1094     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1095     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1096 
1097     // The bit position of `startTimestamp` in packed ownership.
1098     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1099 
1100     // The bit mask of the `burned` bit in packed ownership.
1101     uint256 private constant _BITMASK_BURNED = 1 << 224;
1102 
1103     // The bit position of the `nextInitialized` bit in packed ownership.
1104     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1105 
1106     // The bit mask of the `nextInitialized` bit in packed ownership.
1107     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1108 
1109     // The bit position of `extraData` in packed ownership.
1110     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1111 
1112     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1113     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1114 
1115     // The mask of the lower 160 bits for addresses.
1116     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1117 
1118     // The maximum `quantity` that can be minted with {_mintERC2309}.
1119     // This limit is to prevent overflows on the address data entries.
1120     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1121     // is required to cause an overflow, which is unrealistic.
1122     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1123 
1124     // The `Transfer` event signature is given by:
1125     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1126     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1127         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1128 
1129     // =============================================================
1130     //                            STORAGE
1131     // =============================================================
1132 
1133     // The next token ID to be minted.
1134     uint256 private _currentIndex;
1135 
1136     // The number of tokens burned.
1137     uint256 private _burnCounter;
1138 
1139     // Token name
1140     string private _name;
1141 
1142     // Token symbol
1143     string private _symbol;
1144 
1145     // Mapping from token ID to ownership details
1146     // An empty struct value does not necessarily mean the token is unowned.
1147     // See {_packedOwnershipOf} implementation for details.
1148     //
1149     // Bits Layout:
1150     // - [0..159]   `addr`
1151     // - [160..223] `startTimestamp`
1152     // - [224]      `burned`
1153     // - [225]      `nextInitialized`
1154     // - [232..255] `extraData`
1155     mapping(uint256 => uint256) private _packedOwnerships;
1156 
1157     // Mapping owner address to address data.
1158     //
1159     // Bits Layout:
1160     // - [0..63]    `balance`
1161     // - [64..127]  `numberMinted`
1162     // - [128..191] `numberBurned`
1163     // - [192..255] `aux`
1164     mapping(address => uint256) private _packedAddressData;
1165 
1166     // Mapping from token ID to approved address.
1167     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1168 
1169     // Mapping from owner to operator approvals
1170     mapping(address => mapping(address => bool)) private _operatorApprovals;
1171 
1172     // =============================================================
1173     //                          CONSTRUCTOR
1174     // =============================================================
1175 
1176     constructor(string memory name_, string memory symbol_) {
1177         _name = name_;
1178         _symbol = symbol_;
1179         _currentIndex = _startTokenId();
1180     }
1181 
1182     // =============================================================
1183     //                   TOKEN COUNTING OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Returns the starting token ID.
1188      * To change the starting token ID, please override this function.
1189      */
1190     function _startTokenId() internal view virtual returns (uint256) {
1191         return 1;
1192     }
1193 
1194     /**
1195      * @dev Returns the next token ID to be minted.
1196      */
1197     function _nextTokenId() internal view virtual returns (uint256) {
1198         return _currentIndex;
1199     }
1200 
1201     /**
1202      * @dev Returns the total number of tokens in existence.
1203      * Burned tokens will reduce the count.
1204      * To get the total number of tokens minted, please see {_totalMinted}.
1205      */
1206     function totalSupply() public view virtual override returns (uint256) {
1207         // Counter underflow is impossible as _burnCounter cannot be incremented
1208         // more than `_currentIndex - _startTokenId()` times.
1209         unchecked {
1210             return _currentIndex - _burnCounter - _startTokenId();
1211         }
1212     }
1213 
1214     /**
1215      * @dev Returns the total amount of tokens minted in the contract.
1216      */
1217     function _totalMinted() internal view virtual returns (uint256) {
1218         // Counter underflow is impossible as `_currentIndex` does not decrement,
1219         // and it is initialized to `_startTokenId()`.
1220         unchecked {
1221             return _currentIndex - _startTokenId();
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the total number of tokens burned.
1227      */
1228     function _totalBurned() internal view virtual returns (uint256) {
1229         return _burnCounter;
1230     }
1231 
1232     // =============================================================
1233     //                    ADDRESS DATA OPERATIONS
1234     // =============================================================
1235 
1236     /**
1237      * @dev Returns the number of tokens in `owner`'s account.
1238      */
1239     function balanceOf(address owner) public view virtual override returns (uint256) {
1240         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1241         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1242     }
1243 
1244     /**
1245      * Returns the number of tokens minted by `owner`.
1246      */
1247     function _numberMinted(address owner) internal view returns (uint256) {
1248         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1249     }
1250 
1251     /**
1252      * Returns the number of tokens burned by or on behalf of `owner`.
1253      */
1254     function _numberBurned(address owner) internal view returns (uint256) {
1255         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1256     }
1257 
1258     /**
1259      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1260      */
1261     function _getAux(address owner) internal view returns (uint64) {
1262         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1263     }
1264 
1265     /**
1266      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1267      * If there are multiple variables, please pack them into a uint64.
1268      */
1269     function _setAux(address owner, uint64 aux) internal virtual {
1270         uint256 packed = _packedAddressData[owner];
1271         uint256 auxCasted;
1272         // Cast `aux` with assembly to avoid redundant masking.
1273         assembly {
1274             auxCasted := aux
1275         }
1276         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1277         _packedAddressData[owner] = packed;
1278     }
1279 
1280     // =============================================================
1281     //                            IERC165
1282     // =============================================================
1283 
1284     /**
1285      * @dev Returns true if this contract implements the interface defined by
1286      * `interfaceId`. See the corresponding
1287      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1288      * to learn more about how these ids are created.
1289      *
1290      * This function call must use less than 30000 gas.
1291      */
1292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1293         // The interface IDs are constants representing the first 4 bytes
1294         // of the XOR of all function selectors in the interface.
1295         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1296         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1297         return
1298             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1299             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1300             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1301     }
1302 
1303     // =============================================================
1304     //                        IERC721Metadata
1305     // =============================================================
1306 
1307     /**
1308      * @dev Returns the token collection name.
1309      */
1310     function name() public view virtual override returns (string memory) {
1311         return _name;
1312     }
1313 
1314     /**
1315      * @dev Returns the token collection symbol.
1316      */
1317     function symbol() public view virtual override returns (string memory) {
1318         return _symbol;
1319     }
1320 
1321     /**
1322      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1323      */
1324     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1325         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1326 
1327         string memory baseURI = _baseURI();
1328         return bytes(baseURI).length != 0 
1329         ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1330     }
1331 
1332     /**
1333      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1334      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1335      * by default, it can be overridden in child contracts.
1336      */
1337     function _baseURI() internal view virtual returns (string memory) {
1338         return '';
1339     }
1340 
1341     // =============================================================
1342     //                     OWNERSHIPS OPERATIONS
1343     // =============================================================
1344 
1345     /**
1346      * @dev Returns the owner of the `tokenId` token.
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must exist.
1351      */
1352     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1353         return address(uint160(_packedOwnershipOf(tokenId)));
1354     }
1355 
1356     /**
1357      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1358      * It gradually moves to O(1) as tokens get transferred around over time.
1359      */
1360     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1361         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1362     }
1363 
1364     /**
1365      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1366      */
1367     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1368         return _unpackedOwnership(_packedOwnerships[index]);
1369     }
1370 
1371     /**
1372      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1373      */
1374     function _initializeOwnershipAt(uint256 index) internal virtual {
1375         if (_packedOwnerships[index] == 0) {
1376             _packedOwnerships[index] = _packedOwnershipOf(index);
1377         }
1378     }
1379 
1380     /**
1381      * Returns the packed ownership data of `tokenId`.
1382      */
1383     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1384         uint256 curr = tokenId;
1385 
1386         unchecked {
1387             if (_startTokenId() <= curr)
1388                 if (curr < _currentIndex) {
1389                     uint256 packed = _packedOwnerships[curr];
1390                     // If not burned.
1391                     if (packed & _BITMASK_BURNED == 0) {
1392                         // Invariant:
1393                         // There will always be an initialized ownership slot
1394                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1395                         // before an unintialized ownership slot
1396                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1397                         // Hence, `curr` will not underflow.
1398                         //
1399                         // We can directly compare the packed value.
1400                         // If the address is zero, packed will be zero.
1401                         while (packed == 0) {
1402                             packed = _packedOwnerships[--curr];
1403                         }
1404                         return packed;
1405                     }
1406                 }
1407         }
1408         revert OwnerQueryForNonexistentToken();
1409     }
1410 
1411     /**
1412      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1413      */
1414     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1415         ownership.addr = address(uint160(packed));
1416         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1417         ownership.burned = packed & _BITMASK_BURNED != 0;
1418         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1419     }
1420 
1421     /**
1422      * @dev Packs ownership data into a single uint256.
1423      */
1424     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1425         assembly {
1426             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1427             owner := and(owner, _BITMASK_ADDRESS)
1428             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1429             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1430         }
1431     }
1432 
1433     /**
1434      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1435      */
1436     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1437         // For branchless setting of the `nextInitialized` flag.
1438         assembly {
1439             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1440             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1441         }
1442     }
1443 
1444     // =============================================================
1445     //                      APPROVAL OPERATIONS
1446     // =============================================================
1447 
1448     /**
1449      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1450      * The approval is cleared when the token is transferred.
1451      *
1452      * Only a single account can be approved at a time, so approving the
1453      * zero address clears previous approvals.
1454      *
1455      * Requirements:
1456      *
1457      * - The caller must own the token or be an approved operator.
1458      * - `tokenId` must exist.
1459      *
1460      * Emits an {Approval} event.
1461      */
1462     function approve(address to, uint256 tokenId) public payable virtual override {
1463         address owner = ownerOf(tokenId);
1464 
1465         if (_msgSenderERC721A() != owner)
1466             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1467                 revert ApprovalCallerNotOwnerNorApproved();
1468             }
1469 
1470         _tokenApprovals[tokenId].value = to;
1471         emit Approval(owner, to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev Returns the account approved for `tokenId` token.
1476      *
1477      * Requirements:
1478      *
1479      * - `tokenId` must exist.
1480      */
1481     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1482         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1483 
1484         return _tokenApprovals[tokenId].value;
1485     }
1486 
1487     /**
1488      * @dev Approve or remove `operator` as an operator for the caller.
1489      * Operators can call {transferFrom} or {safeTransferFrom}
1490      * for any token owned by the caller.
1491      *
1492      * Requirements:
1493      *
1494      * - The `operator` cannot be the caller.
1495      *
1496      * Emits an {ApprovalForAll} event.
1497      */
1498     function setApprovalForAll(address operator, bool approved) public virtual override {
1499         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1500         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1501     }
1502 
1503     /**
1504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1505      *
1506      * See {setApprovalForAll}.
1507      */
1508     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1509         return _operatorApprovals[owner][operator];
1510     }
1511 
1512     /**
1513      * @dev Returns whether `tokenId` exists.
1514      *
1515      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1516      *
1517      * Tokens start existing when they are minted. See {_mint}.
1518      */
1519     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1520         return
1521             _startTokenId() <= tokenId &&
1522             tokenId < _currentIndex && // If within bounds,
1523             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1524     }
1525 
1526     /**
1527      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1528      */
1529     function _isSenderApprovedOrOwner(
1530         address approvedAddress,
1531         address owner,
1532         address msgSender
1533     ) private pure returns (bool result) {
1534         assembly {
1535             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1536             owner := and(owner, _BITMASK_ADDRESS)
1537             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1538             msgSender := and(msgSender, _BITMASK_ADDRESS)
1539             // `msgSender == owner || msgSender == approvedAddress`.
1540             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1541         }
1542     }
1543 
1544     /**
1545      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1546      */
1547     function _getApprovedSlotAndAddress(uint256 tokenId)
1548         private
1549         view
1550         returns (uint256 approvedAddressSlot, address approvedAddress)
1551     {
1552         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1553         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1554         assembly {
1555             approvedAddressSlot := tokenApproval.slot
1556             approvedAddress := sload(approvedAddressSlot)
1557         }
1558     }
1559 
1560     // =============================================================
1561     //                      TRANSFER OPERATIONS
1562     // =============================================================
1563 
1564     /**
1565      * @dev Transfers `tokenId` from `from` to `to`.
1566      *
1567      * Requirements:
1568      *
1569      * - `from` cannot be the zero address.
1570      * - `to` cannot be the zero address.
1571      * - `tokenId` token must be owned by `from`.
1572      * - If the caller is not `from`, it must be approved to move this token
1573      * by either {approve} or {setApprovalForAll}.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function transferFrom(
1578         address from,
1579         address to,
1580         uint256 tokenId
1581     ) public payable virtual override {
1582         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1583 
1584         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1585 
1586         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1587 
1588         // The nested ifs save around 20+ gas over a compound boolean condition.
1589         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1590             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1591 
1592         if (to == address(0)) revert TransferToZeroAddress();
1593 
1594         _beforeTokenTransfers(from, to, tokenId, 1);
1595 
1596         // Clear approvals from the previous owner.
1597         assembly {
1598             if approvedAddress {
1599                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1600                 sstore(approvedAddressSlot, 0)
1601             }
1602         }
1603 
1604         // Underflow of the sender's balance is impossible because we check for
1605         // ownership above and the recipient's balance can't realistically overflow.
1606         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1607         unchecked {
1608             // We can directly increment and decrement the balances.
1609             --_packedAddressData[from]; // Updates: `balance -= 1`.
1610             ++_packedAddressData[to]; // Updates: `balance += 1`.
1611 
1612             // Updates:
1613             // - `address` to the next owner.
1614             // - `startTimestamp` to the timestamp of transfering.
1615             // - `burned` to `false`.
1616             // - `nextInitialized` to `true`.
1617             _packedOwnerships[tokenId] = _packOwnershipData(
1618                 to,
1619                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1620             );
1621 
1622             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1623             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1624                 uint256 nextTokenId = tokenId + 1;
1625                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1626                 if (_packedOwnerships[nextTokenId] == 0) {
1627                     // If the next slot is within bounds.
1628                     if (nextTokenId != _currentIndex) {
1629                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1630                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1631                     }
1632                 }
1633             }
1634         }
1635 
1636         emit Transfer(from, to, tokenId);
1637         _afterTokenTransfers(from, to, tokenId, 1);
1638     }
1639 
1640     /**
1641      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1642      */
1643     function safeTransferFrom(
1644         address from,
1645         address to,
1646         uint256 tokenId
1647     ) public payable virtual override {
1648         safeTransferFrom(from, to, tokenId, '');
1649     }
1650 
1651     /**
1652      * @dev Safely transfers `tokenId` token from `from` to `to`.
1653      *
1654      * Requirements:
1655      *
1656      * - `from` cannot be the zero address.
1657      * - `to` cannot be the zero address.
1658      * - `tokenId` token must exist and be owned by `from`.
1659      * - If the caller is not `from`, it must be approved to move this token
1660      * by either {approve} or {setApprovalForAll}.
1661      * - If `to` refers to a smart contract, it must implement
1662      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function safeTransferFrom(
1667         address from,
1668         address to,
1669         uint256 tokenId,
1670         bytes memory _data
1671     ) public payable virtual override {
1672         transferFrom(from, to, tokenId);
1673         if (to.code.length != 0)
1674             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1675                 revert TransferToNonERC721ReceiverImplementer();
1676             }
1677     }
1678 
1679     /**
1680      * @dev Hook that is called before a set of serially-ordered token IDs
1681      * are about to be transferred. This includes minting.
1682      * And also called before burning one token.
1683      *
1684      * `startTokenId` - the first token ID to be transferred.
1685      * `quantity` - the amount to be transferred.
1686      *
1687      * Calling conditions:
1688      *
1689      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1690      * transferred to `to`.
1691      * - When `from` is zero, `tokenId` will be minted for `to`.
1692      * - When `to` is zero, `tokenId` will be burned by `from`.
1693      * - `from` and `to` are never both zero.
1694      */
1695     function _beforeTokenTransfers(
1696         address from,
1697         address to,
1698         uint256 startTokenId,
1699         uint256 quantity
1700     ) internal virtual {}
1701 
1702     /**
1703      * @dev Hook that is called after a set of serially-ordered token IDs
1704      * have been transferred. This includes minting.
1705      * And also called after one token has been burned.
1706      *
1707      * `startTokenId` - the first token ID to be transferred.
1708      * `quantity` - the amount to be transferred.
1709      *
1710      * Calling conditions:
1711      *
1712      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1713      * transferred to `to`.
1714      * - When `from` is zero, `tokenId` has been minted for `to`.
1715      * - When `to` is zero, `tokenId` has been burned by `from`.
1716      * - `from` and `to` are never both zero.
1717      */
1718     function _afterTokenTransfers(
1719         address from,
1720         address to,
1721         uint256 startTokenId,
1722         uint256 quantity
1723     ) internal virtual {}
1724 
1725     /**
1726      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1727      *
1728      * `from` - Previous owner of the given token ID.
1729      * `to` - Target address that will receive the token.
1730      * `tokenId` - Token ID to be transferred.
1731      * `_data` - Optional data to send along with the call.
1732      *
1733      * Returns whether the call correctly returned the expected magic value.
1734      */
1735     function _checkContractOnERC721Received(
1736         address from,
1737         address to,
1738         uint256 tokenId,
1739         bytes memory _data
1740     ) private returns (bool) {
1741         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1742             bytes4 retval
1743         ) {
1744             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1745         } catch (bytes memory reason) {
1746             if (reason.length == 0) {
1747                 revert TransferToNonERC721ReceiverImplementer();
1748             } else {
1749                 assembly {
1750                     revert(add(32, reason), mload(reason))
1751                 }
1752             }
1753         }
1754     }
1755 
1756     // =============================================================
1757     //                        MINT OPERATIONS
1758     // =============================================================
1759 
1760     /**
1761      * @dev Mints `quantity` tokens and transfers them to `to`.
1762      *
1763      * Requirements:
1764      *
1765      * - `to` cannot be the zero address.
1766      * - `quantity` must be greater than 0.
1767      *
1768      * Emits a {Transfer} event for each mint.
1769      */
1770     function _mint(address to, uint256 quantity) internal virtual {
1771         uint256 startTokenId = _currentIndex;
1772         if (quantity == 0) revert MintZeroQuantity();
1773 
1774         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1775 
1776         // Overflows are incredibly unrealistic.
1777         // `balance` and `numberMinted` have a maximum limit of 2**64.
1778         // `tokenId` has a maximum limit of 2**256.
1779         unchecked {
1780             // Updates:
1781             // - `balance += quantity`.
1782             // - `numberMinted += quantity`.
1783             //
1784             // We can directly add to the `balance` and `numberMinted`.
1785             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1786 
1787             // Updates:
1788             // - `address` to the owner.
1789             // - `startTimestamp` to the timestamp of minting.
1790             // - `burned` to `false`.
1791             // - `nextInitialized` to `quantity == 1`.
1792             _packedOwnerships[startTokenId] = _packOwnershipData(
1793                 to,
1794                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1795             );
1796 
1797             uint256 toMasked;
1798             uint256 end = startTokenId + quantity;
1799 
1800             // Use assembly to loop and emit the `Transfer` event for gas savings.
1801             // The duplicated `log4` removes an extra check and reduces stack juggling.
1802             // The assembly, together with the surrounding Solidity code, have been
1803             // delicately arranged to nudge the compiler into producing optimized opcodes.
1804             assembly {
1805                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1806                 toMasked := and(to, _BITMASK_ADDRESS)
1807                 // Emit the `Transfer` event.
1808                 log4(
1809                     0, // Start of data (0, since no data).
1810                     0, // End of data (0, since no data).
1811                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1812                     0, // `address(0)`.
1813                     toMasked, // `to`.
1814                     startTokenId // `tokenId`.
1815                 )
1816 
1817                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1818                 // that overflows uint256 will make the loop run out of gas.
1819                 // The compiler will optimize the `iszero` away for performance.
1820                 for {
1821                     let tokenId := add(startTokenId, 1)
1822                 } iszero(eq(tokenId, end)) {
1823                     tokenId := add(tokenId, 1)
1824                 } {
1825                     // Emit the `Transfer` event. Similar to above.
1826                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1827                 }
1828             }
1829             if (toMasked == 0) revert MintToZeroAddress();
1830 
1831             _currentIndex = end;
1832         }
1833         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1834     }
1835 
1836     /**
1837      * @dev Mints `quantity` tokens and transfers them to `to`.
1838      *
1839      * This function is intended for efficient minting only during contract creation.
1840      *
1841      * It emits only one {ConsecutiveTransfer} as defined in
1842      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1843      * instead of a sequence of {Transfer} event(s).
1844      *
1845      * Calling this function outside of contract creation WILL make your contract
1846      * non-compliant with the ERC721 standard.
1847      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1848      * {ConsecutiveTransfer} event is only permissible during contract creation.
1849      *
1850      * Requirements:
1851      *
1852      * - `to` cannot be the zero address.
1853      * - `quantity` must be greater than 0.
1854      *
1855      * Emits a {ConsecutiveTransfer} event.
1856      */
1857     function _mintERC2309(address to, uint256 quantity) internal virtual {
1858         uint256 startTokenId = _currentIndex;
1859         if (to == address(0)) revert MintToZeroAddress();
1860         if (quantity == 0) revert MintZeroQuantity();
1861         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1862 
1863         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1864 
1865         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1866         unchecked {
1867             // Updates:
1868             // - `balance += quantity`.
1869             // - `numberMinted += quantity`.
1870             //
1871             // We can directly add to the `balance` and `numberMinted`.
1872             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1873 
1874             // Updates:
1875             // - `address` to the owner.
1876             // - `startTimestamp` to the timestamp of minting.
1877             // - `burned` to `false`.
1878             // - `nextInitialized` to `quantity == 1`.
1879             _packedOwnerships[startTokenId] = _packOwnershipData(
1880                 to,
1881                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1882             );
1883 
1884             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1885 
1886             _currentIndex = startTokenId + quantity;
1887         }
1888         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1889     }
1890 
1891     /**
1892      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1893      *
1894      * Requirements:
1895      *
1896      * - If `to` refers to a smart contract, it must implement
1897      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1898      * - `quantity` must be greater than 0.
1899      *
1900      * See {_mint}.
1901      *
1902      * Emits a {Transfer} event for each mint.
1903      */
1904     function _safeMint(
1905         address to,
1906         uint256 quantity,
1907         bytes memory _data
1908     ) internal virtual {
1909         _mint(to, quantity);
1910 
1911         unchecked {
1912             if (to.code.length != 0) {
1913                 uint256 end = _currentIndex;
1914                 uint256 index = end - quantity;
1915                 do {
1916                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1917                         revert TransferToNonERC721ReceiverImplementer();
1918                     }
1919                 } while (index < end);
1920                 // Reentrancy protection.
1921                 if (_currentIndex != end) revert();
1922             }
1923         }
1924     }
1925 
1926     /**
1927      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1928      */
1929     function _safeMint(address to, uint256 quantity) internal virtual {
1930         _safeMint(to, quantity, '');
1931     }
1932 
1933     // =============================================================
1934     //                        BURN OPERATIONS
1935     // =============================================================
1936 
1937     /**
1938      * @dev Equivalent to `_burn(tokenId, false)`.
1939      */
1940     function _burn(uint256 tokenId) internal virtual {
1941         _burn(tokenId, false);
1942     }
1943 
1944     /**
1945      * @dev Destroys `tokenId`.
1946      * The approval is cleared when the token is burned.
1947      *
1948      * Requirements:
1949      *
1950      * - `tokenId` must exist.
1951      *
1952      * Emits a {Transfer} event.
1953      */
1954     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1955         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1956 
1957         address from = address(uint160(prevOwnershipPacked));
1958 
1959         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1960 
1961         if (approvalCheck) {
1962             // The nested ifs save around 20+ gas over a compound boolean condition.
1963             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1964                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1965         }
1966 
1967         _beforeTokenTransfers(from, address(0), tokenId, 1);
1968 
1969         // Clear approvals from the previous owner.
1970         assembly {
1971             if approvedAddress {
1972                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1973                 sstore(approvedAddressSlot, 0)
1974             }
1975         }
1976 
1977         // Underflow of the sender's balance is impossible because we check for
1978         // ownership above and the recipient's balance can't realistically overflow.
1979         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1980         unchecked {
1981             // Updates:
1982             // - `balance -= 1`.
1983             // - `numberBurned += 1`.
1984             //
1985             // We can directly decrement the balance, and increment the number burned.
1986             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1987             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1988 
1989             // Updates:
1990             // - `address` to the last owner.
1991             // - `startTimestamp` to the timestamp of burning.
1992             // - `burned` to `true`.
1993             // - `nextInitialized` to `true`.
1994             _packedOwnerships[tokenId] = _packOwnershipData(
1995                 from,
1996                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1997             );
1998 
1999             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2000             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2001                 uint256 nextTokenId = tokenId + 1;
2002                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2003                 if (_packedOwnerships[nextTokenId] == 0) {
2004                     // If the next slot is within bounds.
2005                     if (nextTokenId != _currentIndex) {
2006                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2007                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2008                     }
2009                 }
2010             }
2011         }
2012 
2013         emit Transfer(from, address(0), tokenId);
2014         _afterTokenTransfers(from, address(0), tokenId, 1);
2015 
2016         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2017         unchecked {
2018             _burnCounter++;
2019         }
2020     }
2021 
2022     // =============================================================
2023     //                     EXTRA DATA OPERATIONS
2024     // =============================================================
2025 
2026     /**
2027      * @dev Directly sets the extra data for the ownership data `index`.
2028      */
2029     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2030         uint256 packed = _packedOwnerships[index];
2031         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2032         uint256 extraDataCasted;
2033         // Cast `extraData` with assembly to avoid redundant masking.
2034         assembly {
2035             extraDataCasted := extraData
2036         }
2037         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2038         _packedOwnerships[index] = packed;
2039     }
2040 
2041     /**
2042      * @dev Called during each token transfer to set the 24bit `extraData` field.
2043      * Intended to be overridden by the cosumer contract.
2044      *
2045      * `previousExtraData` - the value of `extraData` before transfer.
2046      *
2047      * Calling conditions:
2048      *
2049      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2050      * transferred to `to`.
2051      * - When `from` is zero, `tokenId` will be minted for `to`.
2052      * - When `to` is zero, `tokenId` will be burned by `from`.
2053      * - `from` and `to` are never both zero.
2054      */
2055     function _extraData(
2056         address from,
2057         address to,
2058         uint24 previousExtraData
2059     ) internal view virtual returns (uint24) {}
2060 
2061     /**
2062      * @dev Returns the next extra data for the packed ownership data.
2063      * The returned result is shifted into position.
2064      */
2065     function _nextExtraData(
2066         address from,
2067         address to,
2068         uint256 prevOwnershipPacked
2069     ) private view returns (uint256) {
2070         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2071         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2072     }
2073 
2074     // =============================================================
2075     //                       OTHER OPERATIONS
2076     // =============================================================
2077 
2078     /**
2079      * @dev Returns the message sender (defaults to `msg.sender`).
2080      *
2081      * If you are writing GSN compatible contracts, you need to override this function.
2082      */
2083     function _msgSenderERC721A() internal view virtual returns (address) {
2084         return msg.sender;
2085     }
2086 
2087     /**
2088      * @dev Converts a uint256 to its ASCII string decimal representation.
2089      */
2090     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2091         assembly {
2092             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2093             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2094             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2095             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2096             let m := add(mload(0x40), 0xa0)
2097             // Update the free memory pointer to allocate.
2098             mstore(0x40, m)
2099             // Assign the `str` to the end.
2100             str := sub(m, 0x20)
2101             // Zeroize the slot after the string.
2102             mstore(str, 0)
2103 
2104             // Cache the end of the memory to calculate the length later.
2105             let end := str
2106 
2107             // We write the string from rightmost digit to leftmost digit.
2108             // The following is essentially a do-while loop that also handles the zero case.
2109             // prettier-ignore
2110             for { let temp := value } 1 {} {
2111                 str := sub(str, 1)
2112                 // Write the character to the pointer.
2113                 // The ASCII index of the '0' character is 48.
2114                 mstore8(str, add(48, mod(temp, 10)))
2115                 // Keep dividing `temp` until zero.
2116                 temp := div(temp, 10)
2117                 // prettier-ignore
2118                 if iszero(temp) { break }
2119             }
2120 
2121             let length := sub(end, str)
2122             // Move the pointer 32 bytes leftwards to make room for the length.
2123             str := sub(str, 0x20)
2124             // Store the length.
2125             mstore(str, length)
2126         }
2127     }
2128 }
2129 
2130 // File: contracts/blockchainrocks.sol
2131 
2132 
2133 
2134 pragma solidity ^0.8.0;
2135 
2136 
2137 
2138 
2139 
2140 
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 
2150 contract Color_Blast_By_Felix_Norgaard is ERC721A, Ownable, ReentrancyGuard {
2151   using Address for address;
2152   using Strings for uint;
2153 
2154 
2155   string  public  baseTokenURI = "ipfs://bafybeicgo6nmzkrkwrqwi33szz5zoza47injr7nkevmm2gfd7x6tlkjdly/";
2156   
2157   
2158   uint256 public  maxSupply = 333;
2159   uint256 public  maxMintPerTx = 2;
2160   uint256 public  publicSalePrice = 0.016 ether;
2161   uint256 public  allowlistPrice = 0.008 ether;
2162   uint256 public  numFreeMints = 0;
2163   uint256 public  maxFreePerWallet = 1;
2164   uint256 public  freeAlreadyMinted = 0;
2165   
2166   bool public PublicSaleActive = false;
2167   bool public allowListMintOpen = false;
2168   
2169   
2170 
2171   constructor() ERC721A("Color Blast By Felix Norgaard", "BLASTS") {
2172      
2173   }
2174  
2175  function setpublicSalePrice (uint256 _publicSalePrice) public onlyOwner {
2176     publicSalePrice = _publicSalePrice;
2177   }
2178 
2179   function setallowlistPrice (uint256 _allowlistPrice) public onlyOwner {
2180    allowlistPrice = _allowlistPrice;
2181   }
2182   
2183 
2184       // Modify the mint windows
2185     function editMintWindows(
2186         bool _PublicSaleActive,
2187         bool _allowListMintOpen
2188         
2189     ) external onlyOwner {
2190         PublicSaleActive = _PublicSaleActive;
2191         allowListMintOpen = _allowListMintOpen;
2192 
2193 
2194 
2195     }
2196     // require only the allowlist mint
2197     // Add publicMint and allowListMintOpen Variables
2198     function allowListMint (uint256 numberOfTokens) 
2199         external
2200         payable 
2201         
2202         {
2203         
2204         require(allowListMintOpen, "ALLOWLIST MINT CLOSED");
2205         require(totalSupply() + numberOfTokens < maxSupply + 1, "SOLD OUT");
2206         require(totalSupply() + numberOfTokens < maxSupply + 1, "SOLD OUT");
2207         require((allowlistPrice * numberOfTokens) <= msg.value,"MAX MINTS EXCEEDED");
2208         require(numberOfTokens <= maxMintPerTx,"MAX MINTS EXCEEDED");
2209          _safeMint(msg.sender, numberOfTokens);
2210         
2211     }
2212 
2213   function mint(uint256 numberOfTokens)
2214       external
2215       payable
2216   {
2217     require(PublicSaleActive, "MINT CLOSED");
2218     require(totalSupply() + numberOfTokens < maxSupply + 1, "SOLD OUT");
2219 
2220     if(freeAlreadyMinted + numberOfTokens > numFreeMints){
2221         require(
2222             (publicSalePrice * numberOfTokens) <= msg.value,
2223             "FREE MINT SOLD OUT"
2224         );
2225     } else {
2226         if (balanceOf(msg.sender) + numberOfTokens > maxFreePerWallet) {
2227         require(
2228             (publicSalePrice * numberOfTokens) <= msg.value,
2229             "ONLY ONE FREE MINT PER WALLET"
2230         );
2231         require(
2232             numberOfTokens <= maxMintPerTx,
2233             "MAX MINTS EXCEEDED"
2234         );
2235         } else {
2236             require(
2237                 numberOfTokens <= maxFreePerWallet,
2238                 "MAX FREE MINTS EXCEEDED"
2239             );
2240             freeAlreadyMinted += numberOfTokens;
2241         }
2242     }
2243     _safeMint(msg.sender, numberOfTokens);
2244   }
2245 
2246 function setBaseURI(string memory baseURI)
2247     public
2248     onlyOwner
2249   {
2250     baseTokenURI = baseURI;
2251   }  
2252   
2253 
2254 
2255   function treasuryMint(uint quantity)
2256     public
2257     onlyOwner
2258   {
2259     require(
2260       quantity > 0,
2261       ""
2262     );
2263     require(
2264       totalSupply() + quantity <= maxSupply,
2265       "4"
2266     );
2267     _safeMint(msg.sender, quantity);
2268   }
2269 
2270   function withdraw()
2271     public
2272     onlyOwner
2273     nonReentrant
2274   {
2275     Address.sendValue(payable(msg.sender), address(this).balance);
2276   }
2277 
2278   function _baseURI()
2279     internal
2280     view
2281     virtual
2282     override
2283     returns (string memory)
2284   {
2285     return baseTokenURI;
2286     
2287   }
2288 
2289   
2290   
2291     function setMaxLimitPerTransaction(uint256 _limit)
2292       external
2293       onlyOwner
2294     {
2295       maxMintPerTx = _limit;
2296     }
2297 
2298 
2299 
2300   function setFreeLimitPerWallet(uint256 _limit)
2301       external
2302       onlyOwner
2303   {
2304       maxFreePerWallet = _limit;
2305   }
2306 
2307  
2308    
2309 }