1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-21
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-09-20
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-09-19
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-09-18
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-08-31
23  */
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2022-08-13
27  */
28 
29 /**
30  *Submitted for verification at Etherscan.io on 2022-08-13
31  */
32 
33 /**
34  *Submitted for verification at Etherscan.io on 2022-07-25
35  */
36 
37 /**
38  *Submitted for verification at Etherscan.io on 2022-06-27
39  */
40 
41 /**
42  *Submitted for verification at Etherscan.io on 2022-06-23
43  */
44 
45 // SPDX-License-Identifier: MIT
46 
47 // File 1: Address.sol
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
50 
51 pragma solidity ^0.8.1;
52 
53 /**
54  * @dev Collection of functions related to the address type
55  */
56 library Address {
57     /**
58      * @dev Returns true if `account` is a contract.
59      *
60      * [IMPORTANT]
61      * ====
62      * It is unsafe to assume that an address for which this function returns
63      * false is an externally-owned account (EOA) and not a contract.
64      *
65      * Among others, `isContract` will return false for the following
66      * types of addresses:
67      *
68      *  - an externally-owned account
69      *  - a contract in construction
70      *  - an address where a contract will be created
71      *  - an address where a contract lived, but was destroyed
72      * ====
73      *
74      * [IMPORTANT]
75      * ====
76      * You shouldn't rely on `isContract` to protect against flash loan attacks!
77      *
78      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
79      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
80      * constructor.
81      * ====
82      */
83     function isContract(address account) internal view returns (bool) {
84         // This method relies on extcodesize/address.code.length, which returns 0
85         // for contracts in construction, since the code is only stored at the end
86         // of the constructor execution.
87 
88         return account.code.length > 0;
89     }
90 
91     /**
92      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
93      * `recipient`, forwarding all available gas and reverting on errors.
94      *
95      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
96      * of certain opcodes, possibly making contracts go over the 2300 gas limit
97      * imposed by `transfer`, making them unable to receive funds via
98      * `transfer`. {sendValue} removes this limitation.
99      *
100      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
101      *
102      * IMPORTANT: because control is transferred to `recipient`, care must be
103      * taken to not create reentrancy vulnerabilities. Consider using
104      * {ReentrancyGuard} or the
105      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
106      */
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(
109             address(this).balance >= amount,
110             "Address: insufficient balance"
111         );
112 
113         (bool success, ) = recipient.call{value: amount}("");
114         require(
115             success,
116             "Address: unable to send value, recipient may have reverted"
117         );
118     }
119 
120     /**
121      * @dev Performs a Solidity function call using a low level `call`. A
122      * plain `call` is an unsafe replacement for a function call: use this
123      * function instead.
124      *
125      * If `target` reverts with a revert reason, it is bubbled up by this
126      * function (like regular Solidity function calls).
127      *
128      * Returns the raw returned data. To convert to the expected return value,
129      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
130      *
131      * Requirements:
132      *
133      * - `target` must be a contract.
134      * - calling `target` with `data` must not revert.
135      *
136      * _Available since v3.1._
137      */
138     function functionCall(address target, bytes memory data)
139         internal
140         returns (bytes memory)
141     {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
147      * `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but also transferring `value` wei to `target`.
162      *
163      * Requirements:
164      *
165      * - the calling contract must have an ETH balance of at least `value`.
166      * - the called Solidity function must be `payable`.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return
176             functionCallWithValue(
177                 target,
178                 data,
179                 value,
180                 "Address: low-level call with value failed"
181             );
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
186      * with `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         require(
197             address(this).balance >= value,
198             "Address: insufficient balance for call"
199         );
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(
203             data
204         );
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data)
215         internal
216         view
217         returns (bytes memory)
218     {
219         return
220             functionStaticCall(
221                 target,
222                 data,
223                 "Address: low-level static call failed"
224             );
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data)
251         internal
252         returns (bytes memory)
253     {
254         return
255             functionDelegateCall(
256                 target,
257                 data,
258                 "Address: low-level delegate call failed"
259             );
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281      * revert reason using the provided one.
282      *
283      * _Available since v4.3._
284      */
285     function verifyCallResult(
286         bool success,
287         bytes memory returndata,
288         string memory errorMessage
289     ) internal pure returns (bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             // Look for revert reason and bubble it up if present
294             if (returndata.length > 0) {
295                 // The easiest way to bubble the revert reason is using memory via assembly
296 
297                 assembly {
298                     let returndata_size := mload(returndata)
299                     revert(add(32, returndata), returndata_size)
300                 }
301             } else {
302                 revert(errorMessage);
303             }
304         }
305     }
306 }
307 
308 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
309 
310 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Contract module that helps prevent reentrant calls to a function.
316  *
317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
318  * available, which can be applied to functions to make sure there are no nested
319  * (reentrant) calls to them.
320  *
321  * Note that because there is a single `nonReentrant` guard, functions marked as
322  * `nonReentrant` may not call one another. This can be worked around by making
323  * those functions `private`, and then adding `external` `nonReentrant` entry
324  * points to them.
325  *
326  * TIP: If you would like to learn more about reentrancy and alternative ways
327  * to protect against it, check out our blog post
328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
329  */
330 abstract contract ReentrancyGuard {
331     // Booleans are more expensive than uint256 or any type that takes up a full
332     // word because each write operation emits an extra SLOAD to first read the
333     // slot's contents, replace the bits taken up by the boolean, and then write
334     // back. This is the compiler's defense against contract upgrades and
335     // pointer aliasing, and it cannot be disabled.
336 
337     // The values being non-zero value makes deployment a bit more expensive,
338     // but in exchange the refund on every call to nonReentrant will be lower in
339     // amount. Since refunds are capped to a percentage of the total
340     // transaction's gas, it is best to keep them low in cases like this one, to
341     // increase the likelihood of the full refund coming into effect.
342     uint256 private constant _NOT_ENTERED = 1;
343     uint256 private constant _ENTERED = 2;
344 
345     uint256 private _status;
346 
347     constructor() {
348         _status = _NOT_ENTERED;
349     }
350 
351     /**
352      * @dev Prevents a contract from calling itself, directly or indirectly.
353      * Calling a `nonReentrant` function from another `nonReentrant`
354      * function is not supported. It is possible to prevent this from happening
355      * by making the `nonReentrant` function external, and making it call a
356      * `private` function that does the actual work.
357      */
358     modifier nonReentrant() {
359         // On the first call to nonReentrant, _notEntered will be true
360         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
361 
362         // Any calls to nonReentrant after this point will fail
363         _status = _ENTERED;
364 
365         _;
366 
367         // By storing the original value once again, a refund is triggered (see
368         // https://eips.ethereum.org/EIPS/eip-2200)
369         _status = _NOT_ENTERED;
370     }
371 }
372 
373 // FILE 2: Context.sol
374 pragma solidity ^0.8.0;
375 
376 /*
377  * @dev Provides information about the current execution context, including the
378  * sender of the transaction and its data. While these are generally available
379  * via msg.sender and msg.data, they should not be accessed in such a direct
380  * manner, since when dealing with meta-transactions the account sending and
381  * paying for execution may not be the actual sender (as far as an application
382  * is concerned).
383  *
384  * This contract is only required for intermediate, library-like contracts.
385  */
386 abstract contract Context {
387     function _msgSender() internal view virtual returns (address) {
388         return msg.sender;
389     }
390 
391     function _msgData() internal view virtual returns (bytes calldata) {
392         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
393         return msg.data;
394     }
395 }
396 
397 // File 3: Strings.sol
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev String operations.
405  */
406 library Strings {
407     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
411      */
412     function toString(uint256 value) internal pure returns (string memory) {
413         // Inspired by OraclizeAPI's implementation - MIT licence
414         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
415 
416         if (value == 0) {
417             return "0";
418         }
419         uint256 temp = value;
420         uint256 digits;
421         while (temp != 0) {
422             digits++;
423             temp /= 10;
424         }
425         bytes memory buffer = new bytes(digits);
426         while (value != 0) {
427             digits -= 1;
428             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
429             value /= 10;
430         }
431         return string(buffer);
432     }
433 
434     /**
435      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
436      */
437     function toHexString(uint256 value) internal pure returns (string memory) {
438         if (value == 0) {
439             return "0x00";
440         }
441         uint256 temp = value;
442         uint256 length = 0;
443         while (temp != 0) {
444             length++;
445             temp >>= 8;
446         }
447         return toHexString(value, length);
448     }
449 
450     /**
451      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
452      */
453     function toHexString(uint256 value, uint256 length)
454         internal
455         pure
456         returns (string memory)
457     {
458         bytes memory buffer = new bytes(2 * length + 2);
459         buffer[0] = "0";
460         buffer[1] = "x";
461         for (uint256 i = 2 * length + 1; i > 1; --i) {
462             buffer[i] = _HEX_SYMBOLS[value & 0xf];
463             value >>= 4;
464         }
465         require(value == 0, "Strings: hex length insufficient");
466         return string(buffer);
467     }
468 }
469 
470 // File: @openzeppelin/contracts/utils/Counters.sol
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @title Counters
478  * @author Matt Condon (@shrugs)
479  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
480  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
481  *
482  * Include with `using Counters for Counters.Counter;`
483  */
484 library Counters {
485     struct Counter {
486         // This variable should never be directly accessed by users of the library: interactions must be restricted to
487         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
488         // this feature: see https://github.com/ethereum/solidity/issues/4637
489         uint256 _value; // default: 0
490     }
491 
492     function current(Counter storage counter) internal view returns (uint256) {
493         return counter._value;
494     }
495 
496     function increment(Counter storage counter) internal {
497         unchecked {
498             counter._value += 1;
499         }
500     }
501 
502     function decrement(Counter storage counter) internal {
503         uint256 value = counter._value;
504         require(value > 0, "Counter: decrement overflow");
505         unchecked {
506             counter._value = value - 1;
507         }
508     }
509 
510     function reset(Counter storage counter) internal {
511         counter._value = 0;
512     }
513 }
514 
515 // File 4: Ownable.sol
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Contract module which provides a basic access control mechanism, where
521  * there is an account (an owner) that can be granted exclusive access to
522  * specific functions.
523  *
524  * By default, the owner account will be the one that deploys the contract. This
525  * can later be changed with {transferOwnership}.
526  *
527  * This module is used through inheritance. It will make available the modifier
528  * `onlyOwner`, which can be applied to your functions to restrict their use to
529  * the owner.
530  */
531 abstract contract Ownable is Context {
532     address private _owner;
533 
534     event OwnershipTransferred(
535         address indexed previousOwner,
536         address indexed newOwner
537     );
538 
539     /**
540      * @dev Initializes the contract setting the deployer as the initial owner.
541      */
542     constructor() {
543         address msgSender = _msgSender();
544         _owner = msgSender;
545         emit OwnershipTransferred(address(0), msgSender);
546     }
547 
548     /**
549      * @dev Returns the address of the current owner.
550      */
551     function owner() public view virtual returns (address) {
552         return _owner;
553     }
554 
555     /**
556      * @dev Throws if called by any account other than the owner.
557      */
558     modifier onlyOwner() {
559         require(owner() == _msgSender(), "Ownable: caller is not the owner");
560         _;
561     }
562 
563     /**
564      * @dev Leaves the contract without owner. It will not be possible to call
565      * `onlyOwner` functions anymore. Can only be called by the current owner.
566      *
567      * NOTE: Renouncing ownership will leave the contract without an owner,
568      * thereby removing any functionality that is only available to the owner.
569      */
570     function renounceOwnership() public virtual onlyOwner {
571         emit OwnershipTransferred(_owner, address(0));
572         _owner = address(0);
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Can only be called by the current owner.
578      */
579     function transferOwnership(address newOwner) public virtual onlyOwner {
580         require(
581             newOwner != address(0),
582             "Ownable: new owner is the zero address"
583         );
584         emit OwnershipTransferred(_owner, newOwner);
585         _owner = newOwner;
586     }
587 }
588 
589 // File 5: IERC165.sol
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Interface of the ERC165 standard, as defined in the
595  * https://eips.ethereum.org/EIPS/eip-165[EIP].
596  *
597  * Implementers can declare support of contract interfaces, which can then be
598  * queried by others ({ERC165Checker}).
599  *
600  * For an implementation, see {ERC165}.
601  */
602 interface IERC165 {
603     /**
604      * @dev Returns true if this contract implements the interface defined by
605      * `interfaceId`. See the corresponding
606      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
607      * to learn more about how these ids are created.
608      *
609      * This function call must use less than 30 000 gas.
610      */
611     function supportsInterface(bytes4 interfaceId) external view returns (bool);
612 }
613 
614 // File 6: IERC721.sol
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Required interface of an ERC721 compliant contract.
620  */
621 interface IERC721 is IERC165 {
622     /**
623      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
624      */
625     event Transfer(
626         address indexed from,
627         address indexed to,
628         uint256 indexed tokenId
629     );
630 
631     /**
632      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
633      */
634     event Approval(
635         address indexed owner,
636         address indexed approved,
637         uint256 indexed tokenId
638     );
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(
644         address indexed owner,
645         address indexed operator,
646         bool approved
647     );
648 
649     /**
650      * @dev Returns the number of tokens in ``owner``'s account.
651      */
652     function balanceOf(address owner) external view returns (uint256 balance);
653 
654     /**
655      * @dev Returns the owner of the `tokenId` token.
656      *
657      * Requirements:
658      *
659      * - `tokenId` must exist.
660      */
661     function ownerOf(uint256 tokenId) external view returns (address owner);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
665      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     /**
684      * @dev Transfers `tokenId` token from `from` to `to`.
685      *
686      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must be owned by `from`.
693      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external;
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
705      * The approval is cleared when the token is transferred.
706      *
707      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) external;
717 
718     /**
719      * @dev Returns the account approved for `tokenId` token.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must exist.
724      */
725     function getApproved(uint256 tokenId)
726         external
727         view
728         returns (address operator);
729 
730     /**
731      * @dev Approve or remove `operator` as an operator for the caller.
732      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
733      *
734      * Requirements:
735      *
736      * - The `operator` cannot be the caller.
737      *
738      * Emits an {ApprovalForAll} event.
739      */
740     function setApprovalForAll(address operator, bool _approved) external;
741 
742     /**
743      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
744      *
745      * See {setApprovalForAll}
746      */
747     function isApprovedForAll(address owner, address operator)
748         external
749         view
750         returns (bool);
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must exist and be owned by `from`.
760      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
761      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
762      *
763      * Emits a {Transfer} event.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes calldata data
770     ) external;
771 }
772 
773 // File 7: IERC721Metadata.sol
774 
775 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
781  * @dev See https://eips.ethereum.org/EIPS/eip-721
782  */
783 interface IERC721Metadata is IERC721 {
784     /**
785      * @dev Returns the token collection name.
786      */
787     function name() external view returns (string memory);
788 
789     /**
790      * @dev Returns the token collection symbol.
791      */
792     function symbol() external view returns (string memory);
793 
794     /**
795      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
796      */
797     function tokenURI(uint256 tokenId) external returns (string memory);
798 }
799 
800 // File 8: ERC165.sol
801 
802 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Implementation of the {IERC165} interface.
808  *
809  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
810  * for the additional interface id that will be supported. For example:
811  *
812  * ```solidity
813  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
814  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
815  * }
816  * ```
817  *
818  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
819  */
820 abstract contract ERC165 is IERC165 {
821     /**
822      * @dev See {IERC165-supportsInterface}.
823      */
824     function supportsInterface(bytes4 interfaceId)
825         public
826         view
827         virtual
828         override
829         returns (bool)
830     {
831         return interfaceId == type(IERC165).interfaceId;
832     }
833 }
834 
835 // File 9: ERC721.sol
836 
837 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 /**
842  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
843  * the Metadata extension, but not including the Enumerable extension, which is available separately as
844  * {ERC721Enumerable}.
845  */
846 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
847     using Address for address;
848     using Strings for uint256;
849 
850     // Token name
851     string private _name;
852 
853     // Token symbol
854     string private _symbol;
855 
856     // Mapping from token ID to owner address
857     mapping(uint256 => address) private _owners;
858 
859     // Mapping owner address to token count
860     mapping(address => uint256) private _balances;
861 
862     // Mapping from token ID to approved address
863     mapping(uint256 => address) private _tokenApprovals;
864 
865     // Mapping from owner to operator approvals
866     mapping(address => mapping(address => bool)) private _operatorApprovals;
867 
868     /**
869      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
870      */
871     constructor(string memory name_, string memory symbol_) {
872         _name = name_;
873         _symbol = symbol_;
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId)
880         public
881         view
882         virtual
883         override(ERC165, IERC165)
884         returns (bool)
885     {
886         return
887             interfaceId == type(IERC721).interfaceId ||
888             interfaceId == type(IERC721Metadata).interfaceId ||
889             super.supportsInterface(interfaceId);
890     }
891 
892     /**
893      * @dev See {IERC721-balanceOf}.
894      */
895     function balanceOf(address owner)
896         public
897         view
898         virtual
899         override
900         returns (uint256)
901     {
902         require(
903             owner != address(0),
904             "ERC721: balance query for the zero address"
905         );
906         return _balances[owner];
907     }
908 
909     /**
910      * @dev See {IERC721-ownerOf}.
911      */
912     function ownerOf(uint256 tokenId)
913         public
914         view
915         virtual
916         override
917         returns (address)
918     {
919         address owner = _owners[tokenId];
920         require(
921             owner != address(0),
922             "ERC721: owner query for nonexistent token"
923         );
924         return owner;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-name}.
929      */
930     function name() public view virtual override returns (string memory) {
931         return _name;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-symbol}.
936      */
937     function symbol() public view virtual override returns (string memory) {
938         return _symbol;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-tokenURI}.
943      */
944     function tokenURI(uint256 tokenId)
945         public
946         virtual
947         override
948         returns (string memory)
949     {
950         require(
951             _exists(tokenId),
952             "ERC721Metadata: URI query for nonexistent token"
953         );
954 
955         string memory baseURI = _baseURI();
956         return
957             bytes(baseURI).length > 0
958                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
959                 : "";
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overridden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return "";
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public virtual override {
975         address owner = ERC721.ownerOf(tokenId);
976         require(to != owner, "ERC721: approval to current owner");
977 
978         require(
979             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
980             "ERC721: approve caller is not owner nor approved for all"
981         );
982         if (to.isContract()) {
983             revert("Token transfer to contract address is not allowed.");
984         } else {
985             _approve(to, tokenId);
986         }
987         // _approve(to, tokenId);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId)
994         public
995         view
996         virtual
997         override
998         returns (address)
999     {
1000         require(
1001             _exists(tokenId),
1002             "ERC721: approved query for nonexistent token"
1003         );
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved)
1012         public
1013         virtual
1014         override
1015     {
1016         _setApprovalForAll(_msgSender(), operator, approved);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-isApprovedForAll}.
1021      */
1022     function isApprovedForAll(address owner, address operator)
1023         public
1024         view
1025         virtual
1026         override
1027         returns (bool)
1028     {
1029         return _operatorApprovals[owner][operator];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-transferFrom}.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         //solhint-disable-next-line max-line-length
1041         require(
1042             _isApprovedOrOwner(_msgSender(), tokenId),
1043             "ERC721: transfer caller is not owner nor approved"
1044         );
1045 
1046         _transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         safeTransferFrom(from, to, tokenId, "");
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) public virtual override {
1069         require(
1070             _isApprovedOrOwner(_msgSender(), tokenId),
1071             "ERC721: transfer caller is not owner nor approved"
1072         );
1073         _safeTransfer(from, to, tokenId, _data);
1074     }
1075 
1076     /**
1077      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1078      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1079      *
1080      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1081      *
1082      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1083      * implement alternative mechanisms to perform token transfer, such as signature-based.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must exist and be owned by `from`.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _safeTransfer(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) internal virtual {
1100         _transfer(from, to, tokenId);
1101         require(
1102             _checkOnERC721Received(from, to, tokenId, _data),
1103             "ERC721: transfer to non ERC721Receiver implementer"
1104         );
1105     }
1106 
1107     /**
1108      * @dev Returns whether `tokenId` exists.
1109      *
1110      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1111      *
1112      * Tokens start existing when they are minted (`_mint`),
1113      * and stop existing when they are burned (`_burn`).
1114      */
1115     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1116         return _owners[tokenId] != address(0);
1117     }
1118 
1119     /**
1120      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      */
1126     function _isApprovedOrOwner(address spender, uint256 tokenId)
1127         internal
1128         view
1129         virtual
1130         returns (bool)
1131     {
1132         require(
1133             _exists(tokenId),
1134             "ERC721: operator query for nonexistent token"
1135         );
1136         address owner = ERC721.ownerOf(tokenId);
1137         return (spender == owner ||
1138             getApproved(tokenId) == spender ||
1139             isApprovedForAll(owner, spender));
1140     }
1141 
1142     /**
1143      * @dev Safely mints `tokenId` and transfers it to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `tokenId` must not exist.
1148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _safeMint(address to, uint256 tokenId) internal virtual {
1153         _safeMint(to, tokenId, "");
1154     }
1155 
1156     /**
1157      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1158      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1159      */
1160     function _safeMint(
1161         address to,
1162         uint256 tokenId,
1163         bytes memory _data
1164     ) internal virtual {
1165         _mint(to, tokenId);
1166         require(
1167             _checkOnERC721Received(address(0), to, tokenId, _data),
1168             "ERC721: transfer to non ERC721Receiver implementer"
1169         );
1170     }
1171 
1172     /**
1173      * @dev Mints `tokenId` and transfers it to `to`.
1174      *
1175      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must not exist.
1180      * - `to` cannot be the zero address.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _mint(address to, uint256 tokenId) internal virtual {
1185         require(to != address(0), "ERC721: mint to the zero address");
1186         require(!_exists(tokenId), "ERC721: token already minted");
1187 
1188         _beforeTokenTransfer(address(0), to, tokenId);
1189 
1190         _balances[to] += 1;
1191         _owners[tokenId] = to;
1192 
1193         emit Transfer(address(0), to, tokenId);
1194 
1195         _afterTokenTransfer(address(0), to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev Destroys `tokenId`.
1200      * The approval is cleared when the token is burned.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _burn(uint256 tokenId) internal virtual {
1209         address owner = ERC721.ownerOf(tokenId);
1210 
1211         _beforeTokenTransfer(owner, address(0), tokenId);
1212 
1213         // Clear approvals
1214         _approve(address(0), tokenId);
1215 
1216         _balances[owner] -= 1;
1217         delete _owners[tokenId];
1218 
1219         emit Transfer(owner, address(0), tokenId);
1220 
1221         _afterTokenTransfer(owner, address(0), tokenId);
1222     }
1223 
1224     /**
1225      * @dev Transfers `tokenId` from `from` to `to`.
1226      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1227      *
1228      * Requirements:
1229      *
1230      * - `to` cannot be the zero address.
1231      * - `tokenId` token must be owned by `from`.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _transfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {
1240         require(
1241             ERC721.ownerOf(tokenId) == from,
1242             "ERC721: transfer from incorrect owner"
1243         );
1244         require(to != address(0), "ERC721: transfer to the zero address");
1245 
1246         _beforeTokenTransfer(from, to, tokenId);
1247 
1248         // Clear approvals from the previous owner
1249         _approve(address(0), tokenId);
1250 
1251         _balances[from] -= 1;
1252         _balances[to] += 1;
1253         _owners[tokenId] = to;
1254 
1255         emit Transfer(from, to, tokenId);
1256 
1257         _afterTokenTransfer(from, to, tokenId);
1258     }
1259 
1260     /**
1261      * @dev Approve `to` to operate on `tokenId`
1262      *
1263      * Emits a {Approval} event.
1264      */
1265     function _approve(address to, uint256 tokenId) internal virtual {
1266         _tokenApprovals[tokenId] = to;
1267         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Approve `operator` to operate on all of `owner` tokens
1272      *
1273      * Emits a {ApprovalForAll} event.
1274      */
1275     function _setApprovalForAll(
1276         address owner,
1277         address operator,
1278         bool approved
1279     ) internal virtual {
1280         require(owner != operator, "ERC721: approve to caller");
1281         _operatorApprovals[owner][operator] = approved;
1282         emit ApprovalForAll(owner, operator, approved);
1283     }
1284 
1285     /**
1286      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1287      * The call is not executed if the target address is not a contract.
1288      *
1289      * @param from address representing the previous owner of the given token ID
1290      * @param to target address that will receive the tokens
1291      * @param tokenId uint256 ID of the token to be transferred
1292      * @param _data bytes optional data to send along with the call
1293      * @return bool whether the call correctly returned the expected magic value
1294      */
1295     function _checkOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         if (to.isContract()) {
1302             try
1303                 IERC721Receiver(to).onERC721Received(
1304                     _msgSender(),
1305                     from,
1306                     tokenId,
1307                     _data
1308                 )
1309             returns (bytes4 retval) {
1310                 return retval == IERC721Receiver.onERC721Received.selector;
1311             } catch (bytes memory reason) {
1312                 if (reason.length == 0) {
1313                     revert(
1314                         "ERC721: transfer to non ERC721Receiver implementer"
1315                     );
1316                 } else {
1317                     assembly {
1318                         revert(add(32, reason), mload(reason))
1319                     }
1320                 }
1321             }
1322         } else {
1323             return true;
1324         }
1325     }
1326 
1327     /**
1328      * @dev Hook that is called before any token transfer. This includes minting
1329      * and burning.
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1337      * - `from` and `to` are never both zero.
1338      *
1339      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1340      */
1341     function _beforeTokenTransfer(
1342         address from,
1343         address to,
1344         uint256 tokenId
1345     ) internal virtual {}
1346 
1347     /**
1348      * @dev Hook that is called after any transfer of tokens. This includes
1349      * minting and burning.
1350      *
1351      * Calling conditions:
1352      *
1353      * - when `from` and `to` are both non-zero.
1354      * - `from` and `to` are never both zero.
1355      *
1356      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1357      */
1358     function _afterTokenTransfer(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) internal virtual {}
1363 }
1364 
1365 // File 10: IERC721Enumerable.sol
1366 
1367 pragma solidity ^0.8.0;
1368 
1369 /**
1370  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1371  * @dev See https://eips.ethereum.org/EIPS/eip-721
1372  */
1373 interface IERC721Enumerable is IERC721 {
1374     /**
1375      * @dev Returns the total amount of tokens stored by the contract.
1376      */
1377     function totalSupply() external view returns (uint256);
1378 
1379     /**
1380      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1381      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1382      */
1383     function tokenOfOwnerByIndex(address owner, uint256 index)
1384         external
1385         view
1386         returns (uint256 tokenId);
1387 
1388     /**
1389      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1390      * Use along with {totalSupply} to enumerate all tokens.
1391      */
1392     function tokenByIndex(uint256 index) external view returns (uint256);
1393 }
1394 
1395 // File 11: ERC721Enumerable.sol
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 /**
1400  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1401  * enumerability of all the token ids in the contract as well as all token ids owned by each
1402  * account.
1403  */
1404 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1405     // Mapping from owner to list of owned token IDs
1406     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1407 
1408     // Mapping from token ID to index of the owner tokens list
1409     mapping(uint256 => uint256) private _ownedTokensIndex;
1410 
1411     // Array with all token ids, used for enumeration
1412     uint256[] private _allTokens;
1413 
1414     // Mapping from token id to position in the allTokens array
1415     mapping(uint256 => uint256) private _allTokensIndex;
1416 
1417     /**
1418      * @dev See {IERC165-supportsInterface}.
1419      */
1420     function supportsInterface(bytes4 interfaceId)
1421         public
1422         view
1423         virtual
1424         override(IERC165, ERC721)
1425         returns (bool)
1426     {
1427         return
1428             interfaceId == type(IERC721Enumerable).interfaceId ||
1429             super.supportsInterface(interfaceId);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1434      */
1435     function tokenOfOwnerByIndex(address owner, uint256 index)
1436         public
1437         view
1438         virtual
1439         override
1440         returns (uint256)
1441     {
1442         require(
1443             index < ERC721.balanceOf(owner),
1444             "ERC721Enumerable: owner index out of bounds"
1445         );
1446         return _ownedTokens[owner][index];
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-totalSupply}.
1451      */
1452     function totalSupply() public view virtual override returns (uint256) {
1453         return _allTokens.length;
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-tokenByIndex}.
1458      */
1459     function tokenByIndex(uint256 index)
1460         public
1461         view
1462         virtual
1463         override
1464         returns (uint256)
1465     {
1466         require(
1467             index < ERC721Enumerable.totalSupply(),
1468             "ERC721Enumerable: global index out of bounds"
1469         );
1470         return _allTokens[index];
1471     }
1472 
1473     /**
1474      * @dev Hook that is called before any token transfer. This includes minting
1475      * and burning.
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` will be minted for `to`.
1482      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1483      * - `from` cannot be the zero address.
1484      * - `to` cannot be the zero address.
1485      *
1486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1487      */
1488     function _beforeTokenTransfer(
1489         address from,
1490         address to,
1491         uint256 tokenId
1492     ) internal virtual override {
1493         super._beforeTokenTransfer(from, to, tokenId);
1494 
1495         if (from == address(0)) {
1496             _addTokenToAllTokensEnumeration(tokenId);
1497         } else if (from != to) {
1498             _removeTokenFromOwnerEnumeration(from, tokenId);
1499         }
1500         if (to == address(0)) {
1501             _removeTokenFromAllTokensEnumeration(tokenId);
1502         } else if (to != from) {
1503             _addTokenToOwnerEnumeration(to, tokenId);
1504         }
1505     }
1506 
1507     /**
1508      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1509      * @param to address representing the new owner of the given token ID
1510      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1511      */
1512     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1513         uint256 length = ERC721.balanceOf(to);
1514         _ownedTokens[to][length] = tokenId;
1515         _ownedTokensIndex[tokenId] = length;
1516     }
1517 
1518     /**
1519      * @dev Private function to add a token to this extension's token tracking data structures.
1520      * @param tokenId uint256 ID of the token to be added to the tokens list
1521      */
1522     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1523         _allTokensIndex[tokenId] = _allTokens.length;
1524         _allTokens.push(tokenId);
1525     }
1526 
1527     /**
1528      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1529      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1530      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1531      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1532      * @param from address representing the previous owner of the given token ID
1533      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1534      */
1535     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1536         private
1537     {
1538         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1539         // then delete the last slot (swap and pop).
1540 
1541         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1542         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1543 
1544         // When the token to delete is the last token, the swap operation is unnecessary
1545         if (tokenIndex != lastTokenIndex) {
1546             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1547 
1548             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1549             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1550         }
1551 
1552         // This also deletes the contents at the last position of the array
1553         delete _ownedTokensIndex[tokenId];
1554         delete _ownedTokens[from][lastTokenIndex];
1555     }
1556 
1557     /**
1558      * @dev Private function to remove a token from this extension's token tracking data structures.
1559      * This has O(1) time complexity, but alters the order of the _allTokens array.
1560      * @param tokenId uint256 ID of the token to be removed from the tokens list
1561      */
1562     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1563         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1564         // then delete the last slot (swap and pop).
1565 
1566         uint256 lastTokenIndex = _allTokens.length - 1;
1567         uint256 tokenIndex = _allTokensIndex[tokenId];
1568 
1569         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1570         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1571         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1572         uint256 lastTokenId = _allTokens[lastTokenIndex];
1573 
1574         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1575         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1576 
1577         // This also deletes the contents at the last position of the array
1578         delete _allTokensIndex[tokenId];
1579         _allTokens.pop();
1580     }
1581 }
1582 
1583 // File 12: IERC721Receiver.sol
1584 
1585 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1586 
1587 pragma solidity ^0.8.0;
1588 
1589 /**
1590  * @title ERC721 token receiver interface
1591  * @dev Interface for any contract that wants to support safeTransfers
1592  * from ERC721 asset contracts.
1593  */
1594 interface IERC721Receiver {
1595     /**
1596      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1597      * by `operator` from `from`, this function is called.
1598      *
1599      * It must return its Solidity selector to confirm the token transfer.
1600      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1601      *
1602      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1603      */
1604     function onERC721Received(
1605         address operator,
1606         address from,
1607         uint256 tokenId,
1608         bytes calldata data
1609     ) external returns (bytes4);
1610 }
1611 
1612 // File 13: ERC721A.sol
1613 
1614 pragma solidity ^0.8.0;
1615 
1616 contract ERC721A is
1617     Context,
1618     ERC165,
1619     IERC721,
1620     IERC721Metadata,
1621     IERC721Enumerable
1622 {
1623     using Address for address;
1624     using Strings for uint256;
1625 
1626     struct TokenOwnership {
1627         address addr;
1628         uint64 startTimestamp;
1629     }
1630 
1631     struct AddressData {
1632         uint128 balance;
1633         uint128 numberMinted;
1634     }
1635 
1636     uint256 internal currentIndex = 1;
1637 
1638     // Token name
1639     string private _name;
1640 
1641     // Token symbol
1642     string private _symbol;
1643 
1644     // Mapping from token ID to ownership details
1645     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1646     mapping(uint256 => TokenOwnership) internal _ownerships;
1647 
1648     // Mapping owner address to address data
1649     mapping(address => AddressData) private _addressData;
1650 
1651     // Mapping from token ID to approved address
1652     mapping(uint256 => address) private _tokenApprovals;
1653 
1654     // Mapping from owner to operator approvals
1655     mapping(address => mapping(address => bool)) private _operatorApprovals;
1656 
1657     constructor(string memory name_, string memory symbol_) {
1658         _name = name_;
1659         _symbol = symbol_;
1660     }
1661 
1662     /**
1663      * @dev See {IERC721Enumerable-totalSupply}.
1664      */
1665     function totalSupply() public view virtual override returns (uint256) {
1666         return currentIndex;
1667     }
1668 
1669     /**
1670      * @dev See {IERC721Enumerable-tokenByIndex}.
1671      */
1672     function tokenByIndex(uint256 index)
1673         public
1674         view
1675         override
1676         returns (uint256)
1677     {
1678         require(index < totalSupply(), "ERC721A: global index out of bounds");
1679         return index;
1680     }
1681 
1682     /**
1683      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1684      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1685      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1686      */
1687     function tokenOfOwnerByIndex(address owner, uint256 index)
1688         public
1689         view
1690         override
1691         returns (uint256)
1692     {
1693         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1694         uint256 numMintedSoFar = totalSupply();
1695         uint256 tokenIdsIdx;
1696         address currOwnershipAddr;
1697 
1698         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1699         unchecked {
1700             for (uint256 i; i < numMintedSoFar; i++) {
1701                 TokenOwnership memory ownership = _ownerships[i];
1702                 if (ownership.addr != address(0)) {
1703                     currOwnershipAddr = ownership.addr;
1704                 }
1705                 if (currOwnershipAddr == owner) {
1706                     if (tokenIdsIdx == index) {
1707                         return i;
1708                     }
1709                     tokenIdsIdx++;
1710                 }
1711             }
1712         }
1713 
1714         revert("ERC721A: unable to get token of owner by index");
1715     }
1716 
1717     /**
1718      * @dev See {IERC165-supportsInterface}.
1719      */
1720     function supportsInterface(bytes4 interfaceId)
1721         public
1722         view
1723         virtual
1724         override(ERC165, IERC165)
1725         returns (bool)
1726     {
1727         return
1728             interfaceId == type(IERC721).interfaceId ||
1729             interfaceId == type(IERC721Metadata).interfaceId ||
1730             interfaceId == type(IERC721Enumerable).interfaceId ||
1731             super.supportsInterface(interfaceId);
1732     }
1733 
1734     /**
1735      * @dev See {IERC721-balanceOf}.
1736      */
1737     function balanceOf(address owner) public view override returns (uint256) {
1738         require(
1739             owner != address(0),
1740             "ERC721A: balance query for the zero address"
1741         );
1742         return uint256(_addressData[owner].balance);
1743     }
1744 
1745     function _numberMinted(address owner) internal view returns (uint256) {
1746         require(
1747             owner != address(0),
1748             "ERC721A: number minted query for the zero address"
1749         );
1750         return uint256(_addressData[owner].numberMinted);
1751     }
1752 
1753     /**
1754      * Gas spent here starts off proportional to the maximum mint batch size.
1755      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1756      */
1757     function ownershipOf(uint256 tokenId)
1758         internal
1759         view
1760         returns (TokenOwnership memory)
1761     {
1762         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1763 
1764         unchecked {
1765             for (uint256 curr = tokenId; curr >= 0; curr--) {
1766                 TokenOwnership memory ownership = _ownerships[curr];
1767                 if (ownership.addr != address(0)) {
1768                     return ownership;
1769                 }
1770             }
1771         }
1772 
1773         revert("ERC721A: unable to determine the owner of token");
1774     }
1775 
1776     /**
1777      * @dev See {IERC721-ownerOf}.
1778      */
1779     function ownerOf(uint256 tokenId) public view override returns (address) {
1780         return ownershipOf(tokenId).addr;
1781     }
1782 
1783     /**
1784      * @dev See {IERC721Metadata-name}.
1785      */
1786     function name() public view virtual override returns (string memory) {
1787         return _name;
1788     }
1789 
1790     /**
1791      * @dev See {IERC721Metadata-symbol}.
1792      */
1793     function symbol() public view virtual override returns (string memory) {
1794         return _symbol;
1795     }
1796 
1797     /**
1798      * @dev See {IERC721Metadata-tokenURI}.
1799      */
1800     function tokenURI(uint256 tokenId)
1801         public
1802         view
1803         virtual
1804         override
1805         returns (string memory)
1806     {
1807         require(
1808             _exists(tokenId),
1809             "ERC721Metadata: URI query for nonexistent token"
1810         );
1811 
1812         string memory baseURI = _baseURI();
1813         return
1814             bytes(baseURI).length != 0
1815                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1816                 : "";
1817     }
1818 
1819     /**
1820      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1821      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1822      * by default, can be overriden in child contracts.
1823      */
1824     function _baseURI() internal view virtual returns (string memory) {
1825         return "";
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-approve}.
1830      */
1831     function approve(address to, uint256 tokenId) public override {
1832         address owner = ERC721A.ownerOf(tokenId);
1833         require(to != owner, "ERC721A: approval to current owner");
1834 
1835         require(
1836             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1837             "ERC721A: approve caller is not owner nor approved for all"
1838         );
1839 
1840         _approve(to, tokenId, owner);
1841     }
1842 
1843     /**
1844      * @dev See {IERC721-getApproved}.
1845      */
1846     function getApproved(uint256 tokenId)
1847         public
1848         view
1849         override
1850         returns (address)
1851     {
1852         require(
1853             _exists(tokenId),
1854             "ERC721A: approved query for nonexistent token"
1855         );
1856 
1857         return _tokenApprovals[tokenId];
1858     }
1859 
1860     /**
1861      * @dev See {IERC721-setApprovalForAll}.
1862      */
1863     function setApprovalForAll(address operator, bool approved)
1864         public
1865         override
1866     {
1867         require(operator != _msgSender(), "ERC721A: approve to caller");
1868 
1869         _operatorApprovals[_msgSender()][operator] = approved;
1870         emit ApprovalForAll(_msgSender(), operator, approved);
1871     }
1872 
1873     /**
1874      * @dev See {IERC721-isApprovedForAll}.
1875      */
1876     function isApprovedForAll(address owner, address operator)
1877         public
1878         view
1879         virtual
1880         override
1881         returns (bool)
1882     {
1883         return _operatorApprovals[owner][operator];
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-transferFrom}.
1888      */
1889     function transferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId
1893     ) public override {
1894         _transfer(from, to, tokenId);
1895     }
1896 
1897     /**
1898      * @dev See {IERC721-safeTransferFrom}.
1899      */
1900     function safeTransferFrom(
1901         address from,
1902         address to,
1903         uint256 tokenId
1904     ) public override {
1905         safeTransferFrom(from, to, tokenId, "");
1906     }
1907 
1908     /**
1909      * @dev See {IERC721-safeTransferFrom}.
1910      */
1911     function safeTransferFrom(
1912         address from,
1913         address to,
1914         uint256 tokenId,
1915         bytes memory _data
1916     ) public override {
1917         _transfer(from, to, tokenId);
1918         require(
1919             _checkOnERC721Received(from, to, tokenId, _data),
1920             "ERC721A: transfer to non ERC721Receiver implementer"
1921         );
1922     }
1923 
1924     /**
1925      * @dev Returns whether `tokenId` exists.
1926      *
1927      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1928      *
1929      * Tokens start existing when they are minted (`_mint`),
1930      */
1931     function _exists(uint256 tokenId) internal view returns (bool) {
1932         return tokenId < currentIndex;
1933     }
1934 
1935     function _safeMint(address to, uint256 quantity) internal {
1936         _safeMint(to, quantity, "");
1937     }
1938 
1939     /**
1940      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1941      *
1942      * Requirements:
1943      *
1944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1945      * - `quantity` must be greater than 0.
1946      *
1947      * Emits a {Transfer} event.
1948      */
1949     function _safeMint(
1950         address to,
1951         uint256 quantity,
1952         bytes memory _data
1953     ) internal {
1954         _mint(to, quantity, _data, true);
1955     }
1956 
1957     /**
1958      * @dev Mints `quantity` tokens and transfers them to `to`.
1959      *
1960      * Requirements:
1961      *
1962      * - `to` cannot be the zero address.
1963      * - `quantity` must be greater than 0.
1964      *
1965      * Emits a {Transfer} event.
1966      */
1967     function _mint(
1968         address to,
1969         uint256 quantity,
1970         bytes memory _data,
1971         bool safe
1972     ) internal {
1973         uint256 startTokenId = currentIndex;
1974         require(to != address(0), "ERC721A: mint to the zero address");
1975         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1976 
1977         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1978 
1979         // Overflows are incredibly unrealistic.
1980         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1981         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1982         unchecked {
1983             _addressData[to].balance += uint128(quantity);
1984             _addressData[to].numberMinted += uint128(quantity);
1985 
1986             _ownerships[startTokenId].addr = to;
1987             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1988 
1989             uint256 updatedIndex = startTokenId;
1990 
1991             for (uint256 i; i < quantity; i++) {
1992                 emit Transfer(address(0), to, updatedIndex);
1993                 if (safe) {
1994                     require(
1995                         _checkOnERC721Received(
1996                             address(0),
1997                             to,
1998                             updatedIndex,
1999                             _data
2000                         ),
2001                         "ERC721A: transfer to non ERC721Receiver implementer"
2002                     );
2003                 }
2004 
2005                 updatedIndex++;
2006             }
2007 
2008             currentIndex = updatedIndex;
2009         }
2010 
2011         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2012     }
2013 
2014     /**
2015      * @dev Transfers `tokenId` from `from` to `to`.
2016      *
2017      * Requirements:
2018      *
2019      * - `to` cannot be the zero address.
2020      * - `tokenId` token must be owned by `from`.
2021      *
2022      * Emits a {Transfer} event.
2023      */
2024     function _transfer(
2025         address from,
2026         address to,
2027         uint256 tokenId
2028     ) private {
2029         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2030 
2031         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2032             getApproved(tokenId) == _msgSender() ||
2033             isApprovedForAll(prevOwnership.addr, _msgSender()));
2034 
2035         require(
2036             isApprovedOrOwner,
2037             "ERC721A: transfer caller is not owner nor approved"
2038         );
2039 
2040         require(
2041             prevOwnership.addr == from,
2042             "ERC721A: transfer from incorrect owner"
2043         );
2044         require(to != address(0), "ERC721A: transfer to the zero address");
2045 
2046         _beforeTokenTransfers(from, to, tokenId, 1);
2047 
2048         // Clear approvals from the previous owner
2049         _approve(address(0), tokenId, prevOwnership.addr);
2050 
2051         // Underflow of the sender's balance is impossible because we check for
2052         // ownership above and the recipient's balance can't realistically overflow.
2053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2054         unchecked {
2055             _addressData[from].balance -= 1;
2056             _addressData[to].balance += 1;
2057 
2058             _ownerships[tokenId].addr = to;
2059             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2060 
2061             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2063             uint256 nextTokenId = tokenId + 1;
2064             if (_ownerships[nextTokenId].addr == address(0)) {
2065                 if (_exists(nextTokenId)) {
2066                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2067                     _ownerships[nextTokenId].startTimestamp = prevOwnership
2068                         .startTimestamp;
2069                 }
2070             }
2071         }
2072 
2073         emit Transfer(from, to, tokenId);
2074         _afterTokenTransfers(from, to, tokenId, 1);
2075     }
2076 
2077     /**
2078      * @dev Approve `to` to operate on `tokenId`
2079      *
2080      * Emits a {Approval} event.
2081      */
2082     function _approve(
2083         address to,
2084         uint256 tokenId,
2085         address owner
2086     ) private {
2087         _tokenApprovals[tokenId] = to;
2088         emit Approval(owner, to, tokenId);
2089     }
2090 
2091     /**
2092      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2093      * The call is not executed if the target address is not a contract.
2094      *
2095      * @param from address representing the previous owner of the given token ID
2096      * @param to target address that will receive the tokens
2097      * @param tokenId uint256 ID of the token to be transferred
2098      * @param _data bytes optional data to send along with the call
2099      * @return bool whether the call correctly returned the expected magic value
2100      */
2101     function _checkOnERC721Received(
2102         address from,
2103         address to,
2104         uint256 tokenId,
2105         bytes memory _data
2106     ) private returns (bool) {
2107         if (to.isContract()) {
2108             try
2109                 IERC721Receiver(to).onERC721Received(
2110                     _msgSender(),
2111                     from,
2112                     tokenId,
2113                     _data
2114                 )
2115             returns (bytes4 retval) {
2116                 return retval == IERC721Receiver(to).onERC721Received.selector;
2117             } catch (bytes memory reason) {
2118                 if (reason.length == 0) {
2119                     revert(
2120                         "ERC721A: transfer to non ERC721Receiver implementer"
2121                     );
2122                 } else {
2123                     assembly {
2124                         revert(add(32, reason), mload(reason))
2125                     }
2126                 }
2127             }
2128         } else {
2129             return true;
2130         }
2131     }
2132 
2133     /**
2134      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2135      *
2136      * startTokenId - the first token id to be transferred
2137      * quantity - the amount to be transferred
2138      *
2139      * Calling conditions:
2140      *
2141      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2142      * transferred to `to`.
2143      * - When `from` is zero, `tokenId` will be minted for `to`.
2144      */
2145     function _beforeTokenTransfers(
2146         address from,
2147         address to,
2148         uint256 startTokenId,
2149         uint256 quantity
2150     ) internal virtual {}
2151 
2152     /**
2153      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2154      * minting.
2155      *
2156      * startTokenId - the first token id to be transferred
2157      * quantity - the amount to be transferred
2158      *
2159      * Calling conditions:
2160      *
2161      * - when `from` and `to` are both non-zero.
2162      * - `from` and `to` are never both zero.
2163      */
2164     function _afterTokenTransfers(
2165         address from,
2166         address to,
2167         uint256 startTokenId,
2168         uint256 quantity
2169     ) internal virtual {}
2170 }
2171 
2172 // FILE 14: MAGC.sol
2173 
2174 pragma solidity ^0.8.0;
2175 
2176 contract MutantApeGangClub is ERC721A, Ownable, ReentrancyGuard {
2177     using Strings for uint256;
2178     using Counters for Counters.Counter;
2179 
2180     string private uriPrefix = "";
2181     string public uriSuffix = ".json";
2182     string private hiddenMetadataUri;
2183 
2184     constructor() ERC721A("MutantApeGangClub", "MAGC") {
2185         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
2186     }
2187 
2188     uint256 public salePrice = 0.003 ether;
2189     uint256 public maxPerTx = 10;
2190     uint256 public maxPerFree = 2;
2191     uint256 public maxFreeSupply = 2000;
2192     uint256 public maxSupply = 10000;
2193 
2194     bool public paused = true;
2195     bool public revealed = true;
2196 
2197     function withdraw() external onlyOwner {
2198         (bool success, ) = payable(msg.sender).call{
2199             value: address(this).balance
2200         }("");
2201         require(success, "Transfer failed.");
2202     }
2203 
2204     /**
2205      * @notice Team Mint
2206      */
2207     function teamMint(uint256 quantity) external onlyOwner {
2208         require(!paused, "The contract is paused!");
2209         _safeMint(msg.sender, quantity);
2210     }
2211 
2212     /**
2213      * @notice Pre Mint
2214      */
2215     function preMint(uint256 quantity) external payable {
2216         require(!paused, "The contract is paused!");
2217         require(totalSupply() < maxFreeSupply, "Pre sale is not active.");
2218         mint(quantity);
2219     }
2220 
2221     /**
2222      * @notice Public Mint
2223      */
2224     function publicMint(uint256 quantity) external payable {
2225         require(!paused, "The contract is paused!");
2226         require(totalSupply() >= maxFreeSupply, "Public sale is not active.");
2227         mint(quantity);
2228     }
2229 
2230     /**
2231      * @notice mint
2232      */
2233     function mint(uint256 _quantity) internal {
2234         uint256 price = salePrice;
2235         uint256 quantity = _quantity;
2236         require(
2237             _quantity > 0,
2238             "Minimum 1 NFT has to be minted per transaction"
2239         );
2240         require(
2241             _quantity <= maxPerTx && _quantity > 0,
2242             "Invalid quantity or Max Per Tx."
2243         );
2244         require(_quantity + totalSupply() <= maxSupply, "Sold out");
2245         if (msg.sender != owner()) {
2246             bool isFree = ((totalSupply() + _quantity <= maxFreeSupply) && (_quantity <= maxPerFree));
2247             if (isFree) {
2248                 price = 0;
2249             } else {
2250                 if (totalSupply() < maxFreeSupply) {
2251                     quantity = _quantity - (maxFreeSupply - totalSupply());
2252                 } else {
2253                     price = price / 2; 
2254                 }
2255             }
2256             if (quantity % 2 == 0) {
2257                 require(msg.value >= price * quantity, "Not enough ETH to mint"); 
2258             } else {
2259                 require(msg.value >= price * (quantity - 1) + salePrice, "Not enough ETH to mint"); 
2260             }
2261         }
2262         _safeMint(msg.sender, _quantity);
2263     }
2264 
2265     /**
2266      * @notice airdrop
2267      */
2268     function airdrop(address _to, uint256 _quantity) external onlyOwner {
2269         require(!paused, "The contract is paused!");
2270         require(_quantity + totalSupply() <= maxSupply, "Sold out");
2271         _safeMint(_to, _quantity);
2272     }
2273 
2274     function walletOfOwner(address _owner)
2275         public
2276         view
2277         returns (uint256[] memory)
2278     {
2279         uint256 ownerTokenCount = balanceOf(_owner);
2280         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2281         uint256 currentTokenId = 1;
2282         uint256 ownedTokenIndex = 0;
2283 
2284         while (
2285             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
2286         ) {
2287             address currentTokenOwner = ownerOf(currentTokenId);
2288             if (currentTokenOwner == _owner) {
2289                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2290                 ownedTokenIndex++;
2291             }
2292             currentTokenId++;
2293         }
2294         return ownedTokenIds;
2295     }
2296 
2297     function tokenURI(uint256 _tokenId)
2298         public
2299         view
2300         virtual
2301         override
2302         returns (string memory)
2303     {
2304         require(
2305             _exists(_tokenId),
2306             "ERC721Metadata: URI query for nonexistent token"
2307         );
2308         if (revealed == false) {
2309             return hiddenMetadataUri;
2310         }
2311         string memory currentBaseURI = _baseURI();
2312         return
2313             bytes(currentBaseURI).length > 0
2314                 ? string(
2315                     abi.encodePacked(
2316                         currentBaseURI,
2317                         _tokenId.toString(),
2318                         uriSuffix
2319                     )
2320                 )
2321                 : "";
2322     }
2323 
2324     function setPaused(bool _state) public onlyOwner {
2325         paused = _state;
2326     }
2327 
2328     function setRevealed(bool _state) public onlyOwner {
2329         revealed = _state;
2330     }
2331 
2332     function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
2333         maxPerTx = _maxPerTx;
2334     }
2335 
2336     function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2337         maxPerFree = _maxPerFree;
2338     }
2339 
2340     function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2341         maxFreeSupply = _maxFreeSupply;
2342     }
2343 
2344     function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2345         maxSupply = _maxSupply;
2346     }
2347 
2348     function setSalePrice(uint256 _salePrice) external onlyOwner {
2349         salePrice = _salePrice;
2350     }
2351 
2352     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2353         public
2354         onlyOwner
2355     {
2356         hiddenMetadataUri = _hiddenMetadataUri;
2357     }
2358 
2359     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2360         uriPrefix = _uriPrefix;
2361     }
2362 
2363     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2364         uriSuffix = _uriSuffix;
2365     }
2366 
2367     function _baseURI() internal view virtual override returns (string memory) {
2368         return uriPrefix;
2369     }
2370 }