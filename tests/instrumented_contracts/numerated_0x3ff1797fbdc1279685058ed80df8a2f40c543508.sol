1 /**
2 
3    _______  ________  ____________ __  ___  ______  ______
4   / __/ _ \/ __/ __/ / __/_  __/ // / / _ )/ __ \ \/ /_  /
5  / _// , _/ _// _/  / _/  / / / _  / / _  / /_/ /\  / / /_
6 /_/ /_/|_/___/___/ /___/ /_/ /_//_/ /____/\____/ /_/ /___/
7                                                           
8 
9 */
10 
11 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
12 
13 // SPDX-License-Identifier: MIT
14 
15 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and making it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
93      */
94     function toString(uint256 value) internal pure returns (string memory) {
95         // Inspired by OraclizeAPI's implementation - MIT licence
96         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
97 
98         if (value == 0) {
99             return "0";
100         }
101         uint256 temp = value;
102         uint256 digits;
103         while (temp != 0) {
104             digits++;
105             temp /= 10;
106         }
107         bytes memory buffer = new bytes(digits);
108         while (value != 0) {
109             digits -= 1;
110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
111             value /= 10;
112         }
113         return string(buffer);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
118      */
119     function toHexString(uint256 value) internal pure returns (string memory) {
120         if (value == 0) {
121             return "0x00";
122         }
123         uint256 temp = value;
124         uint256 length = 0;
125         while (temp != 0) {
126             length++;
127             temp >>= 8;
128         }
129         return toHexString(value, length);
130     }
131 
132     /**
133      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
134      */
135     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
136         bytes memory buffer = new bytes(2 * length + 2);
137         buffer[0] = "0";
138         buffer[1] = "x";
139         for (uint256 i = 2 * length + 1; i > 1; --i) {
140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
141             value >>= 4;
142         }
143         require(value == 0, "Strings: hex length insufficient");
144         return string(buffer);
145     }
146 }
147 
148 // File: @openzeppelin/contracts/utils/Context.sol
149 
150 
151 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 /**
156  * @dev Provides information about the current execution context, including the
157  * sender of the transaction and its data. While these are generally available
158  * via msg.sender and msg.data, they should not be accessed in such a direct
159  * manner, since when dealing with meta-transactions the account sending and
160  * paying for execution may not be the actual sender (as far as an application
161  * is concerned).
162  *
163  * This contract is only required for intermediate, library-like contracts.
164  */
165 abstract contract Context {
166     function _msgSender() internal view virtual returns (address) {
167         return msg.sender;
168     }
169 
170     function _msgData() internal view virtual returns (bytes calldata) {
171         return msg.data;
172     }
173 }
174 
175 // File: @openzeppelin/contracts/access/Ownable.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @dev Contract module which provides a basic access control mechanism, where
185  * there is an account (an owner) that can be granted exclusive access to
186  * specific functions.
187  *
188  * By default, the owner account will be the one that deploys the contract. This
189  * can later be changed with {transferOwnership}.
190  *
191  * This module is used through inheritance. It will make available the modifier
192  * `onlyOwner`, which can be applied to your functions to restrict their use to
193  * the owner.
194  */
195 abstract contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor() {
204         _transferOwnership(_msgSender());
205     }
206 
207     /**
208      * @dev Returns the address of the current owner.
209      */
210     function owner() public view virtual returns (address) {
211         return _owner;
212     }
213 
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     modifier onlyOwner() {
218         require(owner() == _msgSender(), "Ownable: caller is not the owner");
219         _;
220     }
221 
222     /**
223      * @dev Leaves the contract without owner. It will not be possible to call
224      * `onlyOwner` functions anymore. Can only be called by the current owner.
225      *
226      * NOTE: Renouncing ownership will leave the contract without an owner,
227      * thereby removing any functionality that is only available to the owner.
228      */
229     function renounceOwnership() public virtual onlyOwner {
230         _transferOwnership(address(0));
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Can only be called by the current owner.
236      */
237     function transferOwnership(address newOwner) public virtual onlyOwner {
238         require(newOwner != address(0), "Ownable: new owner is the zero address");
239         _transferOwnership(newOwner);
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Internal function without access restriction.
245      */
246     function _transferOwnership(address newOwner) internal virtual {
247         address oldOwner = _owner;
248         _owner = newOwner;
249         emit OwnershipTransferred(oldOwner, newOwner);
250     }
251 }
252 
253 // File: @openzeppelin/contracts/utils/Address.sol
254 
255 
256 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
257 
258 pragma solidity ^0.8.1;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      *
281      * [IMPORTANT]
282      * ====
283      * You shouldn't rely on `isContract` to protect against flash loan attacks!
284      *
285      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
286      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
287      * constructor.
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies on extcodesize/address.code.length, which returns 0
292         // for contracts in construction, since the code is only stored at the end
293         // of the constructor execution.
294 
295         return account.code.length > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         (bool success, ) = recipient.call{value: amount}("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain `call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         require(isContract(target), "Address: call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.call{value: value}(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
402         return functionStaticCall(target, data, "Address: low-level static call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal view returns (bytes memory) {
416         require(isContract(target), "Address: static call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.staticcall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(isContract(target), "Address: delegate call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
451      * revert reason using the provided one.
452      *
453      * _Available since v4.3._
454      */
455     function verifyCallResult(
456         bool success,
457         bytes memory returndata,
458         string memory errorMessage
459     ) internal pure returns (bytes memory) {
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @title ERC721 token receiver interface
487  * @dev Interface for any contract that wants to support safeTransfers
488  * from ERC721 asset contracts.
489  */
490 interface IERC721Receiver {
491     /**
492      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
493      * by `operator` from `from`, this function is called.
494      *
495      * It must return its Solidity selector to confirm the token transfer.
496      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
497      *
498      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
499      */
500     function onERC721Received(
501         address operator,
502         address from,
503         uint256 tokenId,
504         bytes calldata data
505     ) external returns (bytes4);
506 }
507 
508 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev Required interface of an ERC721 compliant contract.
577  */
578 interface IERC721 is IERC165 {
579     /**
580      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
581      */
582     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
586      */
587     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
588 
589     /**
590      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
591      */
592     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
593 
594     /**
595      * @dev Returns the number of tokens in ``owner``'s account.
596      */
597     function balanceOf(address owner) external view returns (uint256 balance);
598 
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) external view returns (address owner);
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
610      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId
626     ) external;
627 
628     /**
629      * @dev Transfers `tokenId` token from `from` to `to`.
630      *
631      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must be owned by `from`.
638      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
639      *
640      * Emits a {Transfer} event.
641      */
642     function transferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) external;
647 
648     /**
649      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
650      * The approval is cleared when the token is transferred.
651      *
652      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
653      *
654      * Requirements:
655      *
656      * - The caller must own the token or be an approved operator.
657      * - `tokenId` must exist.
658      *
659      * Emits an {Approval} event.
660      */
661     function approve(address to, uint256 tokenId) external;
662 
663     /**
664      * @dev Returns the account approved for `tokenId` token.
665      *
666      * Requirements:
667      *
668      * - `tokenId` must exist.
669      */
670     function getApproved(uint256 tokenId) external view returns (address operator);
671 
672     /**
673      * @dev Approve or remove `operator` as an operator for the caller.
674      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
675      *
676      * Requirements:
677      *
678      * - The `operator` cannot be the caller.
679      *
680      * Emits an {ApprovalForAll} event.
681      */
682     function setApprovalForAll(address operator, bool _approved) external;
683 
684     /**
685      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
686      *
687      * See {setApprovalForAll}
688      */
689     function isApprovedForAll(address owner, address operator) external view returns (bool);
690 
691     /**
692      * @dev Safely transfers `tokenId` token from `from` to `to`.
693      *
694      * Requirements:
695      *
696      * - `from` cannot be the zero address.
697      * - `to` cannot be the zero address.
698      * - `tokenId` token must exist and be owned by `from`.
699      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
700      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
701      *
702      * Emits a {Transfer} event.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId,
708         bytes calldata data
709     ) external;
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Metadata is IERC721 {
725     /**
726      * @dev Returns the token collection name.
727      */
728     function name() external view returns (string memory);
729 
730     /**
731      * @dev Returns the token collection symbol.
732      */
733     function symbol() external view returns (string memory);
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) external view returns (string memory);
739 }
740 
741 // File: contracts/ERC721A.sol
742 
743 
744 // Creator: Chiru Labs
745 
746 pragma solidity ^0.8.4;
747 
748 
749 
750 
751 
752 
753 
754 
755 error ApprovalCallerNotOwnerNorApproved();
756 error ApprovalQueryForNonexistentToken();
757 error ApproveToCaller();
758 error ApprovalToCurrentOwner();
759 error BalanceQueryForZeroAddress();
760 error MintToZeroAddress();
761 error MintZeroQuantity();
762 error OwnerQueryForNonexistentToken();
763 error TransferCallerNotOwnerNorApproved();
764 error TransferFromIncorrectOwner();
765 error TransferToNonERC721ReceiverImplementer();
766 error TransferToZeroAddress();
767 error URIQueryForNonexistentToken();
768 
769 /**
770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
771  * the Metadata extension. Built to optimize for lower gas during batch mints.
772  *
773  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
774  *
775  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
776  *
777  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
778  */
779 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
780     using Address for address;
781     using Strings for uint256;
782 
783     // Compiler will pack this into a single 256bit word.
784     struct TokenOwnership {
785         // The address of the owner.
786         address addr;
787         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
788         uint64 startTimestamp;
789         // Whether the token has been burned.
790         bool burned;
791     }
792 
793     // Compiler will pack this into a single 256bit word.
794     struct AddressData {
795         // Realistically, 2**64-1 is more than enough.
796         uint64 balance;
797         // Keeps track of mint count with minimal overhead for tokenomics.
798         uint64 numberMinted;
799         // Keeps track of burn count with minimal overhead for tokenomics.
800         uint64 numberBurned;
801         // For miscellaneous variable(s) pertaining to the address
802         // (e.g. number of whitelist mint slots used).
803         // If there are multiple variables, please pack them into a uint64.
804         uint64 aux;
805     }
806 
807     // The tokenId of the next token to be minted.
808     uint256 internal _currentIndex;
809 
810     // The number of tokens burned.
811     uint256 internal _burnCounter;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
821     mapping(uint256 => TokenOwnership) internal _ownerships;
822 
823     // Mapping owner address to address data
824     mapping(address => AddressData) private _addressData;
825 
826     // Mapping from token ID to approved address
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835         _currentIndex = _startTokenId();
836     }
837 
838     /**
839      * To change the starting tokenId, please override this function.
840      */
841     function _startTokenId() internal view virtual returns (uint256) {
842         return 1;
843     }
844 
845     /**
846      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
847      */
848     function totalSupply() public view returns (uint256) {
849         // Counter underflow is impossible as _burnCounter cannot be incremented
850         // more than _currentIndex - _startTokenId() times
851         unchecked {
852             return _currentIndex - _burnCounter - _startTokenId();
853         }
854     }
855 
856     /**
857      * Returns the total amount of tokens minted in the contract.
858      */
859     function _totalMinted() internal view returns (uint256) {
860         // Counter underflow is impossible as _currentIndex does not decrement,
861         // and it is initialized to _startTokenId()
862         unchecked {
863             return _currentIndex - _startTokenId();
864         }
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             super.supportsInterface(interfaceId);
875     }
876 
877     /**
878      * @dev See {IERC721-balanceOf}.
879      */
880     function balanceOf(address owner) public view override returns (uint256) {
881         if (owner == address(0)) revert BalanceQueryForZeroAddress();
882         return uint256(_addressData[owner].balance);
883     }
884 
885     /**
886      * Returns the number of tokens minted by `owner`.
887      */
888     function _numberMinted(address owner) internal view returns (uint256) {
889         return uint256(_addressData[owner].numberMinted);
890     }
891 
892     /**
893      * Returns the number of tokens burned by or on behalf of `owner`.
894      */
895     function _numberBurned(address owner) internal view returns (uint256) {
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      */
902     function _getAux(address owner) internal view returns (uint64) {
903         return _addressData[owner].aux;
904     }
905 
906     /**
907      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      * If there are multiple variables, please pack them into a uint64.
909      */
910     function _setAux(address owner, uint64 aux) internal {
911         _addressData[owner].aux = aux;
912     }
913 
914     /**
915      * Gas spent here starts off proportional to the maximum mint batch size.
916      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
917      */
918     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
919         uint256 curr = tokenId;
920 
921         unchecked {
922             if (_startTokenId() <= curr && curr < _currentIndex) {
923                 TokenOwnership memory ownership = _ownerships[curr];
924                 if (!ownership.burned) {
925                     if (ownership.addr != address(0)) {
926                         return ownership;
927                     }
928                     // Invariant:
929                     // There will always be an ownership that has an address and is not burned
930                     // before an ownership that does not have an address and is not burned.
931                     // Hence, curr will not underflow.
932                     while (true) {
933                         curr--;
934                         ownership = _ownerships[curr];
935                         if (ownership.addr != address(0)) {
936                             return ownership;
937                         }
938                     }
939                 }
940             }
941         }
942         revert OwnerQueryForNonexistentToken();
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view override returns (address) {
949         return _ownershipOf(tokenId).addr;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-name}.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-symbol}.
961      */
962     function symbol() public view virtual override returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-tokenURI}.
968      */
969     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
970         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
971 
972         string memory baseURI = _baseURI();
973         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, can be overriden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return '';
983     }
984 
985     /**
986      * @dev See {IERC721-approve}.
987      */
988     function approve(address to, uint256 tokenId) public override {
989         address owner = ERC721A.ownerOf(tokenId);
990         if (to == owner) revert ApprovalToCurrentOwner();
991 
992         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
993             revert ApprovalCallerNotOwnerNorApproved();
994         }
995 
996         _approve(to, tokenId, owner);
997     }
998 
999     /**
1000      * @dev See {IERC721-getApproved}.
1001      */
1002     function getApproved(uint256 tokenId) public view override returns (address) {
1003         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved) public virtual override {
1012         if (operator == _msgSender()) revert ApproveToCaller();
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-transferFrom}.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         _transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         safeTransferFrom(from, to, tokenId, '');
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1058             revert TransferToNonERC721ReceiverImplementer();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns whether `tokenId` exists.
1064      *
1065      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1066      *
1067      * Tokens start existing when they are minted (`_mint`),
1068      */
1069     function _exists(uint256 tokenId) internal view returns (bool) {
1070         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1071     }
1072 
1073     /**
1074      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1075      */
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement 
1086      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeMint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data
1095     ) internal {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are incredibly unrealistic.
1103         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1104         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1105         unchecked {
1106             _addressData[to].balance += uint64(quantity);
1107             _addressData[to].numberMinted += uint64(quantity);
1108 
1109             _ownerships[startTokenId].addr = to;
1110             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1111 
1112             uint256 updatedIndex = startTokenId;
1113             uint256 end = updatedIndex + quantity;
1114 
1115             if (to.isContract()) {
1116                 do {
1117                     emit Transfer(address(0), to, updatedIndex);
1118                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1119                         revert TransferToNonERC721ReceiverImplementer();
1120                     }
1121                 } while (updatedIndex != end);
1122                 // Reentrancy protection
1123                 if (_currentIndex != startTokenId) revert();
1124             } else {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex++);
1127                 } while (updatedIndex != end);
1128             }
1129             _currentIndex = updatedIndex;
1130         }
1131         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1132     }
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _mint(address to, uint256 quantity) internal {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are incredibly unrealistic.
1152         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1153         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             do {
1165                 emit Transfer(address(0), to, updatedIndex++);
1166             } while (updatedIndex != end);
1167 
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1189 
1190         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1191 
1192         bool isApprovedOrOwner = (_msgSender() == from ||
1193             isApprovedForAll(from, _msgSender()) ||
1194             getApproved(tokenId) == _msgSender());
1195 
1196         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1197         if (to == address(0)) revert TransferToZeroAddress();
1198 
1199         _beforeTokenTransfers(from, to, tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, from);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[from].balance -= 1;
1209             _addressData[to].balance += 1;
1210 
1211             TokenOwnership storage currSlot = _ownerships[tokenId];
1212             currSlot.addr = to;
1213             currSlot.startTimestamp = uint64(block.timestamp);
1214 
1215             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1216             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1217             uint256 nextTokenId = tokenId + 1;
1218             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1219             if (nextSlot.addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId != _currentIndex) {
1223                     nextSlot.addr = from;
1224                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(from, to, tokenId);
1230         _afterTokenTransfers(from, to, tokenId, 1);
1231     }
1232 
1233     /**
1234      * @dev Equivalent to `_burn(tokenId, false)`.
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         _burn(tokenId, false);
1238     }
1239 
1240     /**
1241      * @dev Destroys `tokenId`.
1242      * The approval is cleared when the token is burned.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1251         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1252 
1253         address from = prevOwnership.addr;
1254 
1255         if (approvalCheck) {
1256             bool isApprovedOrOwner = (_msgSender() == from ||
1257                 isApprovedForAll(from, _msgSender()) ||
1258                 getApproved(tokenId) == _msgSender());
1259 
1260             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1261         }
1262 
1263         _beforeTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, from);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             AddressData storage addressData = _addressData[from];
1273             addressData.balance -= 1;
1274             addressData.numberBurned += 1;
1275 
1276             // Keep track of who burned the token, and the timestamp of burning.
1277             TokenOwnership storage currSlot = _ownerships[tokenId];
1278             currSlot.addr = from;
1279             currSlot.startTimestamp = uint64(block.timestamp);
1280             currSlot.burned = true;
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1286             if (nextSlot.addr == address(0)) {
1287                 // This will suffice for checking _exists(nextTokenId),
1288                 // as a burned slot cannot contain the zero address.
1289                 if (nextTokenId != _currentIndex) {
1290                     nextSlot.addr = from;
1291                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, address(0), tokenId);
1297         _afterTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1300         unchecked {
1301             _burnCounter++;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Approve `to` to operate on `tokenId`
1307      *
1308      * Emits a {Approval} event.
1309      */
1310     function _approve(
1311         address to,
1312         uint256 tokenId,
1313         address owner
1314     ) private {
1315         _tokenApprovals[tokenId] = to;
1316         emit Approval(owner, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkContractOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1335             return retval == IERC721Receiver(to).onERC721Received.selector;
1336         } catch (bytes memory reason) {
1337             if (reason.length == 0) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             } else {
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349      * And also called before burning one token.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      * - When `to` is zero, `tokenId` will be burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _beforeTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 
1369     /**
1370      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1371      * minting.
1372      * And also called after one token has been burned.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` has been minted for `to`.
1382      * - When `to` is zero, `tokenId` has been burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _afterTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 }
1392 // File: contracts/FREEETHBOYZ.sol
1393 
1394 
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 
1399 
1400 
1401 
1402 contract FREEETHBOYZ is ERC721A, Ownable, ReentrancyGuard {
1403   using Address for address;
1404   using Strings for uint;
1405 
1406 
1407   string  public  baseTokenURI = "ipfs://QmSWaacb1UtGBLjxLt8gRzhLfn1v5fdhXmsDMVRVmvQind/";
1408   uint256  public  maxSupply = 777;
1409   uint256 public  MAX_MINTS_PER_TX = 1;
1410   uint256 public  PUBLIC_SALE_PRICE = 0.00 ether;
1411   uint256 public  NUM_FREE_MINTS = 777;
1412   uint256 public  MAX_FREE_PER_WALLET = 1;
1413   uint256 public freeNFTAlreadyMinted = 0;
1414   bool public isPublicSaleActive = false;
1415 
1416   constructor(
1417 
1418   ) ERC721A("FREE ETH BOYZ", "MOON") {
1419 
1420   }
1421 
1422 
1423   function mint(uint256 numberOfTokens)
1424       external
1425       payable
1426   {
1427     require(isPublicSaleActive, "Public sale is not open");
1428     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1429 
1430     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1431         require(
1432             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1433             "Incorrect ETH value sent"
1434         );
1435     } else {
1436         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1437         require(
1438             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1439             "Incorrect ETH value sent"
1440         );
1441         require(
1442             numberOfTokens <= MAX_MINTS_PER_TX,
1443             "Max mints per transaction exceeded"
1444         );
1445         } else {
1446             require(
1447                 numberOfTokens <= MAX_FREE_PER_WALLET,
1448                 "Max mints per transaction exceeded"
1449             );
1450             freeNFTAlreadyMinted += numberOfTokens;
1451         }
1452     }
1453     _safeMint(msg.sender, numberOfTokens);
1454   }
1455 
1456   function setBaseURI(string memory baseURI)
1457     public
1458     onlyOwner
1459   {
1460     baseTokenURI = baseURI;
1461   }
1462 
1463   function treasuryMint(uint quantity)
1464     public
1465     onlyOwner
1466   {
1467     require(
1468       quantity > 0,
1469       "Invalid mint amount"
1470     );
1471     require(
1472       totalSupply() + quantity <= maxSupply,
1473       "Maximum supply exceeded"
1474     );
1475     _safeMint(msg.sender, quantity);
1476   }
1477 
1478   function withdraw()
1479     public
1480     onlyOwner
1481     nonReentrant
1482   {
1483     Address.sendValue(payable(msg.sender), address(this).balance);
1484   }
1485 
1486   function tokenURI(uint _tokenId)
1487     public
1488     view
1489     virtual
1490     override
1491     returns (string memory)
1492   {
1493     require(
1494       _exists(_tokenId),
1495       "ERC721Metadata: URI query for nonexistent token"
1496     );
1497     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1498   }
1499 
1500   function _baseURI()
1501     internal
1502     view
1503     virtual
1504     override
1505     returns (string memory)
1506   {
1507     return baseTokenURI;
1508   }
1509 
1510   function setIsPublicSaleActive(bool _isPublicSaleActive)
1511       external
1512       onlyOwner
1513   {
1514       isPublicSaleActive = _isPublicSaleActive;
1515   }
1516 
1517   function setNumFreeMints(uint256 _numfreemints)
1518       external
1519       onlyOwner
1520   {
1521       NUM_FREE_MINTS = _numfreemints;
1522   }
1523 
1524   function setSalePrice(uint256 _price)
1525       external
1526       onlyOwner
1527   {
1528       PUBLIC_SALE_PRICE = _price;
1529   }
1530 
1531   function setMaxLimitPerTransaction(uint256 _limit)
1532       external
1533       onlyOwner
1534   {
1535       MAX_MINTS_PER_TX = _limit;
1536   }
1537 
1538   function setFreeLimitPerWallet(uint256 _limit)
1539       external
1540       onlyOwner
1541   {
1542       MAX_FREE_PER_WALLET = _limit;
1543   }
1544 }