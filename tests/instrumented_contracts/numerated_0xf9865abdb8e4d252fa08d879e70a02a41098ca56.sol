1 /*
2  ________ __                   _____                        __    __ ________ ________ 
3 |        \  \                 |     \                      |  \  |  \        \        \
4  \▓▓▓▓▓▓▓▓ ▓▓____   ______     \▓▓▓▓▓ ______   ______      | ▓▓\ | ▓▓ ▓▓▓▓▓▓▓▓\▓▓▓▓▓▓▓▓
5    | ▓▓  | ▓▓    \ /      \      | ▓▓|      \ /      \     | ▓▓▓\| ▓▓ ▓▓__      | ▓▓   
6    | ▓▓  | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\__   | ▓▓ \▓▓▓▓▓▓\  ▓▓▓▓▓▓\    | ▓▓▓▓\ ▓▓ ▓▓  \     | ▓▓   
7    | ▓▓  | ▓▓  | ▓▓ ▓▓    ▓▓  \  | ▓▓/      ▓▓ ▓▓  | ▓▓    | ▓▓\▓▓ ▓▓ ▓▓▓▓▓     | ▓▓   
8    | ▓▓  | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__| ▓▓  ▓▓▓▓▓▓▓ ▓▓__/ ▓▓    | ▓▓ \▓▓▓▓ ▓▓        | ▓▓   
9    | ▓▓  | ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓\▓▓    ▓▓ ▓▓    ▓▓    | ▓▓  \▓▓▓ ▓▓        | ▓▓   
10     \▓▓   \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓  \▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓      \▓▓   \▓▓\▓▓         \▓▓   
11                                              | ▓▓                                      
12                                              | ▓▓                                      
13                                               \▓▓                                      
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31     uint8 private constant _ADDRESS_LENGTH = 20;
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
91      */
92     function toHexString(address addr) internal pure returns (string memory) {
93         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Address.sol
98 
99 
100 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
101 
102 pragma solidity ^0.8.1;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      *
125      * [IMPORTANT]
126      * ====
127      * You shouldn't rely on `isContract` to protect against flash loan attacks!
128      *
129      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
130      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
131      * constructor.
132      * ====
133      */
134     function isContract(address account) internal view returns (bool) {
135         // This method relies on extcodesize/address.code.length, which returns 0
136         // for contracts in construction, since the code is only stored at the end
137         // of the constructor execution.
138 
139         return account.code.length > 0;
140     }
141 
142     /**
143      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
144      * `recipient`, forwarding all available gas and reverting on errors.
145      *
146      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
147      * of certain opcodes, possibly making contracts go over the 2300 gas limit
148      * imposed by `transfer`, making them unable to receive funds via
149      * `transfer`. {sendValue} removes this limitation.
150      *
151      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
152      *
153      * IMPORTANT: because control is transferred to `recipient`, care must be
154      * taken to not create reentrancy vulnerabilities. Consider using
155      * {ReentrancyGuard} or the
156      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
157      */
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164 
165     /**
166      * @dev Performs a Solidity function call using a low level `call`. A
167      * plain `call` is an unsafe replacement for a function call: use this
168      * function instead.
169      *
170      * If `target` reverts with a revert reason, it is bubbled up by this
171      * function (like regular Solidity function calls).
172      *
173      * Returns the raw returned data. To convert to the expected return value,
174      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
175      *
176      * Requirements:
177      *
178      * - `target` must be a contract.
179      * - calling `target` with `data` must not revert.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
184         return functionCall(target, data, "Address: low-level call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
189      * `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, 0, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but also transferring `value` wei to `target`.
204      *
205      * Requirements:
206      *
207      * - the calling contract must have an ETH balance of at least `value`.
208      * - the called Solidity function must be `payable`.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
222      * with `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         require(address(this).balance >= value, "Address: insufficient balance for call");
233         require(isContract(target), "Address: call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.call{value: value}(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
246         return functionStaticCall(target, data, "Address: low-level static call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal view returns (bytes memory) {
260         require(isContract(target), "Address: static call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.staticcall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(isContract(target), "Address: delegate call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.delegatecall(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
295      * revert reason using the provided one.
296      *
297      * _Available since v4.3._
298      */
299     function verifyCallResult(
300         bool success,
301         bytes memory returndata,
302         string memory errorMessage
303     ) internal pure returns (bytes memory) {
304         if (success) {
305             return returndata;
306         } else {
307             // Look for revert reason and bubble it up if present
308             if (returndata.length > 0) {
309                 // The easiest way to bubble the revert reason is using memory via assembly
310                 /// @solidity memory-safe-assembly
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Contract module that helps prevent reentrant calls to a function.
331  *
332  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
333  * available, which can be applied to functions to make sure there are no nested
334  * (reentrant) calls to them.
335  *
336  * Note that because there is a single `nonReentrant` guard, functions marked as
337  * `nonReentrant` may not call one another. This can be worked around by making
338  * those functions `private`, and then adding `external` `nonReentrant` entry
339  * points to them.
340  *
341  * TIP: If you would like to learn more about reentrancy and alternative ways
342  * to protect against it, check out our blog post
343  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
344  */
345 abstract contract ReentrancyGuard {
346     // Booleans are more expensive than uint256 or any type that takes up a full
347     // word because each write operation emits an extra SLOAD to first read the
348     // slot's contents, replace the bits taken up by the boolean, and then write
349     // back. This is the compiler's defense against contract upgrades and
350     // pointer aliasing, and it cannot be disabled.
351 
352     // The values being non-zero value makes deployment a bit more expensive,
353     // but in exchange the refund on every call to nonReentrant will be lower in
354     // amount. Since refunds are capped to a percentage of the total
355     // transaction's gas, it is best to keep them low in cases like this one, to
356     // increase the likelihood of the full refund coming into effect.
357     uint256 private constant _NOT_ENTERED = 1;
358     uint256 private constant _ENTERED = 2;
359 
360     uint256 private _status;
361 
362     constructor() {
363         _status = _NOT_ENTERED;
364     }
365 
366     /**
367      * @dev Prevents a contract from calling itself, directly or indirectly.
368      * Calling a `nonReentrant` function from another `nonReentrant`
369      * function is not supported. It is possible to prevent this from happening
370      * by making the `nonReentrant` function external, and making it call a
371      * `private` function that does the actual work.
372      */
373     modifier nonReentrant() {
374         // On the first call to nonReentrant, _notEntered will be true
375         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
376 
377         // Any calls to nonReentrant after this point will fail
378         _status = _ENTERED;
379 
380         _;
381 
382         // By storing the original value once again, a refund is triggered (see
383         // https://eips.ethereum.org/EIPS/eip-2200)
384         _status = _NOT_ENTERED;
385     }
386 }
387 
388 // File: @openzeppelin/contracts/utils/Context.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Provides information about the current execution context, including the
397  * sender of the transaction and its data. While these are generally available
398  * via msg.sender and msg.data, they should not be accessed in such a direct
399  * manner, since when dealing with meta-transactions the account sending and
400  * paying for execution may not be the actual sender (as far as an application
401  * is concerned).
402  *
403  * This contract is only required for intermediate, library-like contracts.
404  */
405 abstract contract Context {
406     function _msgSender() internal view virtual returns (address) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view virtual returns (bytes calldata) {
411         return msg.data;
412     }
413 }
414 
415 // File: @openzeppelin/contracts/access/Ownable.sol
416 
417 
418 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 abstract contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor() {
444         _transferOwnership(_msgSender());
445     }
446 
447     /**
448      * @dev Throws if called by any account other than the owner.
449      */
450     modifier onlyOwner() {
451         _checkOwner();
452         _;
453     }
454 
455     /**
456      * @dev Returns the address of the current owner.
457      */
458     function owner() public view virtual returns (address) {
459         return _owner;
460     }
461 
462     /**
463      * @dev Throws if the sender is not the owner.
464      */
465     function _checkOwner() internal view virtual {
466         require(owner() == _msgSender(), "Ownable: caller is not the owner");
467     }
468 
469     /**
470      * @dev Leaves the contract without owner. It will not be possible to call
471      * `onlyOwner` functions anymore. Can only be called by the current owner.
472      *
473      * NOTE: Renouncing ownership will leave the contract without an owner,
474      * thereby removing any functionality that is only available to the owner.
475      */
476     function renounceOwnership() public virtual onlyOwner {
477         _transferOwnership(address(0));
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Can only be called by the current owner.
483      */
484     function transferOwnership(address newOwner) public virtual onlyOwner {
485         require(newOwner != address(0), "Ownable: new owner is the zero address");
486         _transferOwnership(newOwner);
487     }
488 
489     /**
490      * @dev Transfers ownership of the contract to a new account (`newOwner`).
491      * Internal function without access restriction.
492      */
493     function _transferOwnership(address newOwner) internal virtual {
494         address oldOwner = _owner;
495         _owner = newOwner;
496         emit OwnershipTransferred(oldOwner, newOwner);
497     }
498 }
499 
500 // File: erc721a/contracts/IERC721A.sol
501 
502 
503 // ERC721A Contracts v4.1.0
504 // Creator: Chiru Labs
505 
506 pragma solidity ^0.8.4;
507 
508 /**
509  * @dev Interface of an ERC721A compliant contract.
510  */
511 interface IERC721A {
512     /**
513      * The caller must own the token or be an approved operator.
514      */
515     error ApprovalCallerNotOwnerNorApproved();
516 
517     /**
518      * The token does not exist.
519      */
520     error ApprovalQueryForNonexistentToken();
521 
522     /**
523      * The caller cannot approve to their own address.
524      */
525     error ApproveToCaller();
526 
527     /**
528      * Cannot query the balance for the zero address.
529      */
530     error BalanceQueryForZeroAddress();
531 
532     /**
533      * Cannot mint to the zero address.
534      */
535     error MintToZeroAddress();
536 
537     /**
538      * The quantity of tokens minted must be more than zero.
539      */
540     error MintZeroQuantity();
541 
542     /**
543      * The token does not exist.
544      */
545     error OwnerQueryForNonexistentToken();
546 
547     /**
548      * The caller must own the token or be an approved operator.
549      */
550     error TransferCallerNotOwnerNorApproved();
551 
552     /**
553      * The token must be owned by `from`.
554      */
555     error TransferFromIncorrectOwner();
556 
557     /**
558      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
559      */
560     error TransferToNonERC721ReceiverImplementer();
561 
562     /**
563      * Cannot transfer to the zero address.
564      */
565     error TransferToZeroAddress();
566 
567     /**
568      * The token does not exist.
569      */
570     error URIQueryForNonexistentToken();
571 
572     /**
573      * The `quantity` minted with ERC2309 exceeds the safety limit.
574      */
575     error MintERC2309QuantityExceedsLimit();
576 
577     /**
578      * The `extraData` cannot be set on an unintialized ownership slot.
579      */
580     error OwnershipNotInitializedForExtraData();
581 
582     struct TokenOwnership {
583         // The address of the owner.
584         address addr;
585         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
586         uint64 startTimestamp;
587         // Whether the token has been burned.
588         bool burned;
589         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
590         uint24 extraData;
591     }
592 
593     /**
594      * @dev Returns the total amount of tokens stored by the contract.
595      *
596      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
597      */
598     function totalSupply() external view returns (uint256);
599 
600     // ==============================
601     //            IERC165
602     // ==============================
603 
604     /**
605      * @dev Returns true if this contract implements the interface defined by
606      * `interfaceId`. See the corresponding
607      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
608      * to learn more about how these ids are created.
609      *
610      * This function call must use less than 30 000 gas.
611      */
612     function supportsInterface(bytes4 interfaceId) external view returns (bool);
613 
614     // ==============================
615     //            IERC721
616     // ==============================
617 
618     /**
619      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
625      */
626     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
630      */
631     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
632 
633     /**
634      * @dev Returns the number of tokens in ``owner``'s account.
635      */
636     function balanceOf(address owner) external view returns (uint256 balance);
637 
638     /**
639      * @dev Returns the owner of the `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function ownerOf(uint256 tokenId) external view returns (address owner);
646 
647     /**
648      * @dev Safely transfers `tokenId` token from `from` to `to`.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must exist and be owned by `from`.
655      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
656      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
657      *
658      * Emits a {Transfer} event.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId,
664         bytes calldata data
665     ) external;
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
669      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
670      *
671      * Requirements:
672      *
673      * - `from` cannot be the zero address.
674      * - `to` cannot be the zero address.
675      * - `tokenId` token must exist and be owned by `from`.
676      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Transfers `tokenId` token from `from` to `to`.
689      *
690      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      *
699      * Emits a {Transfer} event.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external;
706 
707     /**
708      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
709      * The approval is cleared when the token is transferred.
710      *
711      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) external;
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
725      *
726      * Requirements:
727      *
728      * - The `operator` cannot be the caller.
729      *
730      * Emits an {ApprovalForAll} event.
731      */
732     function setApprovalForAll(address operator, bool _approved) external;
733 
734     /**
735      * @dev Returns the account approved for `tokenId` token.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function getApproved(uint256 tokenId) external view returns (address operator);
742 
743     /**
744      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
745      *
746      * See {setApprovalForAll}
747      */
748     function isApprovedForAll(address owner, address operator) external view returns (bool);
749 
750     // ==============================
751     //        IERC721Metadata
752     // ==============================
753 
754     /**
755      * @dev Returns the token collection name.
756      */
757     function name() external view returns (string memory);
758 
759     /**
760      * @dev Returns the token collection symbol.
761      */
762     function symbol() external view returns (string memory);
763 
764     /**
765      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
766      */
767     function tokenURI(uint256 tokenId) external view returns (string memory);
768 
769     // ==============================
770     //            IERC2309
771     // ==============================
772 
773     /**
774      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
775      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
776      */
777     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
778 }
779 
780 // File: erc721a/contracts/ERC721A.sol
781 
782 
783 // ERC721A Contracts v4.1.0
784 // Creator: Chiru Labs
785 
786 pragma solidity ^0.8.4;
787 
788 
789 /**
790  * @dev ERC721 token receiver interface.
791  */
792 interface ERC721A__IERC721Receiver {
793     function onERC721Received(
794         address operator,
795         address from,
796         uint256 tokenId,
797         bytes calldata data
798     ) external returns (bytes4);
799 }
800 
801 /**
802  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
803  * including the Metadata extension. Built to optimize for lower gas during batch mints.
804  *
805  * Assumes serials are sequentially minted starting at `_startTokenId()`
806  * (defaults to 0, e.g. 0, 1, 2, 3..).
807  *
808  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
809  *
810  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
811  */
812 contract ERC721A is IERC721A {
813     // Mask of an entry in packed address data.
814     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
815 
816     // The bit position of `numberMinted` in packed address data.
817     uint256 private constant BITPOS_NUMBER_MINTED = 64;
818 
819     // The bit position of `numberBurned` in packed address data.
820     uint256 private constant BITPOS_NUMBER_BURNED = 128;
821 
822     // The bit position of `aux` in packed address data.
823     uint256 private constant BITPOS_AUX = 192;
824 
825     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
826     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
827 
828     // The bit position of `startTimestamp` in packed ownership.
829     uint256 private constant BITPOS_START_TIMESTAMP = 160;
830 
831     // The bit mask of the `burned` bit in packed ownership.
832     uint256 private constant BITMASK_BURNED = 1 << 224;
833 
834     // The bit position of the `nextInitialized` bit in packed ownership.
835     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
836 
837     // The bit mask of the `nextInitialized` bit in packed ownership.
838     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
839 
840     // The bit position of `extraData` in packed ownership.
841     uint256 private constant BITPOS_EXTRA_DATA = 232;
842 
843     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
844     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
845 
846     // The mask of the lower 160 bits for addresses.
847     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
848 
849     // The maximum `quantity` that can be minted with `_mintERC2309`.
850     // This limit is to prevent overflows on the address data entries.
851     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
852     // is required to cause an overflow, which is unrealistic.
853     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
854 
855     // The tokenId of the next token to be minted.
856     uint256 private _currentIndex;
857 
858     // The number of tokens burned.
859     uint256 private _burnCounter;
860 
861     // Token name
862     string private _name;
863 
864     // Token symbol
865     string private _symbol;
866 
867     // Mapping from token ID to ownership details
868     // An empty struct value does not necessarily mean the token is unowned.
869     // See `_packedOwnershipOf` implementation for details.
870     //
871     // Bits Layout:
872     // - [0..159]   `addr`
873     // - [160..223] `startTimestamp`
874     // - [224]      `burned`
875     // - [225]      `nextInitialized`
876     // - [232..255] `extraData`
877     mapping(uint256 => uint256) private _packedOwnerships;
878 
879     // Mapping owner address to address data.
880     //
881     // Bits Layout:
882     // - [0..63]    `balance`
883     // - [64..127]  `numberMinted`
884     // - [128..191] `numberBurned`
885     // - [192..255] `aux`
886     mapping(address => uint256) private _packedAddressData;
887 
888     // Mapping from token ID to approved address.
889     mapping(uint256 => address) private _tokenApprovals;
890 
891     // Mapping from owner to operator approvals
892     mapping(address => mapping(address => bool)) private _operatorApprovals;
893 
894     constructor(string memory name_, string memory symbol_) {
895         _name = name_;
896         _symbol = symbol_;
897         _currentIndex = _startTokenId();
898     }
899 
900     /**
901      * @dev Returns the starting token ID.
902      * To change the starting token ID, please override this function.
903      */
904     function _startTokenId() internal view virtual returns (uint256) {
905         return 0;
906     }
907 
908     /**
909      * @dev Returns the next token ID to be minted.
910      */
911     function _nextTokenId() internal view returns (uint256) {
912         return _currentIndex;
913     }
914 
915     /**
916      * @dev Returns the total number of tokens in existence.
917      * Burned tokens will reduce the count.
918      * To get the total number of tokens minted, please see `_totalMinted`.
919      */
920     function totalSupply() public view override returns (uint256) {
921         // Counter underflow is impossible as _burnCounter cannot be incremented
922         // more than `_currentIndex - _startTokenId()` times.
923         unchecked {
924             return _currentIndex - _burnCounter - _startTokenId();
925         }
926     }
927 
928     /**
929      * @dev Returns the total amount of tokens minted in the contract.
930      */
931     function _totalMinted() internal view returns (uint256) {
932         // Counter underflow is impossible as _currentIndex does not decrement,
933         // and it is initialized to `_startTokenId()`
934         unchecked {
935             return _currentIndex - _startTokenId();
936         }
937     }
938 
939     /**
940      * @dev Returns the total number of tokens burned.
941      */
942     function _totalBurned() internal view returns (uint256) {
943         return _burnCounter;
944     }
945 
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
950         // The interface IDs are constants representing the first 4 bytes of the XOR of
951         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
952         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
953         return
954             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
955             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
956             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
957     }
958 
959     /**
960      * @dev See {IERC721-balanceOf}.
961      */
962     function balanceOf(address owner) public view override returns (uint256) {
963         if (owner == address(0)) revert BalanceQueryForZeroAddress();
964         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
965     }
966 
967     /**
968      * Returns the number of tokens minted by `owner`.
969      */
970     function _numberMinted(address owner) internal view returns (uint256) {
971         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
972     }
973 
974     /**
975      * Returns the number of tokens burned by or on behalf of `owner`.
976      */
977     function _numberBurned(address owner) internal view returns (uint256) {
978         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
979     }
980 
981     /**
982      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
983      */
984     function _getAux(address owner) internal view returns (uint64) {
985         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
986     }
987 
988     /**
989      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
990      * If there are multiple variables, please pack them into a uint64.
991      */
992     function _setAux(address owner, uint64 aux) internal {
993         uint256 packed = _packedAddressData[owner];
994         uint256 auxCasted;
995         // Cast `aux` with assembly to avoid redundant masking.
996         assembly {
997             auxCasted := aux
998         }
999         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1000         _packedAddressData[owner] = packed;
1001     }
1002 
1003     /**
1004      * Returns the packed ownership data of `tokenId`.
1005      */
1006     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1007         uint256 curr = tokenId;
1008 
1009         unchecked {
1010             if (_startTokenId() <= curr)
1011                 if (curr < _currentIndex) {
1012                     uint256 packed = _packedOwnerships[curr];
1013                     // If not burned.
1014                     if (packed & BITMASK_BURNED == 0) {
1015                         // Invariant:
1016                         // There will always be an ownership that has an address and is not burned
1017                         // before an ownership that does not have an address and is not burned.
1018                         // Hence, curr will not underflow.
1019                         //
1020                         // We can directly compare the packed value.
1021                         // If the address is zero, packed is zero.
1022                         while (packed == 0) {
1023                             packed = _packedOwnerships[--curr];
1024                         }
1025                         return packed;
1026                     }
1027                 }
1028         }
1029         revert OwnerQueryForNonexistentToken();
1030     }
1031 
1032     /**
1033      * Returns the unpacked `TokenOwnership` struct from `packed`.
1034      */
1035     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1036         ownership.addr = address(uint160(packed));
1037         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1038         ownership.burned = packed & BITMASK_BURNED != 0;
1039         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1040     }
1041 
1042     /**
1043      * Returns the unpacked `TokenOwnership` struct at `index`.
1044      */
1045     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1046         return _unpackedOwnership(_packedOwnerships[index]);
1047     }
1048 
1049     /**
1050      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1051      */
1052     function _initializeOwnershipAt(uint256 index) internal {
1053         if (_packedOwnerships[index] == 0) {
1054             _packedOwnerships[index] = _packedOwnershipOf(index);
1055         }
1056     }
1057 
1058     /**
1059      * Gas spent here starts off proportional to the maximum mint batch size.
1060      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1061      */
1062     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1063         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1064     }
1065 
1066     /**
1067      * @dev Packs ownership data into a single uint256.
1068      */
1069     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1070         assembly {
1071             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1072             owner := and(owner, BITMASK_ADDRESS)
1073             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1074             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1075         }
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-ownerOf}.
1080      */
1081     function ownerOf(uint256 tokenId) public view override returns (address) {
1082         return address(uint160(_packedOwnershipOf(tokenId)));
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-name}.
1087      */
1088     function name() public view virtual override returns (string memory) {
1089         return _name;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-symbol}.
1094      */
1095     function symbol() public view virtual override returns (string memory) {
1096         return _symbol;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Metadata-tokenURI}.
1101      */
1102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1103         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1104 
1105         string memory baseURI = _baseURI();
1106         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1107     }
1108 
1109     /**
1110      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1111      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1112      * by default, it can be overridden in child contracts.
1113      */
1114     function _baseURI() internal view virtual returns (string memory) {
1115         return '';
1116     }
1117 
1118     /**
1119      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1120      */
1121     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1122         // For branchless setting of the `nextInitialized` flag.
1123         assembly {
1124             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1125             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1126         }
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-approve}.
1131      */
1132     function approve(address to, uint256 tokenId) public override {
1133         address owner = ownerOf(tokenId);
1134 
1135         if (_msgSenderERC721A() != owner)
1136             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1137                 revert ApprovalCallerNotOwnerNorApproved();
1138             }
1139 
1140         _tokenApprovals[tokenId] = to;
1141         emit Approval(owner, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-getApproved}.
1146      */
1147     function getApproved(uint256 tokenId) public view override returns (address) {
1148         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1149 
1150         return _tokenApprovals[tokenId];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-setApprovalForAll}.
1155      */
1156     function setApprovalForAll(address operator, bool approved) public virtual override {
1157         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1158 
1159         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1160         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-isApprovedForAll}.
1165      */
1166     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1167         return _operatorApprovals[owner][operator];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         safeTransferFrom(from, to, tokenId, '');
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-safeTransferFrom}.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) public virtual override {
1190         transferFrom(from, to, tokenId);
1191         if (to.code.length != 0)
1192             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1193                 revert TransferToNonERC721ReceiverImplementer();
1194             }
1195     }
1196 
1197     /**
1198      * @dev Returns whether `tokenId` exists.
1199      *
1200      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1201      *
1202      * Tokens start existing when they are minted (`_mint`),
1203      */
1204     function _exists(uint256 tokenId) internal view returns (bool) {
1205         return
1206             _startTokenId() <= tokenId &&
1207             tokenId < _currentIndex && // If within bounds,
1208             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1209     }
1210 
1211     /**
1212      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1213      */
1214     function _safeMint(address to, uint256 quantity) internal {
1215         _safeMint(to, quantity, '');
1216     }
1217 
1218     /**
1219      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - If `to` refers to a smart contract, it must implement
1224      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * See {_mint}.
1228      *
1229      * Emits a {Transfer} event for each mint.
1230      */
1231     function _safeMint(
1232         address to,
1233         uint256 quantity,
1234         bytes memory _data
1235     ) internal {
1236         _mint(to, quantity);
1237 
1238         unchecked {
1239             if (to.code.length != 0) {
1240                 uint256 end = _currentIndex;
1241                 uint256 index = end - quantity;
1242                 do {
1243                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1244                         revert TransferToNonERC721ReceiverImplementer();
1245                     }
1246                 } while (index < end);
1247                 // Reentrancy protection.
1248                 if (_currentIndex != end) revert();
1249             }
1250         }
1251     }
1252 
1253     /**
1254      * @dev Mints `quantity` tokens and transfers them to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - `quantity` must be greater than 0.
1260      *
1261      * Emits a {Transfer} event for each mint.
1262      */
1263     function _mint(address to, uint256 quantity) internal {
1264         uint256 startTokenId = _currentIndex;
1265         if (to == address(0)) revert MintToZeroAddress();
1266         if (quantity == 0) revert MintZeroQuantity();
1267 
1268         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1269 
1270         // Overflows are incredibly unrealistic.
1271         // `balance` and `numberMinted` have a maximum limit of 2**64.
1272         // `tokenId` has a maximum limit of 2**256.
1273         unchecked {
1274             // Updates:
1275             // - `balance += quantity`.
1276             // - `numberMinted += quantity`.
1277             //
1278             // We can directly add to the `balance` and `numberMinted`.
1279             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1280 
1281             // Updates:
1282             // - `address` to the owner.
1283             // - `startTimestamp` to the timestamp of minting.
1284             // - `burned` to `false`.
1285             // - `nextInitialized` to `quantity == 1`.
1286             _packedOwnerships[startTokenId] = _packOwnershipData(
1287                 to,
1288                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1289             );
1290 
1291             uint256 tokenId = startTokenId;
1292             uint256 end = startTokenId + quantity;
1293             do {
1294                 emit Transfer(address(0), to, tokenId++);
1295             } while (tokenId < end);
1296 
1297             _currentIndex = end;
1298         }
1299         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1300     }
1301 
1302     /**
1303      * @dev Mints `quantity` tokens and transfers them to `to`.
1304      *
1305      * This function is intended for efficient minting only during contract creation.
1306      *
1307      * It emits only one {ConsecutiveTransfer} as defined in
1308      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1309      * instead of a sequence of {Transfer} event(s).
1310      *
1311      * Calling this function outside of contract creation WILL make your contract
1312      * non-compliant with the ERC721 standard.
1313      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1314      * {ConsecutiveTransfer} event is only permissible during contract creation.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `quantity` must be greater than 0.
1320      *
1321      * Emits a {ConsecutiveTransfer} event.
1322      */
1323     function _mintERC2309(address to, uint256 quantity) internal {
1324         uint256 startTokenId = _currentIndex;
1325         if (to == address(0)) revert MintToZeroAddress();
1326         if (quantity == 0) revert MintZeroQuantity();
1327         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1328 
1329         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1330 
1331         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1332         unchecked {
1333             // Updates:
1334             // - `balance += quantity`.
1335             // - `numberMinted += quantity`.
1336             //
1337             // We can directly add to the `balance` and `numberMinted`.
1338             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1339 
1340             // Updates:
1341             // - `address` to the owner.
1342             // - `startTimestamp` to the timestamp of minting.
1343             // - `burned` to `false`.
1344             // - `nextInitialized` to `quantity == 1`.
1345             _packedOwnerships[startTokenId] = _packOwnershipData(
1346                 to,
1347                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1348             );
1349 
1350             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1351 
1352             _currentIndex = startTokenId + quantity;
1353         }
1354         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1355     }
1356 
1357     /**
1358      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1359      */
1360     function _getApprovedAddress(uint256 tokenId)
1361         private
1362         view
1363         returns (uint256 approvedAddressSlot, address approvedAddress)
1364     {
1365         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1366         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1367         assembly {
1368             // Compute the slot.
1369             mstore(0x00, tokenId)
1370             mstore(0x20, tokenApprovalsPtr.slot)
1371             approvedAddressSlot := keccak256(0x00, 0x40)
1372             // Load the slot's value from storage.
1373             approvedAddress := sload(approvedAddressSlot)
1374         }
1375     }
1376 
1377     /**
1378      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1379      */
1380     function _isOwnerOrApproved(
1381         address approvedAddress,
1382         address from,
1383         address msgSender
1384     ) private pure returns (bool result) {
1385         assembly {
1386             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1387             from := and(from, BITMASK_ADDRESS)
1388             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1389             msgSender := and(msgSender, BITMASK_ADDRESS)
1390             // `msgSender == from || msgSender == approvedAddress`.
1391             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1392         }
1393     }
1394 
1395     /**
1396      * @dev Transfers `tokenId` from `from` to `to`.
1397      *
1398      * Requirements:
1399      *
1400      * - `to` cannot be the zero address.
1401      * - `tokenId` token must be owned by `from`.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function transferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) public virtual override {
1410         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1411 
1412         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1413 
1414         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1415 
1416         // The nested ifs save around 20+ gas over a compound boolean condition.
1417         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1418             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1419 
1420         if (to == address(0)) revert TransferToZeroAddress();
1421 
1422         _beforeTokenTransfers(from, to, tokenId, 1);
1423 
1424         // Clear approvals from the previous owner.
1425         assembly {
1426             if approvedAddress {
1427                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1428                 sstore(approvedAddressSlot, 0)
1429             }
1430         }
1431 
1432         // Underflow of the sender's balance is impossible because we check for
1433         // ownership above and the recipient's balance can't realistically overflow.
1434         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1435         unchecked {
1436             // We can directly increment and decrement the balances.
1437             --_packedAddressData[from]; // Updates: `balance -= 1`.
1438             ++_packedAddressData[to]; // Updates: `balance += 1`.
1439 
1440             // Updates:
1441             // - `address` to the next owner.
1442             // - `startTimestamp` to the timestamp of transfering.
1443             // - `burned` to `false`.
1444             // - `nextInitialized` to `true`.
1445             _packedOwnerships[tokenId] = _packOwnershipData(
1446                 to,
1447                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1448             );
1449 
1450             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1451             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1452                 uint256 nextTokenId = tokenId + 1;
1453                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1454                 if (_packedOwnerships[nextTokenId] == 0) {
1455                     // If the next slot is within bounds.
1456                     if (nextTokenId != _currentIndex) {
1457                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1458                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1459                     }
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, to, tokenId);
1465         _afterTokenTransfers(from, to, tokenId, 1);
1466     }
1467 
1468     /**
1469      * @dev Equivalent to `_burn(tokenId, false)`.
1470      */
1471     function _burn(uint256 tokenId) internal virtual {
1472         _burn(tokenId, false);
1473     }
1474 
1475     /**
1476      * @dev Destroys `tokenId`.
1477      * The approval is cleared when the token is burned.
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must exist.
1482      *
1483      * Emits a {Transfer} event.
1484      */
1485     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1486         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1487 
1488         address from = address(uint160(prevOwnershipPacked));
1489 
1490         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1491 
1492         if (approvalCheck) {
1493             // The nested ifs save around 20+ gas over a compound boolean condition.
1494             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1495                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1496         }
1497 
1498         _beforeTokenTransfers(from, address(0), tokenId, 1);
1499 
1500         // Clear approvals from the previous owner.
1501         assembly {
1502             if approvedAddress {
1503                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1504                 sstore(approvedAddressSlot, 0)
1505             }
1506         }
1507 
1508         // Underflow of the sender's balance is impossible because we check for
1509         // ownership above and the recipient's balance can't realistically overflow.
1510         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1511         unchecked {
1512             // Updates:
1513             // - `balance -= 1`.
1514             // - `numberBurned += 1`.
1515             //
1516             // We can directly decrement the balance, and increment the number burned.
1517             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1518             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1519 
1520             // Updates:
1521             // - `address` to the last owner.
1522             // - `startTimestamp` to the timestamp of burning.
1523             // - `burned` to `true`.
1524             // - `nextInitialized` to `true`.
1525             _packedOwnerships[tokenId] = _packOwnershipData(
1526                 from,
1527                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1528             );
1529 
1530             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1531             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1532                 uint256 nextTokenId = tokenId + 1;
1533                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1534                 if (_packedOwnerships[nextTokenId] == 0) {
1535                     // If the next slot is within bounds.
1536                     if (nextTokenId != _currentIndex) {
1537                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1538                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1539                     }
1540                 }
1541             }
1542         }
1543 
1544         emit Transfer(from, address(0), tokenId);
1545         _afterTokenTransfers(from, address(0), tokenId, 1);
1546 
1547         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1548         unchecked {
1549             _burnCounter++;
1550         }
1551     }
1552 
1553     /**
1554      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1555      *
1556      * @param from address representing the previous owner of the given token ID
1557      * @param to target address that will receive the tokens
1558      * @param tokenId uint256 ID of the token to be transferred
1559      * @param _data bytes optional data to send along with the call
1560      * @return bool whether the call correctly returned the expected magic value
1561      */
1562     function _checkContractOnERC721Received(
1563         address from,
1564         address to,
1565         uint256 tokenId,
1566         bytes memory _data
1567     ) private returns (bool) {
1568         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1569             bytes4 retval
1570         ) {
1571             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1572         } catch (bytes memory reason) {
1573             if (reason.length == 0) {
1574                 revert TransferToNonERC721ReceiverImplementer();
1575             } else {
1576                 assembly {
1577                     revert(add(32, reason), mload(reason))
1578                 }
1579             }
1580         }
1581     }
1582 
1583     /**
1584      * @dev Directly sets the extra data for the ownership data `index`.
1585      */
1586     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1587         uint256 packed = _packedOwnerships[index];
1588         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1589         uint256 extraDataCasted;
1590         // Cast `extraData` with assembly to avoid redundant masking.
1591         assembly {
1592             extraDataCasted := extraData
1593         }
1594         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1595         _packedOwnerships[index] = packed;
1596     }
1597 
1598     /**
1599      * @dev Returns the next extra data for the packed ownership data.
1600      * The returned result is shifted into position.
1601      */
1602     function _nextExtraData(
1603         address from,
1604         address to,
1605         uint256 prevOwnershipPacked
1606     ) private view returns (uint256) {
1607         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1608         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1609     }
1610 
1611     /**
1612      * @dev Called during each token transfer to set the 24bit `extraData` field.
1613      * Intended to be overridden by the cosumer contract.
1614      *
1615      * `previousExtraData` - the value of `extraData` before transfer.
1616      *
1617      * Calling conditions:
1618      *
1619      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1620      * transferred to `to`.
1621      * - When `from` is zero, `tokenId` will be minted for `to`.
1622      * - When `to` is zero, `tokenId` will be burned by `from`.
1623      * - `from` and `to` are never both zero.
1624      */
1625     function _extraData(
1626         address from,
1627         address to,
1628         uint24 previousExtraData
1629     ) internal view virtual returns (uint24) {}
1630 
1631     /**
1632      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1633      * This includes minting.
1634      * And also called before burning one token.
1635      *
1636      * startTokenId - the first token id to be transferred
1637      * quantity - the amount to be transferred
1638      *
1639      * Calling conditions:
1640      *
1641      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1642      * transferred to `to`.
1643      * - When `from` is zero, `tokenId` will be minted for `to`.
1644      * - When `to` is zero, `tokenId` will be burned by `from`.
1645      * - `from` and `to` are never both zero.
1646      */
1647     function _beforeTokenTransfers(
1648         address from,
1649         address to,
1650         uint256 startTokenId,
1651         uint256 quantity
1652     ) internal virtual {}
1653 
1654     /**
1655      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1656      * This includes minting.
1657      * And also called after one token has been burned.
1658      *
1659      * startTokenId - the first token id to be transferred
1660      * quantity - the amount to be transferred
1661      *
1662      * Calling conditions:
1663      *
1664      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1665      * transferred to `to`.
1666      * - When `from` is zero, `tokenId` has been minted for `to`.
1667      * - When `to` is zero, `tokenId` has been burned by `from`.
1668      * - `from` and `to` are never both zero.
1669      */
1670     function _afterTokenTransfers(
1671         address from,
1672         address to,
1673         uint256 startTokenId,
1674         uint256 quantity
1675     ) internal virtual {}
1676 
1677     /**
1678      * @dev Returns the message sender (defaults to `msg.sender`).
1679      *
1680      * If you are writing GSN compatible contracts, you need to override this function.
1681      */
1682     function _msgSenderERC721A() internal view virtual returns (address) {
1683         return msg.sender;
1684     }
1685 
1686     /**
1687      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1688      */
1689     function _toString(uint256 value) internal pure returns (string memory ptr) {
1690         assembly {
1691             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1692             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1693             // We will need 1 32-byte word to store the length,
1694             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1695             ptr := add(mload(0x40), 128)
1696             // Update the free memory pointer to allocate.
1697             mstore(0x40, ptr)
1698 
1699             // Cache the end of the memory to calculate the length later.
1700             let end := ptr
1701 
1702             // We write the string from the rightmost digit to the leftmost digit.
1703             // The following is essentially a do-while loop that also handles the zero case.
1704             // Costs a bit more than early returning for the zero case,
1705             // but cheaper in terms of deployment and overall runtime costs.
1706             for {
1707                 // Initialize and perform the first pass without check.
1708                 let temp := value
1709                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1710                 ptr := sub(ptr, 1)
1711                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1712                 mstore8(ptr, add(48, mod(temp, 10)))
1713                 temp := div(temp, 10)
1714             } temp {
1715                 // Keep dividing `temp` until zero.
1716                 temp := div(temp, 10)
1717             } {
1718                 // Body of the for loop.
1719                 ptr := sub(ptr, 1)
1720                 mstore8(ptr, add(48, mod(temp, 10)))
1721             }
1722 
1723             let length := sub(end, ptr)
1724             // Move the pointer 32 bytes leftwards to make room for the length.
1725             ptr := sub(ptr, 32)
1726             // Store the length.
1727             mstore(ptr, length)
1728         }
1729     }
1730 }
1731 
1732 // File: contracts/TheJap.sol
1733 /*
1734  ________ __                   _____                        __    __ ________ ________ 
1735 |        \  \                 |     \                      |  \  |  \        \        \
1736  \▓▓▓▓▓▓▓▓ ▓▓____   ______     \▓▓▓▓▓ ______   ______      | ▓▓\ | ▓▓ ▓▓▓▓▓▓▓▓\▓▓▓▓▓▓▓▓
1737    | ▓▓  | ▓▓    \ /      \      | ▓▓|      \ /      \     | ▓▓▓\| ▓▓ ▓▓__      | ▓▓   
1738    | ▓▓  | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\__   | ▓▓ \▓▓▓▓▓▓\  ▓▓▓▓▓▓\    | ▓▓▓▓\ ▓▓ ▓▓  \     | ▓▓   
1739    | ▓▓  | ▓▓  | ▓▓ ▓▓    ▓▓  \  | ▓▓/      ▓▓ ▓▓  | ▓▓    | ▓▓\▓▓ ▓▓ ▓▓▓▓▓     | ▓▓   
1740    | ▓▓  | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__| ▓▓  ▓▓▓▓▓▓▓ ▓▓__/ ▓▓    | ▓▓ \▓▓▓▓ ▓▓        | ▓▓   
1741    | ▓▓  | ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓\▓▓    ▓▓ ▓▓    ▓▓    | ▓▓  \▓▓▓ ▓▓        | ▓▓   
1742     \▓▓   \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓  \▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓      \▓▓   \▓▓\▓▓         \▓▓   
1743                                              | ▓▓                                      
1744                                              | ▓▓                                      
1745                                               \▓▓                                      
1746 
1747 
1748 */
1749 
1750 pragma solidity ^0.8.0;
1751 
1752 contract TheJap is ERC721A, Ownable, ReentrancyGuard {
1753   using Address for address;
1754   using Strings for uint;
1755 
1756   string  public  baseTokenURI = "ipfs://QmecyR6swqwibZ6GU4B69SYTxMs5jtyy9mTTV4aiQiLJoP";
1757 
1758   uint256 public  maxSupply = 7777;
1759   uint256 public  marketingSupply = 77;
1760   uint256 public  MAX_MINTS_PER_TX = 7;
1761   uint256 public  FREE_MINTS_PER_TX = 2;
1762   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1763   uint256 public  TOTAL_FREE_MINTS = 3000;
1764   bool public isPublicSaleActive = false;
1765 
1766   constructor() ERC721A("The Jap", "THEJAP") {
1767 
1768   }
1769 
1770   function mint(uint256 numberOfTokens)
1771       external
1772       payable
1773   {
1774     require(isPublicSaleActive, "Public sale is not open");
1775     require(
1776       totalSupply() + numberOfTokens <= (maxSupply - marketingSupply),
1777       "Maximum supply exceeded"
1778     );
1779     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1780         require(
1781             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1782             "Incorrect ETH value sent"
1783         );
1784     }
1785     _safeMint(msg.sender, numberOfTokens);
1786   }
1787 
1788   function setBaseURI(string memory baseURI)
1789     public
1790     onlyOwner
1791   {
1792     baseTokenURI = baseURI;
1793   }
1794 
1795   function _startTokenId() internal view virtual override returns (uint256) {
1796         return 0;
1797     }
1798 
1799   function giveawayMint(uint quantity, address user)
1800     public
1801     onlyOwner
1802   {
1803     require(
1804       quantity > 0,
1805       "Invalid mint amount"
1806     );
1807     require(
1808       totalSupply() + quantity <= maxSupply,
1809       "Maximum supply exceeded"
1810     );
1811     _safeMint(user, quantity);
1812   }
1813 
1814   function withdraw()
1815     public
1816     onlyOwner
1817     nonReentrant
1818   {
1819     Address.sendValue(payable(msg.sender), address(this).balance);
1820   }
1821 
1822   function tokenURI(uint _tokenId)
1823     public
1824     view
1825     virtual
1826     override
1827     returns (string memory)
1828   {
1829     require(
1830       _exists(_tokenId),
1831       "ERC721Metadata: URI query for nonexistent token"
1832     );
1833     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1834   }
1835 
1836   function _baseURI()
1837     internal
1838     view
1839     virtual
1840     override
1841     returns (string memory)
1842   {
1843     return baseTokenURI;
1844   }
1845 
1846   function setIsPublicSaleActive(bool _isPublicSaleActive)
1847       external
1848       onlyOwner
1849   {
1850       isPublicSaleActive = _isPublicSaleActive;
1851   }
1852 
1853   function setNumFreeMints(uint256 _numfreemints)
1854       external
1855       onlyOwner
1856   {
1857       TOTAL_FREE_MINTS = _numfreemints;
1858   }
1859 
1860   function setFreeMintsPerTx(uint256 _numfreelimit)
1861       external
1862       onlyOwner
1863   {
1864       FREE_MINTS_PER_TX = _numfreelimit;
1865   }
1866 
1867   function setSalePrice(uint256 _price)
1868       external
1869       onlyOwner
1870   {
1871       PUBLIC_SALE_PRICE = _price;
1872   }
1873 
1874   function setMaxLimitPerTransaction(uint256 _limit)
1875       external
1876       onlyOwner
1877   {
1878       MAX_MINTS_PER_TX = _limit;
1879   }
1880 
1881 }