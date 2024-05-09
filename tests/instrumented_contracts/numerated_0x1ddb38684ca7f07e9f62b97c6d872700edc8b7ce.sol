1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-29
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-05-29
11 */
12 
13 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
14 
15 // SPDX-License-Identifier: MIT
16 
17 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Contract module that helps prevent reentrant calls to a function.
23  *
24  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
25  * available, which can be applied to functions to make sure there are no nested
26  * (reentrant) calls to them.
27  *
28  * Note that because there is a single `nonReentrant` guard, functions marked as
29  * `nonReentrant` may not call one another. This can be worked around by making
30  * those functions `private`, and then adding `external` `nonReentrant` entry
31  * points to them.
32  *
33  * TIP: If you would like to learn more about reentrancy and alternative ways
34  * to protect against it, check out our blog post
35  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
36  */
37 abstract contract ReentrancyGuard {
38     // Booleans are more expensive than uint256 or any type that takes up a full
39     // word because each write operation emits an extra SLOAD to first read the
40     // slot's contents, replace the bits taken up by the boolean, and then write
41     // back. This is the compiler's defense against contract upgrades and
42     // pointer aliasing, and it cannot be disabled.
43 
44     // The values being non-zero value makes deployment a bit more expensive,
45     // but in exchange the refund on every call to nonReentrant will be lower in
46     // amount. Since refunds are capped to a percentage of the total
47     // transaction's gas, it is best to keep them low in cases like this one, to
48     // increase the likelihood of the full refund coming into effect.
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57 
58     /**
59      * @dev Prevents a contract from calling itself, directly or indirectly.
60      * Calling a `nonReentrant` function from another `nonReentrant`
61      * function is not supported. It is possible to prevent this from happening
62      * by making the `nonReentrant` function external, and making it call a
63      * `private` function that does the actual work.
64      */
65     modifier nonReentrant() {
66         // On the first call to nonReentrant, _notEntered will be true
67         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
68 
69         // Any calls to nonReentrant after this point will fail
70         _status = _ENTERED;
71 
72         _;
73 
74         // By storing the original value once again, a refund is triggered (see
75         // https://eips.ethereum.org/EIPS/eip-2200)
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Strings.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev String operations.
89  */
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
95      */
96     function toString(uint256 value) internal pure returns (string memory) {
97         // Inspired by OraclizeAPI's implementation - MIT licence
98         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
99 
100         if (value == 0) {
101             return "0";
102         }
103         uint256 temp = value;
104         uint256 digits;
105         while (temp != 0) {
106             digits++;
107             temp /= 10;
108         }
109         bytes memory buffer = new bytes(digits);
110         while (value != 0) {
111             digits -= 1;
112             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
113             value /= 10;
114         }
115         return string(buffer);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
120      */
121     function toHexString(uint256 value) internal pure returns (string memory) {
122         if (value == 0) {
123             return "0x00";
124         }
125         uint256 temp = value;
126         uint256 length = 0;
127         while (temp != 0) {
128             length++;
129             temp >>= 8;
130         }
131         return toHexString(value, length);
132     }
133 
134     /**
135      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
136      */
137     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
138         bytes memory buffer = new bytes(2 * length + 2);
139         buffer[0] = "0";
140         buffer[1] = "x";
141         for (uint256 i = 2 * length + 1; i > 1; --i) {
142             buffer[i] = _HEX_SYMBOLS[value & 0xf];
143             value >>= 4;
144         }
145         require(value == 0, "Strings: hex length insufficient");
146         return string(buffer);
147     }
148 }
149 
150 // File: @openzeppelin/contracts/utils/Context.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 abstract contract Context {
168     function _msgSender() internal view virtual returns (address) {
169         return msg.sender;
170     }
171 
172     function _msgData() internal view virtual returns (bytes calldata) {
173         return msg.data;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/access/Ownable.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * By default, the owner account will be the one that deploys the contract. This
191  * can later be changed with {transferOwnership}.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _transferOwnership(_msgSender());
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view virtual returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * @dev Leaves the contract without owner. It will not be possible to call
226      * `onlyOwner` functions anymore. Can only be called by the current owner.
227      *
228      * NOTE: Renouncing ownership will leave the contract without an owner,
229      * thereby removing any functionality that is only available to the owner.
230      */
231     function renounceOwnership() public virtual onlyOwner {
232         _transferOwnership(address(0));
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Can only be called by the current owner.
238      */
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(newOwner != address(0), "Ownable: new owner is the zero address");
241         _transferOwnership(newOwner);
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Internal function without access restriction.
247      */
248     function _transferOwnership(address newOwner) internal virtual {
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Address.sol
256 
257 
258 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
259 
260 pragma solidity ^0.8.1;
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      *
283      * [IMPORTANT]
284      * ====
285      * You shouldn't rely on `isContract` to protect against flash loan attacks!
286      *
287      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
288      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
289      * constructor.
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // This method relies on extcodesize/address.code.length, which returns 0
294         // for contracts in construction, since the code is only stored at the end
295         // of the constructor execution.
296 
297         return account.code.length > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @title ERC721 token receiver interface
489  * @dev Interface for any contract that wants to support safeTransfers
490  * from ERC721 asset contracts.
491  */
492 interface IERC721Receiver {
493     /**
494      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
495      * by `operator` from `from`, this function is called.
496      *
497      * It must return its Solidity selector to confirm the token transfer.
498      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
499      *
500      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
501      */
502     function onERC721Received(
503         address operator,
504         address from,
505         uint256 tokenId,
506         bytes calldata data
507     ) external returns (bytes4);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Interface of the ERC165 standard, as defined in the
519  * https://eips.ethereum.org/EIPS/eip-165[EIP].
520  *
521  * Implementers can declare support of contract interfaces, which can then be
522  * queried by others ({ERC165Checker}).
523  *
524  * For an implementation, see {ERC165}.
525  */
526 interface IERC165 {
527     /**
528      * @dev Returns true if this contract implements the interface defined by
529      * `interfaceId`. See the corresponding
530      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
531      * to learn more about how these ids are created.
532      *
533      * This function call must use less than 30 000 gas.
534      */
535     function supportsInterface(bytes4 interfaceId) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @dev Required interface of an ERC721 compliant contract.
579  */
580 interface IERC721 is IERC165 {
581     /**
582      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
583      */
584     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
588      */
589     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
593      */
594     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
595 
596     /**
597      * @dev Returns the number of tokens in ``owner``'s account.
598      */
599     function balanceOf(address owner) external view returns (uint256 balance);
600 
601     /**
602      * @dev Returns the owner of the `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function ownerOf(uint256 tokenId) external view returns (address owner);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
612      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Transfers `tokenId` token from `from` to `to`.
632      *
633      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) external;
649 
650     /**
651      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
652      * The approval is cleared when the token is transferred.
653      *
654      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
655      *
656      * Requirements:
657      *
658      * - The caller must own the token or be an approved operator.
659      * - `tokenId` must exist.
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address to, uint256 tokenId) external;
664 
665     /**
666      * @dev Returns the account approved for `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function getApproved(uint256 tokenId) external view returns (address operator);
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
688      *
689      * See {setApprovalForAll}
690      */
691     function isApprovedForAll(address owner, address operator) external view returns (bool);
692 
693     /**
694      * @dev Safely transfers `tokenId` token from `from` to `to`.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must exist and be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes calldata data
711     ) external;
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
724  * @dev See https://eips.ethereum.org/EIPS/eip-721
725  */
726 interface IERC721Metadata is IERC721 {
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 }
742 
743 // File: contracts/ERC721A.sol
744 
745 
746 // Creator: Chiru Labs
747 
748 pragma solidity ^0.8.4;
749 
750 
751 
752 
753 
754 
755 
756 
757 error ApprovalCallerNotOwnerNorApproved();
758 error ApprovalQueryForNonexistentToken();
759 error ApproveToCaller();
760 error ApprovalToCurrentOwner();
761 error BalanceQueryForZeroAddress();
762 error MintToZeroAddress();
763 error MintZeroQuantity();
764 error OwnerQueryForNonexistentToken();
765 error TransferCallerNotOwnerNorApproved();
766 error TransferFromIncorrectOwner();
767 error TransferToNonERC721ReceiverImplementer();
768 error TransferToZeroAddress();
769 error URIQueryForNonexistentToken();
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension. Built to optimize for lower gas during batch mints.
774  *
775  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
776  *
777  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
778  *
779  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
780  */
781 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
782     using Address for address;
783     using Strings for uint256;
784 
785     // Compiler will pack this into a single 256bit word.
786     struct TokenOwnership {
787         // The address of the owner.
788         address addr;
789         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
790         uint64 startTimestamp;
791         // Whether the token has been burned.
792         bool burned;
793     }
794 
795     // Compiler will pack this into a single 256bit word.
796     struct AddressData {
797         // Realistically, 2**64-1 is more than enough.
798         uint64 balance;
799         // Keeps track of mint count with minimal overhead for tokenomics.
800         uint64 numberMinted;
801         // Keeps track of burn count with minimal overhead for tokenomics.
802         uint64 numberBurned;
803         // For miscellaneous variable(s) pertaining to the address
804         // (e.g. number of whitelist mint slots used).
805         // If there are multiple variables, please pack them into a uint64.
806         uint64 aux;
807     }
808 
809     // The tokenId of the next token to be minted.
810     uint256 internal _currentIndex;
811 
812     // The number of tokens burned.
813     uint256 internal _burnCounter;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837         _currentIndex = _startTokenId();
838     }
839 
840     /**
841      * To change the starting tokenId, please override this function.
842      */
843     function _startTokenId() internal view virtual returns (uint256) {
844         return 1;
845     }
846 
847     /**
848      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
849      */
850     function totalSupply() public view returns (uint256) {
851         // Counter underflow is impossible as _burnCounter cannot be incremented
852         // more than _currentIndex - _startTokenId() times
853         unchecked {
854             return _currentIndex - _burnCounter - _startTokenId();
855         }
856     }
857 
858     /**
859      * Returns the total amount of tokens minted in the contract.
860      */
861     function _totalMinted() internal view returns (uint256) {
862         // Counter underflow is impossible as _currentIndex does not decrement,
863         // and it is initialized to _startTokenId()
864         unchecked {
865             return _currentIndex - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC721).interfaceId ||
875             interfaceId == type(IERC721Metadata).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         if (owner == address(0)) revert BalanceQueryForZeroAddress();
884         return uint256(_addressData[owner].balance);
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         return _addressData[owner].aux;
906     }
907 
908     /**
909      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      * If there are multiple variables, please pack them into a uint64.
911      */
912     function _setAux(address owner, uint64 aux) internal {
913         _addressData[owner].aux = aux;
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (_startTokenId() <= curr && curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930                     // Invariant:
931                     // There will always be an ownership that has an address and is not burned
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     while (true) {
935                         curr--;
936                         ownership = _ownerships[curr];
937                         if (ownership.addr != address(0)) {
938                             return ownership;
939                         }
940                     }
941                 }
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return _ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public virtual override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1077      */
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement 
1088      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
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
1117             if (to.isContract()) {
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
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _mint(address to, uint256 quantity) internal {
1147         uint256 startTokenId = _currentIndex;
1148         if (to == address(0)) revert MintToZeroAddress();
1149         if (quantity == 0) revert MintZeroQuantity();
1150 
1151         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153         // Overflows are incredibly unrealistic.
1154         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1155         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1156         unchecked {
1157             _addressData[to].balance += uint64(quantity);
1158             _addressData[to].numberMinted += uint64(quantity);
1159 
1160             _ownerships[startTokenId].addr = to;
1161             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             uint256 updatedIndex = startTokenId;
1164             uint256 end = updatedIndex + quantity;
1165 
1166             do {
1167                 emit Transfer(address(0), to, updatedIndex++);
1168             } while (updatedIndex != end);
1169 
1170             _currentIndex = updatedIndex;
1171         }
1172         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173     }
1174 
1175     /**
1176      * @dev Transfers `tokenId` from `from` to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must be owned by `from`.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _transfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) private {
1190         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1191 
1192         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1193 
1194         bool isApprovedOrOwner = (_msgSender() == from ||
1195             isApprovedForAll(from, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (to == address(0)) revert TransferToZeroAddress();
1200 
1201         _beforeTokenTransfers(from, to, tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, from);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[from].balance -= 1;
1211             _addressData[to].balance += 1;
1212 
1213             TokenOwnership storage currSlot = _ownerships[tokenId];
1214             currSlot.addr = to;
1215             currSlot.startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1221             if (nextSlot.addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId != _currentIndex) {
1225                     nextSlot.addr = from;
1226                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1254 
1255         address from = prevOwnership.addr;
1256 
1257         if (approvalCheck) {
1258             bool isApprovedOrOwner = (_msgSender() == from ||
1259                 isApprovedForAll(from, _msgSender()) ||
1260                 getApproved(tokenId) == _msgSender());
1261 
1262             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId, from);
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             AddressData storage addressData = _addressData[from];
1275             addressData.balance -= 1;
1276             addressData.numberBurned += 1;
1277 
1278             // Keep track of who burned the token, and the timestamp of burning.
1279             TokenOwnership storage currSlot = _ownerships[tokenId];
1280             currSlot.addr = from;
1281             currSlot.startTimestamp = uint64(block.timestamp);
1282             currSlot.burned = true;
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1288             if (nextSlot.addr == address(0)) {
1289                 // This will suffice for checking _exists(nextTokenId),
1290                 // as a burned slot cannot contain the zero address.
1291                 if (nextTokenId != _currentIndex) {
1292                     nextSlot.addr = from;
1293                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(from, address(0), tokenId);
1299         _afterTokenTransfers(from, address(0), tokenId, 1);
1300 
1301         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1302         unchecked {
1303             _burnCounter++;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Approve `to` to operate on `tokenId`
1309      *
1310      * Emits a {Approval} event.
1311      */
1312     function _approve(
1313         address to,
1314         uint256 tokenId,
1315         address owner
1316     ) private {
1317         _tokenApprovals[tokenId] = to;
1318         emit Approval(owner, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1337             return retval == IERC721Receiver(to).onERC721Received.selector;
1338         } catch (bytes memory reason) {
1339             if (reason.length == 0) {
1340                 revert TransferToNonERC721ReceiverImplementer();
1341             } else {
1342                 assembly {
1343                     revert(add(32, reason), mload(reason))
1344                 }
1345             }
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * startTokenId - the first token id to be transferred
1354      * quantity - the amount to be transferred
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1373      * minting.
1374      * And also called after one token has been burned.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 }
1394 // File: contracts/GossamerGods.sol
1395 
1396 
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 
1403 
1404 contract GossamerGods is ERC721A, Ownable, ReentrancyGuard {
1405   using Address for address;
1406   using Strings for uint;
1407 
1408 
1409   string  public  baseTokenURI = "ipfs://QmZFHt5Ji5aXupaKpkLGriRYhvZZhYpWipbtro4FkhoN3x/";
1410   uint256  public  maxSupply = 6666;
1411   uint256 public  MAX_MINTS_PER_TX = 5;
1412   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1413   uint256 public  NUM_FREE_MINTS = 2222;
1414   uint256 public  MAX_FREE_PER_WALLET = 5;
1415   uint256 public freeNFTAlreadyMinted = 0;
1416   bool public isPublicSaleActive = false;
1417 
1418   constructor(
1419 
1420   ) ERC721A("Gossamer Gods", "GODS") {
1421 
1422   }
1423 
1424 
1425   function mint(uint256 numberOfTokens)
1426       external
1427       payable
1428   {
1429     require(isPublicSaleActive, "Public sale is not open");
1430     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1431 
1432     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1433         require(
1434             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1435             "Incorrect ETH value sent"
1436         );
1437     } else {
1438         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1439         require(
1440             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1441             "Incorrect ETH value sent"
1442         );
1443         require(
1444             numberOfTokens <= MAX_MINTS_PER_TX,
1445             "Max mints per transaction exceeded"
1446         );
1447         } else {
1448             require(
1449                 numberOfTokens <= MAX_FREE_PER_WALLET,
1450                 "Max mints per transaction exceeded"
1451             );
1452             freeNFTAlreadyMinted += numberOfTokens;
1453         }
1454     }
1455     _safeMint(msg.sender, numberOfTokens);
1456   }
1457 
1458   function setBaseURI(string memory baseURI)
1459     public
1460     onlyOwner
1461   {
1462     baseTokenURI = baseURI;
1463   }
1464 
1465   function treasuryMint(uint quantity)
1466     public
1467     onlyOwner
1468   {
1469     require(
1470       quantity > 0,
1471       "Invalid mint amount"
1472     );
1473     require(
1474       totalSupply() + quantity <= maxSupply,
1475       "Maximum supply exceeded"
1476     );
1477     _safeMint(msg.sender, quantity);
1478   }
1479 
1480   function withdraw()
1481     public
1482     onlyOwner
1483     nonReentrant
1484   {
1485     Address.sendValue(payable(msg.sender), address(this).balance);
1486   }
1487 
1488   function tokenURI(uint _tokenId)
1489     public
1490     view
1491     virtual
1492     override
1493     returns (string memory)
1494   {
1495     require(
1496       _exists(_tokenId),
1497       "ERC721Metadata: URI query for nonexistent token"
1498     );
1499     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1500   }
1501 
1502   function _baseURI()
1503     internal
1504     view
1505     virtual
1506     override
1507     returns (string memory)
1508   {
1509     return baseTokenURI;
1510   }
1511 
1512   function setIsPublicSaleActive(bool _isPublicSaleActive)
1513       external
1514       onlyOwner
1515   {
1516       isPublicSaleActive = _isPublicSaleActive;
1517   }
1518 
1519   function setNumFreeMints(uint256 _numfreemints)
1520       external
1521       onlyOwner
1522   {
1523       NUM_FREE_MINTS = _numfreemints;
1524   }
1525 
1526   function setSalePrice(uint256 _price)
1527       external
1528       onlyOwner
1529   {
1530       PUBLIC_SALE_PRICE = _price;
1531   }
1532 
1533   function setMaxLimitPerTransaction(uint256 _limit)
1534       external
1535       onlyOwner
1536   {
1537       MAX_MINTS_PER_TX = _limit;
1538   }
1539 
1540   function setFreeLimitPerWallet(uint256 _limit)
1541       external
1542       onlyOwner
1543   {
1544       MAX_FREE_PER_WALLET = _limit;
1545   }
1546 }