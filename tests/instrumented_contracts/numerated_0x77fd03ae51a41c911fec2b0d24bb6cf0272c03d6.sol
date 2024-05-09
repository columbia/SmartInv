1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-09
7 */
8 
9 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Strings.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev String operations.
85  */
86 library Strings {
87     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
91      */
92     function toString(uint256 value) internal pure returns (string memory) {
93         // Inspired by OraclizeAPI's implementation - MIT licence
94         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
95 
96         if (value == 0) {
97             return "0";
98         }
99         uint256 temp = value;
100         uint256 digits;
101         while (temp != 0) {
102             digits++;
103             temp /= 10;
104         }
105         bytes memory buffer = new bytes(digits);
106         while (value != 0) {
107             digits -= 1;
108             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
109             value /= 10;
110         }
111         return string(buffer);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
116      */
117     function toHexString(uint256 value) internal pure returns (string memory) {
118         if (value == 0) {
119             return "0x00";
120         }
121         uint256 temp = value;
122         uint256 length = 0;
123         while (temp != 0) {
124             length++;
125             temp >>= 8;
126         }
127         return toHexString(value, length);
128     }
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
132      */
133     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
134         bytes memory buffer = new bytes(2 * length + 2);
135         buffer[0] = "0";
136         buffer[1] = "x";
137         for (uint256 i = 2 * length + 1; i > 1; --i) {
138             buffer[i] = _HEX_SYMBOLS[value & 0xf];
139             value >>= 4;
140         }
141         require(value == 0, "Strings: hex length insufficient");
142         return string(buffer);
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Returns the address of the current owner.
207      */
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211 
212     /**
213      * @dev Throws if called by any account other than the owner.
214      */
215     modifier onlyOwner() {
216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
217         _;
218     }
219 
220     /**
221      * @dev Leaves the contract without owner. It will not be possible to call
222      * `onlyOwner` functions anymore. Can only be called by the current owner.
223      *
224      * NOTE: Renouncing ownership will leave the contract without an owner,
225      * thereby removing any functionality that is only available to the owner.
226      */
227     function renounceOwnership() public virtual onlyOwner {
228         _transferOwnership(address(0));
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         _transferOwnership(newOwner);
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Internal function without access restriction.
243      */
244     function _transferOwnership(address newOwner) internal virtual {
245         address oldOwner = _owner;
246         _owner = newOwner;
247         emit OwnershipTransferred(oldOwner, newOwner);
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Address.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
255 
256 pragma solidity ^0.8.1;
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      *
279      * [IMPORTANT]
280      * ====
281      * You shouldn't rely on `isContract` to protect against flash loan attacks!
282      *
283      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
284      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
285      * constructor.
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize/address.code.length, which returns 0
290         // for contracts in construction, since the code is only stored at the end
291         // of the constructor execution.
292 
293         return account.code.length > 0;
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         (bool success, ) = recipient.call{value: amount}("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain `call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but also transferring `value` wei to `target`.
358      *
359      * Requirements:
360      *
361      * - the calling contract must have an ETH balance of at least `value`.
362      * - the called Solidity function must be `payable`.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         require(isContract(target), "Address: call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.call{value: value}(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
400         return functionStaticCall(target, data, "Address: low-level static call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal view returns (bytes memory) {
414         require(isContract(target), "Address: static call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.staticcall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
427         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         require(isContract(target), "Address: delegate call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.delegatecall(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
449      * revert reason using the provided one.
450      *
451      * _Available since v4.3._
452      */
453     function verifyCallResult(
454         bool success,
455         bytes memory returndata,
456         string memory errorMessage
457     ) internal pure returns (bytes memory) {
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 assembly {
466                     let returndata_size := mload(returndata)
467                     revert(add(32, returndata), returndata_size)
468                 }
469             } else {
470                 revert(errorMessage);
471             }
472         }
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @title ERC721 token receiver interface
485  * @dev Interface for any contract that wants to support safeTransfers
486  * from ERC721 asset contracts.
487  */
488 interface IERC721Receiver {
489     /**
490      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
491      * by `operator` from `from`, this function is called.
492      *
493      * It must return its Solidity selector to confirm the token transfer.
494      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
495      *
496      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
497      */
498     function onERC721Received(
499         address operator,
500         address from,
501         uint256 tokenId,
502         bytes calldata data
503     ) external returns (bytes4);
504 }
505 
506 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Interface of the ERC165 standard, as defined in the
515  * https://eips.ethereum.org/EIPS/eip-165[EIP].
516  *
517  * Implementers can declare support of contract interfaces, which can then be
518  * queried by others ({ERC165Checker}).
519  *
520  * For an implementation, see {ERC165}.
521  */
522 interface IERC165 {
523     /**
524      * @dev Returns true if this contract implements the interface defined by
525      * `interfaceId`. See the corresponding
526      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
527      * to learn more about how these ids are created.
528      *
529      * This function call must use less than 30 000 gas.
530      */
531     function supportsInterface(bytes4 interfaceId) external view returns (bool);
532 }
533 
534 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @dev Required interface of an ERC721 compliant contract.
575  */
576 interface IERC721 is IERC165 {
577     /**
578      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
584      */
585     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
586 
587     /**
588      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
589      */
590     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
591 
592     /**
593      * @dev Returns the number of tokens in ``owner``'s account.
594      */
595     function balanceOf(address owner) external view returns (uint256 balance);
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) external view returns (address owner);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Transfers `tokenId` token from `from` to `to`.
628      *
629      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) external;
645 
646     /**
647      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
648      * The approval is cleared when the token is transferred.
649      *
650      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
651      *
652      * Requirements:
653      *
654      * - The caller must own the token or be an approved operator.
655      * - `tokenId` must exist.
656      *
657      * Emits an {Approval} event.
658      */
659     function approve(address to, uint256 tokenId) external;
660 
661     /**
662      * @dev Returns the account approved for `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function getApproved(uint256 tokenId) external view returns (address operator);
669 
670     /**
671      * @dev Approve or remove `operator` as an operator for the caller.
672      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
673      *
674      * Requirements:
675      *
676      * - The `operator` cannot be the caller.
677      *
678      * Emits an {ApprovalForAll} event.
679      */
680     function setApprovalForAll(address operator, bool _approved) external;
681 
682     /**
683      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
684      *
685      * See {setApprovalForAll}
686      */
687     function isApprovedForAll(address owner, address operator) external view returns (bool);
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes calldata data
707     ) external;
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
720  * @dev See https://eips.ethereum.org/EIPS/eip-721
721  */
722 interface IERC721Metadata is IERC721 {
723     /**
724      * @dev Returns the token collection name.
725      */
726     function name() external view returns (string memory);
727 
728     /**
729      * @dev Returns the token collection symbol.
730      */
731     function symbol() external view returns (string memory);
732 
733     /**
734      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
735      */
736     function tokenURI(uint256 tokenId) external view returns (string memory);
737 }
738 
739 // File: contracts/ERC721A.sol
740 
741 
742 // Creator: Chiru Labs
743 
744 pragma solidity ^0.8.4;
745 
746 
747 
748 
749 
750 
751 
752 
753 error ApprovalCallerNotOwnerNorApproved();
754 error ApprovalQueryForNonexistentToken();
755 error ApproveToCaller();
756 error ApprovalToCurrentOwner();
757 error BalanceQueryForZeroAddress();
758 error MintToZeroAddress();
759 error MintZeroQuantity();
760 error OwnerQueryForNonexistentToken();
761 error TransferCallerNotOwnerNorApproved();
762 error TransferFromIncorrectOwner();
763 error TransferToNonERC721ReceiverImplementer();
764 error TransferToZeroAddress();
765 error URIQueryForNonexistentToken();
766 
767 /**
768  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
769  * the Metadata extension. Built to optimize for lower gas during batch mints.
770  *
771  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
772  *
773  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
774  *
775  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
776  */
777 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
778     using Address for address;
779     using Strings for uint256;
780 
781     // Compiler will pack this into a single 256bit word.
782     struct TokenOwnership {
783         // The address of the owner.
784         address addr;
785         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
786         uint64 startTimestamp;
787         // Whether the token has been burned.
788         bool burned;
789     }
790 
791     // Compiler will pack this into a single 256bit word.
792     struct AddressData {
793         // Realistically, 2**64-1 is more than enough.
794         uint64 balance;
795         // Keeps track of mint count with minimal overhead for tokenomics.
796         uint64 numberMinted;
797         // Keeps track of burn count with minimal overhead for tokenomics.
798         uint64 numberBurned;
799         // For miscellaneous variable(s) pertaining to the address
800         // (e.g. number of whitelist mint slots used).
801         // If there are multiple variables, please pack them into a uint64.
802         uint64 aux;
803     }
804 
805     // The tokenId of the next token to be minted.
806     uint256 internal _currentIndex;
807 
808     // The number of tokens burned.
809     uint256 internal _burnCounter;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to ownership details
818     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
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
833         _currentIndex = _startTokenId();
834     }
835 
836     /**
837      * To change the starting tokenId, please override this function.
838      */
839     function _startTokenId() internal view virtual returns (uint256) {
840         return 1;
841     }
842 
843     /**
844      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
845      */
846     function totalSupply() public view returns (uint256) {
847         // Counter underflow is impossible as _burnCounter cannot be incremented
848         // more than _currentIndex - _startTokenId() times
849         unchecked {
850             return _currentIndex - _burnCounter - _startTokenId();
851         }
852     }
853 
854     /**
855      * Returns the total amount of tokens minted in the contract.
856      */
857     function _totalMinted() internal view returns (uint256) {
858         // Counter underflow is impossible as _currentIndex does not decrement,
859         // and it is initialized to _startTokenId()
860         unchecked {
861             return _currentIndex - _startTokenId();
862         }
863     }
864 
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      * @dev See {IERC721-balanceOf}.
877      */
878     function balanceOf(address owner) public view override returns (uint256) {
879         if (owner == address(0)) revert BalanceQueryForZeroAddress();
880         return uint256(_addressData[owner].balance);
881     }
882 
883     /**
884      * Returns the number of tokens minted by `owner`.
885      */
886     function _numberMinted(address owner) internal view returns (uint256) {
887         return uint256(_addressData[owner].numberMinted);
888     }
889 
890     /**
891      * Returns the number of tokens burned by or on behalf of `owner`.
892      */
893     function _numberBurned(address owner) internal view returns (uint256) {
894         return uint256(_addressData[owner].numberBurned);
895     }
896 
897     /**
898      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      */
900     function _getAux(address owner) internal view returns (uint64) {
901         return _addressData[owner].aux;
902     }
903 
904     /**
905      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      * If there are multiple variables, please pack them into a uint64.
907      */
908     function _setAux(address owner, uint64 aux) internal {
909         _addressData[owner].aux = aux;
910     }
911 
912     /**
913      * Gas spent here starts off proportional to the maximum mint batch size.
914      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
915      */
916     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
917         uint256 curr = tokenId;
918 
919         unchecked {
920             if (_startTokenId() <= curr && curr < _currentIndex) {
921                 TokenOwnership memory ownership = _ownerships[curr];
922                 if (!ownership.burned) {
923                     if (ownership.addr != address(0)) {
924                         return ownership;
925                     }
926                     // Invariant:
927                     // There will always be an ownership that has an address and is not burned
928                     // before an ownership that does not have an address and is not burned.
929                     // Hence, curr will not underflow.
930                     while (true) {
931                         curr--;
932                         ownership = _ownerships[curr];
933                         if (ownership.addr != address(0)) {
934                             return ownership;
935                         }
936                     }
937                 }
938             }
939         }
940         revert OwnerQueryForNonexistentToken();
941     }
942 
943     /**
944      * @dev See {IERC721-ownerOf}.
945      */
946     function ownerOf(uint256 tokenId) public view override returns (address) {
947         return _ownershipOf(tokenId).addr;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return '';
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public override {
987         address owner = ERC721A.ownerOf(tokenId);
988         if (to == owner) revert ApprovalToCurrentOwner();
989 
990         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
991             revert ApprovalCallerNotOwnerNorApproved();
992         }
993 
994         _approve(to, tokenId, owner);
995     }
996 
997     /**
998      * @dev See {IERC721-getApproved}.
999      */
1000     function getApproved(uint256 tokenId) public view override returns (address) {
1001         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1002 
1003         return _tokenApprovals[tokenId];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-setApprovalForAll}.
1008      */
1009     function setApprovalForAll(address operator, bool approved) public virtual override {
1010         if (operator == _msgSender()) revert ApproveToCaller();
1011 
1012         _operatorApprovals[_msgSender()][operator] = approved;
1013         emit ApprovalForAll(_msgSender(), operator, approved);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-isApprovedForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1020         return _operatorApprovals[owner][operator];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-transferFrom}.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         _transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public virtual override {
1042         safeTransferFrom(from, to, tokenId, '');
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) public virtual override {
1054         _transfer(from, to, tokenId);
1055         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1056             revert TransferToNonERC721ReceiverImplementer();
1057         }
1058     }
1059 
1060     /**
1061      * @dev Returns whether `tokenId` exists.
1062      *
1063      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064      *
1065      * Tokens start existing when they are minted (`_mint`),
1066      */
1067     function _exists(uint256 tokenId) internal view returns (bool) {
1068         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1069     }
1070 
1071     /**
1072      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1073      */
1074     function _safeMint(address to, uint256 quantity) internal {
1075         _safeMint(to, quantity, '');
1076     }
1077 
1078     /**
1079      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - If `to` refers to a smart contract, it must implement 
1084      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _safeMint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data
1093     ) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are incredibly unrealistic.
1101         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1102         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1103         unchecked {
1104             _addressData[to].balance += uint64(quantity);
1105             _addressData[to].numberMinted += uint64(quantity);
1106 
1107             _ownerships[startTokenId].addr = to;
1108             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1109 
1110             uint256 updatedIndex = startTokenId;
1111             uint256 end = updatedIndex + quantity;
1112 
1113             if (to.isContract()) {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex);
1116                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1117                         revert TransferToNonERC721ReceiverImplementer();
1118                     }
1119                 } while (updatedIndex != end);
1120                 // Reentrancy protection
1121                 if (_currentIndex != startTokenId) revert();
1122             } else {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex++);
1125                 } while (updatedIndex != end);
1126             }
1127             _currentIndex = updatedIndex;
1128         }
1129         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1130     }
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _mint(address to, uint256 quantity) internal {
1143         uint256 startTokenId = _currentIndex;
1144         if (to == address(0)) revert MintToZeroAddress();
1145         if (quantity == 0) revert MintZeroQuantity();
1146 
1147         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1148 
1149         // Overflows are incredibly unrealistic.
1150         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1151         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1152         unchecked {
1153             _addressData[to].balance += uint64(quantity);
1154             _addressData[to].numberMinted += uint64(quantity);
1155 
1156             _ownerships[startTokenId].addr = to;
1157             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1158 
1159             uint256 updatedIndex = startTokenId;
1160             uint256 end = updatedIndex + quantity;
1161 
1162             do {
1163                 emit Transfer(address(0), to, updatedIndex++);
1164             } while (updatedIndex != end);
1165 
1166             _currentIndex = updatedIndex;
1167         }
1168         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _transfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) private {
1186         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1187 
1188         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1189 
1190         bool isApprovedOrOwner = (_msgSender() == from ||
1191             isApprovedForAll(from, _msgSender()) ||
1192             getApproved(tokenId) == _msgSender());
1193 
1194         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         if (to == address(0)) revert TransferToZeroAddress();
1196 
1197         _beforeTokenTransfers(from, to, tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, from);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             _addressData[from].balance -= 1;
1207             _addressData[to].balance += 1;
1208 
1209             TokenOwnership storage currSlot = _ownerships[tokenId];
1210             currSlot.addr = to;
1211             currSlot.startTimestamp = uint64(block.timestamp);
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1217             if (nextSlot.addr == address(0)) {
1218                 // This will suffice for checking _exists(nextTokenId),
1219                 // as a burned slot cannot contain the zero address.
1220                 if (nextTokenId != _currentIndex) {
1221                     nextSlot.addr = from;
1222                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(from, to, tokenId);
1228         _afterTokenTransfers(from, to, tokenId, 1);
1229     }
1230 
1231     /**
1232      * @dev Equivalent to `_burn(tokenId, false)`.
1233      */
1234     function _burn(uint256 tokenId) internal virtual {
1235         _burn(tokenId, false);
1236     }
1237 
1238     /**
1239      * @dev Destroys `tokenId`.
1240      * The approval is cleared when the token is burned.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1249         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1250 
1251         address from = prevOwnership.addr;
1252 
1253         if (approvalCheck) {
1254             bool isApprovedOrOwner = (_msgSender() == from ||
1255                 isApprovedForAll(from, _msgSender()) ||
1256                 getApproved(tokenId) == _msgSender());
1257 
1258             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1259         }
1260 
1261         _beforeTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Clear approvals from the previous owner
1264         _approve(address(0), tokenId, from);
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             AddressData storage addressData = _addressData[from];
1271             addressData.balance -= 1;
1272             addressData.numberBurned += 1;
1273 
1274             // Keep track of who burned the token, and the timestamp of burning.
1275             TokenOwnership storage currSlot = _ownerships[tokenId];
1276             currSlot.addr = from;
1277             currSlot.startTimestamp = uint64(block.timestamp);
1278             currSlot.burned = true;
1279 
1280             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1281             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1282             uint256 nextTokenId = tokenId + 1;
1283             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1284             if (nextSlot.addr == address(0)) {
1285                 // This will suffice for checking _exists(nextTokenId),
1286                 // as a burned slot cannot contain the zero address.
1287                 if (nextTokenId != _currentIndex) {
1288                     nextSlot.addr = from;
1289                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1290                 }
1291             }
1292         }
1293 
1294         emit Transfer(from, address(0), tokenId);
1295         _afterTokenTransfers(from, address(0), tokenId, 1);
1296 
1297         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1298         unchecked {
1299             _burnCounter++;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Approve `to` to operate on `tokenId`
1305      *
1306      * Emits a {Approval} event.
1307      */
1308     function _approve(
1309         address to,
1310         uint256 tokenId,
1311         address owner
1312     ) private {
1313         _tokenApprovals[tokenId] = to;
1314         emit Approval(owner, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1319      *
1320      * @param from address representing the previous owner of the given token ID
1321      * @param to target address that will receive the tokens
1322      * @param tokenId uint256 ID of the token to be transferred
1323      * @param _data bytes optional data to send along with the call
1324      * @return bool whether the call correctly returned the expected magic value
1325      */
1326     function _checkContractOnERC721Received(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) private returns (bool) {
1332         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1333             return retval == IERC721Receiver(to).onERC721Received.selector;
1334         } catch (bytes memory reason) {
1335             if (reason.length == 0) {
1336                 revert TransferToNonERC721ReceiverImplementer();
1337             } else {
1338                 assembly {
1339                     revert(add(32, reason), mload(reason))
1340                 }
1341             }
1342         }
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1347      * And also called before burning one token.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, `tokenId` will be burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1369      * minting.
1370      * And also called after one token has been burned.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` has been minted for `to`.
1380      * - When `to` is zero, `tokenId` has been burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _afterTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 }
1390 
1391 
1392 pragma solidity ^0.8.0;
1393 
1394 
1395 
1396 
1397 
1398 contract SKELETONCREW is ERC721A, Ownable, ReentrancyGuard {
1399   using Address for address;
1400   using Strings for uint;
1401 
1402 
1403   string  public  baseTokenURI = "ipfs://QmRFYwk8wBfnMYhZYaF6BWbx8oSmF4GxRpSPd7C2DUX6mM/";
1404   uint256  public  maxSupply = 2222;
1405   uint256 public  MAX_MINTS_PER_TX = 20;
1406   uint256 public  PUBLIC_SALE_PRICE = 0.001 ether;
1407   uint256 public  NUM_FREE_MINTS = 2222;
1408   uint256 public  MAX_FREE_PER_WALLET = 2;
1409   uint256 public freeNFTAlreadyMinted = 0;
1410   bool public isPublicSaleActive = false;
1411 
1412   constructor(
1413 
1414   ) ERC721A("SKELETON CREW", "SKE") {
1415 
1416   }
1417 
1418 
1419   function mint(uint256 numberOfTokens)
1420       external
1421       payable
1422   {
1423     require(isPublicSaleActive, "Public sale is not open");
1424     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1425 
1426     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1427         require(
1428             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1429             "Incorrect ETH value sent"
1430         );
1431     } else {
1432         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1433         require(
1434             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1435             "Incorrect ETH value sent"
1436         );
1437         require(
1438             numberOfTokens <= MAX_MINTS_PER_TX,
1439             "Max mints per transaction exceeded"
1440         );
1441         } else {
1442             require(
1443                 numberOfTokens <= MAX_FREE_PER_WALLET,
1444                 "Max mints per transaction exceeded"
1445             );
1446             freeNFTAlreadyMinted += numberOfTokens;
1447         }
1448     }
1449     _safeMint(msg.sender, numberOfTokens);
1450   }
1451 
1452   function setBaseURI(string memory baseURI)
1453     public
1454     onlyOwner
1455   {
1456     baseTokenURI = baseURI;
1457   }
1458 
1459   function treasuryMint(uint quantity)
1460     public
1461     onlyOwner
1462   {
1463     require(
1464       quantity > 0,
1465       "Invalid mint amount"
1466     );
1467     require(
1468       totalSupply() + quantity <= maxSupply,
1469       "Maximum supply exceeded"
1470     );
1471     _safeMint(msg.sender, quantity);
1472   }
1473 
1474   function withdraw()
1475     public
1476     onlyOwner
1477     nonReentrant
1478   {
1479     Address.sendValue(payable(msg.sender), address(this).balance);
1480   }
1481 
1482   function tokenURI(uint _tokenId)
1483     public
1484     view
1485     virtual
1486     override
1487     returns (string memory)
1488   {
1489     require(
1490       _exists(_tokenId),
1491       "ERC721Metadata: URI query for nonexistent token"
1492     );
1493     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1494   }
1495 
1496   function _baseURI()
1497     internal
1498     view
1499     virtual
1500     override
1501     returns (string memory)
1502   {
1503     return baseTokenURI;
1504   }
1505 
1506   function setIsPublicSaleActive(bool _isPublicSaleActive)
1507       external
1508       onlyOwner
1509   {
1510       isPublicSaleActive = _isPublicSaleActive;
1511   }
1512 
1513   function setNumFreeMints(uint256 _numfreemints)
1514       external
1515       onlyOwner
1516   {
1517       NUM_FREE_MINTS = _numfreemints;
1518   }
1519 
1520   function setSalePrice(uint256 _price)
1521       external
1522       onlyOwner
1523   {
1524       PUBLIC_SALE_PRICE = _price;
1525   }
1526 
1527   function setMaxLimitPerTransaction(uint256 _limit)
1528       external
1529       onlyOwner
1530   {
1531       MAX_MINTS_PER_TX = _limit;
1532   }
1533 
1534   function setFreeLimitPerWallet(uint256 _limit)
1535       external
1536       onlyOwner
1537   {
1538       MAX_FREE_PER_WALLET = _limit;
1539   }
1540 }