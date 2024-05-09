1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
85 
86 pragma solidity ^0.8.1;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      *
109      * [IMPORTANT]
110      * ====
111      * You shouldn't rely on `isContract` to protect against flash loan attacks!
112      *
113      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
114      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
115      * constructor.
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize/address.code.length, which returns 0
120         // for contracts in construction, since the code is only stored at the end
121         // of the constructor execution.
122 
123         return account.code.length > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294                 /// @solidity memory-safe-assembly
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Contract module that helps prevent reentrant calls to a function.
315  *
316  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
317  * available, which can be applied to functions to make sure there are no nested
318  * (reentrant) calls to them.
319  *
320  * Note that because there is a single `nonReentrant` guard, functions marked as
321  * `nonReentrant` may not call one another. This can be worked around by making
322  * those functions `private`, and then adding `external` `nonReentrant` entry
323  * points to them.
324  *
325  * TIP: If you would like to learn more about reentrancy and alternative ways
326  * to protect against it, check out our blog post
327  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
328  */
329 abstract contract ReentrancyGuard {
330     // Booleans are more expensive than uint256 or any type that takes up a full
331     // word because each write operation emits an extra SLOAD to first read the
332     // slot's contents, replace the bits taken up by the boolean, and then write
333     // back. This is the compiler's defense against contract upgrades and
334     // pointer aliasing, and it cannot be disabled.
335 
336     // The values being non-zero value makes deployment a bit more expensive,
337     // but in exchange the refund on every call to nonReentrant will be lower in
338     // amount. Since refunds are capped to a percentage of the total
339     // transaction's gas, it is best to keep them low in cases like this one, to
340     // increase the likelihood of the full refund coming into effect.
341     uint256 private constant _NOT_ENTERED = 1;
342     uint256 private constant _ENTERED = 2;
343 
344     uint256 private _status;
345 
346     constructor() {
347         _status = _NOT_ENTERED;
348     }
349 
350     /**
351      * @dev Prevents a contract from calling itself, directly or indirectly.
352      * Calling a `nonReentrant` function from another `nonReentrant`
353      * function is not supported. It is possible to prevent this from happening
354      * by making the `nonReentrant` function external, and making it call a
355      * `private` function that does the actual work.
356      */
357     modifier nonReentrant() {
358         // On the first call to nonReentrant, _notEntered will be true
359         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
360 
361         // Any calls to nonReentrant after this point will fail
362         _status = _ENTERED;
363 
364         _;
365 
366         // By storing the original value once again, a refund is triggered (see
367         // https://eips.ethereum.org/EIPS/eip-2200)
368         _status = _NOT_ENTERED;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/utils/Context.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Provides information about the current execution context, including the
381  * sender of the transaction and its data. While these are generally available
382  * via msg.sender and msg.data, they should not be accessed in such a direct
383  * manner, since when dealing with meta-transactions the account sending and
384  * paying for execution may not be the actual sender (as far as an application
385  * is concerned).
386  *
387  * This contract is only required for intermediate, library-like contracts.
388  */
389 abstract contract Context {
390     function _msgSender() internal view virtual returns (address) {
391         return msg.sender;
392     }
393 
394     function _msgData() internal view virtual returns (bytes calldata) {
395         return msg.data;
396     }
397 }
398 
399 // File: @openzeppelin/contracts/access/Ownable.sol
400 
401 
402 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 abstract contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor() {
428         _transferOwnership(_msgSender());
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         _checkOwner();
436         _;
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view virtual returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if the sender is not the owner.
448      */
449     function _checkOwner() internal view virtual {
450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         _transferOwnership(address(0));
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         _transferOwnership(newOwner);
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Internal function without access restriction.
476      */
477     function _transferOwnership(address newOwner) internal virtual {
478         address oldOwner = _owner;
479         _owner = newOwner;
480         emit OwnershipTransferred(oldOwner, newOwner);
481     }
482 }
483 
484 // File: erc721a/contracts/IERC721A.sol
485 
486 
487 // ERC721A Contracts v4.1.0
488 // Creator: Chiru Labs
489 
490 pragma solidity ^0.8.4;
491 
492 /**
493  * @dev Interface of an ERC721A compliant contract.
494  */
495 interface IERC721A {
496     /**
497      * The caller must own the token or be an approved operator.
498      */
499     error ApprovalCallerNotOwnerNorApproved();
500 
501     /**
502      * The token does not exist.
503      */
504     error ApprovalQueryForNonexistentToken();
505 
506     /**
507      * The caller cannot approve to their own address.
508      */
509     error ApproveToCaller();
510 
511     /**
512      * Cannot query the balance for the zero address.
513      */
514     error BalanceQueryForZeroAddress();
515 
516     /**
517      * Cannot mint to the zero address.
518      */
519     error MintToZeroAddress();
520 
521     /**
522      * The quantity of tokens minted must be more than zero.
523      */
524     error MintZeroQuantity();
525 
526     /**
527      * The token does not exist.
528      */
529     error OwnerQueryForNonexistentToken();
530 
531     /**
532      * The caller must own the token or be an approved operator.
533      */
534     error TransferCallerNotOwnerNorApproved();
535 
536     /**
537      * The token must be owned by `from`.
538      */
539     error TransferFromIncorrectOwner();
540 
541     /**
542      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
543      */
544     error TransferToNonERC721ReceiverImplementer();
545 
546     /**
547      * Cannot transfer to the zero address.
548      */
549     error TransferToZeroAddress();
550 
551     /**
552      * The token does not exist.
553      */
554     error URIQueryForNonexistentToken();
555 
556     /**
557      * The `quantity` minted with ERC2309 exceeds the safety limit.
558      */
559     error MintERC2309QuantityExceedsLimit();
560 
561     /**
562      * The `extraData` cannot be set on an unintialized ownership slot.
563      */
564     error OwnershipNotInitializedForExtraData();
565 
566     struct TokenOwnership {
567         // The address of the owner.
568         address addr;
569         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
570         uint64 startTimestamp;
571         // Whether the token has been burned.
572         bool burned;
573         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
574         uint24 extraData;
575     }
576 
577     /**
578      * @dev Returns the total amount of tokens stored by the contract.
579      *
580      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     // ==============================
585     //            IERC165
586     // ==============================
587 
588     /**
589      * @dev Returns true if this contract implements the interface defined by
590      * `interfaceId`. See the corresponding
591      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
592      * to learn more about how these ids are created.
593      *
594      * This function call must use less than 30 000 gas.
595      */
596     function supportsInterface(bytes4 interfaceId) external view returns (bool);
597 
598     // ==============================
599     //            IERC721
600     // ==============================
601 
602     /**
603      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
604      */
605     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
606 
607     /**
608      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
609      */
610     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
611 
612     /**
613      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
614      */
615     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
616 
617     /**
618      * @dev Returns the number of tokens in ``owner``'s account.
619      */
620     function balanceOf(address owner) external view returns (uint256 balance);
621 
622     /**
623      * @dev Returns the owner of the `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function ownerOf(uint256 tokenId) external view returns (address owner);
630 
631     /**
632      * @dev Safely transfers `tokenId` token from `from` to `to`.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must exist and be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
641      *
642      * Emits a {Transfer} event.
643      */
644     function safeTransferFrom(
645         address from,
646         address to,
647         uint256 tokenId,
648         bytes calldata data
649     ) external;
650 
651     /**
652      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
653      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId
669     ) external;
670 
671     /**
672      * @dev Transfers `tokenId` token from `from` to `to`.
673      *
674      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
675      *
676      * Requirements:
677      *
678      * - `from` cannot be the zero address.
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must be owned by `from`.
681      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
682      *
683      * Emits a {Transfer} event.
684      */
685     function transferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) external;
690 
691     /**
692      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
693      * The approval is cleared when the token is transferred.
694      *
695      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
696      *
697      * Requirements:
698      *
699      * - The caller must own the token or be an approved operator.
700      * - `tokenId` must exist.
701      *
702      * Emits an {Approval} event.
703      */
704     function approve(address to, uint256 tokenId) external;
705 
706     /**
707      * @dev Approve or remove `operator` as an operator for the caller.
708      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
709      *
710      * Requirements:
711      *
712      * - The `operator` cannot be the caller.
713      *
714      * Emits an {ApprovalForAll} event.
715      */
716     function setApprovalForAll(address operator, bool _approved) external;
717 
718     /**
719      * @dev Returns the account approved for `tokenId` token.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must exist.
724      */
725     function getApproved(uint256 tokenId) external view returns (address operator);
726 
727     /**
728      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
729      *
730      * See {setApprovalForAll}
731      */
732     function isApprovedForAll(address owner, address operator) external view returns (bool);
733 
734     // ==============================
735     //        IERC721Metadata
736     // ==============================
737 
738     /**
739      * @dev Returns the token collection name.
740      */
741     function name() external view returns (string memory);
742 
743     /**
744      * @dev Returns the token collection symbol.
745      */
746     function symbol() external view returns (string memory);
747 
748     /**
749      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
750      */
751     function tokenURI(uint256 tokenId) external view returns (string memory);
752 
753     // ==============================
754     //            IERC2309
755     // ==============================
756 
757     /**
758      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
759      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
760      */
761     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
762 }
763 
764 // File: erc721a/contracts/ERC721A.sol
765 
766 
767 // ERC721A Contracts v4.1.0
768 // Creator: Chiru Labs
769 
770 pragma solidity ^0.8.4;
771 
772 
773 /**
774  * @dev ERC721 token receiver interface.
775  */
776 interface ERC721A__IERC721Receiver {
777     function onERC721Received(
778         address operator,
779         address from,
780         uint256 tokenId,
781         bytes calldata data
782     ) external returns (bytes4);
783 }
784 
785 /**
786  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
787  * including the Metadata extension. Built to optimize for lower gas during batch mints.
788  *
789  * Assumes serials are sequentially minted starting at `_startTokenId()`
790  * (defaults to 0, e.g. 0, 1, 2, 3..).
791  *
792  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
793  *
794  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
795  */
796 contract ERC721A is IERC721A {
797     // Mask of an entry in packed address data.
798     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
799 
800     // The bit position of `numberMinted` in packed address data.
801     uint256 private constant BITPOS_NUMBER_MINTED = 64;
802 
803     // The bit position of `numberBurned` in packed address data.
804     uint256 private constant BITPOS_NUMBER_BURNED = 128;
805 
806     // The bit position of `aux` in packed address data.
807     uint256 private constant BITPOS_AUX = 192;
808 
809     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
810     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
811 
812     // The bit position of `startTimestamp` in packed ownership.
813     uint256 private constant BITPOS_START_TIMESTAMP = 160;
814 
815     // The bit mask of the `burned` bit in packed ownership.
816     uint256 private constant BITMASK_BURNED = 1 << 224;
817 
818     // The bit position of the `nextInitialized` bit in packed ownership.
819     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
820 
821     // The bit mask of the `nextInitialized` bit in packed ownership.
822     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
823 
824     // The bit position of `extraData` in packed ownership.
825     uint256 private constant BITPOS_EXTRA_DATA = 232;
826 
827     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
828     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
829 
830     // The mask of the lower 160 bits for addresses.
831     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
832 
833     // The maximum `quantity` that can be minted with `_mintERC2309`.
834     // This limit is to prevent overflows on the address data entries.
835     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
836     // is required to cause an overflow, which is unrealistic.
837     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
838 
839     // The tokenId of the next token to be minted.
840     uint256 private _currentIndex;
841 
842     // The number of tokens burned.
843     uint256 private _burnCounter;
844 
845     // Token name
846     string private _name;
847 
848     // Token symbol
849     string private _symbol;
850 
851     // Mapping from token ID to ownership details
852     // An empty struct value does not necessarily mean the token is unowned.
853     // See `_packedOwnershipOf` implementation for details.
854     //
855     // Bits Layout:
856     // - [0..159]   `addr`
857     // - [160..223] `startTimestamp`
858     // - [224]      `burned`
859     // - [225]      `nextInitialized`
860     // - [232..255] `extraData`
861     mapping(uint256 => uint256) private _packedOwnerships;
862 
863     // Mapping owner address to address data.
864     //
865     // Bits Layout:
866     // - [0..63]    `balance`
867     // - [64..127]  `numberMinted`
868     // - [128..191] `numberBurned`
869     // - [192..255] `aux`
870     mapping(address => uint256) private _packedAddressData;
871 
872     // Mapping from token ID to approved address.
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     constructor(string memory name_, string memory symbol_) {
879         _name = name_;
880         _symbol = symbol_;
881         _currentIndex = _startTokenId();
882     }
883 
884     /**
885      * @dev Returns the starting token ID.
886      * To change the starting token ID, please override this function.
887      */
888     function _startTokenId() internal view virtual returns (uint256) {
889         return 0;
890     }
891 
892     /**
893      * @dev Returns the next token ID to be minted.
894      */
895     function _nextTokenId() internal view returns (uint256) {
896         return _currentIndex;
897     }
898 
899     /**
900      * @dev Returns the total number of tokens in existence.
901      * Burned tokens will reduce the count.
902      * To get the total number of tokens minted, please see `_totalMinted`.
903      */
904     function totalSupply() public view override returns (uint256) {
905         // Counter underflow is impossible as _burnCounter cannot be incremented
906         // more than `_currentIndex - _startTokenId()` times.
907         unchecked {
908             return _currentIndex - _burnCounter - _startTokenId();
909         }
910     }
911 
912     /**
913      * @dev Returns the total amount of tokens minted in the contract.
914      */
915     function _totalMinted() internal view returns (uint256) {
916         // Counter underflow is impossible as _currentIndex does not decrement,
917         // and it is initialized to `_startTokenId()`
918         unchecked {
919             return _currentIndex - _startTokenId();
920         }
921     }
922 
923     /**
924      * @dev Returns the total number of tokens burned.
925      */
926     function _totalBurned() internal view returns (uint256) {
927         return _burnCounter;
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
934         // The interface IDs are constants representing the first 4 bytes of the XOR of
935         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
936         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
937         return
938             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
939             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
940             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
941     }
942 
943     /**
944      * @dev See {IERC721-balanceOf}.
945      */
946     function balanceOf(address owner) public view override returns (uint256) {
947         if (owner == address(0)) revert BalanceQueryForZeroAddress();
948         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
949     }
950 
951     /**
952      * Returns the number of tokens minted by `owner`.
953      */
954     function _numberMinted(address owner) internal view returns (uint256) {
955         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
956     }
957 
958     /**
959      * Returns the number of tokens burned by or on behalf of `owner`.
960      */
961     function _numberBurned(address owner) internal view returns (uint256) {
962         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
963     }
964 
965     /**
966      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
967      */
968     function _getAux(address owner) internal view returns (uint64) {
969         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
970     }
971 
972     /**
973      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
974      * If there are multiple variables, please pack them into a uint64.
975      */
976     function _setAux(address owner, uint64 aux) internal {
977         uint256 packed = _packedAddressData[owner];
978         uint256 auxCasted;
979         // Cast `aux` with assembly to avoid redundant masking.
980         assembly {
981             auxCasted := aux
982         }
983         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
984         _packedAddressData[owner] = packed;
985     }
986 
987     /**
988      * Returns the packed ownership data of `tokenId`.
989      */
990     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
991         uint256 curr = tokenId;
992 
993         unchecked {
994             if (_startTokenId() <= curr)
995                 if (curr < _currentIndex) {
996                     uint256 packed = _packedOwnerships[curr];
997                     // If not burned.
998                     if (packed & BITMASK_BURNED == 0) {
999                         // Invariant:
1000                         // There will always be an ownership that has an address and is not burned
1001                         // before an ownership that does not have an address and is not burned.
1002                         // Hence, curr will not underflow.
1003                         //
1004                         // We can directly compare the packed value.
1005                         // If the address is zero, packed is zero.
1006                         while (packed == 0) {
1007                             packed = _packedOwnerships[--curr];
1008                         }
1009                         return packed;
1010                     }
1011                 }
1012         }
1013         revert OwnerQueryForNonexistentToken();
1014     }
1015 
1016     /**
1017      * Returns the unpacked `TokenOwnership` struct from `packed`.
1018      */
1019     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1020         ownership.addr = address(uint160(packed));
1021         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1022         ownership.burned = packed & BITMASK_BURNED != 0;
1023         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1024     }
1025 
1026     /**
1027      * Returns the unpacked `TokenOwnership` struct at `index`.
1028      */
1029     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1030         return _unpackedOwnership(_packedOwnerships[index]);
1031     }
1032 
1033     /**
1034      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1035      */
1036     function _initializeOwnershipAt(uint256 index) internal {
1037         if (_packedOwnerships[index] == 0) {
1038             _packedOwnerships[index] = _packedOwnershipOf(index);
1039         }
1040     }
1041 
1042     /**
1043      * Gas spent here starts off proportional to the maximum mint batch size.
1044      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1045      */
1046     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1047         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1048     }
1049 
1050     /**
1051      * @dev Packs ownership data into a single uint256.
1052      */
1053     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1054         assembly {
1055             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056             owner := and(owner, BITMASK_ADDRESS)
1057             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1058             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1059         }
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-ownerOf}.
1064      */
1065     function ownerOf(uint256 tokenId) public view override returns (address) {
1066         return address(uint160(_packedOwnershipOf(tokenId)));
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Metadata-name}.
1071      */
1072     function name() public view virtual override returns (string memory) {
1073         return _name;
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Metadata-symbol}.
1078      */
1079     function symbol() public view virtual override returns (string memory) {
1080         return _symbol;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-tokenURI}.
1085      */
1086     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1087         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1088 
1089         string memory baseURI = _baseURI();
1090         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1091     }
1092 
1093     /**
1094      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1095      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1096      * by default, it can be overridden in child contracts.
1097      */
1098     function _baseURI() internal view virtual returns (string memory) {
1099         return '';
1100     }
1101 
1102     /**
1103      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1104      */
1105     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1106         // For branchless setting of the `nextInitialized` flag.
1107         assembly {
1108             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1109             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1110         }
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-approve}.
1115      */
1116     function approve(address to, uint256 tokenId) public override {
1117         address owner = ownerOf(tokenId);
1118 
1119         if (_msgSenderERC721A() != owner)
1120             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1121                 revert ApprovalCallerNotOwnerNorApproved();
1122             }
1123 
1124         _tokenApprovals[tokenId] = to;
1125         emit Approval(owner, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-getApproved}.
1130      */
1131     function getApproved(uint256 tokenId) public view override returns (address) {
1132         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1133 
1134         return _tokenApprovals[tokenId];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-setApprovalForAll}.
1139      */
1140     function setApprovalForAll(address operator, bool approved) public virtual override {
1141         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1142 
1143         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1144         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-isApprovedForAll}.
1149      */
1150     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1151         return _operatorApprovals[owner][operator];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         safeTransferFrom(from, to, tokenId, '');
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-safeTransferFrom}.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) public virtual override {
1174         transferFrom(from, to, tokenId);
1175         if (to.code.length != 0)
1176             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1177                 revert TransferToNonERC721ReceiverImplementer();
1178             }
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted (`_mint`),
1187      */
1188     function _exists(uint256 tokenId) internal view returns (bool) {
1189         return
1190             _startTokenId() <= tokenId &&
1191             tokenId < _currentIndex && // If within bounds,
1192             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1193     }
1194 
1195     /**
1196      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1197      */
1198     function _safeMint(address to, uint256 quantity) internal {
1199         _safeMint(to, quantity, '');
1200     }
1201 
1202     /**
1203      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1204      *
1205      * Requirements:
1206      *
1207      * - If `to` refers to a smart contract, it must implement
1208      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1209      * - `quantity` must be greater than 0.
1210      *
1211      * See {_mint}.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal {
1220         _mint(to, quantity);
1221 
1222         unchecked {
1223             if (to.code.length != 0) {
1224                 uint256 end = _currentIndex;
1225                 uint256 index = end - quantity;
1226                 do {
1227                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1228                         revert TransferToNonERC721ReceiverImplementer();
1229                     }
1230                 } while (index < end);
1231                 // Reentrancy protection.
1232                 if (_currentIndex != end) revert();
1233             }
1234         }
1235     }
1236 
1237     /**
1238      * @dev Mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `quantity` must be greater than 0.
1244      *
1245      * Emits a {Transfer} event for each mint.
1246      */
1247     function _mint(address to, uint256 quantity) internal {
1248         uint256 startTokenId = _currentIndex;
1249         if (to == address(0)) revert MintToZeroAddress();
1250         if (quantity == 0) revert MintZeroQuantity();
1251 
1252         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1253 
1254         // Overflows are incredibly unrealistic.
1255         // `balance` and `numberMinted` have a maximum limit of 2**64.
1256         // `tokenId` has a maximum limit of 2**256.
1257         unchecked {
1258             // Updates:
1259             // - `balance += quantity`.
1260             // - `numberMinted += quantity`.
1261             //
1262             // We can directly add to the `balance` and `numberMinted`.
1263             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1264 
1265             // Updates:
1266             // - `address` to the owner.
1267             // - `startTimestamp` to the timestamp of minting.
1268             // - `burned` to `false`.
1269             // - `nextInitialized` to `quantity == 1`.
1270             _packedOwnerships[startTokenId] = _packOwnershipData(
1271                 to,
1272                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1273             );
1274 
1275             uint256 tokenId = startTokenId;
1276             uint256 end = startTokenId + quantity;
1277             do {
1278                 emit Transfer(address(0), to, tokenId++);
1279             } while (tokenId < end);
1280 
1281             _currentIndex = end;
1282         }
1283         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1284     }
1285 
1286     /**
1287      * @dev Mints `quantity` tokens and transfers them to `to`.
1288      *
1289      * This function is intended for efficient minting only during contract creation.
1290      *
1291      * It emits only one {ConsecutiveTransfer} as defined in
1292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1293      * instead of a sequence of {Transfer} event(s).
1294      *
1295      * Calling this function outside of contract creation WILL make your contract
1296      * non-compliant with the ERC721 standard.
1297      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1298      * {ConsecutiveTransfer} event is only permissible during contract creation.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `quantity` must be greater than 0.
1304      *
1305      * Emits a {ConsecutiveTransfer} event.
1306      */
1307     function _mintERC2309(address to, uint256 quantity) internal {
1308         uint256 startTokenId = _currentIndex;
1309         if (to == address(0)) revert MintToZeroAddress();
1310         if (quantity == 0) revert MintZeroQuantity();
1311         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1316         unchecked {
1317             // Updates:
1318             // - `balance += quantity`.
1319             // - `numberMinted += quantity`.
1320             //
1321             // We can directly add to the `balance` and `numberMinted`.
1322             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1323 
1324             // Updates:
1325             // - `address` to the owner.
1326             // - `startTimestamp` to the timestamp of minting.
1327             // - `burned` to `false`.
1328             // - `nextInitialized` to `quantity == 1`.
1329             _packedOwnerships[startTokenId] = _packOwnershipData(
1330                 to,
1331                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1332             );
1333 
1334             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1335 
1336             _currentIndex = startTokenId + quantity;
1337         }
1338         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1339     }
1340 
1341     /**
1342      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1343      */
1344     function _getApprovedAddress(uint256 tokenId)
1345         private
1346         view
1347         returns (uint256 approvedAddressSlot, address approvedAddress)
1348     {
1349         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1350         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1351         assembly {
1352             // Compute the slot.
1353             mstore(0x00, tokenId)
1354             mstore(0x20, tokenApprovalsPtr.slot)
1355             approvedAddressSlot := keccak256(0x00, 0x40)
1356             // Load the slot's value from storage.
1357             approvedAddress := sload(approvedAddressSlot)
1358         }
1359     }
1360 
1361     /**
1362      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1363      */
1364     function _isOwnerOrApproved(
1365         address approvedAddress,
1366         address from,
1367         address msgSender
1368     ) private pure returns (bool result) {
1369         assembly {
1370             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1371             from := and(from, BITMASK_ADDRESS)
1372             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1373             msgSender := and(msgSender, BITMASK_ADDRESS)
1374             // `msgSender == from || msgSender == approvedAddress`.
1375             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1376         }
1377     }
1378 
1379     /**
1380      * @dev Transfers `tokenId` from `from` to `to`.
1381      *
1382      * Requirements:
1383      *
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must be owned by `from`.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function transferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1395 
1396         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1397 
1398         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1399 
1400         // The nested ifs save around 20+ gas over a compound boolean condition.
1401         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1402             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1403 
1404         if (to == address(0)) revert TransferToZeroAddress();
1405 
1406         _beforeTokenTransfers(from, to, tokenId, 1);
1407 
1408         // Clear approvals from the previous owner.
1409         assembly {
1410             if approvedAddress {
1411                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1412                 sstore(approvedAddressSlot, 0)
1413             }
1414         }
1415 
1416         // Underflow of the sender's balance is impossible because we check for
1417         // ownership above and the recipient's balance can't realistically overflow.
1418         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1419         unchecked {
1420             // We can directly increment and decrement the balances.
1421             --_packedAddressData[from]; // Updates: `balance -= 1`.
1422             ++_packedAddressData[to]; // Updates: `balance += 1`.
1423 
1424             // Updates:
1425             // - `address` to the next owner.
1426             // - `startTimestamp` to the timestamp of transfering.
1427             // - `burned` to `false`.
1428             // - `nextInitialized` to `true`.
1429             _packedOwnerships[tokenId] = _packOwnershipData(
1430                 to,
1431                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1432             );
1433 
1434             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1435             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1436                 uint256 nextTokenId = tokenId + 1;
1437                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1438                 if (_packedOwnerships[nextTokenId] == 0) {
1439                     // If the next slot is within bounds.
1440                     if (nextTokenId != _currentIndex) {
1441                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1442                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1443                     }
1444                 }
1445             }
1446         }
1447 
1448         emit Transfer(from, to, tokenId);
1449         _afterTokenTransfers(from, to, tokenId, 1);
1450     }
1451 
1452     /**
1453      * @dev Equivalent to `_burn(tokenId, false)`.
1454      */
1455     function _burn(uint256 tokenId) internal virtual {
1456         _burn(tokenId, false);
1457     }
1458 
1459     /**
1460      * @dev Destroys `tokenId`.
1461      * The approval is cleared when the token is burned.
1462      *
1463      * Requirements:
1464      *
1465      * - `tokenId` must exist.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1470         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1471 
1472         address from = address(uint160(prevOwnershipPacked));
1473 
1474         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1475 
1476         if (approvalCheck) {
1477             // The nested ifs save around 20+ gas over a compound boolean condition.
1478             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1479                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1480         }
1481 
1482         _beforeTokenTransfers(from, address(0), tokenId, 1);
1483 
1484         // Clear approvals from the previous owner.
1485         assembly {
1486             if approvedAddress {
1487                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1488                 sstore(approvedAddressSlot, 0)
1489             }
1490         }
1491 
1492         // Underflow of the sender's balance is impossible because we check for
1493         // ownership above and the recipient's balance can't realistically overflow.
1494         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1495         unchecked {
1496             // Updates:
1497             // - `balance -= 1`.
1498             // - `numberBurned += 1`.
1499             //
1500             // We can directly decrement the balance, and increment the number burned.
1501             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1502             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1503 
1504             // Updates:
1505             // - `address` to the last owner.
1506             // - `startTimestamp` to the timestamp of burning.
1507             // - `burned` to `true`.
1508             // - `nextInitialized` to `true`.
1509             _packedOwnerships[tokenId] = _packOwnershipData(
1510                 from,
1511                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1512             );
1513 
1514             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1515             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1516                 uint256 nextTokenId = tokenId + 1;
1517                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1518                 if (_packedOwnerships[nextTokenId] == 0) {
1519                     // If the next slot is within bounds.
1520                     if (nextTokenId != _currentIndex) {
1521                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1522                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1523                     }
1524                 }
1525             }
1526         }
1527 
1528         emit Transfer(from, address(0), tokenId);
1529         _afterTokenTransfers(from, address(0), tokenId, 1);
1530 
1531         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1532         unchecked {
1533             _burnCounter++;
1534         }
1535     }
1536 
1537     /**
1538      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1539      *
1540      * @param from address representing the previous owner of the given token ID
1541      * @param to target address that will receive the tokens
1542      * @param tokenId uint256 ID of the token to be transferred
1543      * @param _data bytes optional data to send along with the call
1544      * @return bool whether the call correctly returned the expected magic value
1545      */
1546     function _checkContractOnERC721Received(
1547         address from,
1548         address to,
1549         uint256 tokenId,
1550         bytes memory _data
1551     ) private returns (bool) {
1552         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1553             bytes4 retval
1554         ) {
1555             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1556         } catch (bytes memory reason) {
1557             if (reason.length == 0) {
1558                 revert TransferToNonERC721ReceiverImplementer();
1559             } else {
1560                 assembly {
1561                     revert(add(32, reason), mload(reason))
1562                 }
1563             }
1564         }
1565     }
1566 
1567     /**
1568      * @dev Directly sets the extra data for the ownership data `index`.
1569      */
1570     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1571         uint256 packed = _packedOwnerships[index];
1572         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1573         uint256 extraDataCasted;
1574         // Cast `extraData` with assembly to avoid redundant masking.
1575         assembly {
1576             extraDataCasted := extraData
1577         }
1578         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1579         _packedOwnerships[index] = packed;
1580     }
1581 
1582     /**
1583      * @dev Returns the next extra data for the packed ownership data.
1584      * The returned result is shifted into position.
1585      */
1586     function _nextExtraData(
1587         address from,
1588         address to,
1589         uint256 prevOwnershipPacked
1590     ) private view returns (uint256) {
1591         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1592         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1593     }
1594 
1595     /**
1596      * @dev Called during each token transfer to set the 24bit `extraData` field.
1597      * Intended to be overridden by the cosumer contract.
1598      *
1599      * `previousExtraData` - the value of `extraData` before transfer.
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` will be minted for `to`.
1606      * - When `to` is zero, `tokenId` will be burned by `from`.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _extraData(
1610         address from,
1611         address to,
1612         uint24 previousExtraData
1613     ) internal view virtual returns (uint24) {}
1614 
1615     /**
1616      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1617      * This includes minting.
1618      * And also called before burning one token.
1619      *
1620      * startTokenId - the first token id to be transferred
1621      * quantity - the amount to be transferred
1622      *
1623      * Calling conditions:
1624      *
1625      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1626      * transferred to `to`.
1627      * - When `from` is zero, `tokenId` will be minted for `to`.
1628      * - When `to` is zero, `tokenId` will be burned by `from`.
1629      * - `from` and `to` are never both zero.
1630      */
1631     function _beforeTokenTransfers(
1632         address from,
1633         address to,
1634         uint256 startTokenId,
1635         uint256 quantity
1636     ) internal virtual {}
1637 
1638     /**
1639      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1640      * This includes minting.
1641      * And also called after one token has been burned.
1642      *
1643      * startTokenId - the first token id to be transferred
1644      * quantity - the amount to be transferred
1645      *
1646      * Calling conditions:
1647      *
1648      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1649      * transferred to `to`.
1650      * - When `from` is zero, `tokenId` has been minted for `to`.
1651      * - When `to` is zero, `tokenId` has been burned by `from`.
1652      * - `from` and `to` are never both zero.
1653      */
1654     function _afterTokenTransfers(
1655         address from,
1656         address to,
1657         uint256 startTokenId,
1658         uint256 quantity
1659     ) internal virtual {}
1660 
1661     /**
1662      * @dev Returns the message sender (defaults to `msg.sender`).
1663      *
1664      * If you are writing GSN compatible contracts, you need to override this function.
1665      */
1666     function _msgSenderERC721A() internal view virtual returns (address) {
1667         return msg.sender;
1668     }
1669 
1670     /**
1671      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1672      */
1673     function _toString(uint256 value) internal pure returns (string memory ptr) {
1674         assembly {
1675             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1676             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1677             // We will need 1 32-byte word to store the length,
1678             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1679             ptr := add(mload(0x40), 128)
1680             // Update the free memory pointer to allocate.
1681             mstore(0x40, ptr)
1682 
1683             // Cache the end of the memory to calculate the length later.
1684             let end := ptr
1685 
1686             // We write the string from the rightmost digit to the leftmost digit.
1687             // The following is essentially a do-while loop that also handles the zero case.
1688             // Costs a bit more than early returning for the zero case,
1689             // but cheaper in terms of deployment and overall runtime costs.
1690             for {
1691                 // Initialize and perform the first pass without check.
1692                 let temp := value
1693                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1694                 ptr := sub(ptr, 1)
1695                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1696                 mstore8(ptr, add(48, mod(temp, 10)))
1697                 temp := div(temp, 10)
1698             } temp {
1699                 // Keep dividing `temp` until zero.
1700                 temp := div(temp, 10)
1701             } {
1702                 // Body of the for loop.
1703                 ptr := sub(ptr, 1)
1704                 mstore8(ptr, add(48, mod(temp, 10)))
1705             }
1706 
1707             let length := sub(end, ptr)
1708             // Move the pointer 32 bytes leftwards to make room for the length.
1709             ptr := sub(ptr, 32)
1710             // Store the length.
1711             mstore(ptr, length)
1712         }
1713     }
1714 }
1715 
1716 // File: contracts/RevealedGoblinai.sol
1717 
1718 
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 
1723 
1724 
1725 
1726 
1727 contract RevealedGoblinAI is ERC721A, Ownable, ReentrancyGuard {
1728   using Address for address;
1729   using Strings for uint;
1730 
1731   string  public  baseTokenURI = "ipfs://QmZCwt9RMf3uDcAQ3fhTLLRAz82i42hyP5wB79CoRqZWCo/";
1732 
1733   uint256 public  maxSupply = 1996;
1734   uint256 public  MAX_MINTS_PER_TX = 5;
1735   uint256 public  FREE_MINTS_PER_TX = 1;
1736   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1737   uint256 public  TOTAL_FREE_MINTS = 1000;
1738   bool public isPublicSaleActive = false;
1739 
1740   constructor() ERC721A("Revealed Goblin AI", "RGAI") {
1741 
1742   }
1743 
1744   function mint(uint256 numberOfTokens)
1745       external
1746       payable
1747   {
1748     require(isPublicSaleActive, "Public sale is not open");
1749     require(
1750       totalSupply() + numberOfTokens <= maxSupply,
1751       "Maximum supply exceeded"
1752     );
1753     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1754         require(
1755             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1756             "Incorrect ETH value sent"
1757         );
1758     }
1759     _safeMint(msg.sender, numberOfTokens);
1760   }
1761 
1762   function setBaseURI(string memory baseURI)
1763     public
1764     onlyOwner
1765   {
1766     baseTokenURI = baseURI;
1767   }
1768 
1769   function _startTokenId() internal view virtual override returns (uint256) {
1770         return 1;
1771     }
1772 
1773   function treasuryMint(uint quantity, address user)
1774     public
1775     onlyOwner
1776   {
1777     require(
1778       quantity > 0,
1779       "Invalid mint amount"
1780     );
1781     require(
1782       totalSupply() + quantity <= maxSupply,
1783       "Maximum supply exceeded"
1784     );
1785     _safeMint(user, quantity);
1786   }
1787 
1788   function withdraw()
1789     public
1790     onlyOwner
1791     nonReentrant
1792   {
1793     Address.sendValue(payable(msg.sender), address(this).balance);
1794   }
1795 
1796   function tokenURI(uint _tokenId)
1797     public
1798     view
1799     virtual
1800     override
1801     returns (string memory)
1802   {
1803     require(
1804       _exists(_tokenId),
1805       "ERC721Metadata: URI query for nonexistent token"
1806     );
1807     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1808   }
1809 
1810   function _baseURI()
1811     internal
1812     view
1813     virtual
1814     override
1815     returns (string memory)
1816   {
1817     return baseTokenURI;
1818   }
1819 
1820   function setIsPublicSaleActive(bool _isPublicSaleActive)
1821       external
1822       onlyOwner
1823   {
1824       isPublicSaleActive = _isPublicSaleActive;
1825   }
1826 
1827   function setNumFreeMints(uint256 _numfreemints)
1828       external
1829       onlyOwner
1830   {
1831       TOTAL_FREE_MINTS = _numfreemints;
1832   }
1833 
1834   function setSalePrice(uint256 _price)
1835       external
1836       onlyOwner
1837   {
1838       PUBLIC_SALE_PRICE = _price;
1839   }
1840 
1841   function setMaxLimitPerTransaction(uint256 _limit)
1842       external
1843       onlyOwner
1844   {
1845       MAX_MINTS_PER_TX = _limit;
1846   }
1847 
1848 }