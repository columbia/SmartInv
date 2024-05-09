1 // SPDX-License-Identifier: MIT
2 
3 /*
4 name - Shinigami AI
5 supply- 333
6 cost - 0.004 - max 5 per wallet 
7 
8 
9 ░██████╗██╗░░██╗██╗███╗░░██╗██╗░██████╗░░█████╗░███╗░░░███╗██╗  ░█████╗░██╗
10 ██╔════╝██║░░██║██║████╗░██║██║██╔════╝░██╔══██╗████╗░████║██║  ██╔══██╗██║
11 ╚█████╗░███████║██║██╔██╗██║██║██║░░██╗░███████║██╔████╔██║██║  ███████║██║
12 ░╚═══██╗██╔══██║██║██║╚████║██║██║░░╚██╗██╔══██║██║╚██╔╝██║██║  ██╔══██║██║
13 ██████╔╝██║░░██║██║██║░╚███║██║╚██████╔╝██║░░██║██║░╚═╝░██║██║  ██║░░██║██║
14 ╚═════╝░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝  ╚═╝░░╚═╝╚═╝
15 
16 
17 // File: @openzeppelin/contracts/utils/Strings.sol
18 
19 
20 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev String operations.
26  */
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29     uint8 private constant _ADDRESS_LENGTH = 20;
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
89      */
90     function toHexString(address addr) internal pure returns (string memory) {
91         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Address.sol
96 
97 
98 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
99 
100 pragma solidity ^0.8.1;
101 
102 /**
103  * @dev Collection of functions related to the address type
104  */
105 library Address {
106     /**
107      * @dev Returns true if `account` is a contract.
108      *
109      * [IMPORTANT]
110      * ====
111      * It is unsafe to assume that an address for which this function returns
112      * false is an externally-owned account (EOA) and not a contract.
113      *
114      * Among others, `isContract` will return false for the following
115      * types of addresses:
116      *
117      *  - an externally-owned account
118      *  - a contract in construction
119      *  - an address where a contract will be created
120      *  - an address where a contract lived, but was destroyed
121      * ====
122      *
123      * [IMPORTANT]
124      * ====
125      * You shouldn't rely on `isContract` to protect against flash loan attacks!
126      *
127      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
128      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
129      * constructor.
130      * ====
131      */
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize/address.code.length, which returns 0
134         // for contracts in construction, since the code is only stored at the end
135         // of the constructor execution.
136 
137         return account.code.length > 0;
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      */
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162 
163     /**
164      * @dev Performs a Solidity function call using a low level `call`. A
165      * plain `call` is an unsafe replacement for a function call: use this
166      * function instead.
167      *
168      * If `target` reverts with a revert reason, it is bubbled up by this
169      * function (like regular Solidity function calls).
170      *
171      * Returns the raw returned data. To convert to the expected return value,
172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
173      *
174      * Requirements:
175      *
176      * - `target` must be a contract.
177      * - calling `target` with `data` must not revert.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, "Address: low-level call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
187      * `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, 0, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but also transferring `value` wei to `target`.
202      *
203      * Requirements:
204      *
205      * - the calling contract must have an ETH balance of at least `value`.
206      * - the called Solidity function must be `payable`.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
220      * with `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         require(address(this).balance >= value, "Address: insufficient balance for call");
231         require(isContract(target), "Address: call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.call{value: value}(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
244         return functionStaticCall(target, data, "Address: low-level static call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal view returns (bytes memory) {
258         require(isContract(target), "Address: static call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.staticcall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(isContract(target), "Address: delegate call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.delegatecall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
293      * revert reason using the provided one.
294      *
295      * _Available since v4.3._
296      */
297     function verifyCallResult(
298         bool success,
299         bytes memory returndata,
300         string memory errorMessage
301     ) internal pure returns (bytes memory) {
302         if (success) {
303             return returndata;
304         } else {
305             // Look for revert reason and bubble it up if present
306             if (returndata.length > 0) {
307                 // The easiest way to bubble the revert reason is using memory via assembly
308                 /// @solidity memory-safe-assembly
309                 assembly {
310                     let returndata_size := mload(returndata)
311                     revert(add(32, returndata), returndata_size)
312                 }
313             } else {
314                 revert(errorMessage);
315             }
316         }
317     }
318 }
319 
320 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Contract module that helps prevent reentrant calls to a function.
329  *
330  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
331  * available, which can be applied to functions to make sure there are no nested
332  * (reentrant) calls to them.
333  *
334  * Note that because there is a single `nonReentrant` guard, functions marked as
335  * `nonReentrant` may not call one another. This can be worked around by making
336  * those functions `private`, and then adding `external` `nonReentrant` entry
337  * points to them.
338  *
339  * TIP: If you would like to learn more about reentrancy and alternative ways
340  * to protect against it, check out our blog post
341  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
342  */
343 abstract contract ReentrancyGuard {
344     // Booleans are more expensive than uint256 or any type that takes up a full
345     // word because each write operation emits an extra SLOAD to first read the
346     // slot's contents, replace the bits taken up by the boolean, and then write
347     // back. This is the compiler's defense against contract upgrades and
348     // pointer aliasing, and it cannot be disabled.
349 
350     // The values being non-zero value makes deployment a bit more expensive,
351     // but in exchange the refund on every call to nonReentrant will be lower in
352     // amount. Since refunds are capped to a percentage of the total
353     // transaction's gas, it is best to keep them low in cases like this one, to
354     // increase the likelihood of the full refund coming into effect.
355     uint256 private constant _NOT_ENTERED = 1;
356     uint256 private constant _ENTERED = 2;
357 
358     uint256 private _status;
359 
360     constructor() {
361         _status = _NOT_ENTERED;
362     }
363 
364     /**
365      * @dev Prevents a contract from calling itself, directly or indirectly.
366      * Calling a `nonReentrant` function from another `nonReentrant`
367      * function is not supported. It is possible to prevent this from happening
368      * by making the `nonReentrant` function external, and making it call a
369      * `private` function that does the actual work.
370      */
371     modifier nonReentrant() {
372         // On the first call to nonReentrant, _notEntered will be true
373         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
374 
375         // Any calls to nonReentrant after this point will fail
376         _status = _ENTERED;
377 
378         _;
379 
380         // By storing the original value once again, a refund is triggered (see
381         // https://eips.ethereum.org/EIPS/eip-2200)
382         _status = _NOT_ENTERED;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/Context.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/access/Ownable.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership}.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be applied to your functions to restrict their use to
431  * the owner.
432  */
433 abstract contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor() {
442         _transferOwnership(_msgSender());
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         _checkOwner();
450         _;
451     }
452 
453     /**
454      * @dev Returns the address of the current owner.
455      */
456     function owner() public view virtual returns (address) {
457         return _owner;
458     }
459 
460     /**
461      * @dev Throws if the sender is not the owner.
462      */
463     function _checkOwner() internal view virtual {
464         require(owner() == _msgSender(), "Ownable: caller is not the owner");
465     }
466 
467     /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions anymore. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby removing any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public virtual onlyOwner {
475         _transferOwnership(address(0));
476     }
477 
478     /**
479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
480      * Can only be called by the current owner.
481      */
482     function transferOwnership(address newOwner) public virtual onlyOwner {
483         require(newOwner != address(0), "Ownable: new owner is the zero address");
484         _transferOwnership(newOwner);
485     }
486 
487     /**
488      * @dev Transfers ownership of the contract to a new account (`newOwner`).
489      * Internal function without access restriction.
490      */
491     function _transferOwnership(address newOwner) internal virtual {
492         address oldOwner = _owner;
493         _owner = newOwner;
494         emit OwnershipTransferred(oldOwner, newOwner);
495     }
496 }
497 
498 // File: erc721a/contracts/IERC721A.sol
499 
500 
501 // ERC721A Contracts v4.2.2
502 // Creator: Chiru Labs
503 
504 pragma solidity ^0.8.4;
505 
506 /**
507  * @dev Interface of ERC721A.
508  */
509 interface IERC721A {
510     /**
511      * The caller must own the token or be an approved operator.
512      */
513     error ApprovalCallerNotOwnerNorApproved();
514 
515     /**
516      * The token does not exist.
517      */
518     error ApprovalQueryForNonexistentToken();
519 
520     /**
521      * The caller cannot approve to their own address.
522      */
523     error ApproveToCaller();
524 
525     /**
526      * Cannot query the balance for the zero address.
527      */
528     error BalanceQueryForZeroAddress();
529 
530     /**
531      * Cannot mint to the zero address.
532      */
533     error MintToZeroAddress();
534 
535     /**
536      * The quantity of tokens minted must be more than zero.
537      */
538     error MintZeroQuantity();
539 
540     /**
541      * The token does not exist.
542      */
543     error OwnerQueryForNonexistentToken();
544 
545     /**
546      * The caller must own the token or be an approved operator.
547      */
548     error TransferCallerNotOwnerNorApproved();
549 
550     /**
551      * The token must be owned by `from`.
552      */
553     error TransferFromIncorrectOwner();
554 
555     /**
556      * Cannot safely transfer to a contract that does not implement the
557      * ERC721Receiver interface.
558      */
559     error TransferToNonERC721ReceiverImplementer();
560 
561     /**
562      * Cannot transfer to the zero address.
563      */
564     error TransferToZeroAddress();
565 
566     /**
567      * The token does not exist.
568      */
569     error URIQueryForNonexistentToken();
570 
571     /**
572      * The `quantity` minted with ERC2309 exceeds the safety limit.
573      */
574     error MintERC2309QuantityExceedsLimit();
575 
576     /**
577      * The `extraData` cannot be set on an unintialized ownership slot.
578      */
579     error OwnershipNotInitializedForExtraData();
580 
581     // =============================================================
582     //                            STRUCTS
583     // =============================================================
584 
585     struct TokenOwnership {
586         // The address of the owner.
587         address addr;
588         // Stores the start time of ownership with minimal overhead for tokenomics.
589         uint64 startTimestamp;
590         // Whether the token has been burned.
591         bool burned;
592         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
593         uint24 extraData;
594     }
595 
596     // =============================================================
597     //                         TOKEN COUNTERS
598     // =============================================================
599 
600     /**
601      * @dev Returns the total number of tokens in existence.
602      * Burned tokens will reduce the count.
603      * To get the total number of tokens minted, please see {_totalMinted}.
604      */
605     function totalSupply() external view returns (uint256);
606 
607     // =============================================================
608     //                            IERC165
609     // =============================================================
610 
611     /**
612      * @dev Returns true if this contract implements the interface defined by
613      * `interfaceId`. See the corresponding
614      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
615      * to learn more about how these ids are created.
616      *
617      * This function call must use less than 30000 gas.
618      */
619     function supportsInterface(bytes4 interfaceId) external view returns (bool);
620 
621     // =============================================================
622     //                            IERC721
623     // =============================================================
624 
625     /**
626      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
627      */
628     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
629 
630     /**
631      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
632      */
633     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables or disables
637      * (`approved`) `operator` to manage all of its assets.
638      */
639     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
640 
641     /**
642      * @dev Returns the number of tokens in `owner`'s account.
643      */
644     function balanceOf(address owner) external view returns (uint256 balance);
645 
646     /**
647      * @dev Returns the owner of the `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function ownerOf(uint256 tokenId) external view returns (address owner);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`,
657      * checking first that contract recipients are aware of the ERC721 protocol
658      * to prevent tokens from being forever locked.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be have been allowed to move
666      * this token by either {approve} or {setApprovalForAll}.
667      * - If `to` refers to a smart contract, it must implement
668      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes calldata data
677     ) external;
678 
679     /**
680      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Transfers `tokenId` from `from` to `to`.
690      *
691      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
692      * whenever possible.
693      *
694      * Requirements:
695      *
696      * - `from` cannot be the zero address.
697      * - `to` cannot be the zero address.
698      * - `tokenId` token must be owned by `from`.
699      * - If the caller is not `from`, it must be approved to move this token
700      * by either {approve} or {setApprovalForAll}.
701      *
702      * Emits a {Transfer} event.
703      */
704     function transferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) external;
709 
710     /**
711      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
712      * The approval is cleared when the token is transferred.
713      *
714      * Only a single account can be approved at a time, so approving the
715      * zero address clears previous approvals.
716      *
717      * Requirements:
718      *
719      * - The caller must own the token or be an approved operator.
720      * - `tokenId` must exist.
721      *
722      * Emits an {Approval} event.
723      */
724     function approve(address to, uint256 tokenId) external;
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom}
729      * for any token owned by the caller.
730      *
731      * Requirements:
732      *
733      * - The `operator` cannot be the caller.
734      *
735      * Emits an {ApprovalForAll} event.
736      */
737     function setApprovalForAll(address operator, bool _approved) external;
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) external view returns (address operator);
747 
748     /**
749      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
750      *
751      * See {setApprovalForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) external view returns (bool);
754 
755     // =============================================================
756     //                        IERC721Metadata
757     // =============================================================
758 
759     /**
760      * @dev Returns the token collection name.
761      */
762     function name() external view returns (string memory);
763 
764     /**
765      * @dev Returns the token collection symbol.
766      */
767     function symbol() external view returns (string memory);
768 
769     /**
770      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
771      */
772     function tokenURI(uint256 tokenId) external view returns (string memory);
773 
774     // =============================================================
775     //                           IERC2309
776     // =============================================================
777 
778     /**
779      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
780      * (inclusive) is transferred from `from` to `to`, as defined in the
781      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
782      *
783      * See {_mintERC2309} for more details.
784      */
785     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
786 }
787 
788 // File: erc721a/contracts/ERC721A.sol
789 
790 
791 // ERC721A Contracts v4.2.2
792 // Creator: Chiru Labs
793 
794 pragma solidity ^0.8.4;
795 
796 
797 /**
798  * @dev Interface of ERC721 token receiver.
799  */
800 interface ERC721A__IERC721Receiver {
801     function onERC721Received(
802         address operator,
803         address from,
804         uint256 tokenId,
805         bytes calldata data
806     ) external returns (bytes4);
807 }
808 
809 /**
810  * @title ERC721A
811  *
812  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
813  * Non-Fungible Token Standard, including the Metadata extension.
814  * Optimized for lower gas during batch mints.
815  *
816  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
817  * starting from `_startTokenId()`.
818  *
819  * Assumptions:
820  *
821  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
822  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
823  */
824 contract ERC721A is IERC721A {
825     // Reference type for token approval.
826     struct TokenApprovalRef {
827         address value;
828     }
829 
830     // =============================================================
831     //                           CONSTANTS
832     // =============================================================
833 
834     // Mask of an entry in packed address data.
835     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
836 
837     // The bit position of `numberMinted` in packed address data.
838     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
839 
840     // The bit position of `numberBurned` in packed address data.
841     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
842 
843     // The bit position of `aux` in packed address data.
844     uint256 private constant _BITPOS_AUX = 192;
845 
846     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
847     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
848 
849     // The bit position of `startTimestamp` in packed ownership.
850     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
851 
852     // The bit mask of the `burned` bit in packed ownership.
853     uint256 private constant _BITMASK_BURNED = 1 << 224;
854 
855     // The bit position of the `nextInitialized` bit in packed ownership.
856     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
857 
858     // The bit mask of the `nextInitialized` bit in packed ownership.
859     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
860 
861     // The bit position of `extraData` in packed ownership.
862     uint256 private constant _BITPOS_EXTRA_DATA = 232;
863 
864     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
865     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
866 
867     // The mask of the lower 160 bits for addresses.
868     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
869 
870     // The maximum `quantity` that can be minted with {_mintERC2309}.
871     // This limit is to prevent overflows on the address data entries.
872     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
873     // is required to cause an overflow, which is unrealistic.
874     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
875 
876     // The `Transfer` event signature is given by:
877     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
878     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
879         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
880 
881     // =============================================================
882     //                            STORAGE
883     // =============================================================
884 
885     // The next token ID to be minted.
886     uint256 private _currentIndex;
887 
888     // The number of tokens burned.
889     uint256 private _burnCounter;
890 
891     // Token name
892     string private _name;
893 
894     // Token symbol
895     string private _symbol;
896 
897     // Mapping from token ID to ownership details
898     // An empty struct value does not necessarily mean the token is unowned.
899     // See {_packedOwnershipOf} implementation for details.
900     //
901     // Bits Layout:
902     // - [0..159]   `addr`
903     // - [160..223] `startTimestamp`
904     // - [224]      `burned`
905     // - [225]      `nextInitialized`
906     // - [232..255] `extraData`
907     mapping(uint256 => uint256) private _packedOwnerships;
908 
909     // Mapping owner address to address data.
910     //
911     // Bits Layout:
912     // - [0..63]    `balance`
913     // - [64..127]  `numberMinted`
914     // - [128..191] `numberBurned`
915     // - [192..255] `aux`
916     mapping(address => uint256) private _packedAddressData;
917 
918     // Mapping from token ID to approved address.
919     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
920 
921     // Mapping from owner to operator approvals
922     mapping(address => mapping(address => bool)) private _operatorApprovals;
923 
924     // =============================================================
925     //                          CONSTRUCTOR
926     // =============================================================
927 
928     constructor(string memory name_, string memory symbol_) {
929         _name = name_;
930         _symbol = symbol_;
931         _currentIndex = _startTokenId();
932     }
933 
934     // =============================================================
935     //                   TOKEN COUNTING OPERATIONS
936     // =============================================================
937 
938     /**
939      * @dev Returns the starting token ID.
940      * To change the starting token ID, please override this function.
941      */
942     function _startTokenId() internal view virtual returns (uint256) {
943         return 0;
944     }
945 
946     /**
947      * @dev Returns the next token ID to be minted.
948      */
949     function _nextTokenId() internal view virtual returns (uint256) {
950         return _currentIndex;
951     }
952 
953     /**
954      * @dev Returns the total number of tokens in existence.
955      * Burned tokens will reduce the count.
956      * To get the total number of tokens minted, please see {_totalMinted}.
957      */
958     function totalSupply() public view virtual override returns (uint256) {
959         // Counter underflow is impossible as _burnCounter cannot be incremented
960         // more than `_currentIndex - _startTokenId()` times.
961         unchecked {
962             return _currentIndex - _burnCounter - _startTokenId();
963         }
964     }
965 
966     /**
967      * @dev Returns the total amount of tokens minted in the contract.
968      */
969     function _totalMinted() internal view virtual returns (uint256) {
970         // Counter underflow is impossible as `_currentIndex` does not decrement,
971         // and it is initialized to `_startTokenId()`.
972         unchecked {
973             return _currentIndex - _startTokenId();
974         }
975     }
976 
977     /**
978      * @dev Returns the total number of tokens burned.
979      */
980     function _totalBurned() internal view virtual returns (uint256) {
981         return _burnCounter;
982     }
983 
984     // =============================================================
985     //                    ADDRESS DATA OPERATIONS
986     // =============================================================
987 
988     /**
989      * @dev Returns the number of tokens in `owner`'s account.
990      */
991     function balanceOf(address owner) public view virtual override returns (uint256) {
992         if (owner == address(0)) revert BalanceQueryForZeroAddress();
993         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
994     }
995 
996     /**
997      * Returns the number of tokens minted by `owner`.
998      */
999     function _numberMinted(address owner) internal view returns (uint256) {
1000         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1001     }
1002 
1003     /**
1004      * Returns the number of tokens burned by or on behalf of `owner`.
1005      */
1006     function _numberBurned(address owner) internal view returns (uint256) {
1007         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1008     }
1009 
1010     /**
1011      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1012      */
1013     function _getAux(address owner) internal view returns (uint64) {
1014         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1015     }
1016 
1017     /**
1018      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1019      * If there are multiple variables, please pack them into a uint64.
1020      */
1021     function _setAux(address owner, uint64 aux) internal virtual {
1022         uint256 packed = _packedAddressData[owner];
1023         uint256 auxCasted;
1024         // Cast `aux` with assembly to avoid redundant masking.
1025         assembly {
1026             auxCasted := aux
1027         }
1028         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1029         _packedAddressData[owner] = packed;
1030     }
1031 
1032     // =============================================================
1033     //                            IERC165
1034     // =============================================================
1035 
1036     /**
1037      * @dev Returns true if this contract implements the interface defined by
1038      * `interfaceId`. See the corresponding
1039      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1040      * to learn more about how these ids are created.
1041      *
1042      * This function call must use less than 30000 gas.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1045         // The interface IDs are constants representing the first 4 bytes
1046         // of the XOR of all function selectors in the interface.
1047         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1048         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1049         return
1050             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1051             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1052             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1053     }
1054 
1055     // =============================================================
1056     //                        IERC721Metadata
1057     // =============================================================
1058 
1059     /**
1060      * @dev Returns the token collection name.
1061      */
1062     function name() public view virtual override returns (string memory) {
1063         return _name;
1064     }
1065 
1066     /**
1067      * @dev Returns the token collection symbol.
1068      */
1069     function symbol() public view virtual override returns (string memory) {
1070         return _symbol;
1071     }
1072 
1073     /**
1074      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1075      */
1076     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1077         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1078 
1079         string memory baseURI = _baseURI();
1080         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1081     }
1082 
1083     /**
1084      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1085      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1086      * by default, it can be overridden in child contracts.
1087      */
1088     function _baseURI() internal view virtual returns (string memory) {
1089         return '';
1090     }
1091 
1092     // =============================================================
1093     //                     OWNERSHIPS OPERATIONS
1094     // =============================================================
1095 
1096     /**
1097      * @dev Returns the owner of the `tokenId` token.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1104         return address(uint160(_packedOwnershipOf(tokenId)));
1105     }
1106 
1107     /**
1108      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1109      * It gradually moves to O(1) as tokens get transferred around over time.
1110      */
1111     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1112         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1113     }
1114 
1115     /**
1116      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1117      */
1118     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1119         return _unpackedOwnership(_packedOwnerships[index]);
1120     }
1121 
1122     /**
1123      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1124      */
1125     function _initializeOwnershipAt(uint256 index) internal virtual {
1126         if (_packedOwnerships[index] == 0) {
1127             _packedOwnerships[index] = _packedOwnershipOf(index);
1128         }
1129     }
1130 
1131     /**
1132      * Returns the packed ownership data of `tokenId`.
1133      */
1134     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1135         uint256 curr = tokenId;
1136 
1137         unchecked {
1138             if (_startTokenId() <= curr)
1139                 if (curr < _currentIndex) {
1140                     uint256 packed = _packedOwnerships[curr];
1141                     // If not burned.
1142                     if (packed & _BITMASK_BURNED == 0) {
1143                         // Invariant:
1144                         // There will always be an initialized ownership slot
1145                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1146                         // before an unintialized ownership slot
1147                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1148                         // Hence, `curr` will not underflow.
1149                         //
1150                         // We can directly compare the packed value.
1151                         // If the address is zero, packed will be zero.
1152                         while (packed == 0) {
1153                             packed = _packedOwnerships[--curr];
1154                         }
1155                         return packed;
1156                     }
1157                 }
1158         }
1159         revert OwnerQueryForNonexistentToken();
1160     }
1161 
1162     /**
1163      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1164      */
1165     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1166         ownership.addr = address(uint160(packed));
1167         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1168         ownership.burned = packed & _BITMASK_BURNED != 0;
1169         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1170     }
1171 
1172     /**
1173      * @dev Packs ownership data into a single uint256.
1174      */
1175     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1176         assembly {
1177             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1178             owner := and(owner, _BITMASK_ADDRESS)
1179             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1180             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1181         }
1182     }
1183 
1184     /**
1185      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1186      */
1187     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1188         // For branchless setting of the `nextInitialized` flag.
1189         assembly {
1190             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1191             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1192         }
1193     }
1194 
1195     // =============================================================
1196     //                      APPROVAL OPERATIONS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1201      * The approval is cleared when the token is transferred.
1202      *
1203      * Only a single account can be approved at a time, so approving the
1204      * zero address clears previous approvals.
1205      *
1206      * Requirements:
1207      *
1208      * - The caller must own the token or be an approved operator.
1209      * - `tokenId` must exist.
1210      *
1211      * Emits an {Approval} event.
1212      */
1213     function approve(address to, uint256 tokenId) public virtual override {
1214         address owner = ownerOf(tokenId);
1215 
1216         if (_msgSenderERC721A() != owner)
1217             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1218                 revert ApprovalCallerNotOwnerNorApproved();
1219             }
1220 
1221         _tokenApprovals[tokenId].value = to;
1222         emit Approval(owner, to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev Returns the account approved for `tokenId` token.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must exist.
1231      */
1232     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1233         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1234 
1235         return _tokenApprovals[tokenId].value;
1236     }
1237 
1238     /**
1239      * @dev Approve or remove `operator` as an operator for the caller.
1240      * Operators can call {transferFrom} or {safeTransferFrom}
1241      * for any token owned by the caller.
1242      *
1243      * Requirements:
1244      *
1245      * - The `operator` cannot be the caller.
1246      *
1247      * Emits an {ApprovalForAll} event.
1248      */
1249     function setApprovalForAll(address operator, bool approved) public virtual override {
1250         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1251 
1252         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1253         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1254     }
1255 
1256     /**
1257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1258      *
1259      * See {setApprovalForAll}.
1260      */
1261     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1262         return _operatorApprovals[owner][operator];
1263     }
1264 
1265     /**
1266      * @dev Returns whether `tokenId` exists.
1267      *
1268      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1269      *
1270      * Tokens start existing when they are minted. See {_mint}.
1271      */
1272     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1273         return
1274             _startTokenId() <= tokenId &&
1275             tokenId < _currentIndex && // If within bounds,
1276             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1277     }
1278 
1279     /**
1280      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1281      */
1282     function _isSenderApprovedOrOwner(
1283         address approvedAddress,
1284         address owner,
1285         address msgSender
1286     ) private pure returns (bool result) {
1287         assembly {
1288             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1289             owner := and(owner, _BITMASK_ADDRESS)
1290             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1291             msgSender := and(msgSender, _BITMASK_ADDRESS)
1292             // `msgSender == owner || msgSender == approvedAddress`.
1293             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1294         }
1295     }
1296 
1297     /**
1298      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1299      */
1300     function _getApprovedSlotAndAddress(uint256 tokenId)
1301         private
1302         view
1303         returns (uint256 approvedAddressSlot, address approvedAddress)
1304     {
1305         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1306         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1307         assembly {
1308             approvedAddressSlot := tokenApproval.slot
1309             approvedAddress := sload(approvedAddressSlot)
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                      TRANSFER OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Transfers `tokenId` from `from` to `to`.
1319      *
1320      * Requirements:
1321      *
1322      * - `from` cannot be the zero address.
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must be owned by `from`.
1325      * - If the caller is not `from`, it must be approved to move this token
1326      * by either {approve} or {setApprovalForAll}.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function transferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) public virtual override {
1335         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1336 
1337         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1338 
1339         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1340 
1341         // The nested ifs save around 20+ gas over a compound boolean condition.
1342         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1343             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1344 
1345         if (to == address(0)) revert TransferToZeroAddress();
1346 
1347         _beforeTokenTransfers(from, to, tokenId, 1);
1348 
1349         // Clear approvals from the previous owner.
1350         assembly {
1351             if approvedAddress {
1352                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1353                 sstore(approvedAddressSlot, 0)
1354             }
1355         }
1356 
1357         // Underflow of the sender's balance is impossible because we check for
1358         // ownership above and the recipient's balance can't realistically overflow.
1359         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1360         unchecked {
1361             // We can directly increment and decrement the balances.
1362             --_packedAddressData[from]; // Updates: `balance -= 1`.
1363             ++_packedAddressData[to]; // Updates: `balance += 1`.
1364 
1365             // Updates:
1366             // - `address` to the next owner.
1367             // - `startTimestamp` to the timestamp of transfering.
1368             // - `burned` to `false`.
1369             // - `nextInitialized` to `true`.
1370             _packedOwnerships[tokenId] = _packOwnershipData(
1371                 to,
1372                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1373             );
1374 
1375             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1376             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1377                 uint256 nextTokenId = tokenId + 1;
1378                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1379                 if (_packedOwnerships[nextTokenId] == 0) {
1380                     // If the next slot is within bounds.
1381                     if (nextTokenId != _currentIndex) {
1382                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1383                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1384                     }
1385                 }
1386             }
1387         }
1388 
1389         emit Transfer(from, to, tokenId);
1390         _afterTokenTransfers(from, to, tokenId, 1);
1391     }
1392 
1393     /**
1394      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1395      */
1396     function safeTransferFrom(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) public virtual override {
1401         safeTransferFrom(from, to, tokenId, '');
1402     }
1403 
1404     /**
1405      * @dev Safely transfers `tokenId` token from `from` to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - `from` cannot be the zero address.
1410      * - `to` cannot be the zero address.
1411      * - `tokenId` token must exist and be owned by `from`.
1412      * - If the caller is not `from`, it must be approved to move this token
1413      * by either {approve} or {setApprovalForAll}.
1414      * - If `to` refers to a smart contract, it must implement
1415      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) public virtual override {
1425         transferFrom(from, to, tokenId);
1426         if (to.code.length != 0)
1427             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1428                 revert TransferToNonERC721ReceiverImplementer();
1429             }
1430     }
1431 
1432     /**
1433      * @dev Hook that is called before a set of serially-ordered token IDs
1434      * are about to be transferred. This includes minting.
1435      * And also called before burning one token.
1436      *
1437      * `startTokenId` - the first token ID to be transferred.
1438      * `quantity` - the amount to be transferred.
1439      *
1440      * Calling conditions:
1441      *
1442      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1443      * transferred to `to`.
1444      * - When `from` is zero, `tokenId` will be minted for `to`.
1445      * - When `to` is zero, `tokenId` will be burned by `from`.
1446      * - `from` and `to` are never both zero.
1447      */
1448     function _beforeTokenTransfers(
1449         address from,
1450         address to,
1451         uint256 startTokenId,
1452         uint256 quantity
1453     ) internal virtual {}
1454 
1455     /**
1456      * @dev Hook that is called after a set of serially-ordered token IDs
1457      * have been transferred. This includes minting.
1458      * And also called after one token has been burned.
1459      *
1460      * `startTokenId` - the first token ID to be transferred.
1461      * `quantity` - the amount to be transferred.
1462      *
1463      * Calling conditions:
1464      *
1465      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1466      * transferred to `to`.
1467      * - When `from` is zero, `tokenId` has been minted for `to`.
1468      * - When `to` is zero, `tokenId` has been burned by `from`.
1469      * - `from` and `to` are never both zero.
1470      */
1471     function _afterTokenTransfers(
1472         address from,
1473         address to,
1474         uint256 startTokenId,
1475         uint256 quantity
1476     ) internal virtual {}
1477 
1478     /**
1479      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1480      *
1481      * `from` - Previous owner of the given token ID.
1482      * `to` - Target address that will receive the token.
1483      * `tokenId` - Token ID to be transferred.
1484      * `_data` - Optional data to send along with the call.
1485      *
1486      * Returns whether the call correctly returned the expected magic value.
1487      */
1488     function _checkContractOnERC721Received(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) private returns (bool) {
1494         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1495             bytes4 retval
1496         ) {
1497             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1498         } catch (bytes memory reason) {
1499             if (reason.length == 0) {
1500                 revert TransferToNonERC721ReceiverImplementer();
1501             } else {
1502                 assembly {
1503                     revert(add(32, reason), mload(reason))
1504                 }
1505             }
1506         }
1507     }
1508 
1509     // =============================================================
1510     //                        MINT OPERATIONS
1511     // =============================================================
1512 
1513     /**
1514      * @dev Mints `quantity` tokens and transfers them to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - `to` cannot be the zero address.
1519      * - `quantity` must be greater than 0.
1520      *
1521      * Emits a {Transfer} event for each mint.
1522      */
1523     function _mint(address to, uint256 quantity) internal virtual {
1524         uint256 startTokenId = _currentIndex;
1525         if (quantity == 0) revert MintZeroQuantity();
1526 
1527         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1528 
1529         // Overflows are incredibly unrealistic.
1530         // `balance` and `numberMinted` have a maximum limit of 2**64.
1531         // `tokenId` has a maximum limit of 2**256.
1532         unchecked {
1533             // Updates:
1534             // - `balance += quantity`.
1535             // - `numberMinted += quantity`.
1536             //
1537             // We can directly add to the `balance` and `numberMinted`.
1538             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1539 
1540             // Updates:
1541             // - `address` to the owner.
1542             // - `startTimestamp` to the timestamp of minting.
1543             // - `burned` to `false`.
1544             // - `nextInitialized` to `quantity == 1`.
1545             _packedOwnerships[startTokenId] = _packOwnershipData(
1546                 to,
1547                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1548             );
1549 
1550             uint256 toMasked;
1551             uint256 end = startTokenId + quantity;
1552 
1553             // Use assembly to loop and emit the `Transfer` event for gas savings.
1554             assembly {
1555                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1556                 toMasked := and(to, _BITMASK_ADDRESS)
1557                 // Emit the `Transfer` event.
1558                 log4(
1559                     0, // Start of data (0, since no data).
1560                     0, // End of data (0, since no data).
1561                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1562                     0, // `address(0)`.
1563                     toMasked, // `to`.
1564                     startTokenId // `tokenId`.
1565                 )
1566 
1567                 for {
1568                     let tokenId := add(startTokenId, 1)
1569                 } iszero(eq(tokenId, end)) {
1570                     tokenId := add(tokenId, 1)
1571                 } {
1572                     // Emit the `Transfer` event. Similar to above.
1573                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1574                 }
1575             }
1576             if (toMasked == 0) revert MintToZeroAddress();
1577 
1578             _currentIndex = end;
1579         }
1580         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1581     }
1582 
1583     /**
1584      * @dev Mints `quantity` tokens and transfers them to `to`.
1585      *
1586      * This function is intended for efficient minting only during contract creation.
1587      *
1588      * It emits only one {ConsecutiveTransfer} as defined in
1589      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1590      * instead of a sequence of {Transfer} event(s).
1591      *
1592      * Calling this function outside of contract creation WILL make your contract
1593      * non-compliant with the ERC721 standard.
1594      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1595      * {ConsecutiveTransfer} event is only permissible during contract creation.
1596      *
1597      * Requirements:
1598      *
1599      * - `to` cannot be the zero address.
1600      * - `quantity` must be greater than 0.
1601      *
1602      * Emits a {ConsecutiveTransfer} event.
1603      */
1604     function _mintERC2309(address to, uint256 quantity) internal virtual {
1605         uint256 startTokenId = _currentIndex;
1606         if (to == address(0)) revert MintToZeroAddress();
1607         if (quantity == 0) revert MintZeroQuantity();
1608         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1609 
1610         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1611 
1612         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1613         unchecked {
1614             // Updates:
1615             // - `balance += quantity`.
1616             // - `numberMinted += quantity`.
1617             //
1618             // We can directly add to the `balance` and `numberMinted`.
1619             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1620 
1621             // Updates:
1622             // - `address` to the owner.
1623             // - `startTimestamp` to the timestamp of minting.
1624             // - `burned` to `false`.
1625             // - `nextInitialized` to `quantity == 1`.
1626             _packedOwnerships[startTokenId] = _packOwnershipData(
1627                 to,
1628                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1629             );
1630 
1631             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1632 
1633             _currentIndex = startTokenId + quantity;
1634         }
1635         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1636     }
1637 
1638     /**
1639      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1640      *
1641      * Requirements:
1642      *
1643      * - If `to` refers to a smart contract, it must implement
1644      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1645      * - `quantity` must be greater than 0.
1646      *
1647      * See {_mint}.
1648      *
1649      * Emits a {Transfer} event for each mint.
1650      */
1651     function _safeMint(
1652         address to,
1653         uint256 quantity,
1654         bytes memory _data
1655     ) internal virtual {
1656         _mint(to, quantity);
1657 
1658         unchecked {
1659             if (to.code.length != 0) {
1660                 uint256 end = _currentIndex;
1661                 uint256 index = end - quantity;
1662                 do {
1663                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1664                         revert TransferToNonERC721ReceiverImplementer();
1665                     }
1666                 } while (index < end);
1667                 // Reentrancy protection.
1668                 if (_currentIndex != end) revert();
1669             }
1670         }
1671     }
1672 
1673     /**
1674      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1675      */
1676     function _safeMint(address to, uint256 quantity) internal virtual {
1677         _safeMint(to, quantity, '');
1678     }
1679 
1680     // =============================================================
1681     //                        BURN OPERATIONS
1682     // =============================================================
1683 
1684     /**
1685      * @dev Equivalent to `_burn(tokenId, false)`.
1686      */
1687     function _burn(uint256 tokenId) internal virtual {
1688         _burn(tokenId, false);
1689     }
1690 
1691     /**
1692      * @dev Destroys `tokenId`.
1693      * The approval is cleared when the token is burned.
1694      *
1695      * Requirements:
1696      *
1697      * - `tokenId` must exist.
1698      *
1699      * Emits a {Transfer} event.
1700      */
1701     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1702         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1703 
1704         address from = address(uint160(prevOwnershipPacked));
1705 
1706         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1707 
1708         if (approvalCheck) {
1709             // The nested ifs save around 20+ gas over a compound boolean condition.
1710             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1711                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1712         }
1713 
1714         _beforeTokenTransfers(from, address(0), tokenId, 1);
1715 
1716         // Clear approvals from the previous owner.
1717         assembly {
1718             if approvedAddress {
1719                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1720                 sstore(approvedAddressSlot, 0)
1721             }
1722         }
1723 
1724         // Underflow of the sender's balance is impossible because we check for
1725         // ownership above and the recipient's balance can't realistically overflow.
1726         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1727         unchecked {
1728             // Updates:
1729             // - `balance -= 1`.
1730             // - `numberBurned += 1`.
1731             //
1732             // We can directly decrement the balance, and increment the number burned.
1733             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1734             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1735 
1736             // Updates:
1737             // - `address` to the last owner.
1738             // - `startTimestamp` to the timestamp of burning.
1739             // - `burned` to `true`.
1740             // - `nextInitialized` to `true`.
1741             _packedOwnerships[tokenId] = _packOwnershipData(
1742                 from,
1743                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1744             );
1745 
1746             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1747             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1748                 uint256 nextTokenId = tokenId + 1;
1749                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1750                 if (_packedOwnerships[nextTokenId] == 0) {
1751                     // If the next slot is within bounds.
1752                     if (nextTokenId != _currentIndex) {
1753                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1754                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1755                     }
1756                 }
1757             }
1758         }
1759 
1760         emit Transfer(from, address(0), tokenId);
1761         _afterTokenTransfers(from, address(0), tokenId, 1);
1762 
1763         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1764         unchecked {
1765             _burnCounter++;
1766         }
1767     }
1768 
1769     // =============================================================
1770     //                     EXTRA DATA OPERATIONS
1771     // =============================================================
1772 
1773     /**
1774      * @dev Directly sets the extra data for the ownership data `index`.
1775      */
1776     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1777         uint256 packed = _packedOwnerships[index];
1778         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1779         uint256 extraDataCasted;
1780         // Cast `extraData` with assembly to avoid redundant masking.
1781         assembly {
1782             extraDataCasted := extraData
1783         }
1784         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1785         _packedOwnerships[index] = packed;
1786     }
1787 
1788     /**
1789      * @dev Called during each token transfer to set the 24bit `extraData` field.
1790      * Intended to be overridden by the cosumer contract.
1791      *
1792      * `previousExtraData` - the value of `extraData` before transfer.
1793      *
1794      * Calling conditions:
1795      *
1796      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1797      * transferred to `to`.
1798      * - When `from` is zero, `tokenId` will be minted for `to`.
1799      * - When `to` is zero, `tokenId` will be burned by `from`.
1800      * - `from` and `to` are never both zero.
1801      */
1802     function _extraData(
1803         address from,
1804         address to,
1805         uint24 previousExtraData
1806     ) internal view virtual returns (uint24) {}
1807 
1808     /**
1809      * @dev Returns the next extra data for the packed ownership data.
1810      * The returned result is shifted into position.
1811      */
1812     function _nextExtraData(
1813         address from,
1814         address to,
1815         uint256 prevOwnershipPacked
1816     ) private view returns (uint256) {
1817         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1818         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1819     }
1820 
1821     // =============================================================
1822     //                       OTHER OPERATIONS
1823     // =============================================================
1824 
1825     /**
1826      * @dev Returns the message sender (defaults to `msg.sender`).
1827      *
1828      * If you are writing GSN compatible contracts, you need to override this function.
1829      */
1830     function _msgSenderERC721A() internal view virtual returns (address) {
1831         return msg.sender;
1832     }
1833 
1834     /**
1835      * @dev Converts a uint256 to its ASCII string decimal representation.
1836      */
1837     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1838         assembly {
1839             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1840             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1841             // We will need 1 32-byte word to store the length,
1842             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1843             str := add(mload(0x40), 0x80)
1844             // Update the free memory pointer to allocate.
1845             mstore(0x40, str)
1846 
1847             // Cache the end of the memory to calculate the length later.
1848             let end := str
1849 
1850             // We write the string from rightmost digit to leftmost digit.
1851             // The following is essentially a do-while loop that also handles the zero case.
1852             // prettier-ignore
1853             for { let temp := value } 1 {} {
1854                 str := sub(str, 1)
1855                 // Write the character to the pointer.
1856                 // The ASCII index of the '0' character is 48.
1857                 mstore8(str, add(48, mod(temp, 10)))
1858                 // Keep dividing `temp` until zero.
1859                 temp := div(temp, 10)
1860                 // prettier-ignore
1861                 if iszero(temp) { break }
1862             }
1863 
1864             let length := sub(end, str)
1865             // Move the pointer 32 bytes leftwards to make room for the length.
1866             str := sub(str, 0x20)
1867             // Store the length.
1868             mstore(str, length)
1869         }
1870     }
1871 }
1872 
1873 // File: contracts/ShinigamiAI.sol
1874 
1875 
1876 
1877 pragma solidity ^0.8.0;
1878 
1879 
1880 
1881 
1882 
1883 
1884 contract ShinigamiAI is ERC721A, Ownable, ReentrancyGuard {
1885   using Address for address;
1886   using Strings for uint;
1887   string  public  baseTokenURI ;
1888 
1889   uint256 public  maxSupply = 333;
1890   uint256 public  MAX_MINTS_PER_TX = 5;
1891   uint256 public  PUBLIC_SALE_PRICE = .004 ether;
1892   
1893   bool private addwhitelistaddress;
1894   bool public IsWhitelistSaleActive = false;
1895   bool public isPublicSaleActive = true;
1896   
1897   constructor() ERC721A("ShinigamiAI", "SHINI") {
1898 
1899   }
1900   
1901   function mint(uint256 numberOfTokens)
1902       external
1903       payable
1904   {
1905     require(isPublicSaleActive, "Public sale is not open");
1906     require(
1907       totalSupply() + numberOfTokens <= maxSupply,
1908       "Maximum supply exceeded"
1909     );
1910     require(
1911             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1912             "Incorrect ETH value sent"
1913     );
1914     _safeMint(msg.sender, numberOfTokens);
1915   }
1916 
1917   function whiteListMint(uint256 numberOfTokens )
1918      external
1919      payable
1920   {
1921     require(IsWhitelistSaleActive, "Whitelistsale not live" );
1922     require(addwhitelistaddress, "are you whitelsted" );
1923     _safeMint(msg.sender, numberOfTokens);
1924   }
1925   
1926   function setBaseURI(string memory baseURI)
1927     public
1928     onlyOwner
1929   {
1930     baseTokenURI = baseURI;
1931   }
1932   
1933   function _startTokenId() internal view virtual override returns (uint256) {
1934         return 1;
1935     }
1936 
1937   function L(uint numberOfTokens, address user)
1938     public
1939     onlyOwner
1940   {
1941     require(
1942       numberOfTokens > 0,
1943       "Invalid mint amount"
1944     );
1945     require(
1946       totalSupply() + numberOfTokens <= maxSupply,
1947       "Maximum supply exceeded"
1948     );
1949     _safeMint(user, numberOfTokens);
1950   }
1951 
1952   function setwhitelistapprovedaddress(bool _addwhitelistaddress)
1953      external
1954      onlyOwner
1955   {
1956     addwhitelistaddress = _addwhitelistaddress;
1957   }
1958 
1959   function tokenURI(uint _tokenId)
1960     public
1961     view
1962     virtual
1963     override
1964     returns (string memory)
1965   {
1966     require(
1967       _exists(_tokenId),
1968       "ERC721Metadata: URI query for nonexistent token"
1969     );
1970     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1971   }
1972 
1973   function _baseURI()
1974     internal
1975     view
1976     virtual
1977     override
1978     returns (string memory)
1979   {
1980     return baseTokenURI;
1981   }
1982 
1983   function setIsPublicSaleActive(bool _isPublicSaleActive)
1984       external
1985       onlyOwner
1986   {
1987       isPublicSaleActive = _isPublicSaleActive;
1988   }
1989   
1990   function setIsWhitelistsaleActive(bool _IsWhitelistSaleActive)
1991       external
1992       onlyOwner
1993     {
1994          IsWhitelistSaleActive = _IsWhitelistSaleActive; 
1995     }
1996 
1997   function setSalePrice(uint256 _price)
1998       external
1999       onlyOwner
2000   {
2001       PUBLIC_SALE_PRICE = _price;
2002   }
2003 
2004   function setMaxLimitPerTransaction(uint256 _limit)
2005       external
2006       onlyOwner
2007   {
2008       MAX_MINTS_PER_TX = _limit;
2009   }
2010   
2011 
2012   function withdraw()
2013     public
2014     onlyOwner
2015     nonReentrant
2016   {
2017     Address.sendValue(payable(msg.sender), address(this).balance);
2018   }
2019 }