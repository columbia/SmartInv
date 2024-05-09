1 // SPDX-License-Identifier: MIT
2 
3 // Sources flattened with hardhat v2.9.3 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
114 
115 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Contract module that helps prevent reentrant calls to a function.
121  *
122  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
123  * available, which can be applied to functions to make sure there are no nested
124  * (reentrant) calls to them.
125  *
126  * Note that because there is a single `nonReentrant` guard, functions marked as
127  * `nonReentrant` may not call one another. This can be worked around by making
128  * those functions `private`, and then adding `external` `nonReentrant` entry
129  * points to them.
130  *
131  * TIP: If you would like to learn more about reentrancy and alternative ways
132  * to protect against it, check out our blog post
133  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
134  */
135 abstract contract ReentrancyGuard {
136     // Booleans are more expensive than uint256 or any type that takes up a full
137     // word because each write operation emits an extra SLOAD to first read the
138     // slot's contents, replace the bits taken up by the boolean, and then write
139     // back. This is the compiler's defense against contract upgrades and
140     // pointer aliasing, and it cannot be disabled.
141 
142     // The values being non-zero value makes deployment a bit more expensive,
143     // but in exchange the refund on every call to nonReentrant will be lower in
144     // amount. Since refunds are capped to a percentage of the total
145     // transaction's gas, it is best to keep them low in cases like this one, to
146     // increase the likelihood of the full refund coming into effect.
147     uint256 private constant _NOT_ENTERED = 1;
148     uint256 private constant _ENTERED = 2;
149 
150     uint256 private _status;
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         // On the first call to nonReentrant, _notEntered will be true
165         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
166 
167         // Any calls to nonReentrant after this point will fail
168         _status = _ENTERED;
169 
170         _;
171 
172         // By storing the original value once again, a refund is triggered (see
173         // https://eips.ethereum.org/EIPS/eip-2200)
174         _status = _NOT_ENTERED;
175     }
176 }
177 
178 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Interface of the ERC165 standard, as defined in the
186  * https://eips.ethereum.org/EIPS/eip-165[EIP].
187  *
188  * Implementers can declare support of contract interfaces, which can then be
189  * queried by others ({ERC165Checker}).
190  *
191  * For an implementation, see {ERC165}.
192  */
193 interface IERC165 {
194     /**
195      * @dev Returns true if this contract implements the interface defined by
196      * `interfaceId`. See the corresponding
197      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
198      * to learn more about how these ids are created.
199      *
200      * This function call must use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) external view returns (bool);
203 }
204 
205 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
206 
207 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Required interface of an ERC721 compliant contract.
213  */
214 interface IERC721 is IERC165 {
215     /**
216      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
217      */
218     event Transfer(
219         address indexed from,
220         address indexed to,
221         uint256 indexed tokenId
222     );
223 
224     /**
225      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
226      */
227     event Approval(
228         address indexed owner,
229         address indexed approved,
230         uint256 indexed tokenId
231     );
232 
233     /**
234      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
235      */
236     event ApprovalForAll(
237         address indexed owner,
238         address indexed operator,
239         bool approved
240     );
241 
242     /**
243      * @dev Returns the number of tokens in ``owner``'s account.
244      */
245     function balanceOf(address owner) external view returns (uint256 balance);
246 
247     /**
248      * @dev Returns the owner of the `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function ownerOf(uint256 tokenId) external view returns (address owner);
255 
256     /**
257      * @dev Safely transfers `tokenId` token from `from` to `to`.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must exist and be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
266      *
267      * Emits a {Transfer} event.
268      */
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId,
273         bytes calldata data
274     ) external;
275 
276     /**
277      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
278      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
279      *
280      * Requirements:
281      *
282      * - `from` cannot be the zero address.
283      * - `to` cannot be the zero address.
284      * - `tokenId` token must exist and be owned by `from`.
285      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287      *
288      * Emits a {Transfer} event.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId
294     ) external;
295 
296     /**
297      * @dev Transfers `tokenId` token from `from` to `to`.
298      *
299      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must be owned by `from`.
306      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transferFrom(
311         address from,
312         address to,
313         uint256 tokenId
314     ) external;
315 
316     /**
317      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
318      * The approval is cleared when the token is transferred.
319      *
320      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
321      *
322      * Requirements:
323      *
324      * - The caller must own the token or be an approved operator.
325      * - `tokenId` must exist.
326      *
327      * Emits an {Approval} event.
328      */
329     function approve(address to, uint256 tokenId) external;
330 
331     /**
332      * @dev Approve or remove `operator` as an operator for the caller.
333      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
334      *
335      * Requirements:
336      *
337      * - The `operator` cannot be the caller.
338      *
339      * Emits an {ApprovalForAll} event.
340      */
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     /**
344      * @dev Returns the account approved for `tokenId` token.
345      *
346      * Requirements:
347      *
348      * - `tokenId` must exist.
349      */
350     function getApproved(uint256 tokenId)
351         external
352         view
353         returns (address operator);
354 
355     /**
356      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
357      *
358      * See {setApprovalForAll}
359      */
360     function isApprovedForAll(address owner, address operator)
361         external
362         view
363         returns (bool);
364 }
365 
366 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
367 
368 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
396 
397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
403  * @dev See https://eips.ethereum.org/EIPS/eip-721
404  */
405 interface IERC721Metadata is IERC721 {
406     /**
407      * @dev Returns the token collection name.
408      */
409     function name() external view returns (string memory);
410 
411     /**
412      * @dev Returns the token collection symbol.
413      */
414     function symbol() external view returns (string memory);
415 
416     /**
417      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
418      */
419     function tokenURI(uint256 tokenId) external view returns (string memory);
420 }
421 
422 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
423 
424 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
425 
426 pragma solidity ^0.8.1;
427 
428 /**
429  * @dev Collection of functions related to the address type
430  */
431 library Address {
432     /**
433      * @dev Returns true if `account` is a contract.
434      *
435      * [IMPORTANT]
436      * ====
437      * It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      *
440      * Among others, `isContract` will return false for the following
441      * types of addresses:
442      *
443      *  - an externally-owned account
444      *  - a contract in construction
445      *  - an address where a contract will be created
446      *  - an address where a contract lived, but was destroyed
447      * ====
448      *
449      * [IMPORTANT]
450      * ====
451      * You shouldn't rely on `isContract` to protect against flash loan attacks!
452      *
453      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
454      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
455      * constructor.
456      * ====
457      */
458     function isContract(address account) internal view returns (bool) {
459         // This method relies on extcodesize/address.code.length, which returns 0
460         // for contracts in construction, since the code is only stored at the end
461         // of the constructor execution.
462 
463         return account.code.length > 0;
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(
484             address(this).balance >= amount,
485             "Address: insufficient balance"
486         );
487 
488         (bool success, ) = recipient.call{value: amount}("");
489         require(
490             success,
491             "Address: unable to send value, recipient may have reverted"
492         );
493     }
494 
495     /**
496      * @dev Performs a Solidity function call using a low level `call`. A
497      * plain `call` is an unsafe replacement for a function call: use this
498      * function instead.
499      *
500      * If `target` reverts with a revert reason, it is bubbled up by this
501      * function (like regular Solidity function calls).
502      *
503      * Returns the raw returned data. To convert to the expected return value,
504      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
505      *
506      * Requirements:
507      *
508      * - `target` must be a contract.
509      * - calling `target` with `data` must not revert.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(address target, bytes memory data)
514         internal
515         returns (bytes memory)
516     {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return
551             functionCallWithValue(
552                 target,
553                 data,
554                 value,
555                 "Address: low-level call with value failed"
556             );
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
561      * with `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(
572             address(this).balance >= value,
573             "Address: insufficient balance for call"
574         );
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(
578             data
579         );
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data)
590         internal
591         view
592         returns (bytes memory)
593     {
594         return
595             functionStaticCall(
596                 target,
597                 data,
598                 "Address: low-level static call failed"
599             );
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data)
626         internal
627         returns (bytes memory)
628     {
629         return
630             functionDelegateCall(
631                 target,
632                 data,
633                 "Address: low-level delegate call failed"
634             );
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a delegate call.
640      *
641      * _Available since v3.4._
642      */
643     function functionDelegateCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(isContract(target), "Address: delegate call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.delegatecall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
656      * revert reason using the provided one.
657      *
658      * _Available since v4.3._
659      */
660     function verifyCallResult(
661         bool success,
662         bytes memory returndata,
663         string memory errorMessage
664     ) internal pure returns (bytes memory) {
665         if (success) {
666             return returndata;
667         } else {
668             // Look for revert reason and bubble it up if present
669             if (returndata.length > 0) {
670                 // The easiest way to bubble the revert reason is using memory via assembly
671 
672                 assembly {
673                     let returndata_size := mload(returndata)
674                     revert(add(32, returndata), returndata_size)
675                 }
676             } else {
677                 revert(errorMessage);
678             }
679         }
680     }
681 }
682 
683 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev String operations.
691  */
692 library Strings {
693     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
694 
695     /**
696      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
697      */
698     function toString(uint256 value) internal pure returns (string memory) {
699         // Inspired by OraclizeAPI's implementation - MIT licence
700         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
701 
702         if (value == 0) {
703             return "0";
704         }
705         uint256 temp = value;
706         uint256 digits;
707         while (temp != 0) {
708             digits++;
709             temp /= 10;
710         }
711         bytes memory buffer = new bytes(digits);
712         while (value != 0) {
713             digits -= 1;
714             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
715             value /= 10;
716         }
717         return string(buffer);
718     }
719 
720     /**
721      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
722      */
723     function toHexString(uint256 value) internal pure returns (string memory) {
724         if (value == 0) {
725             return "0x00";
726         }
727         uint256 temp = value;
728         uint256 length = 0;
729         while (temp != 0) {
730             length++;
731             temp >>= 8;
732         }
733         return toHexString(value, length);
734     }
735 
736     /**
737      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
738      */
739     function toHexString(uint256 value, uint256 length)
740         internal
741         pure
742         returns (string memory)
743     {
744         bytes memory buffer = new bytes(2 * length + 2);
745         buffer[0] = "0";
746         buffer[1] = "x";
747         for (uint256 i = 2 * length + 1; i > 1; --i) {
748             buffer[i] = _HEX_SYMBOLS[value & 0xf];
749             value >>= 4;
750         }
751         require(value == 0, "Strings: hex length insufficient");
752         return string(buffer);
753     }
754 }
755 
756 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
757 
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 /**
763  * @dev Implementation of the {IERC165} interface.
764  *
765  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
766  * for the additional interface id that will be supported. For example:
767  *
768  * ```solidity
769  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
771  * }
772  * ```
773  *
774  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
775  */
776 abstract contract ERC165 is IERC165 {
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId)
781         public
782         view
783         virtual
784         override
785         returns (bool)
786     {
787         return interfaceId == type(IERC165).interfaceId;
788     }
789 }
790 
791 // File erc721a/contracts/ERC721A.sol@v3.2.0
792 
793 // Creator: Chiru Labs
794 
795 pragma solidity ^0.8.4;
796 
797 error ApprovalCallerNotOwnerNorApproved();
798 error ApprovalQueryForNonexistentToken();
799 error ApproveToCaller();
800 error ApprovalToCurrentOwner();
801 error BalanceQueryForZeroAddress();
802 error MintToZeroAddress();
803 error MintZeroQuantity();
804 error OwnerQueryForNonexistentToken();
805 error TransferCallerNotOwnerNorApproved();
806 error TransferFromIncorrectOwner();
807 error TransferToNonERC721ReceiverImplementer();
808 error TransferToZeroAddress();
809 error URIQueryForNonexistentToken();
810 
811 /**
812  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
813  * the Metadata extension. Built to optimize for lower gas during batch mints.
814  *
815  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
816  *
817  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
818  *
819  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
820  */
821 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
822     using Address for address;
823     using Strings for uint256;
824 
825     // Compiler will pack this into a single 256bit word.
826     struct TokenOwnership {
827         // The address of the owner.
828         address addr;
829         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
830         uint64 startTimestamp;
831         // Whether the token has been burned.
832         bool burned;
833     }
834 
835     // Compiler will pack this into a single 256bit word.
836     struct AddressData {
837         // Realistically, 2**64-1 is more than enough.
838         uint64 balance;
839         // Keeps track of mint count with minimal overhead for tokenomics.
840         uint64 numberMinted;
841         // Keeps track of burn count with minimal overhead for tokenomics.
842         uint64 numberBurned;
843         // For miscellaneous variable(s) pertaining to the address
844         // (e.g. number of whitelist mint slots used).
845         // If there are multiple variables, please pack them into a uint64.
846         uint64 aux;
847     }
848 
849     // The tokenId of the next token to be minted.
850     uint256 internal _currentIndex;
851 
852     // The number of tokens burned.
853     uint256 internal _burnCounter;
854 
855     // Token name
856     string private _name;
857 
858     // Token symbol
859     string private _symbol;
860 
861     // Mapping from token ID to ownership details
862     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
863     mapping(uint256 => TokenOwnership) internal _ownerships;
864 
865     // Mapping owner address to address data
866     mapping(address => AddressData) private _addressData;
867 
868     // Mapping from token ID to approved address
869     mapping(uint256 => address) private _tokenApprovals;
870 
871     // Mapping from owner to operator approvals
872     mapping(address => mapping(address => bool)) private _operatorApprovals;
873 
874     constructor(string memory name_, string memory symbol_) {
875         _name = name_;
876         _symbol = symbol_;
877         _currentIndex = _startTokenId();
878     }
879 
880     /**
881      * To change the starting tokenId, please override this function.
882      */
883     function _startTokenId() internal view virtual returns (uint256) {
884         return 0;
885     }
886 
887     /**
888      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
889      */
890     function totalSupply() public view returns (uint256) {
891         // Counter underflow is impossible as _burnCounter cannot be incremented
892         // more than _currentIndex - _startTokenId() times
893         unchecked {
894             return _currentIndex - _burnCounter - _startTokenId();
895         }
896     }
897 
898     /**
899      * Returns the total amount of tokens minted in the contract.
900      */
901     function _totalMinted() internal view returns (uint256) {
902         // Counter underflow is impossible as _currentIndex does not decrement,
903         // and it is initialized to _startTokenId()
904         unchecked {
905             return _currentIndex - _startTokenId();
906         }
907     }
908 
909     /**
910      * @dev See {IERC165-supportsInterface}.
911      */
912     function supportsInterface(bytes4 interfaceId)
913         public
914         view
915         virtual
916         override(ERC165, IERC165)
917         returns (bool)
918     {
919         return
920             interfaceId == type(IERC721).interfaceId ||
921             interfaceId == type(IERC721Metadata).interfaceId ||
922             super.supportsInterface(interfaceId);
923     }
924 
925     /**
926      * @dev See {IERC721-balanceOf}.
927      */
928     function balanceOf(address owner) public view override returns (uint256) {
929         if (owner == address(0)) revert BalanceQueryForZeroAddress();
930         return uint256(_addressData[owner].balance);
931     }
932 
933     /**
934      * Returns the number of tokens minted by `owner`.
935      */
936     function _numberMinted(address owner) internal view returns (uint256) {
937         return uint256(_addressData[owner].numberMinted);
938     }
939 
940     /**
941      * Returns the number of tokens burned by or on behalf of `owner`.
942      */
943     function _numberBurned(address owner) internal view returns (uint256) {
944         return uint256(_addressData[owner].numberBurned);
945     }
946 
947     /**
948      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
949      */
950     function _getAux(address owner) internal view returns (uint64) {
951         return _addressData[owner].aux;
952     }
953 
954     /**
955      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
956      * If there are multiple variables, please pack them into a uint64.
957      */
958     function _setAux(address owner, uint64 aux) internal {
959         _addressData[owner].aux = aux;
960     }
961 
962     /**
963      * Gas spent here starts off proportional to the maximum mint batch size.
964      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
965      */
966     function _ownershipOf(uint256 tokenId)
967         internal
968         view
969         returns (TokenOwnership memory)
970     {
971         uint256 curr = tokenId;
972 
973         unchecked {
974             if (_startTokenId() <= curr && curr < _currentIndex) {
975                 TokenOwnership memory ownership = _ownerships[curr];
976                 if (!ownership.burned) {
977                     if (ownership.addr != address(0)) {
978                         return ownership;
979                     }
980                     // Invariant:
981                     // There will always be an ownership that has an address and is not burned
982                     // before an ownership that does not have an address and is not burned.
983                     // Hence, curr will not underflow.
984                     while (true) {
985                         curr--;
986                         ownership = _ownerships[curr];
987                         if (ownership.addr != address(0)) {
988                             return ownership;
989                         }
990                     }
991                 }
992             }
993         }
994         revert OwnerQueryForNonexistentToken();
995     }
996 
997     /**
998      * @dev See {IERC721-ownerOf}.
999      */
1000     function ownerOf(uint256 tokenId) public view override returns (address) {
1001         return _ownershipOf(tokenId).addr;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-name}.
1006      */
1007     function name() public view virtual override returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-symbol}.
1013      */
1014     function symbol() public view virtual override returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-tokenURI}.
1020      */
1021     function tokenURI(uint256 tokenId)
1022         public
1023         view
1024         virtual
1025         override
1026         returns (string memory)
1027     {
1028         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1029 
1030         string memory baseURI = _baseURI();
1031         return
1032             bytes(baseURI).length != 0
1033                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1034                 : "";
1035     }
1036 
1037     /**
1038      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1039      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1040      * by default, can be overriden in child contracts.
1041      */
1042     function _baseURI() internal view virtual returns (string memory) {
1043         return "";
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-approve}.
1048      */
1049     function approve(address to, uint256 tokenId) public override {
1050         address owner = ERC721A.ownerOf(tokenId);
1051         if (to == owner) revert ApprovalToCurrentOwner();
1052 
1053         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1054             revert ApprovalCallerNotOwnerNorApproved();
1055         }
1056 
1057         _approve(to, tokenId, owner);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-getApproved}.
1062      */
1063     function getApproved(uint256 tokenId)
1064         public
1065         view
1066         override
1067         returns (address)
1068     {
1069         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1070 
1071         return _tokenApprovals[tokenId];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-setApprovalForAll}.
1076      */
1077     function setApprovalForAll(address operator, bool approved)
1078         public
1079         virtual
1080         override
1081     {
1082         if (operator == _msgSender()) revert ApproveToCaller();
1083 
1084         _operatorApprovals[_msgSender()][operator] = approved;
1085         emit ApprovalForAll(_msgSender(), operator, approved);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-isApprovedForAll}.
1090      */
1091     function isApprovedForAll(address owner, address operator)
1092         public
1093         view
1094         virtual
1095         override
1096         returns (bool)
1097     {
1098         return _operatorApprovals[owner][operator];
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-transferFrom}.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         _transfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-safeTransferFrom}.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) public virtual override {
1120         safeTransferFrom(from, to, tokenId, "");
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-safeTransferFrom}.
1125      */
1126     function safeTransferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) public virtual override {
1132         _transfer(from, to, tokenId);
1133         if (
1134             to.isContract() &&
1135             !_checkContractOnERC721Received(from, to, tokenId, _data)
1136         ) {
1137             revert TransferToNonERC721ReceiverImplementer();
1138         }
1139     }
1140 
1141     /**
1142      * @dev Returns whether `tokenId` exists.
1143      *
1144      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1145      *
1146      * Tokens start existing when they are minted (`_mint`),
1147      */
1148     function _exists(uint256 tokenId) internal view returns (bool) {
1149         return
1150             _startTokenId() <= tokenId &&
1151             tokenId < _currentIndex &&
1152             !_ownerships[tokenId].burned;
1153     }
1154 
1155     function _safeMint(address to, uint256 quantity) internal {
1156         _safeMint(to, quantity, "");
1157     }
1158 
1159     /**
1160      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1165      * - `quantity` must be greater than 0.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _safeMint(
1170         address to,
1171         uint256 quantity,
1172         bytes memory _data
1173     ) internal {
1174         _mint(to, quantity, _data, true);
1175     }
1176 
1177     /**
1178      * @dev Mints `quantity` tokens and transfers them to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _mint(
1188         address to,
1189         uint256 quantity,
1190         bytes memory _data,
1191         bool safe
1192     ) internal {
1193         uint256 startTokenId = _currentIndex;
1194         if (to == address(0)) revert MintToZeroAddress();
1195         if (quantity == 0) revert MintZeroQuantity();
1196 
1197         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1198 
1199         // Overflows are incredibly unrealistic.
1200         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1201         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1202         unchecked {
1203             _addressData[to].balance += uint64(quantity);
1204             _addressData[to].numberMinted += uint64(quantity);
1205 
1206             _ownerships[startTokenId].addr = to;
1207             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1208 
1209             uint256 updatedIndex = startTokenId;
1210             uint256 end = updatedIndex + quantity;
1211 
1212             if (safe && to.isContract()) {
1213                 do {
1214                     emit Transfer(address(0), to, updatedIndex);
1215                     if (
1216                         !_checkContractOnERC721Received(
1217                             address(0),
1218                             to,
1219                             updatedIndex++,
1220                             _data
1221                         )
1222                     ) {
1223                         revert TransferToNonERC721ReceiverImplementer();
1224                     }
1225                 } while (updatedIndex != end);
1226                 // Reentrancy protection
1227                 if (_currentIndex != startTokenId) revert();
1228             } else {
1229                 do {
1230                     emit Transfer(address(0), to, updatedIndex++);
1231                 } while (updatedIndex != end);
1232             }
1233             _currentIndex = updatedIndex;
1234         }
1235         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1236     }
1237 
1238     /**
1239      * @dev Transfers `tokenId` from `from` to `to`.
1240      *
1241      * Requirements:
1242      *
1243      * - `to` cannot be the zero address.
1244      * - `tokenId` token must be owned by `from`.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _transfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) private {
1253         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1254 
1255         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1256 
1257         bool isApprovedOrOwner = (_msgSender() == from ||
1258             isApprovedForAll(from, _msgSender()) ||
1259             getApproved(tokenId) == _msgSender());
1260 
1261         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1262         if (to == address(0)) revert TransferToZeroAddress();
1263 
1264         _beforeTokenTransfers(from, to, tokenId, 1);
1265 
1266         // Clear approvals from the previous owner
1267         _approve(address(0), tokenId, from);
1268 
1269         // Underflow of the sender's balance is impossible because we check for
1270         // ownership above and the recipient's balance can't realistically overflow.
1271         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1272         unchecked {
1273             _addressData[from].balance -= 1;
1274             _addressData[to].balance += 1;
1275 
1276             TokenOwnership storage currSlot = _ownerships[tokenId];
1277             currSlot.addr = to;
1278             currSlot.startTimestamp = uint64(block.timestamp);
1279 
1280             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
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
1294         emit Transfer(from, to, tokenId);
1295         _afterTokenTransfers(from, to, tokenId, 1);
1296     }
1297 
1298     /**
1299      * @dev This is equivalent to _burn(tokenId, false)
1300      */
1301     function _burn(uint256 tokenId) internal virtual {
1302         _burn(tokenId, false);
1303     }
1304 
1305     /**
1306      * @dev Destroys `tokenId`.
1307      * The approval is cleared when the token is burned.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1316         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1317 
1318         address from = prevOwnership.addr;
1319 
1320         if (approvalCheck) {
1321             bool isApprovedOrOwner = (_msgSender() == from ||
1322                 isApprovedForAll(from, _msgSender()) ||
1323                 getApproved(tokenId) == _msgSender());
1324 
1325             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1326         }
1327 
1328         _beforeTokenTransfers(from, address(0), tokenId, 1);
1329 
1330         // Clear approvals from the previous owner
1331         _approve(address(0), tokenId, from);
1332 
1333         // Underflow of the sender's balance is impossible because we check for
1334         // ownership above and the recipient's balance can't realistically overflow.
1335         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1336         unchecked {
1337             AddressData storage addressData = _addressData[from];
1338             addressData.balance -= 1;
1339             addressData.numberBurned += 1;
1340 
1341             // Keep track of who burned the token, and the timestamp of burning.
1342             TokenOwnership storage currSlot = _ownerships[tokenId];
1343             currSlot.addr = from;
1344             currSlot.startTimestamp = uint64(block.timestamp);
1345             currSlot.burned = true;
1346 
1347             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1348             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1349             uint256 nextTokenId = tokenId + 1;
1350             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1351             if (nextSlot.addr == address(0)) {
1352                 // This will suffice for checking _exists(nextTokenId),
1353                 // as a burned slot cannot contain the zero address.
1354                 if (nextTokenId != _currentIndex) {
1355                     nextSlot.addr = from;
1356                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1357                 }
1358             }
1359         }
1360 
1361         emit Transfer(from, address(0), tokenId);
1362         _afterTokenTransfers(from, address(0), tokenId, 1);
1363 
1364         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1365         unchecked {
1366             _burnCounter++;
1367         }
1368     }
1369 
1370     /**
1371      * @dev Approve `to` to operate on `tokenId`
1372      *
1373      * Emits a {Approval} event.
1374      */
1375     function _approve(
1376         address to,
1377         uint256 tokenId,
1378         address owner
1379     ) private {
1380         _tokenApprovals[tokenId] = to;
1381         emit Approval(owner, to, tokenId);
1382     }
1383 
1384     /**
1385      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1386      *
1387      * @param from address representing the previous owner of the given token ID
1388      * @param to target address that will receive the tokens
1389      * @param tokenId uint256 ID of the token to be transferred
1390      * @param _data bytes optional data to send along with the call
1391      * @return bool whether the call correctly returned the expected magic value
1392      */
1393     function _checkContractOnERC721Received(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) private returns (bool) {
1399         try
1400             IERC721Receiver(to).onERC721Received(
1401                 _msgSender(),
1402                 from,
1403                 tokenId,
1404                 _data
1405             )
1406         returns (bytes4 retval) {
1407             return retval == IERC721Receiver(to).onERC721Received.selector;
1408         } catch (bytes memory reason) {
1409             if (reason.length == 0) {
1410                 revert TransferToNonERC721ReceiverImplementer();
1411             } else {
1412                 assembly {
1413                     revert(add(32, reason), mload(reason))
1414                 }
1415             }
1416         }
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1421      * And also called before burning one token.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` will be minted for `to`.
1431      * - When `to` is zero, `tokenId` will be burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _beforeTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 
1441     /**
1442      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1443      * minting.
1444      * And also called after one token has been burned.
1445      *
1446      * startTokenId - the first token id to be transferred
1447      * quantity - the amount to be transferred
1448      *
1449      * Calling conditions:
1450      *
1451      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1452      * transferred to `to`.
1453      * - When `from` is zero, `tokenId` has been minted for `to`.
1454      * - When `to` is zero, `tokenId` has been burned by `from`.
1455      * - `from` and `to` are never both zero.
1456      */
1457     function _afterTokenTransfers(
1458         address from,
1459         address to,
1460         uint256 startTokenId,
1461         uint256 quantity
1462     ) internal virtual {}
1463 }
1464 
1465 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
1466 
1467 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 /**
1472  * @dev Contract module which allows children to implement an emergency stop
1473  * mechanism that can be triggered by an authorized account.
1474  *
1475  * This module is used through inheritance. It will make available the
1476  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1477  * the functions of your contract. Note that they will not be pausable by
1478  * simply including this module, only once the modifiers are put in place.
1479  */
1480 abstract contract Pausable is Context {
1481     /**
1482      * @dev Emitted when the pause is triggered by `account`.
1483      */
1484     event Paused(address account);
1485 
1486     /**
1487      * @dev Emitted when the pause is lifted by `account`.
1488      */
1489     event Unpaused(address account);
1490 
1491     bool private _paused;
1492 
1493     /**
1494      * @dev Initializes the contract in unpaused state.
1495      */
1496     constructor() {
1497         _paused = false;
1498     }
1499 
1500     /**
1501      * @dev Returns true if the contract is paused, and false otherwise.
1502      */
1503     function paused() public view virtual returns (bool) {
1504         return _paused;
1505     }
1506 
1507     /**
1508      * @dev Modifier to make a function callable only when the contract is not paused.
1509      *
1510      * Requirements:
1511      *
1512      * - The contract must not be paused.
1513      */
1514     modifier whenNotPaused() {
1515         require(!paused(), "Pausable: paused");
1516         _;
1517     }
1518 
1519     /**
1520      * @dev Modifier to make a function callable only when the contract is paused.
1521      *
1522      * Requirements:
1523      *
1524      * - The contract must be paused.
1525      */
1526     modifier whenPaused() {
1527         require(paused(), "Pausable: not paused");
1528         _;
1529     }
1530 
1531     /**
1532      * @dev Triggers stopped state.
1533      *
1534      * Requirements:
1535      *
1536      * - The contract must not be paused.
1537      */
1538     function _pause() internal virtual whenNotPaused {
1539         _paused = true;
1540         emit Paused(_msgSender());
1541     }
1542 
1543     /**
1544      * @dev Returns to normal state.
1545      *
1546      * Requirements:
1547      *
1548      * - The contract must be paused.
1549      */
1550     function _unpause() internal virtual whenPaused {
1551         _paused = false;
1552         emit Unpaused(_msgSender());
1553     }
1554 }
1555 
1556 // File erc721a/contracts/extensions/ERC721APausable.sol@v3.2.0
1557 
1558 // Creator: Chiru Labs
1559 
1560 pragma solidity ^0.8.4;
1561 
1562 error ContractPaused();
1563 
1564 /**
1565  * @dev ERC721A token with pausable token transfers, minting and burning.
1566  *
1567  * Based off of OpenZeppelin's ERC721Pausable extension.
1568  *
1569  * Useful for scenarios such as preventing trades until the end of an evaluation
1570  * period, or having an emergency switch for freezing all token transfers in the
1571  * event of a large bug.
1572  */
1573 abstract contract ERC721APausable is ERC721A, Pausable {
1574     /**
1575      * @dev See {ERC721A-_beforeTokenTransfers}.
1576      *
1577      * Requirements:
1578      *
1579      * - the contract must not be paused.
1580      */
1581     function _beforeTokenTransfers(
1582         address from,
1583         address to,
1584         uint256 startTokenId,
1585         uint256 quantity
1586     ) internal virtual override {
1587         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1588         if (paused()) revert ContractPaused();
1589     }
1590 }
1591 
1592 // File contracts/Genesis.sol
1593 
1594 pragma solidity ^0.8.4;
1595 
1596 error TotalSupplyExceeded();
1597 
1598 /**
1599  *
1600  *                                                       _
1601  *                                                      (_)
1602  *  _ __ ___ _ __ ___ __  __   __ _  ___ _ __   ___  ___ _ ___
1603  * | '__/ _ \ '_ ` _ \\ \/ /  / _` |/ _ \ '_ \ / _ \/ __| / __|
1604  * | | |  __/ | | | | |>  <  | (_| |  __/ | | |  __/\__ \ \__ \
1605  * |_|  \___|_| |_| |_/_/\_\  \__, |\___|_| |_|\___||___/_|___/
1606  *                             __/ |
1607  *                            |___/
1608  *
1609  * The remx genesis collection is the membership token of the remx community
1610  *
1611  */
1612 contract Genesis is ERC721A, Ownable, ERC721APausable, ReentrancyGuard {
1613     string private _tokenBaseUri;
1614     string private _contractURI;
1615 
1616     constructor(
1617         string memory name_,
1618         string memory symbol_,
1619         string memory tokenBaseUri_,
1620         string memory contractURI_
1621     ) ERC721A(name_, symbol_) {
1622         _tokenBaseUri = tokenBaseUri_;
1623         _contractURI = contractURI_;
1624     }
1625 
1626     function _startTokenId() internal pure override returns (uint256) {
1627         return 1;
1628     }
1629 
1630     function maxSupply() public pure returns (uint256) {
1631         return 2500;
1632     }
1633 
1634     function contractURI() public view returns (string memory) {
1635         return _contractURI;
1636     }
1637 
1638     function setContractURI(string memory contractURI_) external onlyOwner {
1639         _contractURI = contractURI_;
1640     }
1641 
1642     function _baseURI() internal view override returns (string memory) {
1643         return _tokenBaseUri;
1644     }
1645 
1646     function setBaseURI(string memory tokenBaseUri_) external onlyOwner {
1647         _tokenBaseUri = tokenBaseUri_;
1648     }
1649 
1650     function mint(address to, uint256 quantity)
1651         external
1652         nonReentrant
1653         onlyOwner
1654         whenNotPaused
1655     {
1656         if (totalSupply() + quantity > maxSupply())
1657             revert TotalSupplyExceeded();
1658         _safeMint(to, quantity);
1659     }
1660 
1661     function pause() external onlyOwner {
1662         _pause();
1663     }
1664 
1665     function unpause() external onlyOwner {
1666         _unpause();
1667     }
1668 
1669     function _beforeTokenTransfers(
1670         address from,
1671         address to,
1672         uint256 startTokenId,
1673         uint256 quantity
1674     ) internal virtual override(ERC721A, ERC721APausable) {
1675         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1676     }
1677 }