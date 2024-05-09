1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-09
3 */
4 
5 
6 
7 //           EGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEG
8 //           EGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEG
9 //           EGEGE                  GEGEGEGEGEGE                  GEGEGEG
10 //           EGEGE                  GEGEGEGEGE                  GEGEGEGEG
11 //           EGEGE        GEGEGEGEGEGEGEGEGEGE        GEGEGEGEGEGEGEGEGEG
12 //           EGEGE        GEGEGEGEGEGEGEGEGEGE        GEGEGEGEGEGEGGEGEGE  
13 //           EGEGE                  GEGEGEGEGE        GEGEG        EGEGEG
14 //           EGEGE                  GEGEGEGEGE        EGEGEGEE      GEGEG
15 //           EGEGE        GEGEGEGEGEGEGEGEGEGE        GEGEGEGEG     EGEGE
16 //           EGEGE        GEGEGEGEGEGEGEGEGEGE        GEGEGEGEG     EGEGE
17 //           EGEGE                  GEGEGEGEGE                      GEGEG
18 //           EGEGE                  GEGEGEGEGEG                     EGEGE
19 //           EGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEG
20 //           EGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEGEG
21 
22                                        
23 
24 
25 // SPDX-License-Identifier: MIT
26 
27 // File: @openzeppelin/contracts/utils/Strings.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39     uint8 private constant _ADDRESS_LENGTH = 20;
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
99      */
100     function toHexString(address addr) internal pure returns (string memory) {
101         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
102     }
103 }
104 
105 // File: @openzeppelin/contracts/utils/Address.sol
106 
107 
108 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
109 
110 pragma solidity ^0.8.1;
111 
112 /**
113  * @dev Collection of functions related to the address type
114  */
115 library Address {
116     /**
117      * @dev Returns true if `account` is a contract.
118      *
119      * [IMPORTANT]
120      * ====
121      * It is unsafe to assume that an address for which this function returns
122      * false is an externally-owned account (EOA) and not a contract.
123      *
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *
127      *  - an externally-owned account
128      *  - a contract in construction
129      *  - an address where a contract will be created
130      *  - an address where a contract lived, but was destroyed
131      * ====
132      *
133      * [IMPORTANT]
134      * ====
135      * You shouldn't rely on `isContract` to protect against flash loan attacks!
136      *
137      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
138      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
139      * constructor.
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize/address.code.length, which returns 0
144         // for contracts in construction, since the code is only stored at the end
145         // of the constructor execution.
146 
147         return account.code.length > 0;
148     }
149 
150     /**
151      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
152      * `recipient`, forwarding all available gas and reverting on errors.
153      *
154      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
155      * of certain opcodes, possibly making contracts go over the 2300 gas limit
156      * imposed by `transfer`, making them unable to receive funds via
157      * `transfer`. {sendValue} removes this limitation.
158      *
159      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
160      *
161      * IMPORTANT: because control is transferred to `recipient`, care must be
162      * taken to not create reentrancy vulnerabilities. Consider using
163      * {ReentrancyGuard} or the
164      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
165      */
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(address(this).balance >= amount, "Address: insufficient balance");
168 
169         (bool success, ) = recipient.call{value: amount}("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173     /**
174      * @dev Performs a Solidity function call using a low level `call`. A
175      * plain `call` is an unsafe replacement for a function call: use this
176      * function instead.
177      *
178      * If `target` reverts with a revert reason, it is bubbled up by this
179      * function (like regular Solidity function calls).
180      *
181      * Returns the raw returned data. To convert to the expected return value,
182      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
183      *
184      * Requirements:
185      *
186      * - `target` must be a contract.
187      * - calling `target` with `data` must not revert.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionCall(target, data, "Address: low-level call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
197      * `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but also transferring `value` wei to `target`.
212      *
213      * Requirements:
214      *
215      * - the calling contract must have an ETH balance of at least `value`.
216      * - the called Solidity function must be `payable`.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
230      * with `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         require(address(this).balance >= value, "Address: insufficient balance for call");
241         require(isContract(target), "Address: call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.call{value: value}(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
254         return functionStaticCall(target, data, "Address: low-level static call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal view returns (bytes memory) {
268         require(isContract(target), "Address: static call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.staticcall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
303      * revert reason using the provided one.
304      *
305      * _Available since v4.3._
306      */
307     function verifyCallResult(
308         bool success,
309         bytes memory returndata,
310         string memory errorMessage
311     ) internal pure returns (bytes memory) {
312         if (success) {
313             return returndata;
314         } else {
315             // Look for revert reason and bubble it up if present
316             if (returndata.length > 0) {
317                 // The easiest way to bubble the revert reason is using memory via assembly
318                 /// @solidity memory-safe-assembly
319                 assembly {
320                     let returndata_size := mload(returndata)
321                     revert(add(32, returndata), returndata_size)
322                 }
323             } else {
324                 revert(errorMessage);
325             }
326         }
327     }
328 }
329 
330 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Contract module that helps prevent reentrant calls to a function.
339  *
340  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
341  * available, which can be applied to functions to make sure there are no nested
342  * (reentrant) calls to them.
343  *
344  * Note that because there is a single `nonReentrant` guard, functions marked as
345  * `nonReentrant` may not call one another. This can be worked around by making
346  * those functions `private`, and then adding `external` `nonReentrant` entry
347  * points to them.
348  *
349  * TIP: If you would like to learn more about reentrancy and alternative ways
350  * to protect against it, check out our blog post
351  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
352  */
353 abstract contract ReentrancyGuard {
354     // Booleans are more expensive than uint256 or any type that takes up a full
355     // word because each write operation emits an extra SLOAD to first read the
356     // slot's contents, replace the bits taken up by the boolean, and then write
357     // back. This is the compiler's defense against contract upgrades and
358     // pointer aliasing, and it cannot be disabled.
359 
360     // The values being non-zero value makes deployment a bit more expensive,
361     // but in exchange the refund on every call to nonReentrant will be lower in
362     // amount. Since refunds are capped to a percentage of the total
363     // transaction's gas, it is best to keep them low in cases like this one, to
364     // increase the likelihood of the full refund coming into effect.
365     uint256 private constant _NOT_ENTERED = 1;
366     uint256 private constant _ENTERED = 2;
367 
368     uint256 private _status;
369 
370     constructor() {
371         _status = _NOT_ENTERED;
372     }
373 
374     /**
375      * @dev Prevents a contract from calling itself, directly or indirectly.
376      * Calling a `nonReentrant` function from another `nonReentrant`
377      * function is not supported. It is possible to prevent this from happening
378      * by making the `nonReentrant` function external, and making it call a
379      * `private` function that does the actual work.
380      */
381     modifier nonReentrant() {
382         // On the first call to nonReentrant, _notEntered will be true
383         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
384 
385         // Any calls to nonReentrant after this point will fail
386         _status = _ENTERED;
387 
388         _;
389 
390         // By storing the original value once again, a refund is triggered (see
391         // https://eips.ethereum.org/EIPS/eip-2200)
392         _status = _NOT_ENTERED;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/utils/Context.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes calldata) {
419         return msg.data;
420     }
421 }
422 
423 // File: @openzeppelin/contracts/access/Ownable.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 abstract contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor() {
452         _transferOwnership(_msgSender());
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         _checkOwner();
460         _;
461     }
462 
463     /**
464      * @dev Returns the address of the current owner.
465      */
466     function owner() public view virtual returns (address) {
467         return _owner;
468     }
469 
470     /**
471      * @dev Throws if the sender is not the owner.
472      */
473     function _checkOwner() internal view virtual {
474         require(owner() == _msgSender(), "Ownable: caller is not the owner");
475     }
476 
477     /**
478      * @dev Leaves the contract without owner. It will not be possible to call
479      * `onlyOwner` functions anymore. Can only be called by the current owner.
480      *
481      * NOTE: Renouncing ownership will leave the contract without an owner,
482      * thereby removing any functionality that is only available to the owner.
483      */
484     function renounceOwnership() public virtual onlyOwner {
485         _transferOwnership(address(0));
486     }
487 
488     /**
489      * @dev Transfers ownership of the contract to a new account (`newOwner`).
490      * Can only be called by the current owner.
491      */
492     function transferOwnership(address newOwner) public virtual onlyOwner {
493         require(newOwner != address(0), "Ownable: new owner is the zero address");
494         _transferOwnership(newOwner);
495     }
496 
497     /**
498      * @dev Transfers ownership of the contract to a new account (`newOwner`).
499      * Internal function without access restriction.
500      */
501     function _transferOwnership(address newOwner) internal virtual {
502         address oldOwner = _owner;
503         _owner = newOwner;
504         emit OwnershipTransferred(oldOwner, newOwner);
505     }
506 }
507 
508 // File: erc721a/contracts/IERC721A.sol
509 
510 
511 // ERC721A Contracts v4.1.0
512 // Creator: Chiru Labs
513 
514 pragma solidity ^0.8.4;
515 
516 /**
517  * @dev Interface of an ERC721A compliant contract.
518  */
519 interface IERC721A {
520     /**
521      * The caller must own the token or be an approved operator.
522      */
523     error ApprovalCallerNotOwnerNorApproved();
524 
525     /**
526      * The token does not exist.
527      */
528     error ApprovalQueryForNonexistentToken();
529 
530     /**
531      * The caller cannot approve to their own address.
532      */
533     error ApproveToCaller();
534 
535     /**
536      * Cannot query the balance for the zero address.
537      */
538     error BalanceQueryForZeroAddress();
539 
540     /**
541      * Cannot mint to the zero address.
542      */
543     error MintToZeroAddress();
544 
545     /**
546      * The quantity of tokens minted must be more than zero.
547      */
548     error MintZeroQuantity();
549 
550     /**
551      * The token does not exist.
552      */
553     error OwnerQueryForNonexistentToken();
554 
555     /**
556      * The caller must own the token or be an approved operator.
557      */
558     error TransferCallerNotOwnerNorApproved();
559 
560     /**
561      * The token must be owned by `from`.
562      */
563     error TransferFromIncorrectOwner();
564 
565     /**
566      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
567      */
568     error TransferToNonERC721ReceiverImplementer();
569 
570     /**
571      * Cannot transfer to the zero address.
572      */
573     error TransferToZeroAddress();
574 
575     /**
576      * The token does not exist.
577      */
578     error URIQueryForNonexistentToken();
579 
580     /**
581      * The `quantity` minted with ERC2309 exceeds the safety limit.
582      */
583     error MintERC2309QuantityExceedsLimit();
584 
585     /**
586      * The `extraData` cannot be set on an unintialized ownership slot.
587      */
588     error OwnershipNotInitializedForExtraData();
589 
590     struct TokenOwnership {
591         // The address of the owner.
592         address addr;
593         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
594         uint64 startTimestamp;
595         // Whether the token has been burned.
596         bool burned;
597         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
598         uint24 extraData;
599     }
600 
601     /**
602      * @dev Returns the total amount of tokens stored by the contract.
603      *
604      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
605      */
606     function totalSupply() external view returns (uint256);
607 
608     // ==============================
609     //            IERC165
610     // ==============================
611 
612     /**
613      * @dev Returns true if this contract implements the interface defined by
614      * `interfaceId`. See the corresponding
615      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
616      * to learn more about how these ids are created.
617      *
618      * This function call must use less than 30 000 gas.
619      */
620     function supportsInterface(bytes4 interfaceId) external view returns (bool);
621 
622     // ==============================
623     //            IERC721
624     // ==============================
625 
626     /**
627      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
628      */
629     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
633      */
634     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
638      */
639     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
640 
641     /**
642      * @dev Returns the number of tokens in ``owner``'s account.
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
656      * @dev Safely transfers `tokenId` token from `from` to `to`.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes calldata data
673     ) external;
674 
675     /**
676      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
677      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Transfers `tokenId` token from `from` to `to`.
697      *
698      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      *
707      * Emits a {Transfer} event.
708      */
709     function transferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) external;
714 
715     /**
716      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
717      * The approval is cleared when the token is transferred.
718      *
719      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
720      *
721      * Requirements:
722      *
723      * - The caller must own the token or be an approved operator.
724      * - `tokenId` must exist.
725      *
726      * Emits an {Approval} event.
727      */
728     function approve(address to, uint256 tokenId) external;
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
743      * @dev Returns the account approved for `tokenId` token.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function getApproved(uint256 tokenId) external view returns (address operator);
750 
751     /**
752      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
753      *
754      * See {setApprovalForAll}
755      */
756     function isApprovedForAll(address owner, address operator) external view returns (bool);
757 
758     // ==============================
759     //        IERC721Metadata
760     // ==============================
761 
762     /**
763      * @dev Returns the token collection name.
764      */
765     function name() external view returns (string memory);
766 
767     /**
768      * @dev Returns the token collection symbol.
769      */
770     function symbol() external view returns (string memory);
771 
772     /**
773      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
774      */
775     function tokenURI(uint256 tokenId) external view returns (string memory);
776 
777     // ==============================
778     //            IERC2309
779     // ==============================
780 
781     /**
782      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
783      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
784      */
785     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
786 }
787 
788 // File: erc721a/contracts/ERC721A.sol
789 
790 
791 // ERC721A Contracts v4.1.0
792 // Creator: Chiru Labs
793 
794 pragma solidity ^0.8.4;
795 
796 
797 /**
798  * @dev ERC721 token receiver interface.
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
810  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
811  * including the Metadata extension. Built to optimize for lower gas during batch mints.
812  *
813  * Assumes serials are sequentially minted starting at `_startTokenId()`
814  * (defaults to 0, e.g. 0, 1, 2, 3..).
815  *
816  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
817  *
818  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
819  */
820 contract ERC721A is IERC721A {
821     // Mask of an entry in packed address data.
822     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
823 
824     // The bit position of `numberMinted` in packed address data.
825     uint256 private constant BITPOS_NUMBER_MINTED = 64;
826 
827     // The bit position of `numberBurned` in packed address data.
828     uint256 private constant BITPOS_NUMBER_BURNED = 128;
829 
830     // The bit position of `aux` in packed address data.
831     uint256 private constant BITPOS_AUX = 192;
832 
833     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
834     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
835 
836     // The bit position of `startTimestamp` in packed ownership.
837     uint256 private constant BITPOS_START_TIMESTAMP = 160;
838 
839     // The bit mask of the `burned` bit in packed ownership.
840     uint256 private constant BITMASK_BURNED = 1 << 224;
841 
842     // The bit position of the `nextInitialized` bit in packed ownership.
843     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
844 
845     // The bit mask of the `nextInitialized` bit in packed ownership.
846     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
847 
848     // The bit position of `extraData` in packed ownership.
849     uint256 private constant BITPOS_EXTRA_DATA = 232;
850 
851     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
852     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
853 
854     // The mask of the lower 160 bits for addresses.
855     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
856 
857     // The maximum `quantity` that can be minted with `_mintERC2309`.
858     // This limit is to prevent overflows on the address data entries.
859     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
860     // is required to cause an overflow, which is unrealistic.
861     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
862 
863     // The tokenId of the next token to be minted.
864     uint256 private _currentIndex;
865 
866     // The number of tokens burned.
867     uint256 private _burnCounter;
868 
869     // Token name
870     string private _name;
871 
872     // Token symbol
873     string private _symbol;
874 
875     // Mapping from token ID to ownership details
876     // An empty struct value does not necessarily mean the token is unowned.
877     // See `_packedOwnershipOf` implementation for details.
878     //
879     // Bits Layout:
880     // - [0..159]   `addr`
881     // - [160..223] `startTimestamp`
882     // - [224]      `burned`
883     // - [225]      `nextInitialized`
884     // - [232..255] `extraData`
885     mapping(uint256 => uint256) private _packedOwnerships;
886 
887     // Mapping owner address to address data.
888     //
889     // Bits Layout:
890     // - [0..63]    `balance`
891     // - [64..127]  `numberMinted`
892     // - [128..191] `numberBurned`
893     // - [192..255] `aux`
894     mapping(address => uint256) private _packedAddressData;
895 
896     // Mapping from token ID to approved address.
897     mapping(uint256 => address) private _tokenApprovals;
898 
899     // Mapping from owner to operator approvals
900     mapping(address => mapping(address => bool)) private _operatorApprovals;
901 
902     constructor(string memory name_, string memory symbol_) {
903         _name = name_;
904         _symbol = symbol_;
905         _currentIndex = _startTokenId();
906     }
907 
908     /**
909      * @dev Returns the starting token ID.
910      * To change the starting token ID, please override this function.
911      */
912     function _startTokenId() internal view virtual returns (uint256) {
913         return 0;
914     }
915 
916     /**
917      * @dev Returns the next token ID to be minted.
918      */
919     function _nextTokenId() internal view returns (uint256) {
920         return _currentIndex;
921     }
922 
923     /**
924      * @dev Returns the total number of tokens in existence.
925      * Burned tokens will reduce the count.
926      * To get the total number of tokens minted, please see `_totalMinted`.
927      */
928     function totalSupply() public view override returns (uint256) {
929         // Counter underflow is impossible as _burnCounter cannot be incremented
930         // more than `_currentIndex - _startTokenId()` times.
931         unchecked {
932             return _currentIndex - _burnCounter - _startTokenId();
933         }
934     }
935 
936     /**
937      * @dev Returns the total amount of tokens minted in the contract.
938      */
939     function _totalMinted() internal view returns (uint256) {
940         // Counter underflow is impossible as _currentIndex does not decrement,
941         // and it is initialized to `_startTokenId()`
942         unchecked {
943             return _currentIndex - _startTokenId();
944         }
945     }
946 
947     /**
948      * @dev Returns the total number of tokens burned.
949      */
950     function _totalBurned() internal view returns (uint256) {
951         return _burnCounter;
952     }
953 
954     /**
955      * @dev See {IERC165-supportsInterface}.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
958         // The interface IDs are constants representing the first 4 bytes of the XOR of
959         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
960         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
961         return
962             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
963             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
964             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
965     }
966 
967     /**
968      * @dev See {IERC721-balanceOf}.
969      */
970     function balanceOf(address owner) public view override returns (uint256) {
971         if (owner == address(0)) revert BalanceQueryForZeroAddress();
972         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
973     }
974 
975     /**
976      * Returns the number of tokens minted by `owner`.
977      */
978     function _numberMinted(address owner) internal view returns (uint256) {
979         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
980     }
981 
982     /**
983      * Returns the number of tokens burned by or on behalf of `owner`.
984      */
985     function _numberBurned(address owner) internal view returns (uint256) {
986         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
987     }
988 
989     /**
990      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
991      */
992     function _getAux(address owner) internal view returns (uint64) {
993         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
994     }
995 
996     /**
997      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
998      * If there are multiple variables, please pack them into a uint64.
999      */
1000     function _setAux(address owner, uint64 aux) internal {
1001         uint256 packed = _packedAddressData[owner];
1002         uint256 auxCasted;
1003         // Cast `aux` with assembly to avoid redundant masking.
1004         assembly {
1005             auxCasted := aux
1006         }
1007         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1008         _packedAddressData[owner] = packed;
1009     }
1010 
1011     /**
1012      * Returns the packed ownership data of `tokenId`.
1013      */
1014     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1015         uint256 curr = tokenId;
1016 
1017         unchecked {
1018             if (_startTokenId() <= curr)
1019                 if (curr < _currentIndex) {
1020                     uint256 packed = _packedOwnerships[curr];
1021                     // If not burned.
1022                     if (packed & BITMASK_BURNED == 0) {
1023                         // Invariant:
1024                         // There will always be an ownership that has an address and is not burned
1025                         // before an ownership that does not have an address and is not burned.
1026                         // Hence, curr will not underflow.
1027                         //
1028                         // We can directly compare the packed value.
1029                         // If the address is zero, packed is zero.
1030                         while (packed == 0) {
1031                             packed = _packedOwnerships[--curr];
1032                         }
1033                         return packed;
1034                     }
1035                 }
1036         }
1037         revert OwnerQueryForNonexistentToken();
1038     }
1039 
1040     /**
1041      * Returns the unpacked `TokenOwnership` struct from `packed`.
1042      */
1043     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1044         ownership.addr = address(uint160(packed));
1045         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1046         ownership.burned = packed & BITMASK_BURNED != 0;
1047         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1048     }
1049 
1050     /**
1051      * Returns the unpacked `TokenOwnership` struct at `index`.
1052      */
1053     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1054         return _unpackedOwnership(_packedOwnerships[index]);
1055     }
1056 
1057     /**
1058      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1059      */
1060     function _initializeOwnershipAt(uint256 index) internal {
1061         if (_packedOwnerships[index] == 0) {
1062             _packedOwnerships[index] = _packedOwnershipOf(index);
1063         }
1064     }
1065 
1066     /**
1067      * Gas spent here starts off proportional to the maximum mint batch size.
1068      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1069      */
1070     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1071         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1072     }
1073 
1074     /**
1075      * @dev Packs ownership data into a single uint256.
1076      */
1077     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1078         assembly {
1079             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1080             owner := and(owner, BITMASK_ADDRESS)
1081             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1082             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1083         }
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-ownerOf}.
1088      */
1089     function ownerOf(uint256 tokenId) public view override returns (address) {
1090         return address(uint160(_packedOwnershipOf(tokenId)));
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Metadata-name}.
1095      */
1096     function name() public view virtual override returns (string memory) {
1097         return _name;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-symbol}.
1102      */
1103     function symbol() public view virtual override returns (string memory) {
1104         return _symbol;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Metadata-tokenURI}.
1109      */
1110     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1111         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1112 
1113         string memory baseURI = _baseURI();
1114         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1115     }
1116 
1117     /**
1118      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1119      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1120      * by default, it can be overridden in child contracts.
1121      */
1122     function _baseURI() internal view virtual returns (string memory) {
1123         return '';
1124     }
1125 
1126     /**
1127      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1128      */
1129     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1130         // For branchless setting of the `nextInitialized` flag.
1131         assembly {
1132             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1133             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1134         }
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-approve}.
1139      */
1140     function approve(address to, uint256 tokenId) public override {
1141         address owner = ownerOf(tokenId);
1142 
1143         if (_msgSenderERC721A() != owner)
1144             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1145                 revert ApprovalCallerNotOwnerNorApproved();
1146             }
1147 
1148         _tokenApprovals[tokenId] = to;
1149         emit Approval(owner, to, tokenId);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-getApproved}.
1154      */
1155     function getApproved(uint256 tokenId) public view override returns (address) {
1156         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1157 
1158         return _tokenApprovals[tokenId];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-setApprovalForAll}.
1163      */
1164     function setApprovalForAll(address operator, bool approved) public virtual override {
1165         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1166 
1167         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1168         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-isApprovedForAll}.
1173      */
1174     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1175         return _operatorApprovals[owner][operator];
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-safeTransferFrom}.
1180      */
1181     function safeTransferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) public virtual override {
1186         safeTransferFrom(from, to, tokenId, '');
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-safeTransferFrom}.
1191      */
1192     function safeTransferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) public virtual override {
1198         transferFrom(from, to, tokenId);
1199         if (to.code.length != 0)
1200             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1201                 revert TransferToNonERC721ReceiverImplementer();
1202             }
1203     }
1204 
1205     /**
1206      * @dev Returns whether `tokenId` exists.
1207      *
1208      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1209      *
1210      * Tokens start existing when they are minted (`_mint`),
1211      */
1212     function _exists(uint256 tokenId) internal view returns (bool) {
1213         return
1214             _startTokenId() <= tokenId &&
1215             tokenId < _currentIndex && // If within bounds,
1216             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1217     }
1218 
1219     /**
1220      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1221      */
1222     function _safeMint(address to, uint256 quantity) internal {
1223         _safeMint(to, quantity, '');
1224     }
1225 
1226     /**
1227      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - If `to` refers to a smart contract, it must implement
1232      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1233      * - `quantity` must be greater than 0.
1234      *
1235      * See {_mint}.
1236      *
1237      * Emits a {Transfer} event for each mint.
1238      */
1239     function _safeMint(
1240         address to,
1241         uint256 quantity,
1242         bytes memory _data
1243     ) internal {
1244         _mint(to, quantity);
1245 
1246         unchecked {
1247             if (to.code.length != 0) {
1248                 uint256 end = _currentIndex;
1249                 uint256 index = end - quantity;
1250                 do {
1251                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1252                         revert TransferToNonERC721ReceiverImplementer();
1253                     }
1254                 } while (index < end);
1255                 // Reentrancy protection.
1256                 if (_currentIndex != end) revert();
1257             }
1258         }
1259     }
1260 
1261     /**
1262      * @dev Mints `quantity` tokens and transfers them to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - `to` cannot be the zero address.
1267      * - `quantity` must be greater than 0.
1268      *
1269      * Emits a {Transfer} event for each mint.
1270      */
1271     function _mint(address to, uint256 quantity) internal {
1272         uint256 startTokenId = _currentIndex;
1273         if (to == address(0)) revert MintToZeroAddress();
1274         if (quantity == 0) revert MintZeroQuantity();
1275 
1276         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1277 
1278         // Overflows are incredibly unrealistic.
1279         // `balance` and `numberMinted` have a maximum limit of 2**64.
1280         // `tokenId` has a maximum limit of 2**256.
1281         unchecked {
1282             // Updates:
1283             // - `balance += quantity`.
1284             // - `numberMinted += quantity`.
1285             //
1286             // We can directly add to the `balance` and `numberMinted`.
1287             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1288 
1289             // Updates:
1290             // - `address` to the owner.
1291             // - `startTimestamp` to the timestamp of minting.
1292             // - `burned` to `false`.
1293             // - `nextInitialized` to `quantity == 1`.
1294             _packedOwnerships[startTokenId] = _packOwnershipData(
1295                 to,
1296                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1297             );
1298 
1299             uint256 tokenId = startTokenId;
1300             uint256 end = startTokenId + quantity;
1301             do {
1302                 emit Transfer(address(0), to, tokenId++);
1303             } while (tokenId < end);
1304 
1305             _currentIndex = end;
1306         }
1307         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1308     }
1309 
1310     /**
1311      * @dev Mints `quantity` tokens and transfers them to `to`.
1312      *
1313      * This function is intended for efficient minting only during contract creation.
1314      *
1315      * It emits only one {ConsecutiveTransfer} as defined in
1316      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1317      * instead of a sequence of {Transfer} event(s).
1318      *
1319      * Calling this function outside of contract creation WILL make your contract
1320      * non-compliant with the ERC721 standard.
1321      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1322      * {ConsecutiveTransfer} event is only permissible during contract creation.
1323      *
1324      * Requirements:
1325      *
1326      * - `to` cannot be the zero address.
1327      * - `quantity` must be greater than 0.
1328      *
1329      * Emits a {ConsecutiveTransfer} event.
1330      */
1331     function _mintERC2309(address to, uint256 quantity) internal {
1332         uint256 startTokenId = _currentIndex;
1333         if (to == address(0)) revert MintToZeroAddress();
1334         if (quantity == 0) revert MintZeroQuantity();
1335         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1336 
1337         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1338 
1339         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1340         unchecked {
1341             // Updates:
1342             // - `balance += quantity`.
1343             // - `numberMinted += quantity`.
1344             //
1345             // We can directly add to the `balance` and `numberMinted`.
1346             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1347 
1348             // Updates:
1349             // - `address` to the owner.
1350             // - `startTimestamp` to the timestamp of minting.
1351             // - `burned` to `false`.
1352             // - `nextInitialized` to `quantity == 1`.
1353             _packedOwnerships[startTokenId] = _packOwnershipData(
1354                 to,
1355                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1356             );
1357 
1358             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1359 
1360             _currentIndex = startTokenId + quantity;
1361         }
1362         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1363     }
1364 
1365     /**
1366      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1367      */
1368     function _getApprovedAddress(uint256 tokenId)
1369         private
1370         view
1371         returns (uint256 approvedAddressSlot, address approvedAddress)
1372     {
1373         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1374         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1375         assembly {
1376             // Compute the slot.
1377             mstore(0x00, tokenId)
1378             mstore(0x20, tokenApprovalsPtr.slot)
1379             approvedAddressSlot := keccak256(0x00, 0x40)
1380             // Load the slot's value from storage.
1381             approvedAddress := sload(approvedAddressSlot)
1382         }
1383     }
1384 
1385     /**
1386      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1387      */
1388     function _isOwnerOrApproved(
1389         address approvedAddress,
1390         address from,
1391         address msgSender
1392     ) private pure returns (bool result) {
1393         assembly {
1394             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1395             from := and(from, BITMASK_ADDRESS)
1396             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1397             msgSender := and(msgSender, BITMASK_ADDRESS)
1398             // `msgSender == from || msgSender == approvedAddress`.
1399             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1400         }
1401     }
1402 
1403     /**
1404      * @dev Transfers `tokenId` from `from` to `to`.
1405      *
1406      * Requirements:
1407      *
1408      * - `to` cannot be the zero address.
1409      * - `tokenId` token must be owned by `from`.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function transferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId
1417     ) public virtual override {
1418         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1419 
1420         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1421 
1422         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1423 
1424         // The nested ifs save around 20+ gas over a compound boolean condition.
1425         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1426             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1427 
1428         if (to == address(0)) revert TransferToZeroAddress();
1429 
1430         _beforeTokenTransfers(from, to, tokenId, 1);
1431 
1432         // Clear approvals from the previous owner.
1433         assembly {
1434             if approvedAddress {
1435                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1436                 sstore(approvedAddressSlot, 0)
1437             }
1438         }
1439 
1440         // Underflow of the sender's balance is impossible because we check for
1441         // ownership above and the recipient's balance can't realistically overflow.
1442         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1443         unchecked {
1444             // We can directly increment and decrement the balances.
1445             --_packedAddressData[from]; // Updates: `balance -= 1`.
1446             ++_packedAddressData[to]; // Updates: `balance += 1`.
1447 
1448             // Updates:
1449             // - `address` to the next owner.
1450             // - `startTimestamp` to the timestamp of transfering.
1451             // - `burned` to `false`.
1452             // - `nextInitialized` to `true`.
1453             _packedOwnerships[tokenId] = _packOwnershipData(
1454                 to,
1455                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1456             );
1457 
1458             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1459             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1460                 uint256 nextTokenId = tokenId + 1;
1461                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1462                 if (_packedOwnerships[nextTokenId] == 0) {
1463                     // If the next slot is within bounds.
1464                     if (nextTokenId != _currentIndex) {
1465                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1466                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1467                     }
1468                 }
1469             }
1470         }
1471 
1472         emit Transfer(from, to, tokenId);
1473         _afterTokenTransfers(from, to, tokenId, 1);
1474     }
1475 
1476     /**
1477      * @dev Equivalent to `_burn(tokenId, false)`.
1478      */
1479     function _burn(uint256 tokenId) internal virtual {
1480         _burn(tokenId, false);
1481     }
1482 
1483     /**
1484      * @dev Destroys `tokenId`.
1485      * The approval is cleared when the token is burned.
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must exist.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1494         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1495 
1496         address from = address(uint160(prevOwnershipPacked));
1497 
1498         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1499 
1500         if (approvalCheck) {
1501             // The nested ifs save around 20+ gas over a compound boolean condition.
1502             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1503                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1504         }
1505 
1506         _beforeTokenTransfers(from, address(0), tokenId, 1);
1507 
1508         // Clear approvals from the previous owner.
1509         assembly {
1510             if approvedAddress {
1511                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1512                 sstore(approvedAddressSlot, 0)
1513             }
1514         }
1515 
1516         // Underflow of the sender's balance is impossible because we check for
1517         // ownership above and the recipient's balance can't realistically overflow.
1518         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1519         unchecked {
1520             // Updates:
1521             // - `balance -= 1`.
1522             // - `numberBurned += 1`.
1523             //
1524             // We can directly decrement the balance, and increment the number burned.
1525             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1526             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1527 
1528             // Updates:
1529             // - `address` to the last owner.
1530             // - `startTimestamp` to the timestamp of burning.
1531             // - `burned` to `true`.
1532             // - `nextInitialized` to `true`.
1533             _packedOwnerships[tokenId] = _packOwnershipData(
1534                 from,
1535                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1536             );
1537 
1538             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1539             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1540                 uint256 nextTokenId = tokenId + 1;
1541                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1542                 if (_packedOwnerships[nextTokenId] == 0) {
1543                     // If the next slot is within bounds.
1544                     if (nextTokenId != _currentIndex) {
1545                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1546                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1547                     }
1548                 }
1549             }
1550         }
1551 
1552         emit Transfer(from, address(0), tokenId);
1553         _afterTokenTransfers(from, address(0), tokenId, 1);
1554 
1555         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1556         unchecked {
1557             _burnCounter++;
1558         }
1559     }
1560 
1561     /**
1562      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1563      *
1564      * @param from address representing the previous owner of the given token ID
1565      * @param to target address that will receive the tokens
1566      * @param tokenId uint256 ID of the token to be transferred
1567      * @param _data bytes optional data to send along with the call
1568      * @return bool whether the call correctly returned the expected magic value
1569      */
1570     function _checkContractOnERC721Received(
1571         address from,
1572         address to,
1573         uint256 tokenId,
1574         bytes memory _data
1575     ) private returns (bool) {
1576         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1577             bytes4 retval
1578         ) {
1579             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1580         } catch (bytes memory reason) {
1581             if (reason.length == 0) {
1582                 revert TransferToNonERC721ReceiverImplementer();
1583             } else {
1584                 assembly {
1585                     revert(add(32, reason), mload(reason))
1586                 }
1587             }
1588         }
1589     }
1590 
1591     /**
1592      * @dev Directly sets the extra data for the ownership data `index`.
1593      */
1594     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1595         uint256 packed = _packedOwnerships[index];
1596         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1597         uint256 extraDataCasted;
1598         // Cast `extraData` with assembly to avoid redundant masking.
1599         assembly {
1600             extraDataCasted := extraData
1601         }
1602         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1603         _packedOwnerships[index] = packed;
1604     }
1605 
1606     /**
1607      * @dev Returns the next extra data for the packed ownership data.
1608      * The returned result is shifted into position.
1609      */
1610     function _nextExtraData(
1611         address from,
1612         address to,
1613         uint256 prevOwnershipPacked
1614     ) private view returns (uint256) {
1615         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1616         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1617     }
1618 
1619     /**
1620      * @dev Called during each token transfer to set the 24bit `extraData` field.
1621      * Intended to be overridden by the cosumer contract.
1622      *
1623      * `previousExtraData` - the value of `extraData` before transfer.
1624      *
1625      * Calling conditions:
1626      *
1627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1628      * transferred to `to`.
1629      * - When `from` is zero, `tokenId` will be minted for `to`.
1630      * - When `to` is zero, `tokenId` will be burned by `from`.
1631      * - `from` and `to` are never both zero.
1632      */
1633     function _extraData(
1634         address from,
1635         address to,
1636         uint24 previousExtraData
1637     ) internal view virtual returns (uint24) {}
1638 
1639     /**
1640      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1641      * This includes minting.
1642      * And also called before burning one token.
1643      *
1644      * startTokenId - the first token id to be transferred
1645      * quantity - the amount to be transferred
1646      *
1647      * Calling conditions:
1648      *
1649      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1650      * transferred to `to`.
1651      * - When `from` is zero, `tokenId` will be minted for `to`.
1652      * - When `to` is zero, `tokenId` will be burned by `from`.
1653      * - `from` and `to` are never both zero.
1654      */
1655     function _beforeTokenTransfers(
1656         address from,
1657         address to,
1658         uint256 startTokenId,
1659         uint256 quantity
1660     ) internal virtual {}
1661 
1662     /**
1663      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1664      * This includes minting.
1665      * And also called after one token has been burned.
1666      *
1667      * startTokenId - the first token id to be transferred
1668      * quantity - the amount to be transferred
1669      *
1670      * Calling conditions:
1671      *
1672      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1673      * transferred to `to`.
1674      * - When `from` is zero, `tokenId` has been minted for `to`.
1675      * - When `to` is zero, `tokenId` has been burned by `from`.
1676      * - `from` and `to` are never both zero.
1677      */
1678     function _afterTokenTransfers(
1679         address from,
1680         address to,
1681         uint256 startTokenId,
1682         uint256 quantity
1683     ) internal virtual {}
1684 
1685     /**
1686      * @dev Returns the message sender (defaults to `msg.sender`).
1687      *
1688      * If you are writing GSN compatible contracts, you need to override this function.
1689      */
1690     function _msgSenderERC721A() internal view virtual returns (address) {
1691         return msg.sender;
1692     }
1693 
1694     /**
1695      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1696      */
1697     function _toString(uint256 value) internal pure returns (string memory ptr) {
1698         assembly {
1699             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1700             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1701             // We will need 1 32-byte word to store the length,
1702             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1703             ptr := add(mload(0x40), 128)
1704             // Update the free memory pointer to allocate.
1705             mstore(0x40, ptr)
1706 
1707             // Cache the end of the memory to calculate the length later.
1708             let end := ptr
1709 
1710             // We write the string from the rightmost digit to the leftmost digit.
1711             // The following is essentially a do-while loop that also handles the zero case.
1712             // Costs a bit more than early returning for the zero case,
1713             // but cheaper in terms of deployment and overall runtime costs.
1714             for {
1715                 // Initialize and perform the first pass without check.
1716                 let temp := value
1717                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1718                 ptr := sub(ptr, 1)
1719                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1720                 mstore8(ptr, add(48, mod(temp, 10)))
1721                 temp := div(temp, 10)
1722             } temp {
1723                 // Keep dividing `temp` until zero.
1724                 temp := div(temp, 10)
1725             } {
1726                 // Body of the for loop.
1727                 ptr := sub(ptr, 1)
1728                 mstore8(ptr, add(48, mod(temp, 10)))
1729             }
1730 
1731             let length := sub(end, ptr)
1732             // Move the pointer 32 bytes leftwards to make room for the length.
1733             ptr := sub(ptr, 32)
1734             // Store the length.
1735             mstore(ptr, length)
1736         }
1737     }
1738 }
1739 
1740 // File: contracts/TheEgyptians.sol
1741 
1742 
1743 pragma solidity ^0.8.0;
1744 
1745 
1746 
1747 
1748 
1749 
1750 contract TheEgyptians is ERC721A, Ownable, ReentrancyGuard {
1751   using Address for address;
1752   using Strings for uint;
1753 
1754   string  public  baseTokenURI = "ipfs://QmdTpLRHiir9uJuTMTjsFAyAPvSGqqDGWuAiu8q2ViUgKN/";
1755 
1756   uint256 public  maxSupply = 5555;
1757   uint256 public  MAX_MINTS_PER_TX = 5;
1758   uint256 public  FREE_MINTS_PER_TX = 2;
1759   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1760   uint256 public  TOTAL_FREE_MINTS = 2000;
1761   bool public isPublicSaleActive = false;
1762 
1763   constructor() ERC721A("The Egyptians", "Egyptians") {
1764 
1765   }
1766 
1767   function mint(uint256 numberOfTokens)
1768       external
1769       payable
1770   {
1771     require(isPublicSaleActive, "Public sale is not open");
1772     require(
1773       totalSupply() + numberOfTokens <= maxSupply,
1774       "Maximum supply exceeded"
1775     );
1776     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1777         require(
1778             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1779             "Incorrect ETH value sent"
1780         );
1781     }
1782     _safeMint(msg.sender, numberOfTokens);
1783   }
1784 
1785   function setBaseURI(string memory baseURI)
1786     public
1787     onlyOwner
1788   {
1789     baseTokenURI = baseURI;
1790   }
1791 
1792   function _startTokenId() internal view virtual override returns (uint256) {
1793         return 1;
1794     }
1795 
1796   function treasuryMint(uint quantity, address user)
1797     public
1798     onlyOwner
1799   {
1800     require(
1801       quantity > 0,
1802       "Invalid mint amount"
1803     );
1804     require(
1805       totalSupply() + quantity <= maxSupply,
1806       "Maximum supply exceeded"
1807     );
1808     _safeMint(user, quantity);
1809   }
1810 
1811   function withdraw()
1812     public
1813     onlyOwner
1814     nonReentrant
1815   {
1816     Address.sendValue(payable(msg.sender), address(this).balance);
1817   }
1818 
1819   function tokenURI(uint _tokenId)
1820     public
1821     view
1822     virtual
1823     override
1824     returns (string memory)
1825   {
1826     require(
1827       _exists(_tokenId),
1828       "ERC721Metadata: URI query for nonexistent token"
1829     );
1830     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1831   }
1832 
1833   function _baseURI()
1834     internal
1835     view
1836     virtual
1837     override
1838     returns (string memory)
1839   {
1840     return baseTokenURI;
1841   }
1842 
1843   function setIsPublicSaleActive(bool _isPublicSaleActive)
1844       external
1845       onlyOwner
1846   {
1847       isPublicSaleActive = _isPublicSaleActive;
1848   }
1849 
1850   function setNumFreeMints(uint256 _numfreemints)
1851       external
1852       onlyOwner
1853   {
1854       TOTAL_FREE_MINTS = _numfreemints;
1855   }
1856 
1857   function setSalePrice(uint256 _price)
1858       external
1859       onlyOwner
1860   {
1861       PUBLIC_SALE_PRICE = _price;
1862   }
1863 
1864   function setMaxLimitPerTransaction(uint256 _limit)
1865       external
1866       onlyOwner
1867   {
1868       MAX_MINTS_PER_TX = _limit;
1869   }
1870 
1871 }