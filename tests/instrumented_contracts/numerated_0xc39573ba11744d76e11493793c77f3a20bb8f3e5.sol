1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-23
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-05-29
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-05-29
15 */
16 
17 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
18 
19 // SPDX-License-Identifier: MIT
20 
21 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Contract module that helps prevent reentrant calls to a function.
27  *
28  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
29  * available, which can be applied to functions to make sure there are no nested
30  * (reentrant) calls to them.
31  *
32  * Note that because there is a single `nonReentrant` guard, functions marked as
33  * `nonReentrant` may not call one another. This can be worked around by making
34  * those functions `private`, and then adding `external` `nonReentrant` entry
35  * points to them.
36  *
37  * TIP: If you would like to learn more about reentrancy and alternative ways
38  * to protect against it, check out our blog post
39  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
40  */
41 abstract contract ReentrancyGuard {
42     // Booleans are more expensive than uint256 or any type that takes up a full
43     // word because each write operation emits an extra SLOAD to first read the
44     // slot's contents, replace the bits taken up by the boolean, and then write
45     // back. This is the compiler's defense against contract upgrades and
46     // pointer aliasing, and it cannot be disabled.
47 
48     // The values being non-zero value makes deployment a bit more expensive,
49     // but in exchange the refund on every call to nonReentrant will be lower in
50     // amount. Since refunds are capped to a percentage of the total
51     // transaction's gas, it is best to keep them low in cases like this one, to
52     // increase the likelihood of the full refund coming into effect.
53     uint256 private constant _NOT_ENTERED = 1;
54     uint256 private constant _ENTERED = 2;
55 
56     uint256 private _status;
57 
58     constructor() {
59         _status = _NOT_ENTERED;
60     }
61 
62     /**
63      * @dev Prevents a contract from calling itself, directly or indirectly.
64      * Calling a `nonReentrant` function from another `nonReentrant`
65      * function is not supported. It is possible to prevent this from happening
66      * by making the `nonReentrant` function external, and making it call a
67      * `private` function that does the actual work.
68      */
69     modifier nonReentrant() {
70         // On the first call to nonReentrant, _notEntered will be true
71         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
72 
73         // Any calls to nonReentrant after this point will fail
74         _status = _ENTERED;
75 
76         _;
77 
78         // By storing the original value once again, a refund is triggered (see
79         // https://eips.ethereum.org/EIPS/eip-2200)
80         _status = _NOT_ENTERED;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 
154 // File: @openzeppelin/contracts/utils/Context.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes calldata) {
177         return msg.data;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/access/Ownable.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 
189 /**
190  * @dev Contract module which provides a basic access control mechanism, where
191  * there is an account (an owner) that can be granted exclusive access to
192  * specific functions.
193  *
194  * By default, the owner account will be the one that deploys the contract. This
195  * can later be changed with {transferOwnership}.
196  *
197  * This module is used through inheritance. It will make available the modifier
198  * `onlyOwner`, which can be applied to your functions to restrict their use to
199  * the owner.
200  */
201 abstract contract Ownable is Context {
202     address private _owner;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206     /**
207      * @dev Initializes the contract setting the deployer as the initial owner.
208      */
209     constructor() {
210         _transferOwnership(_msgSender());
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Address.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
263 
264 pragma solidity ^0.8.1;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      *
287      * [IMPORTANT]
288      * ====
289      * You shouldn't rely on `isContract` to protect against flash loan attacks!
290      *
291      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
292      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
293      * constructor.
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize/address.code.length, which returns 0
298         // for contracts in construction, since the code is only stored at the end
299         // of the constructor execution.
300 
301         return account.code.length > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         (bool success, ) = recipient.call{value: amount}("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain `call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         require(isContract(target), "Address: call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.call{value: value}(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         require(isContract(target), "Address: static call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by `operator` from `from`, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Interface of the ERC165 standard, as defined in the
523  * https://eips.ethereum.org/EIPS/eip-165[EIP].
524  *
525  * Implementers can declare support of contract interfaces, which can then be
526  * queried by others ({ERC165Checker}).
527  *
528  * For an implementation, see {ERC165}.
529  */
530 interface IERC165 {
531     /**
532      * @dev Returns true if this contract implements the interface defined by
533      * `interfaceId`. See the corresponding
534      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
535      * to learn more about how these ids are created.
536      *
537      * This function call must use less than 30 000 gas.
538      */
539     function supportsInterface(bytes4 interfaceId) external view returns (bool);
540 }
541 
542 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * ```solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * ```
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Required interface of an ERC721 compliant contract.
583  */
584 interface IERC721 is IERC165 {
585     /**
586      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
587      */
588     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
592      */
593     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
597      */
598     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
599 
600     /**
601      * @dev Returns the number of tokens in ``owner``'s account.
602      */
603     function balanceOf(address owner) external view returns (uint256 balance);
604 
605     /**
606      * @dev Returns the owner of the `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function ownerOf(uint256 tokenId) external view returns (address owner);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
616      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Transfers `tokenId` token from `from` to `to`.
636      *
637      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must be owned by `from`.
644      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
656      * The approval is cleared when the token is transferred.
657      *
658      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
659      *
660      * Requirements:
661      *
662      * - The caller must own the token or be an approved operator.
663      * - `tokenId` must exist.
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address to, uint256 tokenId) external;
668 
669     /**
670      * @dev Returns the account approved for `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Approve or remove `operator` as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The `operator` cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
692      *
693      * See {setApprovalForAll}
694      */
695     function isApprovedForAll(address owner, address operator) external view returns (bool);
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes calldata data
715     ) external;
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 interface IERC721Metadata is IERC721 {
731     /**
732      * @dev Returns the token collection name.
733      */
734     function name() external view returns (string memory);
735 
736     /**
737      * @dev Returns the token collection symbol.
738      */
739     function symbol() external view returns (string memory);
740 
741     /**
742      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
743      */
744     function tokenURI(uint256 tokenId) external view returns (string memory);
745 }
746 
747 // File: contracts/ERC721A.sol
748 
749 
750 // Creator: Chiru Labs
751 
752 pragma solidity ^0.8.4;
753 
754 
755 
756 
757 
758 
759 
760 
761 error ApprovalCallerNotOwnerNorApproved();
762 error ApprovalQueryForNonexistentToken();
763 error ApproveToCaller();
764 error ApprovalToCurrentOwner();
765 error BalanceQueryForZeroAddress();
766 error MintToZeroAddress();
767 error MintZeroQuantity();
768 error OwnerQueryForNonexistentToken();
769 error TransferCallerNotOwnerNorApproved();
770 error TransferFromIncorrectOwner();
771 error TransferToNonERC721ReceiverImplementer();
772 error TransferToZeroAddress();
773 error URIQueryForNonexistentToken();
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension. Built to optimize for lower gas during batch mints.
778  *
779  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
780  *
781  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
782  *
783  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
784  */
785 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
786     using Address for address;
787     using Strings for uint256;
788 
789     // Compiler will pack this into a single 256bit word.
790     struct TokenOwnership {
791         // The address of the owner.
792         address addr;
793         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
794         uint64 startTimestamp;
795         // Whether the token has been burned.
796         bool burned;
797     }
798 
799     // Compiler will pack this into a single 256bit word.
800     struct AddressData {
801         // Realistically, 2**64-1 is more than enough.
802         uint64 balance;
803         // Keeps track of mint count with minimal overhead for tokenomics.
804         uint64 numberMinted;
805         // Keeps track of burn count with minimal overhead for tokenomics.
806         uint64 numberBurned;
807         // For miscellaneous variable(s) pertaining to the address
808         // (e.g. number of whitelist mint slots used).
809         // If there are multiple variables, please pack them into a uint64.
810         uint64 aux;
811     }
812 
813     // The tokenId of the next token to be minted.
814     uint256 internal _currentIndex;
815 
816     // The number of tokens burned.
817     uint256 internal _burnCounter;
818 
819     // Token name
820     string private _name;
821 
822     // Token symbol
823     string private _symbol;
824 
825     // Mapping from token ID to ownership details
826     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
827     mapping(uint256 => TokenOwnership) internal _ownerships;
828 
829     // Mapping owner address to address data
830     mapping(address => AddressData) private _addressData;
831 
832     // Mapping from token ID to approved address
833     mapping(uint256 => address) private _tokenApprovals;
834 
835     // Mapping from owner to operator approvals
836     mapping(address => mapping(address => bool)) private _operatorApprovals;
837 
838     constructor(string memory name_, string memory symbol_) {
839         _name = name_;
840         _symbol = symbol_;
841         _currentIndex = _startTokenId();
842     }
843 
844     /**
845      * To change the starting tokenId, please override this function.
846      */
847     function _startTokenId() internal view virtual returns (uint256) {
848         return 1;
849     }
850 
851     /**
852      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
853      */
854     function totalSupply() public view returns (uint256) {
855         // Counter underflow is impossible as _burnCounter cannot be incremented
856         // more than _currentIndex - _startTokenId() times
857         unchecked {
858             return _currentIndex - _burnCounter - _startTokenId();
859         }
860     }
861 
862     /**
863      * Returns the total amount of tokens minted in the contract.
864      */
865     function _totalMinted() internal view returns (uint256) {
866         // Counter underflow is impossible as _currentIndex does not decrement,
867         // and it is initialized to _startTokenId()
868         unchecked {
869             return _currentIndex - _startTokenId();
870         }
871     }
872 
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
877         return
878             interfaceId == type(IERC721).interfaceId ||
879             interfaceId == type(IERC721Metadata).interfaceId ||
880             super.supportsInterface(interfaceId);
881     }
882 
883     /**
884      * @dev See {IERC721-balanceOf}.
885      */
886     function balanceOf(address owner) public view override returns (uint256) {
887         if (owner == address(0)) revert BalanceQueryForZeroAddress();
888         return uint256(_addressData[owner].balance);
889     }
890 
891     /**
892      * Returns the number of tokens minted by `owner`.
893      */
894     function _numberMinted(address owner) internal view returns (uint256) {
895         return uint256(_addressData[owner].numberMinted);
896     }
897 
898     /**
899      * Returns the number of tokens burned by or on behalf of `owner`.
900      */
901     function _numberBurned(address owner) internal view returns (uint256) {
902         return uint256(_addressData[owner].numberBurned);
903     }
904 
905     /**
906      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      */
908     function _getAux(address owner) internal view returns (uint64) {
909         return _addressData[owner].aux;
910     }
911 
912     /**
913      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
914      * If there are multiple variables, please pack them into a uint64.
915      */
916     function _setAux(address owner, uint64 aux) internal {
917         _addressData[owner].aux = aux;
918     }
919 
920     /**
921      * Gas spent here starts off proportional to the maximum mint batch size.
922      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
923      */
924     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
925         uint256 curr = tokenId;
926 
927         unchecked {
928             if (_startTokenId() <= curr && curr < _currentIndex) {
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
955         return _ownershipOf(tokenId).addr;
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
1017     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1063         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
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
1076         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1077     }
1078 
1079     /**
1080      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1081      */
1082     function _safeMint(address to, uint256 quantity) internal {
1083         _safeMint(to, quantity, '');
1084     }
1085 
1086     /**
1087      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - If `to` refers to a smart contract, it must implement 
1092      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _safeMint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data
1101     ) internal {
1102         uint256 startTokenId = _currentIndex;
1103         if (to == address(0)) revert MintToZeroAddress();
1104         if (quantity == 0) revert MintZeroQuantity();
1105 
1106         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108         // Overflows are incredibly unrealistic.
1109         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1110         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1111         unchecked {
1112             _addressData[to].balance += uint64(quantity);
1113             _addressData[to].numberMinted += uint64(quantity);
1114 
1115             _ownerships[startTokenId].addr = to;
1116             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1117 
1118             uint256 updatedIndex = startTokenId;
1119             uint256 end = updatedIndex + quantity;
1120 
1121             if (to.isContract()) {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex);
1124                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex != end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex != end);
1134             }
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _mint(address to, uint256 quantity) internal {
1151         uint256 startTokenId = _currentIndex;
1152         if (to == address(0)) revert MintToZeroAddress();
1153         if (quantity == 0) revert MintZeroQuantity();
1154 
1155         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1156 
1157         // Overflows are incredibly unrealistic.
1158         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1159         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1160         unchecked {
1161             _addressData[to].balance += uint64(quantity);
1162             _addressData[to].numberMinted += uint64(quantity);
1163 
1164             _ownerships[startTokenId].addr = to;
1165             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             uint256 updatedIndex = startTokenId;
1168             uint256 end = updatedIndex + quantity;
1169 
1170             do {
1171                 emit Transfer(address(0), to, updatedIndex++);
1172             } while (updatedIndex != end);
1173 
1174             _currentIndex = updatedIndex;
1175         }
1176         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `to` cannot be the zero address.
1185      * - `tokenId` token must be owned by `from`.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _transfer(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) private {
1194         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1195 
1196         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1197 
1198         bool isApprovedOrOwner = (_msgSender() == from ||
1199             isApprovedForAll(from, _msgSender()) ||
1200             getApproved(tokenId) == _msgSender());
1201 
1202         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1203         if (to == address(0)) revert TransferToZeroAddress();
1204 
1205         _beforeTokenTransfers(from, to, tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, from);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             _addressData[from].balance -= 1;
1215             _addressData[to].balance += 1;
1216 
1217             TokenOwnership storage currSlot = _ownerships[tokenId];
1218             currSlot.addr = to;
1219             currSlot.startTimestamp = uint64(block.timestamp);
1220 
1221             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1222             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1223             uint256 nextTokenId = tokenId + 1;
1224             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1225             if (nextSlot.addr == address(0)) {
1226                 // This will suffice for checking _exists(nextTokenId),
1227                 // as a burned slot cannot contain the zero address.
1228                 if (nextTokenId != _currentIndex) {
1229                     nextSlot.addr = from;
1230                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1231                 }
1232             }
1233         }
1234 
1235         emit Transfer(from, to, tokenId);
1236         _afterTokenTransfers(from, to, tokenId, 1);
1237     }
1238 
1239     /**
1240      * @dev Equivalent to `_burn(tokenId, false)`.
1241      */
1242     function _burn(uint256 tokenId) internal virtual {
1243         _burn(tokenId, false);
1244     }
1245 
1246     /**
1247      * @dev Destroys `tokenId`.
1248      * The approval is cleared when the token is burned.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must exist.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1257         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1258 
1259         address from = prevOwnership.addr;
1260 
1261         if (approvalCheck) {
1262             bool isApprovedOrOwner = (_msgSender() == from ||
1263                 isApprovedForAll(from, _msgSender()) ||
1264                 getApproved(tokenId) == _msgSender());
1265 
1266             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1267         }
1268 
1269         _beforeTokenTransfers(from, address(0), tokenId, 1);
1270 
1271         // Clear approvals from the previous owner
1272         _approve(address(0), tokenId, from);
1273 
1274         // Underflow of the sender's balance is impossible because we check for
1275         // ownership above and the recipient's balance can't realistically overflow.
1276         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1277         unchecked {
1278             AddressData storage addressData = _addressData[from];
1279             addressData.balance -= 1;
1280             addressData.numberBurned += 1;
1281 
1282             // Keep track of who burned the token, and the timestamp of burning.
1283             TokenOwnership storage currSlot = _ownerships[tokenId];
1284             currSlot.addr = from;
1285             currSlot.startTimestamp = uint64(block.timestamp);
1286             currSlot.burned = true;
1287 
1288             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1289             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1290             uint256 nextTokenId = tokenId + 1;
1291             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1292             if (nextSlot.addr == address(0)) {
1293                 // This will suffice for checking _exists(nextTokenId),
1294                 // as a burned slot cannot contain the zero address.
1295                 if (nextTokenId != _currentIndex) {
1296                     nextSlot.addr = from;
1297                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1298                 }
1299             }
1300         }
1301 
1302         emit Transfer(from, address(0), tokenId);
1303         _afterTokenTransfers(from, address(0), tokenId, 1);
1304 
1305         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1306         unchecked {
1307             _burnCounter++;
1308         }
1309     }
1310 
1311     /**
1312      * @dev Approve `to` to operate on `tokenId`
1313      *
1314      * Emits a {Approval} event.
1315      */
1316     function _approve(
1317         address to,
1318         uint256 tokenId,
1319         address owner
1320     ) private {
1321         _tokenApprovals[tokenId] = to;
1322         emit Approval(owner, to, tokenId);
1323     }
1324 
1325     /**
1326      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1327      *
1328      * @param from address representing the previous owner of the given token ID
1329      * @param to target address that will receive the tokens
1330      * @param tokenId uint256 ID of the token to be transferred
1331      * @param _data bytes optional data to send along with the call
1332      * @return bool whether the call correctly returned the expected magic value
1333      */
1334     function _checkContractOnERC721Received(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory _data
1339     ) private returns (bool) {
1340         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1341             return retval == IERC721Receiver(to).onERC721Received.selector;
1342         } catch (bytes memory reason) {
1343             if (reason.length == 0) {
1344                 revert TransferToNonERC721ReceiverImplementer();
1345             } else {
1346                 assembly {
1347                     revert(add(32, reason), mload(reason))
1348                 }
1349             }
1350         }
1351     }
1352 
1353     /**
1354      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1355      * And also called before burning one token.
1356      *
1357      * startTokenId - the first token id to be transferred
1358      * quantity - the amount to be transferred
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` will be minted for `to`.
1365      * - When `to` is zero, `tokenId` will be burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _beforeTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 
1375     /**
1376      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1377      * minting.
1378      * And also called after one token has been burned.
1379      *
1380      * startTokenId - the first token id to be transferred
1381      * quantity - the amount to be transferred
1382      *
1383      * Calling conditions:
1384      *
1385      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1386      * transferred to `to`.
1387      * - When `from` is zero, `tokenId` has been minted for `to`.
1388      * - When `to` is zero, `tokenId` has been burned by `from`.
1389      * - `from` and `to` are never both zero.
1390      */
1391     function _afterTokenTransfers(
1392         address from,
1393         address to,
1394         uint256 startTokenId,
1395         uint256 quantity
1396     ) internal virtual {}
1397 }
1398 // File: contracts/GossamerGods.sol
1399 
1400 
1401 
1402 pragma solidity ^0.8.0;
1403 
1404 
1405 
1406 
1407 
1408 contract MoonKillerOfficial is ERC721A, Ownable, ReentrancyGuard {
1409   using Address for address;
1410   using Strings for uint;
1411 
1412 
1413   string  public  baseTokenURI = "ipfs://QmbqpLTnTZBzvqXrSzkA36XfeZhwF1wkMmAfP5Agw7tDjN//";
1414   uint256  public  maxSupply = 2500;
1415   uint256 public  MAX_MINTS_PER_TX = 5;
1416   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1417   uint256 public  NUM_FREE_MINTS = 1000;
1418   uint256 public  MAX_FREE_PER_WALLET = 3;
1419   uint256 public freeNFTAlreadyMinted = 0;
1420   bool public isPublicSaleActive = true;
1421 
1422   constructor() ERC721A("MoonKiller Official", "MkO") {
1423   }
1424 
1425 
1426   function mint(uint256 numberOfTokens)
1427       external
1428       payable
1429   {
1430     require(isPublicSaleActive, "Sale is not open");
1431     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more left");
1432 
1433     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1434         require(
1435             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1436             "Incorrect ETH value sent"
1437         );
1438     } else {
1439         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1440         require(
1441             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1442             "Incorrect ETH value sent"
1443         );
1444         require(
1445             numberOfTokens <= MAX_MINTS_PER_TX,
1446             "Max mints per transaction exceeded"
1447         );
1448         } else {
1449             require(
1450                 numberOfTokens <= MAX_FREE_PER_WALLET,
1451                 "Max mints per transaction exceeded"
1452             );
1453             freeNFTAlreadyMinted += numberOfTokens;
1454         }
1455     }
1456     _safeMint(msg.sender, numberOfTokens);
1457   }
1458 
1459   function setBaseURI(string memory baseURI)
1460     public
1461     onlyOwner
1462   {
1463     baseTokenURI = baseURI;
1464   }
1465 
1466   function treasuryMint(uint quantity)
1467     public
1468     onlyOwner
1469   {
1470     require(
1471       quantity > 0,
1472       "Invalid mint amount"
1473     );
1474     require(
1475       totalSupply() + quantity <= maxSupply,
1476       "Maximum supply exceeded"
1477     );
1478     _safeMint(msg.sender, quantity);
1479   }
1480 
1481   function withdraw()
1482     public
1483     onlyOwner
1484     nonReentrant
1485   {
1486     Address.sendValue(payable(msg.sender), address(this).balance);
1487   }
1488 
1489   function tokenURI(uint _tokenId)
1490     public
1491     view
1492     virtual
1493     override
1494     returns (string memory)
1495   {
1496     require(
1497       _exists(_tokenId),
1498       "ERC721Metadata: URI query for nonexistent token"
1499     );
1500     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1501   }
1502 
1503   function _baseURI()
1504     internal
1505     view
1506     virtual
1507     override
1508     returns (string memory)
1509   {
1510     return baseTokenURI;
1511   }
1512 
1513   function setIsPublicSaleActive(bool _isPublicSaleActive)
1514       external
1515       onlyOwner
1516   {
1517       isPublicSaleActive = _isPublicSaleActive;
1518   }
1519 
1520   function setNumFreeMints(uint256 _numfreemints)
1521       external
1522       onlyOwner
1523   {
1524       NUM_FREE_MINTS = _numfreemints;
1525   }
1526 
1527   function setSalePrice(uint256 _price)
1528       external
1529       onlyOwner
1530   {
1531       PUBLIC_SALE_PRICE = _price;
1532   }
1533 
1534   function setMaxLimitPerTransaction(uint256 _limit)
1535       external
1536       onlyOwner
1537   {
1538       MAX_MINTS_PER_TX = _limit;
1539   }
1540 
1541   function setFreeLimitPerWallet(uint256 _limit)
1542       external
1543       onlyOwner
1544   {
1545       MAX_FREE_PER_WALLET = _limit;
1546   }
1547 }