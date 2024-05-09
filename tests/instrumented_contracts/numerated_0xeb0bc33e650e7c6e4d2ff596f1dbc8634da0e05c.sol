1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-15
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Contract module that helps prevent reentrant calls to a function.
20  *
21  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
22  * available, which can be applied to functions to make sure there are no nested
23  * (reentrant) calls to them.
24  *
25  * Note that because there is a single `nonReentrant` guard, functions marked as
26  * `nonReentrant` may not call one another. This can be worked around by making
27  * those functions `private`, and then adding `external` `nonReentrant` entry
28  * points to them.
29  *
30  * TIP: If you would like to learn more about reentrancy and alternative ways
31  * to protect against it, check out our blog post
32  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
33  */
34 abstract contract ReentrancyGuard {
35     // Booleans are more expensive than uint256 or any type that takes up a full
36     // word because each write operation emits an extra SLOAD to first read the
37     // slot's contents, replace the bits taken up by the boolean, and then write
38     // back. This is the compiler's defense against contract upgrades and
39     // pointer aliasing, and it cannot be disabled.
40 
41     // The values being non-zero value makes deployment a bit more expensive,
42     // but in exchange the refund on every call to nonReentrant will be lower in
43     // amount. Since refunds are capped to a percentage of the total
44     // transaction's gas, it is best to keep them low in cases like this one, to
45     // increase the likelihood of the full refund coming into effect.
46     uint256 private constant _NOT_ENTERED = 1;
47     uint256 private constant _ENTERED = 2;
48 
49     uint256 private _status;
50 
51     constructor() {
52         _status = _NOT_ENTERED;
53     }
54 
55     /**
56      * @dev Prevents a contract from calling itself, directly or indirectly.
57      * Calling a `nonReentrant` function from another `nonReentrant`
58      * function is not supported. It is possible to prevent this from happening
59      * by making the `nonReentrant` function external, and making it call a
60      * `private` function that does the actual work.
61      */
62     modifier nonReentrant() {
63         // On the first call to nonReentrant, _notEntered will be true
64         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
65 
66         // Any calls to nonReentrant after this point will fail
67         _status = _ENTERED;
68 
69         _;
70 
71         // By storing the original value once again, a refund is triggered (see
72         // https://eips.ethereum.org/EIPS/eip-2200)
73         _status = _NOT_ENTERED;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Strings.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         _transferOwnership(address(0));
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Can only be called by the current owner.
235      */
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(newOwner != address(0), "Ownable: new owner is the zero address");
238         _transferOwnership(newOwner);
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Internal function without access restriction.
244      */
245     function _transferOwnership(address newOwner) internal virtual {
246         address oldOwner = _owner;
247         _owner = newOwner;
248         emit OwnershipTransferred(oldOwner, newOwner);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/Address.sol
253 
254 
255 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
256 
257 pragma solidity ^0.8.1;
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      *
280      * [IMPORTANT]
281      * ====
282      * You shouldn't rely on `isContract` to protect against flash loan attacks!
283      *
284      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
285      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
286      * constructor.
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // This method relies on extcodesize/address.code.length, which returns 0
291         // for contracts in construction, since the code is only stored at the end
292         // of the constructor execution.
293 
294         return account.code.length > 0;
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         (bool success, ) = recipient.call{value: amount}("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain `call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value
371     ) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         require(isContract(target), "Address: call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.call{value: value}(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
401         return functionStaticCall(target, data, "Address: low-level static call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal view returns (bytes memory) {
415         require(isContract(target), "Address: static call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.staticcall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(isContract(target), "Address: delegate call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.delegatecall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
450      * revert reason using the provided one.
451      *
452      * _Available since v4.3._
453      */
454     function verifyCallResult(
455         bool success,
456         bytes memory returndata,
457         string memory errorMessage
458     ) internal pure returns (bytes memory) {
459         if (success) {
460             return returndata;
461         } else {
462             // Look for revert reason and bubble it up if present
463             if (returndata.length > 0) {
464                 // The easiest way to bubble the revert reason is using memory via assembly
465 
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @title ERC721 token receiver interface
486  * @dev Interface for any contract that wants to support safeTransfers
487  * from ERC721 asset contracts.
488  */
489 interface IERC721Receiver {
490     /**
491      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
492      * by `operator` from `from`, this function is called.
493      *
494      * It must return its Solidity selector to confirm the token transfer.
495      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
496      *
497      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
498      */
499     function onERC721Received(
500         address operator,
501         address from,
502         uint256 tokenId,
503         bytes calldata data
504     ) external returns (bytes4);
505 }
506 
507 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Interface of the ERC165 standard, as defined in the
516  * https://eips.ethereum.org/EIPS/eip-165[EIP].
517  *
518  * Implementers can declare support of contract interfaces, which can then be
519  * queried by others ({ERC165Checker}).
520  *
521  * For an implementation, see {ERC165}.
522  */
523 interface IERC165 {
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30 000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 }
534 
535 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @dev Required interface of an ERC721 compliant contract.
576  */
577 interface IERC721 is IERC165 {
578     /**
579      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
580      */
581     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
585      */
586     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
590      */
591     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
592 
593     /**
594      * @dev Returns the number of tokens in ``owner``'s account.
595      */
596     function balanceOf(address owner) external view returns (uint256 balance);
597 
598     /**
599      * @dev Returns the owner of the `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function ownerOf(uint256 tokenId) external view returns (address owner);
606 
607     /**
608      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
609      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must exist and be owned by `from`.
616      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
618      *
619      * Emits a {Transfer} event.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) external;
626 
627     /**
628      * @dev Transfers `tokenId` token from `from` to `to`.
629      *
630      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) external;
646 
647     /**
648      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
649      * The approval is cleared when the token is transferred.
650      *
651      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
652      *
653      * Requirements:
654      *
655      * - The caller must own the token or be an approved operator.
656      * - `tokenId` must exist.
657      *
658      * Emits an {Approval} event.
659      */
660     function approve(address to, uint256 tokenId) external;
661 
662     /**
663      * @dev Returns the account approved for `tokenId` token.
664      *
665      * Requirements:
666      *
667      * - `tokenId` must exist.
668      */
669     function getApproved(uint256 tokenId) external view returns (address operator);
670 
671     /**
672      * @dev Approve or remove `operator` as an operator for the caller.
673      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
674      *
675      * Requirements:
676      *
677      * - The `operator` cannot be the caller.
678      *
679      * Emits an {ApprovalForAll} event.
680      */
681     function setApprovalForAll(address operator, bool _approved) external;
682 
683     /**
684      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
685      *
686      * See {setApprovalForAll}
687      */
688     function isApprovedForAll(address owner, address operator) external view returns (bool);
689 
690     /**
691      * @dev Safely transfers `tokenId` token from `from` to `to`.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must exist and be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external;
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
721  * @dev See https://eips.ethereum.org/EIPS/eip-721
722  */
723 interface IERC721Metadata is IERC721 {
724     /**
725      * @dev Returns the token collection name.
726      */
727     function name() external view returns (string memory);
728 
729     /**
730      * @dev Returns the token collection symbol.
731      */
732     function symbol() external view returns (string memory);
733 
734     /**
735      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
736      */
737     function tokenURI(uint256 tokenId) external view returns (string memory);
738 }
739 
740 // File: erc721a/contracts/ERC721A.sol
741 
742 
743 // Creator: Chiru Labs
744 
745 pragma solidity ^0.8.4;
746 
747 
748 
749 
750 
751 
752 
753 
754 error ApprovalCallerNotOwnerNorApproved();
755 error ApprovalQueryForNonexistentToken();
756 error ApproveToCaller();
757 error ApprovalToCurrentOwner();
758 error BalanceQueryForZeroAddress();
759 error MintToZeroAddress();
760 error MintZeroQuantity();
761 error OwnerQueryForNonexistentToken();
762 error TransferCallerNotOwnerNorApproved();
763 error TransferFromIncorrectOwner();
764 error TransferToNonERC721ReceiverImplementer();
765 error TransferToZeroAddress();
766 error URIQueryForNonexistentToken();
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata extension. Built to optimize for lower gas during batch mints.
771  *
772  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
773  *
774  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
775  *
776  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
777  */
778 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
779     using Address for address;
780     using Strings for uint256;
781 
782     // Compiler will pack this into a single 256bit word.
783     struct TokenOwnership {
784         // The address of the owner.
785         address addr;
786         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
787         uint64 startTimestamp;
788         // Whether the token has been burned.
789         bool burned;
790     }
791 
792     // Compiler will pack this into a single 256bit word.
793     struct AddressData {
794         // Realistically, 2**64-1 is more than enough.
795         uint64 balance;
796         // Keeps track of mint count with minimal overhead for tokenomics.
797         uint64 numberMinted;
798         // Keeps track of burn count with minimal overhead for tokenomics.
799         uint64 numberBurned;
800         // For miscellaneous variable(s) pertaining to the address
801         // (e.g. number of whitelist mint slots used).
802         // If there are multiple variables, please pack them into a uint64.
803         uint64 aux;
804     }
805 
806     // The tokenId of the next token to be minted.
807     uint256 internal _currentIndex;
808 
809     // The number of tokens burned.
810     uint256 internal _burnCounter;
811 
812     // Token name
813     string private _name;
814 
815     // Token symbol
816     string private _symbol;
817 
818     // Mapping from token ID to ownership details
819     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
820     mapping(uint256 => TokenOwnership) internal _ownerships;
821 
822     // Mapping owner address to address data
823     mapping(address => AddressData) private _addressData;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834         _currentIndex = _startTokenId();
835     }
836 
837     /**
838      * To change the starting tokenId, please override this function.
839      */
840     function _startTokenId() internal view virtual returns (uint256) {
841         return 0;
842     }
843 
844     /**
845      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
846      */
847     function totalSupply() public view returns (uint256) {
848         // Counter underflow is impossible as _burnCounter cannot be incremented
849         // more than _currentIndex - _startTokenId() times
850         unchecked {
851             return _currentIndex - _burnCounter - _startTokenId();
852         }
853     }
854 
855     /**
856      * Returns the total amount of tokens minted in the contract.
857      */
858     function _totalMinted() internal view returns (uint256) {
859         // Counter underflow is impossible as _currentIndex does not decrement,
860         // and it is initialized to _startTokenId()
861         unchecked {
862             return _currentIndex - _startTokenId();
863         }
864     }
865 
866     /**
867      * @dev See {IERC165-supportsInterface}.
868      */
869     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
870         return
871             interfaceId == type(IERC721).interfaceId ||
872             interfaceId == type(IERC721Metadata).interfaceId ||
873             super.supportsInterface(interfaceId);
874     }
875 
876     /**
877      * @dev See {IERC721-balanceOf}.
878      */
879     function balanceOf(address owner) public view override returns (uint256) {
880         if (owner == address(0)) revert BalanceQueryForZeroAddress();
881         return uint256(_addressData[owner].balance);
882     }
883 
884     /**
885      * Returns the number of tokens minted by `owner`.
886      */
887     function _numberMinted(address owner) internal view returns (uint256) {
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Returns the number of tokens burned by or on behalf of `owner`.
893      */
894     function _numberBurned(address owner) internal view returns (uint256) {
895         return uint256(_addressData[owner].numberBurned);
896     }
897 
898     /**
899      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      */
901     function _getAux(address owner) internal view returns (uint64) {
902         return _addressData[owner].aux;
903     }
904 
905     /**
906      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      * If there are multiple variables, please pack them into a uint64.
908      */
909     function _setAux(address owner, uint64 aux) internal {
910         _addressData[owner].aux = aux;
911     }
912 
913     /**
914      * Gas spent here starts off proportional to the maximum mint batch size.
915      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
916      */
917     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
918         uint256 curr = tokenId;
919 
920         unchecked {
921             if (_startTokenId() <= curr && curr < _currentIndex) {
922                 TokenOwnership memory ownership = _ownerships[curr];
923                 if (!ownership.burned) {
924                     if (ownership.addr != address(0)) {
925                         return ownership;
926                     }
927                     // Invariant:
928                     // There will always be an ownership that has an address and is not burned
929                     // before an ownership that does not have an address and is not burned.
930                     // Hence, curr will not underflow.
931                     while (true) {
932                         curr--;
933                         ownership = _ownerships[curr];
934                         if (ownership.addr != address(0)) {
935                             return ownership;
936                         }
937                     }
938                 }
939             }
940         }
941         revert OwnerQueryForNonexistentToken();
942     }
943 
944     /**
945      * @dev See {IERC721-ownerOf}.
946      */
947     function ownerOf(uint256 tokenId) public view override returns (address) {
948         return _ownershipOf(tokenId).addr;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-name}.
953      */
954     function name() public view virtual override returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-symbol}.
960      */
961     function symbol() public view virtual override returns (string memory) {
962         return _symbol;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-tokenURI}.
967      */
968     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
969         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
970 
971         string memory baseURI = _baseURI();
972         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
973     }
974 
975     /**
976      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978      * by default, can be overriden in child contracts.
979      */
980     function _baseURI() internal view virtual returns (string memory) {
981         return '';
982     }
983 
984     /**
985      * @dev See {IERC721-approve}.
986      */
987     function approve(address to, uint256 tokenId) public override {
988         address owner = ERC721A.ownerOf(tokenId);
989         if (to == owner) revert ApprovalToCurrentOwner();
990 
991         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
992             revert ApprovalCallerNotOwnerNorApproved();
993         }
994 
995         _approve(to, tokenId, owner);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId) public view override returns (address) {
1002         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1003 
1004         return _tokenApprovals[tokenId];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-setApprovalForAll}.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public virtual override {
1011         if (operator == _msgSender()) revert ApproveToCaller();
1012 
1013         _operatorApprovals[_msgSender()][operator] = approved;
1014         emit ApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         safeTransferFrom(from, to, tokenId, '');
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public virtual override {
1055         _transfer(from, to, tokenId);
1056         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1057             revert TransferToNonERC721ReceiverImplementer();
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      */
1068     function _exists(uint256 tokenId) internal view returns (bool) {
1069         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1070     }
1071 
1072     function _safeMint(address to, uint256 quantity) internal {
1073         _safeMint(to, quantity, '');
1074     }
1075 
1076     /**
1077      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1082      * - `quantity` must be greater than 0.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeMint(
1087         address to,
1088         uint256 quantity,
1089         bytes memory _data
1090     ) internal {
1091         _mint(to, quantity, _data, true);
1092     }
1093 
1094     /**
1095      * @dev Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _mint(
1105         address to,
1106         uint256 quantity,
1107         bytes memory _data,
1108         bool safe
1109     ) internal {
1110         uint256 startTokenId = _currentIndex;
1111         if (to == address(0)) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113 
1114         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116         // Overflows are incredibly unrealistic.
1117         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1118         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1119         unchecked {
1120             _addressData[to].balance += uint64(quantity);
1121             _addressData[to].numberMinted += uint64(quantity);
1122 
1123             _ownerships[startTokenId].addr = to;
1124             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1125 
1126             uint256 updatedIndex = startTokenId;
1127             uint256 end = updatedIndex + quantity;
1128 
1129             if (safe && to.isContract()) {
1130                 do {
1131                     emit Transfer(address(0), to, updatedIndex);
1132                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1133                         revert TransferToNonERC721ReceiverImplementer();
1134                     }
1135                 } while (updatedIndex != end);
1136                 // Reentrancy protection
1137                 if (_currentIndex != startTokenId) revert();
1138             } else {
1139                 do {
1140                     emit Transfer(address(0), to, updatedIndex++);
1141                 } while (updatedIndex != end);
1142             }
1143             _currentIndex = updatedIndex;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) private {
1163         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1164 
1165         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1166 
1167         bool isApprovedOrOwner = (_msgSender() == from ||
1168             isApprovedForAll(from, _msgSender()) ||
1169             getApproved(tokenId) == _msgSender());
1170 
1171         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1172         if (to == address(0)) revert TransferToZeroAddress();
1173 
1174         _beforeTokenTransfers(from, to, tokenId, 1);
1175 
1176         // Clear approvals from the previous owner
1177         _approve(address(0), tokenId, from);
1178 
1179         // Underflow of the sender's balance is impossible because we check for
1180         // ownership above and the recipient's balance can't realistically overflow.
1181         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1182         unchecked {
1183             _addressData[from].balance -= 1;
1184             _addressData[to].balance += 1;
1185 
1186             TokenOwnership storage currSlot = _ownerships[tokenId];
1187             currSlot.addr = to;
1188             currSlot.startTimestamp = uint64(block.timestamp);
1189 
1190             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1191             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1192             uint256 nextTokenId = tokenId + 1;
1193             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1194             if (nextSlot.addr == address(0)) {
1195                 // This will suffice for checking _exists(nextTokenId),
1196                 // as a burned slot cannot contain the zero address.
1197                 if (nextTokenId != _currentIndex) {
1198                     nextSlot.addr = from;
1199                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      * @dev This is equivalent to _burn(tokenId, false)
1210      */
1211     function _burn(uint256 tokenId) internal virtual {
1212         _burn(tokenId, false);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1226         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1227 
1228         address from = prevOwnership.addr;
1229 
1230         if (approvalCheck) {
1231             bool isApprovedOrOwner = (_msgSender() == from ||
1232                 isApprovedForAll(from, _msgSender()) ||
1233                 getApproved(tokenId) == _msgSender());
1234 
1235             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1236         }
1237 
1238         _beforeTokenTransfers(from, address(0), tokenId, 1);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId, from);
1242 
1243         // Underflow of the sender's balance is impossible because we check for
1244         // ownership above and the recipient's balance can't realistically overflow.
1245         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1246         unchecked {
1247             AddressData storage addressData = _addressData[from];
1248             addressData.balance -= 1;
1249             addressData.numberBurned += 1;
1250 
1251             // Keep track of who burned the token, and the timestamp of burning.
1252             TokenOwnership storage currSlot = _ownerships[tokenId];
1253             currSlot.addr = from;
1254             currSlot.startTimestamp = uint64(block.timestamp);
1255             currSlot.burned = true;
1256 
1257             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1258             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1259             uint256 nextTokenId = tokenId + 1;
1260             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1261             if (nextSlot.addr == address(0)) {
1262                 // This will suffice for checking _exists(nextTokenId),
1263                 // as a burned slot cannot contain the zero address.
1264                 if (nextTokenId != _currentIndex) {
1265                     nextSlot.addr = from;
1266                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1267                 }
1268             }
1269         }
1270 
1271         emit Transfer(from, address(0), tokenId);
1272         _afterTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1275         unchecked {
1276             _burnCounter++;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(
1286         address to,
1287         uint256 tokenId,
1288         address owner
1289     ) private {
1290         _tokenApprovals[tokenId] = to;
1291         emit Approval(owner, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1296      *
1297      * @param from address representing the previous owner of the given token ID
1298      * @param to target address that will receive the tokens
1299      * @param tokenId uint256 ID of the token to be transferred
1300      * @param _data bytes optional data to send along with the call
1301      * @return bool whether the call correctly returned the expected magic value
1302      */
1303     function _checkContractOnERC721Received(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) private returns (bool) {
1309         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1310             return retval == IERC721Receiver(to).onERC721Received.selector;
1311         } catch (bytes memory reason) {
1312             if (reason.length == 0) {
1313                 revert TransferToNonERC721ReceiverImplementer();
1314             } else {
1315                 assembly {
1316                     revert(add(32, reason), mload(reason))
1317                 }
1318             }
1319         }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324      * And also called before burning one token.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, `tokenId` will be burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      * And also called after one token has been burned.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` has been minted for `to`.
1357      * - When `to` is zero, `tokenId` has been burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _afterTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 }
1367 
1368 // File: contracts/RareZupepe.sol
1369 
1370 
1371  
1372 pragma solidity >=0.8.0 <0.9.0;
1373 
1374 
1375 
1376 
1377  
1378 contract TinyApeYachtClub is ERC721A, Ownable, ReentrancyGuard {
1379   using Strings for uint256;
1380  
1381 string public uriPrefix = '';
1382   string public uriSuffix = '.json';
1383   string public hiddenMetadataUri;
1384   
1385   uint256 public cost = 0.005 ether;
1386   uint256 public maxSupply = 5555;
1387   uint256 public freeSupply = 1000;
1388   uint256 public maxMintAmountPerTx = 20;
1389   uint256 public maxMintPerWallet = 60;
1390   uint256 public maxFreePerWallet = 1;
1391 
1392  
1393  mapping(address => uint256) public _mintedFreeAmount; 
1394 
1395   bool public paused = true;
1396   bool public whitelistMintEnabled = false;
1397   bool public revealed = false;
1398 
1399   constructor(
1400     string memory _tokenName,
1401     string memory _tokenSymbol,
1402     string memory _hiddenMetadataUri
1403   ) ERC721A(_tokenName, _tokenSymbol) {
1404     setHiddenMetadataUri(_hiddenMetadataUri);
1405   }
1406 
1407 
1408 function mint(uint256 _mintAmount) external payable {
1409     uint256 price = cost;
1410         bool isFree = ((totalSupply()  < freeSupply + 1 ) &&
1411             (_mintedFreeAmount[msg.sender] + _mintAmount <= maxFreePerWallet));
1412 
1413         if (isFree) {
1414             price = 0;
1415             
1416         }
1417 
1418         require(msg.value >= _mintAmount * price, "Please send the exact amount.");
1419         require(totalSupply() + _mintAmount < maxSupply + 1 , "No more");
1420         require(!paused, "Minting is not live yet");
1421         require(_mintAmount < maxMintAmountPerTx + 1, "Max per TX reached.");
1422         require(numberMinted(msg.sender) + _mintAmount <= maxMintPerWallet, 'PER_WALLET_LIMIT_REACHED');
1423 
1424         if (isFree) {
1425             _mintedFreeAmount[msg.sender] += _mintAmount;
1426         }
1427 
1428         _safeMint(msg.sender, _mintAmount);
1429     }
1430 
1431   function numberMinted(address owner) public view returns (uint256) {
1432         return _numberMinted(owner);
1433   }
1434 
1435 
1436   
1437   function AdminMint(uint256 _mintAmount) public payable onlyOwner {
1438         _safeMint(msg.sender, _mintAmount);
1439     }
1440 
1441   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1442     uint256 ownerTokenCount = balanceOf(_owner);
1443     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1444     uint256 currentTokenId = _startTokenId();
1445     uint256 ownedTokenIndex = 0;
1446     address latestOwnerAddress;
1447 
1448     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1449       TokenOwnership memory ownership = _ownerships[currentTokenId];
1450 
1451       if (!ownership.burned) {
1452         if (ownership.addr != address(0)) {
1453           latestOwnerAddress = ownership.addr;
1454         }
1455 
1456         if (latestOwnerAddress == _owner) {
1457           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1458 
1459           ownedTokenIndex++;
1460         }
1461       }
1462 
1463       currentTokenId++;
1464     }
1465 
1466     return ownedTokenIds;
1467   }
1468 
1469   function _startTokenId() internal view virtual override returns (uint256) {
1470     return 1;
1471   }
1472 
1473   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1474     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1475 
1476     if (revealed == false) {
1477       return hiddenMetadataUri;
1478     }
1479 
1480     string memory currentBaseURI = _baseURI();
1481     return bytes(currentBaseURI).length > 0
1482         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1483         : '';
1484   }
1485 
1486   function setRevealed(bool _state) public onlyOwner {
1487     revealed = _state;
1488   }
1489 
1490   function setCost(uint256 _cost) public onlyOwner {
1491     cost = _cost;
1492   }
1493 
1494   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1495     maxMintAmountPerTx = _maxMintAmountPerTx;
1496   }
1497 
1498   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1499     hiddenMetadataUri = _hiddenMetadataUri;
1500   }
1501 
1502   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1503     uriPrefix = _uriPrefix;
1504   }
1505 
1506   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1507     uriSuffix = _uriSuffix;
1508   }
1509 
1510   function setPaused(bool _state) public onlyOwner {
1511     paused = _state;
1512   }
1513 
1514 
1515 
1516   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1517     whitelistMintEnabled = _state;
1518   }
1519 
1520   function withdraw() public onlyOwner nonReentrant {
1521     // This will transfer the remaining contract balance to the owner.
1522     // Do not remove this otherwise you will not be able to withdraw the funds.
1523 
1524    
1525 
1526     //=========================================================================
1527     (bool qs, ) = payable(0x6C8B1B3fD0BC116da0C6E609bd6Db63928be6F00).call{value: address(this).balance * 33 / 100}('');
1528     require(qs);
1529     // =============================================================================
1530     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1531     require(os);
1532     // =============================================================================
1533   }
1534 
1535   function _baseURI() internal view virtual override returns (string memory) {
1536     return uriPrefix;
1537   }
1538 }