1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Contract module that helps prevent reentrant calls to a function.
313  *
314  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
315  * available, which can be applied to functions to make sure there are no nested
316  * (reentrant) calls to them.
317  *
318  * Note that because there is a single `nonReentrant` guard, functions marked as
319  * `nonReentrant` may not call one another. This can be worked around by making
320  * those functions `private`, and then adding `external` `nonReentrant` entry
321  * points to them.
322  *
323  * TIP: If you would like to learn more about reentrancy and alternative ways
324  * to protect against it, check out our blog post
325  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
326  */
327 abstract contract ReentrancyGuard {
328     // Booleans are more expensive than uint256 or any type that takes up a full
329     // word because each write operation emits an extra SLOAD to first read the
330     // slot's contents, replace the bits taken up by the boolean, and then write
331     // back. This is the compiler's defense against contract upgrades and
332     // pointer aliasing, and it cannot be disabled.
333 
334     // The values being non-zero value makes deployment a bit more expensive,
335     // but in exchange the refund on every call to nonReentrant will be lower in
336     // amount. Since refunds are capped to a percentage of the total
337     // transaction's gas, it is best to keep them low in cases like this one, to
338     // increase the likelihood of the full refund coming into effect.
339     uint256 private constant _NOT_ENTERED = 1;
340     uint256 private constant _ENTERED = 2;
341 
342     uint256 private _status;
343 
344     constructor() {
345         _status = _NOT_ENTERED;
346     }
347 
348     /**
349      * @dev Prevents a contract from calling itself, directly or indirectly.
350      * Calling a `nonReentrant` function from another `nonReentrant`
351      * function is not supported. It is possible to prevent this from happening
352      * by making the `nonReentrant` function external, and making it call a
353      * `private` function that does the actual work.
354      */
355     modifier nonReentrant() {
356         // On the first call to nonReentrant, _notEntered will be true
357         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
358 
359         // Any calls to nonReentrant after this point will fail
360         _status = _ENTERED;
361 
362         _;
363 
364         // By storing the original value once again, a refund is triggered (see
365         // https://eips.ethereum.org/EIPS/eip-2200)
366         _status = _NOT_ENTERED;
367     }
368 }
369 
370 // File: @openzeppelin/contracts/utils/Context.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Provides information about the current execution context, including the
379  * sender of the transaction and its data. While these are generally available
380  * via msg.sender and msg.data, they should not be accessed in such a direct
381  * manner, since when dealing with meta-transactions the account sending and
382  * paying for execution may not be the actual sender (as far as an application
383  * is concerned).
384  *
385  * This contract is only required for intermediate, library-like contracts.
386  */
387 abstract contract Context {
388     function _msgSender() internal view virtual returns (address) {
389         return msg.sender;
390     }
391 
392     function _msgData() internal view virtual returns (bytes calldata) {
393         return msg.data;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/access/Ownable.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev Contract module which provides a basic access control mechanism, where
407  * there is an account (an owner) that can be granted exclusive access to
408  * specific functions.
409  *
410  * By default, the owner account will be the one that deploys the contract. This
411  * can later be changed with {transferOwnership}.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be applied to your functions to restrict their use to
415  * the owner.
416  */
417 abstract contract Ownable is Context {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor() {
426         _transferOwnership(_msgSender());
427     }
428 
429     /**
430      * @dev Returns the address of the current owner.
431      */
432     function owner() public view virtual returns (address) {
433         return _owner;
434     }
435 
436     /**
437      * @dev Throws if called by any account other than the owner.
438      */
439     modifier onlyOwner() {
440         require(owner() == _msgSender(), "Ownable: caller is not the owner");
441         _;
442     }
443 
444     /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions anymore. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby removing any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public virtual onlyOwner {
452         _transferOwnership(address(0));
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         _transferOwnership(newOwner);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Internal function without access restriction.
467      */
468     function _transferOwnership(address newOwner) internal virtual {
469         address oldOwner = _owner;
470         _owner = newOwner;
471         emit OwnershipTransferred(oldOwner, newOwner);
472     }
473 }
474 
475 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
476 
477 
478 // ERC721A Contracts v4.0.0
479 // Creator: Chiru Labs
480 
481 pragma solidity ^0.8.4;
482 
483 /**
484  * @dev Interface of an ERC721A compliant contract.
485  */
486 interface IERC721A {
487     /**
488      * The caller must own the token or be an approved operator.
489      */
490     error ApprovalCallerNotOwnerNorApproved();
491 
492     /**
493      * The token does not exist.
494      */
495     error ApprovalQueryForNonexistentToken();
496 
497     /**
498      * The caller cannot approve to their own address.
499      */
500     error ApproveToCaller();
501 
502     /**
503      * The caller cannot approve to the current owner.
504      */
505     error ApprovalToCurrentOwner();
506 
507     /**
508      * Cannot query the balance for the zero address.
509      */
510     error BalanceQueryForZeroAddress();
511 
512     /**
513      * Cannot mint to the zero address.
514      */
515     error MintToZeroAddress();
516 
517     /**
518      * The quantity of tokens minted must be more than zero.
519      */
520     error MintZeroQuantity();
521 
522     /**
523      * The token does not exist.
524      */
525     error OwnerQueryForNonexistentToken();
526 
527     /**
528      * The caller must own the token or be an approved operator.
529      */
530     error TransferCallerNotOwnerNorApproved();
531 
532     /**
533      * The token must be owned by `from`.
534      */
535     error TransferFromIncorrectOwner();
536 
537     /**
538      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
539      */
540     error TransferToNonERC721ReceiverImplementer();
541 
542     /**
543      * Cannot transfer to the zero address.
544      */
545     error TransferToZeroAddress();
546 
547     /**
548      * The token does not exist.
549      */
550     error URIQueryForNonexistentToken();
551 
552     struct TokenOwnership {
553         // The address of the owner.
554         address addr;
555         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
556         uint64 startTimestamp;
557         // Whether the token has been burned.
558         bool burned;
559     }
560 
561     /**
562      * @dev Returns the total amount of tokens stored by the contract.
563      *
564      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     // ==============================
569     //            IERC165
570     // ==============================
571 
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 
582     // ==============================
583     //            IERC721
584     // ==============================
585 
586     /**
587      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
588      */
589     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
593      */
594     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
598      */
599     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
600 
601     /**
602      * @dev Returns the number of tokens in ``owner``'s account.
603      */
604     function balanceOf(address owner) external view returns (uint256 balance);
605 
606     /**
607      * @dev Returns the owner of the `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function ownerOf(uint256 tokenId) external view returns (address owner);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
637      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must exist and be owned by `from`.
644      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
646      *
647      * Emits a {Transfer} event.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Transfers `tokenId` token from `from` to `to`.
657      *
658      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must be owned by `from`.
665      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666      *
667      * Emits a {Transfer} event.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
677      * The approval is cleared when the token is transferred.
678      *
679      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
680      *
681      * Requirements:
682      *
683      * - The caller must own the token or be an approved operator.
684      * - `tokenId` must exist.
685      *
686      * Emits an {Approval} event.
687      */
688     function approve(address to, uint256 tokenId) external;
689 
690     /**
691      * @dev Approve or remove `operator` as an operator for the caller.
692      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
693      *
694      * Requirements:
695      *
696      * - The `operator` cannot be the caller.
697      *
698      * Emits an {ApprovalForAll} event.
699      */
700     function setApprovalForAll(address operator, bool _approved) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
713      *
714      * See {setApprovalForAll}
715      */
716     function isApprovedForAll(address owner, address operator) external view returns (bool);
717 
718     // ==============================
719     //        IERC721Metadata
720     // ==============================
721 
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
739 
740 
741 // ERC721A Contracts v4.0.0
742 // Creator: Chiru Labs
743 
744 pragma solidity ^0.8.4;
745 
746 
747 /**
748  * @dev ERC721 token receiver interface.
749  */
750 interface ERC721A__IERC721Receiver {
751     function onERC721Received(
752         address operator,
753         address from,
754         uint256 tokenId,
755         bytes calldata data
756     ) external returns (bytes4);
757 }
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension. Built to optimize for lower gas during batch mints.
762  *
763  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
764  *
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766  *
767  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
768  */
769 contract ERC721A is IERC721A {
770     // Mask of an entry in packed address data.
771     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
772 
773     // The bit position of `numberMinted` in packed address data.
774     uint256 private constant BITPOS_NUMBER_MINTED = 64;
775 
776     // The bit position of `numberBurned` in packed address data.
777     uint256 private constant BITPOS_NUMBER_BURNED = 128;
778 
779     // The bit position of `aux` in packed address data.
780     uint256 private constant BITPOS_AUX = 192;
781 
782     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
783     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
784 
785     // The bit position of `startTimestamp` in packed ownership.
786     uint256 private constant BITPOS_START_TIMESTAMP = 160;
787 
788     // The bit mask of the `burned` bit in packed ownership.
789     uint256 private constant BITMASK_BURNED = 1 << 224;
790 
791     // The bit position of the `nextInitialized` bit in packed ownership.
792     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
793 
794     // The bit mask of the `nextInitialized` bit in packed ownership.
795     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
796 
797     // The tokenId of the next token to be minted.
798     uint256 private _currentIndex;
799 
800     // The number of tokens burned.
801     uint256 private _burnCounter;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned.
811     // See `_packedOwnershipOf` implementation for details.
812     //
813     // Bits Layout:
814     // - [0..159]   `addr`
815     // - [160..223] `startTimestamp`
816     // - [224]      `burned`
817     // - [225]      `nextInitialized`
818     mapping(uint256 => uint256) private _packedOwnerships;
819 
820     // Mapping owner address to address data.
821     //
822     // Bits Layout:
823     // - [0..63]    `balance`
824     // - [64..127]  `numberMinted`
825     // - [128..191] `numberBurned`
826     // - [192..255] `aux`
827     mapping(address => uint256) private _packedAddressData;
828 
829     // Mapping from token ID to approved address.
830     mapping(uint256 => address) private _tokenApprovals;
831 
832     // Mapping from owner to operator approvals
833     mapping(address => mapping(address => bool)) private _operatorApprovals;
834 
835     constructor(string memory name_, string memory symbol_) {
836         _name = name_;
837         _symbol = symbol_;
838         _currentIndex = _startTokenId();
839     }
840 
841     /**
842      * @dev Returns the starting token ID.
843      * To change the starting token ID, please override this function.
844      */
845     function _startTokenId() internal view virtual returns (uint256) {
846         return 0;
847     }
848 
849     /**
850      * @dev Returns the next token ID to be minted.
851      */
852     function _nextTokenId() internal view returns (uint256) {
853         return _currentIndex;
854     }
855 
856     /**
857      * @dev Returns the total number of tokens in existence.
858      * Burned tokens will reduce the count.
859      * To get the total number of tokens minted, please see `_totalMinted`.
860      */
861     function totalSupply() public view override returns (uint256) {
862         // Counter underflow is impossible as _burnCounter cannot be incremented
863         // more than `_currentIndex - _startTokenId()` times.
864         unchecked {
865             return _currentIndex - _burnCounter - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev Returns the total amount of tokens minted in the contract.
871      */
872     function _totalMinted() internal view returns (uint256) {
873         // Counter underflow is impossible as _currentIndex does not decrement,
874         // and it is initialized to `_startTokenId()`
875         unchecked {
876             return _currentIndex - _startTokenId();
877         }
878     }
879 
880     /**
881      * @dev Returns the total number of tokens burned.
882      */
883     function _totalBurned() internal view returns (uint256) {
884         return _burnCounter;
885     }
886 
887     /**
888      * @dev See {IERC165-supportsInterface}.
889      */
890     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
891         // The interface IDs are constants representing the first 4 bytes of the XOR of
892         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
893         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
894         return
895             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
896             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
897             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view override returns (uint256) {
904         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
905         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
906     }
907 
908     /**
909      * Returns the number of tokens minted by `owner`.
910      */
911     function _numberMinted(address owner) internal view returns (uint256) {
912         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
913     }
914 
915     /**
916      * Returns the number of tokens burned by or on behalf of `owner`.
917      */
918     function _numberBurned(address owner) internal view returns (uint256) {
919         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
920     }
921 
922     /**
923      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
924      */
925     function _getAux(address owner) internal view returns (uint64) {
926         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
927     }
928 
929     /**
930      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
931      * If there are multiple variables, please pack them into a uint64.
932      */
933     function _setAux(address owner, uint64 aux) internal {
934         uint256 packed = _packedAddressData[owner];
935         uint256 auxCasted;
936         assembly { // Cast aux without masking.
937             auxCasted := aux
938         }
939         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
940         _packedAddressData[owner] = packed;
941     }
942 
943     /**
944      * Returns the packed ownership data of `tokenId`.
945      */
946     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
947         uint256 curr = tokenId;
948 
949         unchecked {
950             if (_startTokenId() <= curr)
951                 if (curr < _currentIndex) {
952                     uint256 packed = _packedOwnerships[curr];
953                     // If not burned.
954                     if (packed & BITMASK_BURNED == 0) {
955                         // Invariant:
956                         // There will always be an ownership that has an address and is not burned
957                         // before an ownership that does not have an address and is not burned.
958                         // Hence, curr will not underflow.
959                         //
960                         // We can directly compare the packed value.
961                         // If the address is zero, packed is zero.
962                         while (packed == 0) {
963                             packed = _packedOwnerships[--curr];
964                         }
965                         return packed;
966                     }
967                 }
968         }
969         revert OwnerQueryForNonexistentToken();
970     }
971 
972     /**
973      * Returns the unpacked `TokenOwnership` struct from `packed`.
974      */
975     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
976         ownership.addr = address(uint160(packed));
977         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
978         ownership.burned = packed & BITMASK_BURNED != 0;
979     }
980 
981     /**
982      * Returns the unpacked `TokenOwnership` struct at `index`.
983      */
984     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
985         return _unpackedOwnership(_packedOwnerships[index]);
986     }
987 
988     /**
989      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
990      */
991     function _initializeOwnershipAt(uint256 index) internal {
992         if (_packedOwnerships[index] == 0) {
993             _packedOwnerships[index] = _packedOwnershipOf(index);
994         }
995     }
996 
997     /**
998      * Gas spent here starts off proportional to the maximum mint batch size.
999      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1000      */
1001     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1002         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-ownerOf}.
1007      */
1008     function ownerOf(uint256 tokenId) public view override returns (address) {
1009         return address(uint160(_packedOwnershipOf(tokenId)));
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-name}.
1014      */
1015     function name() public view virtual override returns (string memory) {
1016         return _name;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-symbol}.
1021      */
1022     function symbol() public view virtual override returns (string memory) {
1023         return _symbol;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Metadata-tokenURI}.
1028      */
1029     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1030         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1031 
1032         string memory baseURI = _baseURI();
1033         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1034     }
1035 
1036     /**
1037      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1038      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1039      * by default, can be overriden in child contracts.
1040      */
1041     function _baseURI() internal view virtual returns (string memory) {
1042         return '';
1043     }
1044 
1045     /**
1046      * @dev Casts the address to uint256 without masking.
1047      */
1048     function _addressToUint256(address value) private pure returns (uint256 result) {
1049         assembly {
1050             result := value
1051         }
1052     }
1053 
1054     /**
1055      * @dev Casts the boolean to uint256 without branching.
1056      */
1057     function _boolToUint256(bool value) private pure returns (uint256 result) {
1058         assembly {
1059             result := value
1060         }
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-approve}.
1065      */
1066     function approve(address to, uint256 tokenId) public override {
1067         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1068         if (to == owner) revert ApprovalToCurrentOwner();
1069 
1070         if (_msgSenderERC721A() != owner)
1071             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1072                 revert ApprovalCallerNotOwnerNorApproved();
1073             }
1074 
1075         _tokenApprovals[tokenId] = to;
1076         emit Approval(owner, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-getApproved}.
1081      */
1082     function getApproved(uint256 tokenId) public view override returns (address) {
1083         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1084 
1085         return _tokenApprovals[tokenId];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-setApprovalForAll}.
1090      */
1091     function setApprovalForAll(address operator, bool approved) public virtual override {
1092         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1093 
1094         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1095         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-isApprovedForAll}.
1100      */
1101     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1102         return _operatorApprovals[owner][operator];
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-transferFrom}.
1107      */
1108     function transferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) public virtual override {
1113         _transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public virtual override {
1124         safeTransferFrom(from, to, tokenId, '');
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-safeTransferFrom}.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) public virtual override {
1136         _transfer(from, to, tokenId);
1137         if (to.code.length != 0)
1138             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1139                 revert TransferToNonERC721ReceiverImplementer();
1140             }
1141     }
1142 
1143     /**
1144      * @dev Returns whether `tokenId` exists.
1145      *
1146      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1147      *
1148      * Tokens start existing when they are minted (`_mint`),
1149      */
1150     function _exists(uint256 tokenId) internal view returns (bool) {
1151         return
1152             _startTokenId() <= tokenId &&
1153             tokenId < _currentIndex && // If within bounds,
1154             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1155     }
1156 
1157     /**
1158      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1159      */
1160     function _safeMint(address to, uint256 quantity) internal {
1161         _safeMint(to, quantity, '');
1162     }
1163 
1164     /**
1165      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - If `to` refers to a smart contract, it must implement
1170      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1171      * - `quantity` must be greater than 0.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _safeMint(
1176         address to,
1177         uint256 quantity,
1178         bytes memory _data
1179     ) internal {
1180         uint256 startTokenId = _currentIndex;
1181         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1182         if (quantity == 0) revert MintZeroQuantity();
1183 
1184         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1185 
1186         // Overflows are incredibly unrealistic.
1187         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1188         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1189         unchecked {
1190             // Updates:
1191             // - `balance += quantity`.
1192             // - `numberMinted += quantity`.
1193             //
1194             // We can directly add to the balance and number minted.
1195             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1196 
1197             // Updates:
1198             // - `address` to the owner.
1199             // - `startTimestamp` to the timestamp of minting.
1200             // - `burned` to `false`.
1201             // - `nextInitialized` to `quantity == 1`.
1202             _packedOwnerships[startTokenId] =
1203                 _addressToUint256(to) |
1204                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1205                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1206 
1207             uint256 updatedIndex = startTokenId;
1208             uint256 end = updatedIndex + quantity;
1209 
1210             if (to.code.length != 0) {
1211                 do {
1212                     emit Transfer(address(0), to, updatedIndex);
1213                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1214                         revert TransferToNonERC721ReceiverImplementer();
1215                     }
1216                 } while (updatedIndex < end);
1217                 // Reentrancy protection
1218                 if (_currentIndex != startTokenId) revert();
1219             } else {
1220                 do {
1221                     emit Transfer(address(0), to, updatedIndex++);
1222                 } while (updatedIndex < end);
1223             }
1224             _currentIndex = updatedIndex;
1225         }
1226         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1227     }
1228 
1229     /**
1230      * @dev Mints `quantity` tokens and transfers them to `to`.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `quantity` must be greater than 0.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _mint(address to, uint256 quantity) internal {
1240         uint256 startTokenId = _currentIndex;
1241         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1242         if (quantity == 0) revert MintZeroQuantity();
1243 
1244         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1245 
1246         // Overflows are incredibly unrealistic.
1247         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1248         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1249         unchecked {
1250             // Updates:
1251             // - `balance += quantity`.
1252             // - `numberMinted += quantity`.
1253             //
1254             // We can directly add to the balance and number minted.
1255             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1256 
1257             // Updates:
1258             // - `address` to the owner.
1259             // - `startTimestamp` to the timestamp of minting.
1260             // - `burned` to `false`.
1261             // - `nextInitialized` to `quantity == 1`.
1262             _packedOwnerships[startTokenId] =
1263                 _addressToUint256(to) |
1264                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1265                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1266 
1267             uint256 updatedIndex = startTokenId;
1268             uint256 end = updatedIndex + quantity;
1269 
1270             do {
1271                 emit Transfer(address(0), to, updatedIndex++);
1272             } while (updatedIndex < end);
1273 
1274             _currentIndex = updatedIndex;
1275         }
1276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must be owned by `from`.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _transfer(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) private {
1294         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1295 
1296         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1297 
1298         address approvedAddress = _tokenApprovals[tokenId];
1299 
1300         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1301             isApprovedForAll(from, _msgSenderERC721A()) ||
1302             approvedAddress == _msgSenderERC721A());
1303 
1304         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1305         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1306 
1307         _beforeTokenTransfers(from, to, tokenId, 1);
1308 
1309         // Clear approvals from the previous owner.
1310         if (_addressToUint256(approvedAddress) != 0) {
1311             delete _tokenApprovals[tokenId];
1312         }
1313 
1314         // Underflow of the sender's balance is impossible because we check for
1315         // ownership above and the recipient's balance can't realistically overflow.
1316         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1317         unchecked {
1318             // We can directly increment and decrement the balances.
1319             --_packedAddressData[from]; // Updates: `balance -= 1`.
1320             ++_packedAddressData[to]; // Updates: `balance += 1`.
1321 
1322             // Updates:
1323             // - `address` to the next owner.
1324             // - `startTimestamp` to the timestamp of transfering.
1325             // - `burned` to `false`.
1326             // - `nextInitialized` to `true`.
1327             _packedOwnerships[tokenId] =
1328                 _addressToUint256(to) |
1329                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1330                 BITMASK_NEXT_INITIALIZED;
1331 
1332             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1333             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1334                 uint256 nextTokenId = tokenId + 1;
1335                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1336                 if (_packedOwnerships[nextTokenId] == 0) {
1337                     // If the next slot is within bounds.
1338                     if (nextTokenId != _currentIndex) {
1339                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1340                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1341                     }
1342                 }
1343             }
1344         }
1345 
1346         emit Transfer(from, to, tokenId);
1347         _afterTokenTransfers(from, to, tokenId, 1);
1348     }
1349 
1350     /**
1351      * @dev Equivalent to `_burn(tokenId, false)`.
1352      */
1353     function _burn(uint256 tokenId) internal virtual {
1354         _burn(tokenId, false);
1355     }
1356 
1357     /**
1358      * @dev Destroys `tokenId`.
1359      * The approval is cleared when the token is burned.
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must exist.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1368         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1369 
1370         address from = address(uint160(prevOwnershipPacked));
1371         address approvedAddress = _tokenApprovals[tokenId];
1372 
1373         if (approvalCheck) {
1374             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1375                 isApprovedForAll(from, _msgSenderERC721A()) ||
1376                 approvedAddress == _msgSenderERC721A());
1377 
1378             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1379         }
1380 
1381         _beforeTokenTransfers(from, address(0), tokenId, 1);
1382 
1383         // Clear approvals from the previous owner.
1384         if (_addressToUint256(approvedAddress) != 0) {
1385             delete _tokenApprovals[tokenId];
1386         }
1387 
1388         // Underflow of the sender's balance is impossible because we check for
1389         // ownership above and the recipient's balance can't realistically overflow.
1390         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1391         unchecked {
1392             // Updates:
1393             // - `balance -= 1`.
1394             // - `numberBurned += 1`.
1395             //
1396             // We can directly decrement the balance, and increment the number burned.
1397             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1398             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1399 
1400             // Updates:
1401             // - `address` to the last owner.
1402             // - `startTimestamp` to the timestamp of burning.
1403             // - `burned` to `true`.
1404             // - `nextInitialized` to `true`.
1405             _packedOwnerships[tokenId] =
1406                 _addressToUint256(from) |
1407                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1408                 BITMASK_BURNED |
1409                 BITMASK_NEXT_INITIALIZED;
1410 
1411             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1412             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1413                 uint256 nextTokenId = tokenId + 1;
1414                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1415                 if (_packedOwnerships[nextTokenId] == 0) {
1416                     // If the next slot is within bounds.
1417                     if (nextTokenId != _currentIndex) {
1418                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1419                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1420                     }
1421                 }
1422             }
1423         }
1424 
1425         emit Transfer(from, address(0), tokenId);
1426         _afterTokenTransfers(from, address(0), tokenId, 1);
1427 
1428         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1429         unchecked {
1430             _burnCounter++;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1436      *
1437      * @param from address representing the previous owner of the given token ID
1438      * @param to target address that will receive the tokens
1439      * @param tokenId uint256 ID of the token to be transferred
1440      * @param _data bytes optional data to send along with the call
1441      * @return bool whether the call correctly returned the expected magic value
1442      */
1443     function _checkContractOnERC721Received(
1444         address from,
1445         address to,
1446         uint256 tokenId,
1447         bytes memory _data
1448     ) private returns (bool) {
1449         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1450             bytes4 retval
1451         ) {
1452             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1453         } catch (bytes memory reason) {
1454             if (reason.length == 0) {
1455                 revert TransferToNonERC721ReceiverImplementer();
1456             } else {
1457                 assembly {
1458                     revert(add(32, reason), mload(reason))
1459                 }
1460             }
1461         }
1462     }
1463 
1464     /**
1465      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1466      * And also called before burning one token.
1467      *
1468      * startTokenId - the first token id to be transferred
1469      * quantity - the amount to be transferred
1470      *
1471      * Calling conditions:
1472      *
1473      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1474      * transferred to `to`.
1475      * - When `from` is zero, `tokenId` will be minted for `to`.
1476      * - When `to` is zero, `tokenId` will be burned by `from`.
1477      * - `from` and `to` are never both zero.
1478      */
1479     function _beforeTokenTransfers(
1480         address from,
1481         address to,
1482         uint256 startTokenId,
1483         uint256 quantity
1484     ) internal virtual {}
1485 
1486     /**
1487      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1488      * minting.
1489      * And also called after one token has been burned.
1490      *
1491      * startTokenId - the first token id to be transferred
1492      * quantity - the amount to be transferred
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` has been minted for `to`.
1499      * - When `to` is zero, `tokenId` has been burned by `from`.
1500      * - `from` and `to` are never both zero.
1501      */
1502     function _afterTokenTransfers(
1503         address from,
1504         address to,
1505         uint256 startTokenId,
1506         uint256 quantity
1507     ) internal virtual {}
1508 
1509     /**
1510      * @dev Returns the message sender (defaults to `msg.sender`).
1511      *
1512      * If you are writing GSN compatible contracts, you need to override this function.
1513      */
1514     function _msgSenderERC721A() internal view virtual returns (address) {
1515         return msg.sender;
1516     }
1517 
1518     /**
1519      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1520      */
1521     function _toString(uint256 value) internal pure returns (string memory ptr) {
1522         assembly {
1523             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1524             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1525             // We will need 1 32-byte word to store the length,
1526             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1527             ptr := add(mload(0x40), 128)
1528             // Update the free memory pointer to allocate.
1529             mstore(0x40, ptr)
1530 
1531             // Cache the end of the memory to calculate the length later.
1532             let end := ptr
1533 
1534             // We write the string from the rightmost digit to the leftmost digit.
1535             // The following is essentially a do-while loop that also handles the zero case.
1536             // Costs a bit more than early returning for the zero case,
1537             // but cheaper in terms of deployment and overall runtime costs.
1538             for {
1539                 // Initialize and perform the first pass without check.
1540                 let temp := value
1541                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1542                 ptr := sub(ptr, 1)
1543                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1544                 mstore8(ptr, add(48, mod(temp, 10)))
1545                 temp := div(temp, 10)
1546             } temp {
1547                 // Keep dividing `temp` until zero.
1548                 temp := div(temp, 10)
1549             } { // Body of the for loop.
1550                 ptr := sub(ptr, 1)
1551                 mstore8(ptr, add(48, mod(temp, 10)))
1552             }
1553 
1554             let length := sub(end, ptr)
1555             // Move the pointer 32 bytes leftwards to make room for the length.
1556             ptr := sub(ptr, 32)
1557             // Store the length.
1558             mstore(ptr, length)
1559         }
1560     }
1561 }
1562 
1563 // File: contracts/tinygoblin.sol
1564 
1565 
1566 
1567 pragma solidity ^0.8.9;
1568 
1569 
1570 
1571 
1572 
1573 
1574 
1575 contract tinygoblinwtf is ERC721A, Ownable, ReentrancyGuard {
1576   using Address for address;
1577   using Strings for uint;
1578 
1579   string  public  baseTokenURI = "ipfs://QmTSBRutWKGQcd4njngvPD5w8PKHedZetaNMYM9p72xzCc";
1580 
1581   uint256 public  maxSupply = 10000;
1582   uint256 public  MAX_MINTS_PER_TX = 10;
1583   uint256 public  FREE_MINTS_PER_TX = 10;
1584   uint256 public  PUBLIC_SALE_PRICE = 0.0025 ether;
1585   uint256 public  TOTAL_FREE_MINTS = 2500;
1586   bool public isPublicSaleActive = true;
1587 
1588   constructor(
1589 
1590   ) ERC721A("tinygoblinwtf", "TGWTF") {
1591 
1592   }
1593 
1594   function mint(uint256 numberOfTokens)
1595       external
1596       payable
1597   {
1598     require(isPublicSaleActive, "Public sale is not open");
1599     require(
1600       totalSupply() + numberOfTokens <= maxSupply,
1601       "Maximum supply exceeded"
1602     );
1603     require(numberOfTokens <= MAX_MINTS_PER_TX, "Maximum per tx exceeded");
1604     if((totalSupply() + numberOfTokens) > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1605         require(
1606             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1607             "Incorrect ETH value sent"
1608         );
1609     }
1610     _safeMint(msg.sender, numberOfTokens);
1611   }
1612 
1613   function setBaseURI(string memory baseURI)
1614     public
1615     onlyOwner
1616   {
1617     baseTokenURI = baseURI;
1618   }
1619 
1620   function treasuryMint(uint quantity, address user)
1621     public
1622     onlyOwner
1623   {
1624     require(
1625       quantity > 0,
1626       "Invalid mint amount"
1627     );
1628     require(
1629       totalSupply() + quantity <= maxSupply,
1630       "Maximum supply exceeded"
1631     );
1632     _safeMint(user, quantity);
1633   }
1634 
1635   function withdraw()
1636     public
1637     onlyOwner
1638     nonReentrant
1639   {
1640     Address.sendValue(payable(msg.sender), address(this).balance);
1641   }
1642 
1643   function _startTokenId() internal view virtual override returns (uint256) {
1644     return 1;
1645   }
1646   
1647   function tokenURI(uint _tokenId)
1648     public
1649     view
1650     virtual
1651     override
1652     returns (string memory)
1653   {
1654     require(
1655       _exists(_tokenId),
1656       "ERC721Metadata: URI query for nonexistent token"
1657     );
1658     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1659   }
1660 
1661   function _baseURI()
1662     internal
1663     view
1664     virtual
1665     override
1666     returns (string memory)
1667   {
1668     return baseTokenURI;
1669   }
1670 
1671   function setIsPublicSaleActive(bool _isPublicSaleActive)
1672       external
1673       onlyOwner
1674   {
1675       isPublicSaleActive = _isPublicSaleActive;
1676   }
1677 
1678   function setNumFreeMints(uint256 _numfreemints)
1679       external
1680       onlyOwner
1681   {
1682       TOTAL_FREE_MINTS = _numfreemints;
1683   }
1684 
1685   function setSalePrice(uint256 _price)
1686       external
1687       onlyOwner
1688   {
1689       PUBLIC_SALE_PRICE = _price;
1690   }
1691 
1692   function setMaxLimitPerTransaction(uint256 _limit)
1693       external
1694       onlyOwner
1695   {
1696       MAX_MINTS_PER_TX = _limit;
1697   }
1698 
1699 }