1 // SPDX-License-Identifier: MIT
2 
3 // ,--.                                      ,--.   ,--.           ,--.  ,--.                              
4 // |  |    ,---.  ,--,--.,--.  ,--.,---.     |   `.'   | ,---.     |  ,'.|  | ,---.,--.  ,--.,---. ,--.--. 
5 // |  |   | .-. :' ,-.  | \  `'  /| .-. :    |  |'.'|  || .-. :    |  |' '  || .-. :\  `'  /| .-. :|  .--' 
6 // |  '--.\   --.\ '-'  |  \    / \   --.    |  |   |  |\   --.    |  | `   |\   --. \    / \   --.|  |    
7 // `-----' `----' `--`--'   `--'   `----'    `--'   `--' `----'    `--'  `--' `----'  `--'   `----'`--'    
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Address.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
81 
82 pragma solidity ^0.8.1;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      *
105      * [IMPORTANT]
106      * ====
107      * You shouldn't rely on `isContract` to protect against flash loan attacks!
108      *
109      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
110      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
111      * constructor.
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize/address.code.length, which returns 0
116         // for contracts in construction, since the code is only stored at the end
117         // of the constructor execution.
118 
119         return account.code.length > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         (bool success, ) = recipient.call{value: amount}("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain `call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.call{value: value}(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(isContract(target), "Address: delegate call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.delegatecall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
275      * revert reason using the provided one.
276      *
277      * _Available since v4.3._
278      */
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Contract module that helps prevent reentrant calls to a function.
311  *
312  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
313  * available, which can be applied to functions to make sure there are no nested
314  * (reentrant) calls to them.
315  *
316  * Note that because there is a single `nonReentrant` guard, functions marked as
317  * `nonReentrant` may not call one another. This can be worked around by making
318  * those functions `private`, and then adding `external` `nonReentrant` entry
319  * points to them.
320  *
321  * TIP: If you would like to learn more about reentrancy and alternative ways
322  * to protect against it, check out our blog post
323  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
324  */
325 abstract contract ReentrancyGuard {
326     // Booleans are more expensive than uint256 or any type that takes up a full
327     // word because each write operation emits an extra SLOAD to first read the
328     // slot's contents, replace the bits taken up by the boolean, and then write
329     // back. This is the compiler's defense against contract upgrades and
330     // pointer aliasing, and it cannot be disabled.
331 
332     // The values being non-zero value makes deployment a bit more expensive,
333     // but in exchange the refund on every call to nonReentrant will be lower in
334     // amount. Since refunds are capped to a percentage of the total
335     // transaction's gas, it is best to keep them low in cases like this one, to
336     // increase the likelihood of the full refund coming into effect.
337     uint256 private constant _NOT_ENTERED = 1;
338     uint256 private constant _ENTERED = 2;
339 
340     uint256 private _status;
341 
342     constructor() {
343         _status = _NOT_ENTERED;
344     }
345 
346     /**
347      * @dev Prevents a contract from calling itself, directly or indirectly.
348      * Calling a `nonReentrant` function from another `nonReentrant`
349      * function is not supported. It is possible to prevent this from happening
350      * by making the `nonReentrant` function external, and making it call a
351      * `private` function that does the actual work.
352      */
353     modifier nonReentrant() {
354         // On the first call to nonReentrant, _notEntered will be true
355         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
356 
357         // Any calls to nonReentrant after this point will fail
358         _status = _ENTERED;
359 
360         _;
361 
362         // By storing the original value once again, a refund is triggered (see
363         // https://eips.ethereum.org/EIPS/eip-2200)
364         _status = _NOT_ENTERED;
365     }
366 }
367 
368 // File: @openzeppelin/contracts/utils/Context.sol
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes calldata) {
391         return msg.data;
392     }
393 }
394 
395 // File: @openzeppelin/contracts/access/Ownable.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Contract module which provides a basic access control mechanism, where
405  * there is an account (an owner) that can be granted exclusive access to
406  * specific functions.
407  *
408  * By default, the owner account will be the one that deploys the contract. This
409  * can later be changed with {transferOwnership}.
410  *
411  * This module is used through inheritance. It will make available the modifier
412  * `onlyOwner`, which can be applied to your functions to restrict their use to
413  * the owner.
414  */
415 abstract contract Ownable is Context {
416     address private _owner;
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor() {
424         _transferOwnership(_msgSender());
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if called by any account other than the owner.
436      */
437     modifier onlyOwner() {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439         _;
440     }
441 
442     /**
443      * @dev Leaves the contract without owner. It will not be possible to call
444      * `onlyOwner` functions anymore. Can only be called by the current owner.
445      *
446      * NOTE: Renouncing ownership will leave the contract without an owner,
447      * thereby removing any functionality that is only available to the owner.
448      */
449     function renounceOwnership() public virtual onlyOwner {
450         _transferOwnership(address(0));
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         _transferOwnership(newOwner);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Internal function without access restriction.
465      */
466     function _transferOwnership(address newOwner) internal virtual {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 
473 // File: erc721a/contracts/IERC721A.sol
474 
475 
476 // ERC721A Contracts v4.0.0
477 // Creator: Chiru Labs
478 
479 pragma solidity ^0.8.4;
480 
481 /**
482  * @dev Interface of an ERC721A compliant contract.
483  */
484 interface IERC721A {
485     /**
486      * The caller must own the token or be an approved operator.
487      */
488     error ApprovalCallerNotOwnerNorApproved();
489 
490     /**
491      * The token does not exist.
492      */
493     error ApprovalQueryForNonexistentToken();
494 
495     /**
496      * The caller cannot approve to their own address.
497      */
498     error ApproveToCaller();
499 
500     /**
501      * The caller cannot approve to the current owner.
502      */
503     error ApprovalToCurrentOwner();
504 
505     /**
506      * Cannot query the balance for the zero address.
507      */
508     error BalanceQueryForZeroAddress();
509 
510     /**
511      * Cannot mint to the zero address.
512      */
513     error MintToZeroAddress();
514 
515     /**
516      * The quantity of tokens minted must be more than zero.
517      */
518     error MintZeroQuantity();
519 
520     /**
521      * The token does not exist.
522      */
523     error OwnerQueryForNonexistentToken();
524 
525     /**
526      * The caller must own the token or be an approved operator.
527      */
528     error TransferCallerNotOwnerNorApproved();
529 
530     /**
531      * The token must be owned by `from`.
532      */
533     error TransferFromIncorrectOwner();
534 
535     /**
536      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
537      */
538     error TransferToNonERC721ReceiverImplementer();
539 
540     /**
541      * Cannot transfer to the zero address.
542      */
543     error TransferToZeroAddress();
544 
545     /**
546      * The token does not exist.
547      */
548     error URIQueryForNonexistentToken();
549 
550     struct TokenOwnership {
551         // The address of the owner.
552         address addr;
553         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
554         uint64 startTimestamp;
555         // Whether the token has been burned.
556         bool burned;
557     }
558 
559     /**
560      * @dev Returns the total amount of tokens stored by the contract.
561      *
562      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
563      */
564     function totalSupply() external view returns (uint256);
565 
566     // ==============================
567     //            IERC165
568     // ==============================
569 
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 
580     // ==============================
581     //            IERC721
582     // ==============================
583 
584     /**
585      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
586      */
587     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
588 
589     /**
590      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
591      */
592     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      * @dev Returns the number of tokens in ``owner``'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
635      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must exist and be owned by `from`.
642      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      * @dev Transfers `tokenId` token from `from` to `to`.
655      *
656      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      *
665      * Emits a {Transfer} event.
666      */
667     function transferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) external;
672 
673     /**
674      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
675      * The approval is cleared when the token is transferred.
676      *
677      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
678      *
679      * Requirements:
680      *
681      * - The caller must own the token or be an approved operator.
682      * - `tokenId` must exist.
683      *
684      * Emits an {Approval} event.
685      */
686     function approve(address to, uint256 tokenId) external;
687 
688     /**
689      * @dev Approve or remove `operator` as an operator for the caller.
690      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
691      *
692      * Requirements:
693      *
694      * - The `operator` cannot be the caller.
695      *
696      * Emits an {ApprovalForAll} event.
697      */
698     function setApprovalForAll(address operator, bool _approved) external;
699 
700     /**
701      * @dev Returns the account approved for `tokenId` token.
702      *
703      * Requirements:
704      *
705      * - `tokenId` must exist.
706      */
707     function getApproved(uint256 tokenId) external view returns (address operator);
708 
709     /**
710      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
711      *
712      * See {setApprovalForAll}
713      */
714     function isApprovedForAll(address owner, address operator) external view returns (bool);
715 
716     // ==============================
717     //        IERC721Metadata
718     // ==============================
719 
720     /**
721      * @dev Returns the token collection name.
722      */
723     function name() external view returns (string memory);
724 
725     /**
726      * @dev Returns the token collection symbol.
727      */
728     function symbol() external view returns (string memory);
729 
730     /**
731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
732      */
733     function tokenURI(uint256 tokenId) external view returns (string memory);
734 }
735 
736 // File: erc721a/contracts/ERC721A.sol
737 
738 
739 // ERC721A Contracts v4.0.0
740 // Creator: Chiru Labs
741 
742 pragma solidity ^0.8.4;
743 
744 
745 /**
746  * @dev ERC721 token receiver interface.
747  */
748 interface ERC721A__IERC721Receiver {
749     function onERC721Received(
750         address operator,
751         address from,
752         uint256 tokenId,
753         bytes calldata data
754     ) external returns (bytes4);
755 }
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  *
763  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
764  *
765  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
766  */
767 contract ERC721A is IERC721A {
768     // Mask of an entry in packed address data.
769     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
770 
771     // The bit position of `numberMinted` in packed address data.
772     uint256 private constant BITPOS_NUMBER_MINTED = 64;
773 
774     // The bit position of `numberBurned` in packed address data.
775     uint256 private constant BITPOS_NUMBER_BURNED = 128;
776 
777     // The bit position of `aux` in packed address data.
778     uint256 private constant BITPOS_AUX = 192;
779 
780     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
781     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
782 
783     // The bit position of `startTimestamp` in packed ownership.
784     uint256 private constant BITPOS_START_TIMESTAMP = 160;
785 
786     // The bit mask of the `burned` bit in packed ownership.
787     uint256 private constant BITMASK_BURNED = 1 << 224;
788     
789     // The bit position of the `nextInitialized` bit in packed ownership.
790     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
791 
792     // The bit mask of the `nextInitialized` bit in packed ownership.
793     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
794 
795     // The tokenId of the next token to be minted.
796     uint256 private _currentIndex;
797 
798     // The number of tokens burned.
799     uint256 private _burnCounter;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned.
809     // See `_packedOwnershipOf` implementation for details.
810     //
811     // Bits Layout:
812     // - [0..159]   `addr`
813     // - [160..223] `startTimestamp`
814     // - [224]      `burned`
815     // - [225]      `nextInitialized`
816     mapping(uint256 => uint256) private _packedOwnerships;
817 
818     // Mapping owner address to address data.
819     //
820     // Bits Layout:
821     // - [0..63]    `balance`
822     // - [64..127]  `numberMinted`
823     // - [128..191] `numberBurned`
824     // - [192..255] `aux`
825     mapping(address => uint256) private _packedAddressData;
826 
827     // Mapping from token ID to approved address.
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     constructor(string memory name_, string memory symbol_) {
834         _name = name_;
835         _symbol = symbol_;
836         _currentIndex = _startTokenId();
837     }
838 
839     /**
840      * @dev Returns the starting token ID. 
841      * To change the starting token ID, please override this function.
842      */
843     function _startTokenId() internal view virtual returns (uint256) {
844         return 0;
845     }
846 
847     /**
848      * @dev Returns the next token ID to be minted.
849      */
850     function _nextTokenId() internal view returns (uint256) {
851         return _currentIndex;
852     }
853 
854     /**
855      * @dev Returns the total number of tokens in existence.
856      * Burned tokens will reduce the count. 
857      * To get the total number of tokens minted, please see `_totalMinted`.
858      */
859     function totalSupply() public view override returns (uint256) {
860         // Counter underflow is impossible as _burnCounter cannot be incremented
861         // more than `_currentIndex - _startTokenId()` times.
862         unchecked {
863             return _currentIndex - _burnCounter - _startTokenId();
864         }
865     }
866 
867     /**
868      * @dev Returns the total amount of tokens minted in the contract.
869      */
870     function _totalMinted() internal view returns (uint256) {
871         // Counter underflow is impossible as _currentIndex does not decrement,
872         // and it is initialized to `_startTokenId()`
873         unchecked {
874             return _currentIndex - _startTokenId();
875         }
876     }
877 
878     /**
879      * @dev Returns the total number of tokens burned.
880      */
881     function _totalBurned() internal view returns (uint256) {
882         return _burnCounter;
883     }
884 
885     /**
886      * @dev See {IERC165-supportsInterface}.
887      */
888     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
889         // The interface IDs are constants representing the first 4 bytes of the XOR of
890         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
891         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
892         return
893             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
894             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
895             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
896     }
897 
898     /**
899      * @dev See {IERC721-balanceOf}.
900      */
901     function balanceOf(address owner) public view override returns (uint256) {
902         if (owner == address(0)) revert BalanceQueryForZeroAddress();
903         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
904     }
905 
906     /**
907      * Returns the number of tokens minted by `owner`.
908      */
909     function _numberMinted(address owner) internal view returns (uint256) {
910         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
911     }
912 
913     /**
914      * Returns the number of tokens burned by or on behalf of `owner`.
915      */
916     function _numberBurned(address owner) internal view returns (uint256) {
917         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
918     }
919 
920     /**
921      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
922      */
923     function _getAux(address owner) internal view returns (uint64) {
924         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
925     }
926 
927     /**
928      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
929      * If there are multiple variables, please pack them into a uint64.
930      */
931     function _setAux(address owner, uint64 aux) internal {
932         uint256 packed = _packedAddressData[owner];
933         uint256 auxCasted;
934         assembly { // Cast aux without masking.
935             auxCasted := aux
936         }
937         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
938         _packedAddressData[owner] = packed;
939     }
940 
941     /**
942      * Returns the packed ownership data of `tokenId`.
943      */
944     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
945         uint256 curr = tokenId;
946 
947         unchecked {
948             if (_startTokenId() <= curr)
949                 if (curr < _currentIndex) {
950                     uint256 packed = _packedOwnerships[curr];
951                     // If not burned.
952                     if (packed & BITMASK_BURNED == 0) {
953                         // Invariant:
954                         // There will always be an ownership that has an address and is not burned
955                         // before an ownership that does not have an address and is not burned.
956                         // Hence, curr will not underflow.
957                         //
958                         // We can directly compare the packed value.
959                         // If the address is zero, packed is zero.
960                         while (packed == 0) {
961                             packed = _packedOwnerships[--curr];
962                         }
963                         return packed;
964                     }
965                 }
966         }
967         revert OwnerQueryForNonexistentToken();
968     }
969 
970     /**
971      * Returns the unpacked `TokenOwnership` struct from `packed`.
972      */
973     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
974         ownership.addr = address(uint160(packed));
975         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
976         ownership.burned = packed & BITMASK_BURNED != 0;
977     }
978 
979     /**
980      * Returns the unpacked `TokenOwnership` struct at `index`.
981      */
982     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
983         return _unpackedOwnership(_packedOwnerships[index]);
984     }
985 
986     /**
987      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
988      */
989     function _initializeOwnershipAt(uint256 index) internal {
990         if (_packedOwnerships[index] == 0) {
991             _packedOwnerships[index] = _packedOwnershipOf(index);
992         }
993     }
994 
995     /**
996      * Gas spent here starts off proportional to the maximum mint batch size.
997      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
998      */
999     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1000         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-ownerOf}.
1005      */
1006     function ownerOf(uint256 tokenId) public view override returns (address) {
1007         return address(uint160(_packedOwnershipOf(tokenId)));
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-name}.
1012      */
1013     function name() public view virtual override returns (string memory) {
1014         return _name;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-symbol}.
1019      */
1020     function symbol() public view virtual override returns (string memory) {
1021         return _symbol;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-tokenURI}.
1026      */
1027     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1028         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1029 
1030         string memory baseURI = _baseURI();
1031         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1032     }
1033 
1034     /**
1035      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1036      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1037      * by default, can be overriden in child contracts.
1038      */
1039     function _baseURI() internal view virtual returns (string memory) {
1040         return '';
1041     }
1042 
1043     /**
1044      * @dev Casts the address to uint256 without masking.
1045      */
1046     function _addressToUint256(address value) private pure returns (uint256 result) {
1047         assembly {
1048             result := value
1049         }
1050     }
1051 
1052     /**
1053      * @dev Casts the boolean to uint256 without branching.
1054      */
1055     function _boolToUint256(bool value) private pure returns (uint256 result) {
1056         assembly {
1057             result := value
1058         }
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-approve}.
1063      */
1064     function approve(address to, uint256 tokenId) public override {
1065         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1066         if (to == owner) revert ApprovalToCurrentOwner();
1067 
1068         if (_msgSenderERC721A() != owner)
1069             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1070                 revert ApprovalCallerNotOwnerNorApproved();
1071             }
1072 
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(owner, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-getApproved}.
1079      */
1080     function getApproved(uint256 tokenId) public view override returns (address) {
1081         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1082 
1083         return _tokenApprovals[tokenId];
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-setApprovalForAll}.
1088      */
1089     function setApprovalForAll(address operator, bool approved) public virtual override {
1090         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1091 
1092         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1093         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-isApprovedForAll}.
1098      */
1099     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1100         return _operatorApprovals[owner][operator];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-transferFrom}.
1105      */
1106     function transferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         _transfer(from, to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) public virtual override {
1122         safeTransferFrom(from, to, tokenId, '');
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-safeTransferFrom}.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) public virtual override {
1134         _transfer(from, to, tokenId);
1135         if (to.code.length != 0)
1136             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1137                 revert TransferToNonERC721ReceiverImplementer();
1138             }
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
1151             tokenId < _currentIndex && // If within bounds,
1152             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1153     }
1154 
1155     /**
1156      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1157      */
1158     function _safeMint(address to, uint256 quantity) internal {
1159         _safeMint(to, quantity, '');
1160     }
1161 
1162     /**
1163      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - If `to` refers to a smart contract, it must implement
1168      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data
1177     ) internal {
1178         uint256 startTokenId = _currentIndex;
1179         if (to == address(0)) revert MintToZeroAddress();
1180         if (quantity == 0) revert MintZeroQuantity();
1181 
1182         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1183 
1184         // Overflows are incredibly unrealistic.
1185         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1186         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1187         unchecked {
1188             // Updates:
1189             // - `balance += quantity`.
1190             // - `numberMinted += quantity`.
1191             //
1192             // We can directly add to the balance and number minted.
1193             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1194 
1195             // Updates:
1196             // - `address` to the owner.
1197             // - `startTimestamp` to the timestamp of minting.
1198             // - `burned` to `false`.
1199             // - `nextInitialized` to `quantity == 1`.
1200             _packedOwnerships[startTokenId] =
1201                 _addressToUint256(to) |
1202                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1203                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1204 
1205             uint256 updatedIndex = startTokenId;
1206             uint256 end = updatedIndex + quantity;
1207 
1208             if (to.code.length != 0) {
1209                 do {
1210                     emit Transfer(address(0), to, updatedIndex);
1211                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1212                         revert TransferToNonERC721ReceiverImplementer();
1213                     }
1214                 } while (updatedIndex < end);
1215                 // Reentrancy protection
1216                 if (_currentIndex != startTokenId) revert();
1217             } else {
1218                 do {
1219                     emit Transfer(address(0), to, updatedIndex++);
1220                 } while (updatedIndex < end);
1221             }
1222             _currentIndex = updatedIndex;
1223         }
1224         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1225     }
1226 
1227     /**
1228      * @dev Mints `quantity` tokens and transfers them to `to`.
1229      *
1230      * Requirements:
1231      *
1232      * - `to` cannot be the zero address.
1233      * - `quantity` must be greater than 0.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _mint(address to, uint256 quantity) internal {
1238         uint256 startTokenId = _currentIndex;
1239         if (to == address(0)) revert MintToZeroAddress();
1240         if (quantity == 0) revert MintZeroQuantity();
1241 
1242         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1243 
1244         // Overflows are incredibly unrealistic.
1245         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1246         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1247         unchecked {
1248             // Updates:
1249             // - `balance += quantity`.
1250             // - `numberMinted += quantity`.
1251             //
1252             // We can directly add to the balance and number minted.
1253             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1254 
1255             // Updates:
1256             // - `address` to the owner.
1257             // - `startTimestamp` to the timestamp of minting.
1258             // - `burned` to `false`.
1259             // - `nextInitialized` to `quantity == 1`.
1260             _packedOwnerships[startTokenId] =
1261                 _addressToUint256(to) |
1262                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1263                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1264 
1265             uint256 updatedIndex = startTokenId;
1266             uint256 end = updatedIndex + quantity;
1267 
1268             do {
1269                 emit Transfer(address(0), to, updatedIndex++);
1270             } while (updatedIndex < end);
1271 
1272             _currentIndex = updatedIndex;
1273         }
1274         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1275     }
1276 
1277     /**
1278      * @dev Transfers `tokenId` from `from` to `to`.
1279      *
1280      * Requirements:
1281      *
1282      * - `to` cannot be the zero address.
1283      * - `tokenId` token must be owned by `from`.
1284      *
1285      * Emits a {Transfer} event.
1286      */
1287     function _transfer(
1288         address from,
1289         address to,
1290         uint256 tokenId
1291     ) private {
1292         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1293 
1294         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1295 
1296         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1297             isApprovedForAll(from, _msgSenderERC721A()) ||
1298             getApproved(tokenId) == _msgSenderERC721A());
1299 
1300         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1301         if (to == address(0)) revert TransferToZeroAddress();
1302 
1303         _beforeTokenTransfers(from, to, tokenId, 1);
1304 
1305         // Clear approvals from the previous owner.
1306         delete _tokenApprovals[tokenId];
1307 
1308         // Underflow of the sender's balance is impossible because we check for
1309         // ownership above and the recipient's balance can't realistically overflow.
1310         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1311         unchecked {
1312             // We can directly increment and decrement the balances.
1313             --_packedAddressData[from]; // Updates: `balance -= 1`.
1314             ++_packedAddressData[to]; // Updates: `balance += 1`.
1315 
1316             // Updates:
1317             // - `address` to the next owner.
1318             // - `startTimestamp` to the timestamp of transfering.
1319             // - `burned` to `false`.
1320             // - `nextInitialized` to `true`.
1321             _packedOwnerships[tokenId] =
1322                 _addressToUint256(to) |
1323                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1324                 BITMASK_NEXT_INITIALIZED;
1325 
1326             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1327             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1328                 uint256 nextTokenId = tokenId + 1;
1329                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1330                 if (_packedOwnerships[nextTokenId] == 0) {
1331                     // If the next slot is within bounds.
1332                     if (nextTokenId != _currentIndex) {
1333                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1334                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1335                     }
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, to, tokenId);
1341         _afterTokenTransfers(from, to, tokenId, 1);
1342     }
1343 
1344     /**
1345      * @dev Equivalent to `_burn(tokenId, false)`.
1346      */
1347     function _burn(uint256 tokenId) internal virtual {
1348         _burn(tokenId, false);
1349     }
1350 
1351     /**
1352      * @dev Destroys `tokenId`.
1353      * The approval is cleared when the token is burned.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must exist.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1362         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1363 
1364         address from = address(uint160(prevOwnershipPacked));
1365 
1366         if (approvalCheck) {
1367             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1368                 isApprovedForAll(from, _msgSenderERC721A()) ||
1369                 getApproved(tokenId) == _msgSenderERC721A());
1370 
1371             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1372         }
1373 
1374         _beforeTokenTransfers(from, address(0), tokenId, 1);
1375 
1376         // Clear approvals from the previous owner.
1377         delete _tokenApprovals[tokenId];
1378 
1379         // Underflow of the sender's balance is impossible because we check for
1380         // ownership above and the recipient's balance can't realistically overflow.
1381         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1382         unchecked {
1383             // Updates:
1384             // - `balance -= 1`.
1385             // - `numberBurned += 1`.
1386             //
1387             // We can directly decrement the balance, and increment the number burned.
1388             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1389             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1390 
1391             // Updates:
1392             // - `address` to the last owner.
1393             // - `startTimestamp` to the timestamp of burning.
1394             // - `burned` to `true`.
1395             // - `nextInitialized` to `true`.
1396             _packedOwnerships[tokenId] =
1397                 _addressToUint256(from) |
1398                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1399                 BITMASK_BURNED | 
1400                 BITMASK_NEXT_INITIALIZED;
1401 
1402             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1403             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1404                 uint256 nextTokenId = tokenId + 1;
1405                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1406                 if (_packedOwnerships[nextTokenId] == 0) {
1407                     // If the next slot is within bounds.
1408                     if (nextTokenId != _currentIndex) {
1409                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1410                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1411                     }
1412                 }
1413             }
1414         }
1415 
1416         emit Transfer(from, address(0), tokenId);
1417         _afterTokenTransfers(from, address(0), tokenId, 1);
1418 
1419         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1420         unchecked {
1421             _burnCounter++;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1427      *
1428      * @param from address representing the previous owner of the given token ID
1429      * @param to target address that will receive the tokens
1430      * @param tokenId uint256 ID of the token to be transferred
1431      * @param _data bytes optional data to send along with the call
1432      * @return bool whether the call correctly returned the expected magic value
1433      */
1434     function _checkContractOnERC721Received(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) private returns (bool) {
1440         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1441             bytes4 retval
1442         ) {
1443             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1444         } catch (bytes memory reason) {
1445             if (reason.length == 0) {
1446                 revert TransferToNonERC721ReceiverImplementer();
1447             } else {
1448                 assembly {
1449                     revert(add(32, reason), mload(reason))
1450                 }
1451             }
1452         }
1453     }
1454 
1455     /**
1456      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1457      * And also called before burning one token.
1458      *
1459      * startTokenId - the first token id to be transferred
1460      * quantity - the amount to be transferred
1461      *
1462      * Calling conditions:
1463      *
1464      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1465      * transferred to `to`.
1466      * - When `from` is zero, `tokenId` will be minted for `to`.
1467      * - When `to` is zero, `tokenId` will be burned by `from`.
1468      * - `from` and `to` are never both zero.
1469      */
1470     function _beforeTokenTransfers(
1471         address from,
1472         address to,
1473         uint256 startTokenId,
1474         uint256 quantity
1475     ) internal virtual {}
1476 
1477     /**
1478      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1479      * minting.
1480      * And also called after one token has been burned.
1481      *
1482      * startTokenId - the first token id to be transferred
1483      * quantity - the amount to be transferred
1484      *
1485      * Calling conditions:
1486      *
1487      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1488      * transferred to `to`.
1489      * - When `from` is zero, `tokenId` has been minted for `to`.
1490      * - When `to` is zero, `tokenId` has been burned by `from`.
1491      * - `from` and `to` are never both zero.
1492      */
1493     function _afterTokenTransfers(
1494         address from,
1495         address to,
1496         uint256 startTokenId,
1497         uint256 quantity
1498     ) internal virtual {}
1499 
1500     /**
1501      * @dev Returns the message sender (defaults to `msg.sender`).
1502      *
1503      * If you are writing GSN compatible contracts, you need to override this function.
1504      */
1505     function _msgSenderERC721A() internal view virtual returns (address) {
1506         return msg.sender;
1507     }
1508 
1509     /**
1510      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1511      */
1512     function _toString(uint256 value) internal pure returns (string memory ptr) {
1513         assembly {
1514             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1515             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1516             // We will need 1 32-byte word to store the length, 
1517             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1518             ptr := add(mload(0x40), 128)
1519             // Update the free memory pointer to allocate.
1520             mstore(0x40, ptr)
1521 
1522             // Cache the end of the memory to calculate the length later.
1523             let end := ptr
1524 
1525             // We write the string from the rightmost digit to the leftmost digit.
1526             // The following is essentially a do-while loop that also handles the zero case.
1527             // Costs a bit more than early returning for the zero case,
1528             // but cheaper in terms of deployment and overall runtime costs.
1529             for { 
1530                 // Initialize and perform the first pass without check.
1531                 let temp := value
1532                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1533                 ptr := sub(ptr, 1)
1534                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1535                 mstore8(ptr, add(48, mod(temp, 10)))
1536                 temp := div(temp, 10)
1537             } temp { 
1538                 // Keep dividing `temp` until zero.
1539                 temp := div(temp, 10)
1540             } { // Body of the for loop.
1541                 ptr := sub(ptr, 1)
1542                 mstore8(ptr, add(48, mod(temp, 10)))
1543             }
1544             
1545             let length := sub(end, ptr)
1546             // Move the pointer 32 bytes leftwards to make room for the length.
1547             ptr := sub(ptr, 32)
1548             // Store the length.
1549             mstore(ptr, length)
1550         }
1551     }
1552 }
1553 
1554 // File: contracts/LeaveMeNever.sol
1555 pragma solidity ^0.8.0;
1556 
1557 contract LeaveMeNever is ERC721A, Ownable, ReentrancyGuard {
1558     using Address for address;
1559     using Strings for uint256;
1560 
1561     uint256 public constant MAX_SUPPLY = 5000;
1562     uint256 public constant MAX_FREE_SUPPLY = 2000;
1563     uint256 public constant MAX_MINT_PER_TX = 20;
1564     uint256 public constant MAX_FREE_MINT_PER_WALLET = 2;
1565 
1566     uint256 public freeMinted;
1567     uint256 public salePrice = .005 ether;
1568 
1569     bool public mintActive;
1570 
1571     mapping(address => uint256) public totalFreeMint;
1572 
1573     // metadata URI
1574     string private _baseTokenURI;
1575 
1576     constructor() ERC721A("LeaveMeNever", "LMN") {}
1577 
1578     function mint(uint256 _quantity) external payable nonReentrant {
1579         require(tx.origin == msg.sender, "Cannot be called by a contract");
1580         require(mintActive, "Mint Not Active");
1581         require(_quantity > 0 && _quantity <= MAX_MINT_PER_TX, "Incorrect Mint Quantity");
1582         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Beyond Max Supply");
1583 
1584         uint256 cost = salePrice * _quantity;
1585 
1586         if (freeMinted < MAX_FREE_SUPPLY) {
1587             uint256 remainingFreeMints = MAX_FREE_MINT_PER_WALLET - totalFreeMint[msg.sender];
1588             if (remainingFreeMints > 0) {
1589                 if (_quantity <= remainingFreeMints) {
1590                     cost = 0;
1591                     require(msg.value >= cost, "Not enough payment sent");
1592                     totalFreeMint[msg.sender] += _quantity;
1593                     freeMinted = freeMinted + _quantity;
1594                 } else {
1595                     cost = salePrice * (_quantity - remainingFreeMints);
1596                     require(msg.value >= cost, "Not enough payment sent");
1597                     totalFreeMint[msg.sender] += remainingFreeMints;
1598                     freeMinted = freeMinted + remainingFreeMints;
1599                 }
1600             } else {
1601                 require(msg.value >= cost, "Not enough payment sent");
1602             }
1603         } else {
1604             require(msg.value >= cost, "Not enough payment sent");
1605         }
1606 
1607         _safeMint(msg.sender, _quantity);
1608     }
1609 
1610     function devMint(uint256 _quantity, address _receiver) external onlyOwner {
1611         require(_quantity > 0, "Quantity must be greater than 0");
1612         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Beyond Max Supply");
1613         _safeMint(_receiver, _quantity);
1614     }
1615 
1616     function _baseURI() internal view virtual override returns (string memory) {
1617         return _baseTokenURI;
1618     }
1619 
1620     function setBaseURI(string calldata baseURI) external onlyOwner {
1621         _baseTokenURI = baseURI;
1622     }
1623 
1624     function changeMintPrice(uint256 _newPrice) external onlyOwner {
1625         salePrice = _newPrice;
1626     }
1627 
1628     function numberMinted(address owner) public view returns (uint256) {
1629         return _numberMinted(owner);
1630     }
1631 
1632     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1633         return _ownershipOf(tokenId);
1634     }
1635 
1636     function toggleMintActive() external onlyOwner {
1637         mintActive = !mintActive;
1638     }
1639 
1640     function withdraw() external onlyOwner nonReentrant {
1641         Address.sendValue(payable(msg.sender), address(this).balance);
1642     }
1643 }