1 /***
2  *     .----------------.  .----------------.  .----------------.  .----------------.   .----------------.  .----------------.  .----------------.  .----------------.   .----------------.  .----------------. 
3  *    | .--------------. || .--------------. || .--------------. || .--------------. | | .--------------. || .--------------. || .--------------. || .--------------. | | .--------------. || .--------------. |
4  *    | |     ______   | || |     ____     | || |     ____     | || |   _____      | | | |     ______   | || |      __      | || |  _________   | || |    _______   | | | |      __      | || |     _____    | |
5  *    | |   .' ___  |  | || |   .'    `.   | || |   .'    `.   | || |  |_   _|     | | | |   .' ___  |  | || |     /  \     | || | |  _   _  |  | || |   /  ___  |  | | | |     /  \     | || |    |_   _|   | |
6  *    | |  / .'   \_|  | || |  /  .--.  \  | || |  /  .--.  \  | || |    | |       | | | |  / .'   \_|  | || |    / /\ \    | || | |_/ | | \_|  | || |  |  (__ \_|  | | | |    / /\ \    | || |      | |     | |
7  *    | |  | |         | || |  | |    | |  | || |  | |    | |  | || |    | |   _   | | | |  | |         | || |   / ____ \   | || |     | |      | || |   '.___`-.   | | | |   / ____ \   | || |      | |     | |
8  *    | |  \ `.___.'\  | || |  \  `--'  /  | || |  \  `--'  /  | || |   _| |__/ |  | | | |  \ `.___.'\  | || | _/ /    \ \_ | || |    _| |_     | || |  |`\____) |  | | | | _/ /    \ \_ | || |     _| |_    | |
9  *    | |   `._____.'  | || |   `.____.'   | || |   `.____.'   | || |  |________|  | | | |   `._____.'  | || ||____|  |____|| || |   |_____|    | || |  |_______.'  | | | ||____|  |____|| || |    |_____|   | |
10  *    | |              | || |              | || |              | || |              | | | |              | || |              | || |              | || |              | | | |              | || |              | |
11  *    | '--------------' || '--------------' || '--------------' || '--------------' | | '--------------' || '--------------' || '--------------' || '--------------' | | '--------------' || '--------------' |
12  *     '----------------'  '----------------'  '----------------'  '----------------'   '----------------'  '----------------'  '----------------'  '----------------'   '----------------'  '----------------' 
13  */
14 
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27     uint8 private constant _ADDRESS_LENGTH = 20;
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
56      */
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
72      */
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
87      */
88     function toHexString(address addr) internal pure returns (string memory) {
89         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Address.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
97 
98 pragma solidity ^0.8.1;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
291      * revert reason using the provided one.
292      *
293      * _Available since v4.3._
294      */
295     function verifyCallResult(
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal pure returns (bytes memory) {
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306                 /// @solidity memory-safe-assembly
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Contract module that helps prevent reentrant calls to a function.
327  *
328  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
329  * available, which can be applied to functions to make sure there are no nested
330  * (reentrant) calls to them.
331  *
332  * Note that because there is a single `nonReentrant` guard, functions marked as
333  * `nonReentrant` may not call one another. This can be worked around by making
334  * those functions `private`, and then adding `external` `nonReentrant` entry
335  * points to them.
336  *
337  * TIP: If you would like to learn more about reentrancy and alternative ways
338  * to protect against it, check out our blog post
339  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
340  */
341 abstract contract ReentrancyGuard {
342     // Booleans are more expensive than uint256 or any type that takes up a full
343     // word because each write operation emits an extra SLOAD to first read the
344     // slot's contents, replace the bits taken up by the boolean, and then write
345     // back. This is the compiler's defense against contract upgrades and
346     // pointer aliasing, and it cannot be disabled.
347 
348     // The values being non-zero value makes deployment a bit more expensive,
349     // but in exchange the refund on every call to nonReentrant will be lower in
350     // amount. Since refunds are capped to a percentage of the total
351     // transaction's gas, it is best to keep them low in cases like this one, to
352     // increase the likelihood of the full refund coming into effect.
353     uint256 private constant _NOT_ENTERED = 1;
354     uint256 private constant _ENTERED = 2;
355 
356     uint256 private _status;
357 
358     constructor() {
359         _status = _NOT_ENTERED;
360     }
361 
362     /**
363      * @dev Prevents a contract from calling itself, directly or indirectly.
364      * Calling a `nonReentrant` function from another `nonReentrant`
365      * function is not supported. It is possible to prevent this from happening
366      * by making the `nonReentrant` function external, and making it call a
367      * `private` function that does the actual work.
368      */
369     modifier nonReentrant() {
370         // On the first call to nonReentrant, _notEntered will be true
371         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
372 
373         // Any calls to nonReentrant after this point will fail
374         _status = _ENTERED;
375 
376         _;
377 
378         // By storing the original value once again, a refund is triggered (see
379         // https://eips.ethereum.org/EIPS/eip-2200)
380         _status = _NOT_ENTERED;
381     }
382 }
383 
384 // File: @openzeppelin/contracts/utils/Context.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 abstract contract Context {
402     function _msgSender() internal view virtual returns (address) {
403         return msg.sender;
404     }
405 
406     function _msgData() internal view virtual returns (bytes calldata) {
407         return msg.data;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/access/Ownable.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Contract module which provides a basic access control mechanism, where
421  * there is an account (an owner) that can be granted exclusive access to
422  * specific functions.
423  *
424  * By default, the owner account will be the one that deploys the contract. This
425  * can later be changed with {transferOwnership}.
426  *
427  * This module is used through inheritance. It will make available the modifier
428  * `onlyOwner`, which can be applied to your functions to restrict their use to
429  * the owner.
430  */
431 abstract contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor() {
440         _transferOwnership(_msgSender());
441     }
442 
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         _checkOwner();
448         _;
449     }
450 
451     /**
452      * @dev Returns the address of the current owner.
453      */
454     function owner() public view virtual returns (address) {
455         return _owner;
456     }
457 
458     /**
459      * @dev Throws if the sender is not the owner.
460      */
461     function _checkOwner() internal view virtual {
462         require(owner() == _msgSender(), "Ownable: caller is not the owner");
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public virtual onlyOwner {
473         _transferOwnership(address(0));
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         _transferOwnership(newOwner);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      * Internal function without access restriction.
488      */
489     function _transferOwnership(address newOwner) internal virtual {
490         address oldOwner = _owner;
491         _owner = newOwner;
492         emit OwnershipTransferred(oldOwner, newOwner);
493     }
494 }
495 
496 // File: erc721a/contracts/IERC721A.sol
497 
498 
499 // ERC721A Contracts v4.2.2
500 // Creator: Chiru Labs
501 
502 pragma solidity ^0.8.4;
503 
504 /**
505  * @dev Interface of ERC721A.
506  */
507 interface IERC721A {
508     /**
509      * The caller must own the token or be an approved operator.
510      */
511     error ApprovalCallerNotOwnerNorApproved();
512 
513     /**
514      * The token does not exist.
515      */
516     error ApprovalQueryForNonexistentToken();
517 
518     /**
519      * The caller cannot approve to their own address.
520      */
521     error ApproveToCaller();
522 
523     /**
524      * Cannot query the balance for the zero address.
525      */
526     error BalanceQueryForZeroAddress();
527 
528     /**
529      * Cannot mint to the zero address.
530      */
531     error MintToZeroAddress();
532 
533     /**
534      * The quantity of tokens minted must be more than zero.
535      */
536     error MintZeroQuantity();
537 
538     /**
539      * The token does not exist.
540      */
541     error OwnerQueryForNonexistentToken();
542 
543     /**
544      * The caller must own the token or be an approved operator.
545      */
546     error TransferCallerNotOwnerNorApproved();
547 
548     /**
549      * The token must be owned by `from`.
550      */
551     error TransferFromIncorrectOwner();
552 
553     /**
554      * Cannot safely transfer to a contract that does not implement the
555      * ERC721Receiver interface.
556      */
557     error TransferToNonERC721ReceiverImplementer();
558 
559     /**
560      * Cannot transfer to the zero address.
561      */
562     error TransferToZeroAddress();
563 
564     /**
565      * The token does not exist.
566      */
567     error URIQueryForNonexistentToken();
568 
569     /**
570      * The `quantity` minted with ERC2309 exceeds the safety limit.
571      */
572     error MintERC2309QuantityExceedsLimit();
573 
574     /**
575      * The `extraData` cannot be set on an unintialized ownership slot.
576      */
577     error OwnershipNotInitializedForExtraData();
578 
579     // =============================================================
580     //                            STRUCTS
581     // =============================================================
582 
583     struct TokenOwnership {
584         // The address of the owner.
585         address addr;
586         // Stores the start time of ownership with minimal overhead for tokenomics.
587         uint64 startTimestamp;
588         // Whether the token has been burned.
589         bool burned;
590         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
591         uint24 extraData;
592     }
593 
594     // =============================================================
595     //                         TOKEN COUNTERS
596     // =============================================================
597 
598     /**
599      * @dev Returns the total number of tokens in existence.
600      * Burned tokens will reduce the count.
601      * To get the total number of tokens minted, please see {_totalMinted}.
602      */
603     function totalSupply() external view returns (uint256);
604 
605     // =============================================================
606     //                            IERC165
607     // =============================================================
608 
609     /**
610      * @dev Returns true if this contract implements the interface defined by
611      * `interfaceId`. See the corresponding
612      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
613      * to learn more about how these ids are created.
614      *
615      * This function call must use less than 30000 gas.
616      */
617     function supportsInterface(bytes4 interfaceId) external view returns (bool);
618 
619     // =============================================================
620     //                            IERC721
621     // =============================================================
622 
623     /**
624      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
625      */
626     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
630      */
631     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables or disables
635      * (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
638 
639     /**
640      * @dev Returns the number of tokens in `owner`'s account.
641      */
642     function balanceOf(address owner) external view returns (uint256 balance);
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId) external view returns (address owner);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`,
655      * checking first that contract recipients are aware of the ERC721 protocol
656      * to prevent tokens from being forever locked.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be have been allowed to move
664      * this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement
666      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId,
674         bytes calldata data
675     ) external;
676 
677     /**
678      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) external;
685 
686     /**
687      * @dev Transfers `tokenId` from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
690      * whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token
698      * by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the
713      * zero address clears previous approvals.
714      *
715      * Requirements:
716      *
717      * - The caller must own the token or be an approved operator.
718      * - `tokenId` must exist.
719      *
720      * Emits an {Approval} event.
721      */
722     function approve(address to, uint256 tokenId) external;
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom}
727      * for any token owned by the caller.
728      *
729      * Requirements:
730      *
731      * - The `operator` cannot be the caller.
732      *
733      * Emits an {ApprovalForAll} event.
734      */
735     function setApprovalForAll(address operator, bool _approved) external;
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) external view returns (address operator);
745 
746     /**
747      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
748      *
749      * See {setApprovalForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) external view returns (bool);
752 
753     // =============================================================
754     //                        IERC721Metadata
755     // =============================================================
756 
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 
772     // =============================================================
773     //                           IERC2309
774     // =============================================================
775 
776     /**
777      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
778      * (inclusive) is transferred from `from` to `to`, as defined in the
779      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
780      *
781      * See {_mintERC2309} for more details.
782      */
783     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
784 }
785 
786 // File: erc721a/contracts/ERC721A.sol
787 
788 
789 // ERC721A Contracts v4.2.2
790 // Creator: Chiru Labs
791 
792 pragma solidity ^0.8.4;
793 
794 
795 /**
796  * @dev Interface of ERC721 token receiver.
797  */
798 interface ERC721A__IERC721Receiver {
799     function onERC721Received(
800         address operator,
801         address from,
802         uint256 tokenId,
803         bytes calldata data
804     ) external returns (bytes4);
805 }
806 
807 /**
808  * @title ERC721A
809  *
810  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
811  * Non-Fungible Token Standard, including the Metadata extension.
812  * Optimized for lower gas during batch mints.
813  *
814  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
815  * starting from `_startTokenId()`.
816  *
817  * Assumptions:
818  *
819  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
820  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
821  */
822 contract ERC721A is IERC721A {
823     // Reference type for token approval.
824     struct TokenApprovalRef {
825         address value;
826     }
827 
828     // =============================================================
829     //                           CONSTANTS
830     // =============================================================
831 
832     // Mask of an entry in packed address data.
833     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
834 
835     // The bit position of `numberMinted` in packed address data.
836     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
837 
838     // The bit position of `numberBurned` in packed address data.
839     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
840 
841     // The bit position of `aux` in packed address data.
842     uint256 private constant _BITPOS_AUX = 192;
843 
844     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
845     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
846 
847     // The bit position of `startTimestamp` in packed ownership.
848     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
849 
850     // The bit mask of the `burned` bit in packed ownership.
851     uint256 private constant _BITMASK_BURNED = 1 << 224;
852 
853     // The bit position of the `nextInitialized` bit in packed ownership.
854     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
855 
856     // The bit mask of the `nextInitialized` bit in packed ownership.
857     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
858 
859     // The bit position of `extraData` in packed ownership.
860     uint256 private constant _BITPOS_EXTRA_DATA = 232;
861 
862     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
863     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
864 
865     // The mask of the lower 160 bits for addresses.
866     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
867 
868     // The maximum `quantity` that can be minted with {_mintERC2309}.
869     // This limit is to prevent overflows on the address data entries.
870     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
871     // is required to cause an overflow, which is unrealistic.
872     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
873 
874     // The `Transfer` event signature is given by:
875     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
876     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
877         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
878 
879     // =============================================================
880     //                            STORAGE
881     // =============================================================
882 
883     // The next token ID to be minted.
884     uint256 private _currentIndex;
885 
886     // The number of tokens burned.
887     uint256 private _burnCounter;
888 
889     // Token name
890     string private _name;
891 
892     // Token symbol
893     string private _symbol;
894 
895     // Mapping from token ID to ownership details
896     // An empty struct value does not necessarily mean the token is unowned.
897     // See {_packedOwnershipOf} implementation for details.
898     //
899     // Bits Layout:
900     // - [0..159]   `addr`
901     // - [160..223] `startTimestamp`
902     // - [224]      `burned`
903     // - [225]      `nextInitialized`
904     // - [232..255] `extraData`
905     mapping(uint256 => uint256) private _packedOwnerships;
906 
907     // Mapping owner address to address data.
908     //
909     // Bits Layout:
910     // - [0..63]    `balance`
911     // - [64..127]  `numberMinted`
912     // - [128..191] `numberBurned`
913     // - [192..255] `aux`
914     mapping(address => uint256) private _packedAddressData;
915 
916     // Mapping from token ID to approved address.
917     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     // =============================================================
923     //                          CONSTRUCTOR
924     // =============================================================
925 
926     constructor(string memory name_, string memory symbol_) {
927         _name = name_;
928         _symbol = symbol_;
929         _currentIndex = _startTokenId();
930     }
931 
932     // =============================================================
933     //                   TOKEN COUNTING OPERATIONS
934     // =============================================================
935 
936     /**
937      * @dev Returns the starting token ID.
938      * To change the starting token ID, please override this function.
939      */
940     function _startTokenId() internal view virtual returns (uint256) {
941         return 0;
942     }
943 
944     /**
945      * @dev Returns the next token ID to be minted.
946      */
947     function _nextTokenId() internal view virtual returns (uint256) {
948         return _currentIndex;
949     }
950 
951     /**
952      * @dev Returns the total number of tokens in existence.
953      * Burned tokens will reduce the count.
954      * To get the total number of tokens minted, please see {_totalMinted}.
955      */
956     function totalSupply() public view virtual override returns (uint256) {
957         // Counter underflow is impossible as _burnCounter cannot be incremented
958         // more than `_currentIndex - _startTokenId()` times.
959         unchecked {
960             return _currentIndex - _burnCounter - _startTokenId();
961         }
962     }
963 
964     /**
965      * @dev Returns the total amount of tokens minted in the contract.
966      */
967     function _totalMinted() internal view virtual returns (uint256) {
968         // Counter underflow is impossible as `_currentIndex` does not decrement,
969         // and it is initialized to `_startTokenId()`.
970         unchecked {
971             return _currentIndex - _startTokenId();
972         }
973     }
974 
975     /**
976      * @dev Returns the total number of tokens burned.
977      */
978     function _totalBurned() internal view virtual returns (uint256) {
979         return _burnCounter;
980     }
981 
982     // =============================================================
983     //                    ADDRESS DATA OPERATIONS
984     // =============================================================
985 
986     /**
987      * @dev Returns the number of tokens in `owner`'s account.
988      */
989     function balanceOf(address owner) public view virtual override returns (uint256) {
990         if (owner == address(0)) revert BalanceQueryForZeroAddress();
991         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
992     }
993 
994     /**
995      * Returns the number of tokens minted by `owner`.
996      */
997     function _numberMinted(address owner) internal view returns (uint256) {
998         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
999     }
1000 
1001     /**
1002      * Returns the number of tokens burned by or on behalf of `owner`.
1003      */
1004     function _numberBurned(address owner) internal view returns (uint256) {
1005         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1006     }
1007 
1008     /**
1009      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1010      */
1011     function _getAux(address owner) internal view returns (uint64) {
1012         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1013     }
1014 
1015     /**
1016      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1017      * If there are multiple variables, please pack them into a uint64.
1018      */
1019     function _setAux(address owner, uint64 aux) internal virtual {
1020         uint256 packed = _packedAddressData[owner];
1021         uint256 auxCasted;
1022         // Cast `aux` with assembly to avoid redundant masking.
1023         assembly {
1024             auxCasted := aux
1025         }
1026         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1027         _packedAddressData[owner] = packed;
1028     }
1029 
1030     // =============================================================
1031     //                            IERC165
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns true if this contract implements the interface defined by
1036      * `interfaceId`. See the corresponding
1037      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1038      * to learn more about how these ids are created.
1039      *
1040      * This function call must use less than 30000 gas.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1043         // The interface IDs are constants representing the first 4 bytes
1044         // of the XOR of all function selectors in the interface.
1045         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1046         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1047         return
1048             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1049             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1050             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1051     }
1052 
1053     // =============================================================
1054     //                        IERC721Metadata
1055     // =============================================================
1056 
1057     /**
1058      * @dev Returns the token collection name.
1059      */
1060     function name() public view virtual override returns (string memory) {
1061         return _name;
1062     }
1063 
1064     /**
1065      * @dev Returns the token collection symbol.
1066      */
1067     function symbol() public view virtual override returns (string memory) {
1068         return _symbol;
1069     }
1070 
1071     /**
1072      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1073      */
1074     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1075         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1076 
1077         string memory baseURI = _baseURI();
1078         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1079     }
1080 
1081     /**
1082      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1083      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1084      * by default, it can be overridden in child contracts.
1085      */
1086     function _baseURI() internal view virtual returns (string memory) {
1087         return '';
1088     }
1089 
1090     // =============================================================
1091     //                     OWNERSHIPS OPERATIONS
1092     // =============================================================
1093 
1094     /**
1095      * @dev Returns the owner of the `tokenId` token.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      */
1101     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1102         return address(uint160(_packedOwnershipOf(tokenId)));
1103     }
1104 
1105     /**
1106      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1107      * It gradually moves to O(1) as tokens get transferred around over time.
1108      */
1109     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1110         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1111     }
1112 
1113     /**
1114      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1115      */
1116     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1117         return _unpackedOwnership(_packedOwnerships[index]);
1118     }
1119 
1120     /**
1121      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1122      */
1123     function _initializeOwnershipAt(uint256 index) internal virtual {
1124         if (_packedOwnerships[index] == 0) {
1125             _packedOwnerships[index] = _packedOwnershipOf(index);
1126         }
1127     }
1128 
1129     /**
1130      * Returns the packed ownership data of `tokenId`.
1131      */
1132     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1133         uint256 curr = tokenId;
1134 
1135         unchecked {
1136             if (_startTokenId() <= curr)
1137                 if (curr < _currentIndex) {
1138                     uint256 packed = _packedOwnerships[curr];
1139                     // If not burned.
1140                     if (packed & _BITMASK_BURNED == 0) {
1141                         // Invariant:
1142                         // There will always be an initialized ownership slot
1143                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1144                         // before an unintialized ownership slot
1145                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1146                         // Hence, `curr` will not underflow.
1147                         //
1148                         // We can directly compare the packed value.
1149                         // If the address is zero, packed will be zero.
1150                         while (packed == 0) {
1151                             packed = _packedOwnerships[--curr];
1152                         }
1153                         return packed;
1154                     }
1155                 }
1156         }
1157         revert OwnerQueryForNonexistentToken();
1158     }
1159 
1160     /**
1161      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1162      */
1163     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1164         ownership.addr = address(uint160(packed));
1165         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1166         ownership.burned = packed & _BITMASK_BURNED != 0;
1167         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1168     }
1169 
1170     /**
1171      * @dev Packs ownership data into a single uint256.
1172      */
1173     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1174         assembly {
1175             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1176             owner := and(owner, _BITMASK_ADDRESS)
1177             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1178             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1184      */
1185     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1186         // For branchless setting of the `nextInitialized` flag.
1187         assembly {
1188             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1189             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1190         }
1191     }
1192 
1193     // =============================================================
1194     //                      APPROVAL OPERATIONS
1195     // =============================================================
1196 
1197     /**
1198      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1199      * The approval is cleared when the token is transferred.
1200      *
1201      * Only a single account can be approved at a time, so approving the
1202      * zero address clears previous approvals.
1203      *
1204      * Requirements:
1205      *
1206      * - The caller must own the token or be an approved operator.
1207      * - `tokenId` must exist.
1208      *
1209      * Emits an {Approval} event.
1210      */
1211     function approve(address to, uint256 tokenId) public virtual override {
1212         address owner = ownerOf(tokenId);
1213 
1214         if (_msgSenderERC721A() != owner)
1215             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1216                 revert ApprovalCallerNotOwnerNorApproved();
1217             }
1218 
1219         _tokenApprovals[tokenId].value = to;
1220         emit Approval(owner, to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Returns the account approved for `tokenId` token.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      */
1230     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1231         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1232 
1233         return _tokenApprovals[tokenId].value;
1234     }
1235 
1236     /**
1237      * @dev Approve or remove `operator` as an operator for the caller.
1238      * Operators can call {transferFrom} or {safeTransferFrom}
1239      * for any token owned by the caller.
1240      *
1241      * Requirements:
1242      *
1243      * - The `operator` cannot be the caller.
1244      *
1245      * Emits an {ApprovalForAll} event.
1246      */
1247     function setApprovalForAll(address operator, bool approved) public virtual override {
1248         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1249 
1250         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1251         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1252     }
1253 
1254     /**
1255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1256      *
1257      * See {setApprovalForAll}.
1258      */
1259     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1260         return _operatorApprovals[owner][operator];
1261     }
1262 
1263     /**
1264      * @dev Returns whether `tokenId` exists.
1265      *
1266      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1267      *
1268      * Tokens start existing when they are minted. See {_mint}.
1269      */
1270     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1271         return
1272             _startTokenId() <= tokenId &&
1273             tokenId < _currentIndex && // If within bounds,
1274             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1275     }
1276 
1277     /**
1278      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1279      */
1280     function _isSenderApprovedOrOwner(
1281         address approvedAddress,
1282         address owner,
1283         address msgSender
1284     ) private pure returns (bool result) {
1285         assembly {
1286             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1287             owner := and(owner, _BITMASK_ADDRESS)
1288             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1289             msgSender := and(msgSender, _BITMASK_ADDRESS)
1290             // `msgSender == owner || msgSender == approvedAddress`.
1291             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1297      */
1298     function _getApprovedSlotAndAddress(uint256 tokenId)
1299         private
1300         view
1301         returns (uint256 approvedAddressSlot, address approvedAddress)
1302     {
1303         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1304         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1305         assembly {
1306             approvedAddressSlot := tokenApproval.slot
1307             approvedAddress := sload(approvedAddressSlot)
1308         }
1309     }
1310 
1311     // =============================================================
1312     //                      TRANSFER OPERATIONS
1313     // =============================================================
1314 
1315     /**
1316      * @dev Transfers `tokenId` from `from` to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `from` cannot be the zero address.
1321      * - `to` cannot be the zero address.
1322      * - `tokenId` token must be owned by `from`.
1323      * - If the caller is not `from`, it must be approved to move this token
1324      * by either {approve} or {setApprovalForAll}.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function transferFrom(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) public virtual override {
1333         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1334 
1335         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1336 
1337         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1338 
1339         // The nested ifs save around 20+ gas over a compound boolean condition.
1340         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1341             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1342 
1343         if (to == address(0)) revert TransferToZeroAddress();
1344 
1345         _beforeTokenTransfers(from, to, tokenId, 1);
1346 
1347         // Clear approvals from the previous owner.
1348         assembly {
1349             if approvedAddress {
1350                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1351                 sstore(approvedAddressSlot, 0)
1352             }
1353         }
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1358         unchecked {
1359             // We can directly increment and decrement the balances.
1360             --_packedAddressData[from]; // Updates: `balance -= 1`.
1361             ++_packedAddressData[to]; // Updates: `balance += 1`.
1362 
1363             // Updates:
1364             // - `address` to the next owner.
1365             // - `startTimestamp` to the timestamp of transfering.
1366             // - `burned` to `false`.
1367             // - `nextInitialized` to `true`.
1368             _packedOwnerships[tokenId] = _packOwnershipData(
1369                 to,
1370                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1371             );
1372 
1373             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1374             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1375                 uint256 nextTokenId = tokenId + 1;
1376                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1377                 if (_packedOwnerships[nextTokenId] == 0) {
1378                     // If the next slot is within bounds.
1379                     if (nextTokenId != _currentIndex) {
1380                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1381                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1382                     }
1383                 }
1384             }
1385         }
1386 
1387         emit Transfer(from, to, tokenId);
1388         _afterTokenTransfers(from, to, tokenId, 1);
1389     }
1390 
1391     /**
1392      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1393      */
1394     function safeTransferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) public virtual override {
1399         safeTransferFrom(from, to, tokenId, '');
1400     }
1401 
1402     /**
1403      * @dev Safely transfers `tokenId` token from `from` to `to`.
1404      *
1405      * Requirements:
1406      *
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      * - `tokenId` token must exist and be owned by `from`.
1410      * - If the caller is not `from`, it must be approved to move this token
1411      * by either {approve} or {setApprovalForAll}.
1412      * - If `to` refers to a smart contract, it must implement
1413      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function safeTransferFrom(
1418         address from,
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) public virtual override {
1423         transferFrom(from, to, tokenId);
1424         if (to.code.length != 0)
1425             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1426                 revert TransferToNonERC721ReceiverImplementer();
1427             }
1428     }
1429 
1430     /**
1431      * @dev Hook that is called before a set of serially-ordered token IDs
1432      * are about to be transferred. This includes minting.
1433      * And also called before burning one token.
1434      *
1435      * `startTokenId` - the first token ID to be transferred.
1436      * `quantity` - the amount to be transferred.
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` will be minted for `to`.
1443      * - When `to` is zero, `tokenId` will be burned by `from`.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _beforeTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 
1453     /**
1454      * @dev Hook that is called after a set of serially-ordered token IDs
1455      * have been transferred. This includes minting.
1456      * And also called after one token has been burned.
1457      *
1458      * `startTokenId` - the first token ID to be transferred.
1459      * `quantity` - the amount to be transferred.
1460      *
1461      * Calling conditions:
1462      *
1463      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1464      * transferred to `to`.
1465      * - When `from` is zero, `tokenId` has been minted for `to`.
1466      * - When `to` is zero, `tokenId` has been burned by `from`.
1467      * - `from` and `to` are never both zero.
1468      */
1469     function _afterTokenTransfers(
1470         address from,
1471         address to,
1472         uint256 startTokenId,
1473         uint256 quantity
1474     ) internal virtual {}
1475 
1476     /**
1477      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1478      *
1479      * `from` - Previous owner of the given token ID.
1480      * `to` - Target address that will receive the token.
1481      * `tokenId` - Token ID to be transferred.
1482      * `_data` - Optional data to send along with the call.
1483      *
1484      * Returns whether the call correctly returned the expected magic value.
1485      */
1486     function _checkContractOnERC721Received(
1487         address from,
1488         address to,
1489         uint256 tokenId,
1490         bytes memory _data
1491     ) private returns (bool) {
1492         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1493             bytes4 retval
1494         ) {
1495             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1496         } catch (bytes memory reason) {
1497             if (reason.length == 0) {
1498                 revert TransferToNonERC721ReceiverImplementer();
1499             } else {
1500                 assembly {
1501                     revert(add(32, reason), mload(reason))
1502                 }
1503             }
1504         }
1505     }
1506 
1507     // =============================================================
1508     //                        MINT OPERATIONS
1509     // =============================================================
1510 
1511     /**
1512      * @dev Mints `quantity` tokens and transfers them to `to`.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      * - `quantity` must be greater than 0.
1518      *
1519      * Emits a {Transfer} event for each mint.
1520      */
1521     function _mint(address to, uint256 quantity) internal virtual {
1522         uint256 startTokenId = _currentIndex;
1523         if (quantity == 0) revert MintZeroQuantity();
1524 
1525         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1526 
1527         // Overflows are incredibly unrealistic.
1528         // `balance` and `numberMinted` have a maximum limit of 2**64.
1529         // `tokenId` has a maximum limit of 2**256.
1530         unchecked {
1531             // Updates:
1532             // - `balance += quantity`.
1533             // - `numberMinted += quantity`.
1534             //
1535             // We can directly add to the `balance` and `numberMinted`.
1536             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1537 
1538             // Updates:
1539             // - `address` to the owner.
1540             // - `startTimestamp` to the timestamp of minting.
1541             // - `burned` to `false`.
1542             // - `nextInitialized` to `quantity == 1`.
1543             _packedOwnerships[startTokenId] = _packOwnershipData(
1544                 to,
1545                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1546             );
1547 
1548             uint256 toMasked;
1549             uint256 end = startTokenId + quantity;
1550 
1551             // Use assembly to loop and emit the `Transfer` event for gas savings.
1552             assembly {
1553                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1554                 toMasked := and(to, _BITMASK_ADDRESS)
1555                 // Emit the `Transfer` event.
1556                 log4(
1557                     0, // Start of data (0, since no data).
1558                     0, // End of data (0, since no data).
1559                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1560                     0, // `address(0)`.
1561                     toMasked, // `to`.
1562                     startTokenId // `tokenId`.
1563                 )
1564 
1565                 for {
1566                     let tokenId := add(startTokenId, 1)
1567                 } iszero(eq(tokenId, end)) {
1568                     tokenId := add(tokenId, 1)
1569                 } {
1570                     // Emit the `Transfer` event. Similar to above.
1571                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1572                 }
1573             }
1574             if (toMasked == 0) revert MintToZeroAddress();
1575 
1576             _currentIndex = end;
1577         }
1578         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1579     }
1580 
1581     /**
1582      * @dev Mints `quantity` tokens and transfers them to `to`.
1583      *
1584      * This function is intended for efficient minting only during contract creation.
1585      *
1586      * It emits only one {ConsecutiveTransfer} as defined in
1587      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1588      * instead of a sequence of {Transfer} event(s).
1589      *
1590      * Calling this function outside of contract creation WILL make your contract
1591      * non-compliant with the ERC721 standard.
1592      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1593      * {ConsecutiveTransfer} event is only permissible during contract creation.
1594      *
1595      * Requirements:
1596      *
1597      * - `to` cannot be the zero address.
1598      * - `quantity` must be greater than 0.
1599      *
1600      * Emits a {ConsecutiveTransfer} event.
1601      */
1602     function _mintERC2309(address to, uint256 quantity) internal virtual {
1603         uint256 startTokenId = _currentIndex;
1604         if (to == address(0)) revert MintToZeroAddress();
1605         if (quantity == 0) revert MintZeroQuantity();
1606         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1607 
1608         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1609 
1610         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1611         unchecked {
1612             // Updates:
1613             // - `balance += quantity`.
1614             // - `numberMinted += quantity`.
1615             //
1616             // We can directly add to the `balance` and `numberMinted`.
1617             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1618 
1619             // Updates:
1620             // - `address` to the owner.
1621             // - `startTimestamp` to the timestamp of minting.
1622             // - `burned` to `false`.
1623             // - `nextInitialized` to `quantity == 1`.
1624             _packedOwnerships[startTokenId] = _packOwnershipData(
1625                 to,
1626                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1627             );
1628 
1629             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1630 
1631             _currentIndex = startTokenId + quantity;
1632         }
1633         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1634     }
1635 
1636     /**
1637      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1638      *
1639      * Requirements:
1640      *
1641      * - If `to` refers to a smart contract, it must implement
1642      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1643      * - `quantity` must be greater than 0.
1644      *
1645      * See {_mint}.
1646      *
1647      * Emits a {Transfer} event for each mint.
1648      */
1649     function _safeMint(
1650         address to,
1651         uint256 quantity,
1652         bytes memory _data
1653     ) internal virtual {
1654         _mint(to, quantity);
1655 
1656         unchecked {
1657             if (to.code.length != 0) {
1658                 uint256 end = _currentIndex;
1659                 uint256 index = end - quantity;
1660                 do {
1661                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1662                         revert TransferToNonERC721ReceiverImplementer();
1663                     }
1664                 } while (index < end);
1665                 // Reentrancy protection.
1666                 if (_currentIndex != end) revert();
1667             }
1668         }
1669     }
1670 
1671     /**
1672      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1673      */
1674     function _safeMint(address to, uint256 quantity) internal virtual {
1675         _safeMint(to, quantity, '');
1676     }
1677 
1678     // =============================================================
1679     //                        BURN OPERATIONS
1680     // =============================================================
1681 
1682     /**
1683      * @dev Equivalent to `_burn(tokenId, false)`.
1684      */
1685     function _burn(uint256 tokenId) internal virtual {
1686         _burn(tokenId, false);
1687     }
1688 
1689     /**
1690      * @dev Destroys `tokenId`.
1691      * The approval is cleared when the token is burned.
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must exist.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1700         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1701 
1702         address from = address(uint160(prevOwnershipPacked));
1703 
1704         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1705 
1706         if (approvalCheck) {
1707             // The nested ifs save around 20+ gas over a compound boolean condition.
1708             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1709                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1710         }
1711 
1712         _beforeTokenTransfers(from, address(0), tokenId, 1);
1713 
1714         // Clear approvals from the previous owner.
1715         assembly {
1716             if approvedAddress {
1717                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1718                 sstore(approvedAddressSlot, 0)
1719             }
1720         }
1721 
1722         // Underflow of the sender's balance is impossible because we check for
1723         // ownership above and the recipient's balance can't realistically overflow.
1724         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1725         unchecked {
1726             // Updates:
1727             // - `balance -= 1`.
1728             // - `numberBurned += 1`.
1729             //
1730             // We can directly decrement the balance, and increment the number burned.
1731             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1732             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1733 
1734             // Updates:
1735             // - `address` to the last owner.
1736             // - `startTimestamp` to the timestamp of burning.
1737             // - `burned` to `true`.
1738             // - `nextInitialized` to `true`.
1739             _packedOwnerships[tokenId] = _packOwnershipData(
1740                 from,
1741                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1742             );
1743 
1744             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1745             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1746                 uint256 nextTokenId = tokenId + 1;
1747                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1748                 if (_packedOwnerships[nextTokenId] == 0) {
1749                     // If the next slot is within bounds.
1750                     if (nextTokenId != _currentIndex) {
1751                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1752                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1753                     }
1754                 }
1755             }
1756         }
1757 
1758         emit Transfer(from, address(0), tokenId);
1759         _afterTokenTransfers(from, address(0), tokenId, 1);
1760 
1761         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1762         unchecked {
1763             _burnCounter++;
1764         }
1765     }
1766 
1767     // =============================================================
1768     //                     EXTRA DATA OPERATIONS
1769     // =============================================================
1770 
1771     /**
1772      * @dev Directly sets the extra data for the ownership data `index`.
1773      */
1774     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1775         uint256 packed = _packedOwnerships[index];
1776         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1777         uint256 extraDataCasted;
1778         // Cast `extraData` with assembly to avoid redundant masking.
1779         assembly {
1780             extraDataCasted := extraData
1781         }
1782         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1783         _packedOwnerships[index] = packed;
1784     }
1785 
1786     /**
1787      * @dev Called during each token transfer to set the 24bit `extraData` field.
1788      * Intended to be overridden by the cosumer contract.
1789      *
1790      * `previousExtraData` - the value of `extraData` before transfer.
1791      *
1792      * Calling conditions:
1793      *
1794      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1795      * transferred to `to`.
1796      * - When `from` is zero, `tokenId` will be minted for `to`.
1797      * - When `to` is zero, `tokenId` will be burned by `from`.
1798      * - `from` and `to` are never both zero.
1799      */
1800     function _extraData(
1801         address from,
1802         address to,
1803         uint24 previousExtraData
1804     ) internal view virtual returns (uint24) {}
1805 
1806     /**
1807      * @dev Returns the next extra data for the packed ownership data.
1808      * The returned result is shifted into position.
1809      */
1810     function _nextExtraData(
1811         address from,
1812         address to,
1813         uint256 prevOwnershipPacked
1814     ) private view returns (uint256) {
1815         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1816         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1817     }
1818 
1819     // =============================================================
1820     //                       OTHER OPERATIONS
1821     // =============================================================
1822 
1823     /**
1824      * @dev Returns the message sender (defaults to `msg.sender`).
1825      *
1826      * If you are writing GSN compatible contracts, you need to override this function.
1827      */
1828     function _msgSenderERC721A() internal view virtual returns (address) {
1829         return msg.sender;
1830     }
1831 
1832     /**
1833      * @dev Converts a uint256 to its ASCII string decimal representation.
1834      */
1835     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1836         assembly {
1837             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1838             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1839             // We will need 1 32-byte word to store the length,
1840             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1841             str := add(mload(0x40), 0x80)
1842             // Update the free memory pointer to allocate.
1843             mstore(0x40, str)
1844 
1845             // Cache the end of the memory to calculate the length later.
1846             let end := str
1847 
1848             // We write the string from rightmost digit to leftmost digit.
1849             // The following is essentially a do-while loop that also handles the zero case.
1850             // prettier-ignore
1851             for { let temp := value } 1 {} {
1852                 str := sub(str, 1)
1853                 // Write the character to the pointer.
1854                 // The ASCII index of the '0' character is 48.
1855                 mstore8(str, add(48, mod(temp, 10)))
1856                 // Keep dividing `temp` until zero.
1857                 temp := div(temp, 10)
1858                 // prettier-ignore
1859                 if iszero(temp) { break }
1860             }
1861 
1862             let length := sub(end, str)
1863             // Move the pointer 32 bytes leftwards to make room for the length.
1864             str := sub(str, 0x20)
1865             // Store the length.
1866             mstore(str, length)
1867         }
1868     }
1869 }
1870 
1871 // File: hardhat/console.sol
1872 
1873 
1874 pragma solidity >= 0.4.22 <0.9.0;
1875 
1876 library console {
1877 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1878 
1879 	function _sendLogPayload(bytes memory payload) private view {
1880 		uint256 payloadLength = payload.length;
1881 		address consoleAddress = CONSOLE_ADDRESS;
1882 		assembly {
1883 			let payloadStart := add(payload, 32)
1884 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1885 		}
1886 	}
1887 
1888 	function log() internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log()"));
1890 	}
1891 
1892 	function logInt(int256 p0) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
1894 	}
1895 
1896 	function logUint(uint256 p0) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
1898 	}
1899 
1900 	function logString(string memory p0) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1902 	}
1903 
1904 	function logBool(bool p0) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1906 	}
1907 
1908 	function logAddress(address p0) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1910 	}
1911 
1912 	function logBytes(bytes memory p0) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1914 	}
1915 
1916 	function logBytes1(bytes1 p0) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1918 	}
1919 
1920 	function logBytes2(bytes2 p0) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1922 	}
1923 
1924 	function logBytes3(bytes3 p0) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1926 	}
1927 
1928 	function logBytes4(bytes4 p0) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1930 	}
1931 
1932 	function logBytes5(bytes5 p0) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1934 	}
1935 
1936 	function logBytes6(bytes6 p0) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1938 	}
1939 
1940 	function logBytes7(bytes7 p0) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1942 	}
1943 
1944 	function logBytes8(bytes8 p0) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1946 	}
1947 
1948 	function logBytes9(bytes9 p0) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1950 	}
1951 
1952 	function logBytes10(bytes10 p0) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1954 	}
1955 
1956 	function logBytes11(bytes11 p0) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1958 	}
1959 
1960 	function logBytes12(bytes12 p0) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1962 	}
1963 
1964 	function logBytes13(bytes13 p0) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1966 	}
1967 
1968 	function logBytes14(bytes14 p0) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1970 	}
1971 
1972 	function logBytes15(bytes15 p0) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1974 	}
1975 
1976 	function logBytes16(bytes16 p0) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1978 	}
1979 
1980 	function logBytes17(bytes17 p0) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1982 	}
1983 
1984 	function logBytes18(bytes18 p0) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1986 	}
1987 
1988 	function logBytes19(bytes19 p0) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1990 	}
1991 
1992 	function logBytes20(bytes20 p0) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1994 	}
1995 
1996 	function logBytes21(bytes21 p0) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1998 	}
1999 
2000 	function logBytes22(bytes22 p0) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
2002 	}
2003 
2004 	function logBytes23(bytes23 p0) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
2006 	}
2007 
2008 	function logBytes24(bytes24 p0) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
2010 	}
2011 
2012 	function logBytes25(bytes25 p0) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
2014 	}
2015 
2016 	function logBytes26(bytes26 p0) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
2018 	}
2019 
2020 	function logBytes27(bytes27 p0) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
2022 	}
2023 
2024 	function logBytes28(bytes28 p0) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
2026 	}
2027 
2028 	function logBytes29(bytes29 p0) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
2030 	}
2031 
2032 	function logBytes30(bytes30 p0) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
2034 	}
2035 
2036 	function logBytes31(bytes31 p0) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
2038 	}
2039 
2040 	function logBytes32(bytes32 p0) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2042 	}
2043 
2044 	function log(uint256 p0) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
2046 	}
2047 
2048 	function log(string memory p0) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2050 	}
2051 
2052 	function log(bool p0) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2054 	}
2055 
2056 	function log(address p0) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2058 	}
2059 
2060 	function log(uint256 p0, uint256 p1) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
2062 	}
2063 
2064 	function log(uint256 p0, string memory p1) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
2066 	}
2067 
2068 	function log(uint256 p0, bool p1) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
2070 	}
2071 
2072 	function log(uint256 p0, address p1) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
2074 	}
2075 
2076 	function log(string memory p0, uint256 p1) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
2078 	}
2079 
2080 	function log(string memory p0, string memory p1) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2082 	}
2083 
2084 	function log(string memory p0, bool p1) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2086 	}
2087 
2088 	function log(string memory p0, address p1) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2090 	}
2091 
2092 	function log(bool p0, uint256 p1) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
2094 	}
2095 
2096 	function log(bool p0, string memory p1) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2098 	}
2099 
2100 	function log(bool p0, bool p1) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2102 	}
2103 
2104 	function log(bool p0, address p1) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2106 	}
2107 
2108 	function log(address p0, uint256 p1) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
2110 	}
2111 
2112 	function log(address p0, string memory p1) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2114 	}
2115 
2116 	function log(address p0, bool p1) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2118 	}
2119 
2120 	function log(address p0, address p1) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2122 	}
2123 
2124 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
2126 	}
2127 
2128 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
2130 	}
2131 
2132 	function log(uint256 p0, uint256 p1, bool p2) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
2134 	}
2135 
2136 	function log(uint256 p0, uint256 p1, address p2) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
2138 	}
2139 
2140 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
2142 	}
2143 
2144 	function log(uint256 p0, string memory p1, string memory p2) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
2146 	}
2147 
2148 	function log(uint256 p0, string memory p1, bool p2) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
2150 	}
2151 
2152 	function log(uint256 p0, string memory p1, address p2) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
2154 	}
2155 
2156 	function log(uint256 p0, bool p1, uint256 p2) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
2158 	}
2159 
2160 	function log(uint256 p0, bool p1, string memory p2) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
2162 	}
2163 
2164 	function log(uint256 p0, bool p1, bool p2) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
2166 	}
2167 
2168 	function log(uint256 p0, bool p1, address p2) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
2170 	}
2171 
2172 	function log(uint256 p0, address p1, uint256 p2) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
2174 	}
2175 
2176 	function log(uint256 p0, address p1, string memory p2) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
2178 	}
2179 
2180 	function log(uint256 p0, address p1, bool p2) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
2182 	}
2183 
2184 	function log(uint256 p0, address p1, address p2) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
2186 	}
2187 
2188 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
2190 	}
2191 
2192 	function log(string memory p0, uint256 p1, string memory p2) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
2194 	}
2195 
2196 	function log(string memory p0, uint256 p1, bool p2) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
2198 	}
2199 
2200 	function log(string memory p0, uint256 p1, address p2) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
2202 	}
2203 
2204 	function log(string memory p0, string memory p1, uint256 p2) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
2206 	}
2207 
2208 	function log(string memory p0, string memory p1, string memory p2) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2210 	}
2211 
2212 	function log(string memory p0, string memory p1, bool p2) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2214 	}
2215 
2216 	function log(string memory p0, string memory p1, address p2) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2218 	}
2219 
2220 	function log(string memory p0, bool p1, uint256 p2) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
2222 	}
2223 
2224 	function log(string memory p0, bool p1, string memory p2) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2226 	}
2227 
2228 	function log(string memory p0, bool p1, bool p2) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2230 	}
2231 
2232 	function log(string memory p0, bool p1, address p2) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2234 	}
2235 
2236 	function log(string memory p0, address p1, uint256 p2) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
2238 	}
2239 
2240 	function log(string memory p0, address p1, string memory p2) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2242 	}
2243 
2244 	function log(string memory p0, address p1, bool p2) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2246 	}
2247 
2248 	function log(string memory p0, address p1, address p2) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2250 	}
2251 
2252 	function log(bool p0, uint256 p1, uint256 p2) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
2254 	}
2255 
2256 	function log(bool p0, uint256 p1, string memory p2) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
2258 	}
2259 
2260 	function log(bool p0, uint256 p1, bool p2) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
2262 	}
2263 
2264 	function log(bool p0, uint256 p1, address p2) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
2266 	}
2267 
2268 	function log(bool p0, string memory p1, uint256 p2) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
2270 	}
2271 
2272 	function log(bool p0, string memory p1, string memory p2) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2274 	}
2275 
2276 	function log(bool p0, string memory p1, bool p2) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2278 	}
2279 
2280 	function log(bool p0, string memory p1, address p2) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2282 	}
2283 
2284 	function log(bool p0, bool p1, uint256 p2) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
2286 	}
2287 
2288 	function log(bool p0, bool p1, string memory p2) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2290 	}
2291 
2292 	function log(bool p0, bool p1, bool p2) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2294 	}
2295 
2296 	function log(bool p0, bool p1, address p2) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2298 	}
2299 
2300 	function log(bool p0, address p1, uint256 p2) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
2302 	}
2303 
2304 	function log(bool p0, address p1, string memory p2) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2306 	}
2307 
2308 	function log(bool p0, address p1, bool p2) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2310 	}
2311 
2312 	function log(bool p0, address p1, address p2) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2314 	}
2315 
2316 	function log(address p0, uint256 p1, uint256 p2) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
2318 	}
2319 
2320 	function log(address p0, uint256 p1, string memory p2) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
2322 	}
2323 
2324 	function log(address p0, uint256 p1, bool p2) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
2326 	}
2327 
2328 	function log(address p0, uint256 p1, address p2) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
2330 	}
2331 
2332 	function log(address p0, string memory p1, uint256 p2) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
2334 	}
2335 
2336 	function log(address p0, string memory p1, string memory p2) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2338 	}
2339 
2340 	function log(address p0, string memory p1, bool p2) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2342 	}
2343 
2344 	function log(address p0, string memory p1, address p2) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2346 	}
2347 
2348 	function log(address p0, bool p1, uint256 p2) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
2350 	}
2351 
2352 	function log(address p0, bool p1, string memory p2) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2354 	}
2355 
2356 	function log(address p0, bool p1, bool p2) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2358 	}
2359 
2360 	function log(address p0, bool p1, address p2) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2362 	}
2363 
2364 	function log(address p0, address p1, uint256 p2) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
2366 	}
2367 
2368 	function log(address p0, address p1, string memory p2) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2370 	}
2371 
2372 	function log(address p0, address p1, bool p2) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2374 	}
2375 
2376 	function log(address p0, address p1, address p2) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2378 	}
2379 
2380 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(uint256 p0, address p1, address p2, address p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2870 	}
2871 
2872 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2873 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2874 	}
2875 
2876 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
2877 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
2878 	}
2879 
2880 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2881 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2882 	}
2883 
2884 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2885 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2886 	}
2887 
2888 	function log(string memory p0, address p1, address p2, address p3) internal view {
2889 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2890 	}
2891 
2892 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2893 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
2894 	}
2895 
2896 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
2897 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
2898 	}
2899 
2900 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
2901 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
2902 	}
2903 
2904 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
2905 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
2906 	}
2907 
2908 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
2909 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
2910 	}
2911 
2912 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
2913 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
2914 	}
2915 
2916 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
2917 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
2918 	}
2919 
2920 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
2921 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
2922 	}
2923 
2924 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
2925 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
2926 	}
2927 
2928 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
2929 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
2930 	}
2931 
2932 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
2933 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
2934 	}
2935 
2936 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
2937 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
2938 	}
2939 
2940 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
2941 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
2942 	}
2943 
2944 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
2945 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
2946 	}
2947 
2948 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
2949 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
2950 	}
2951 
2952 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
2953 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
2954 	}
2955 
2956 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
2957 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
2958 	}
2959 
2960 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
2961 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
2962 	}
2963 
2964 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
2965 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
2966 	}
2967 
2968 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
2969 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
2970 	}
2971 
2972 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
2973 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
2974 	}
2975 
2976 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2977 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2978 	}
2979 
2980 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2981 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2982 	}
2983 
2984 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2985 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2986 	}
2987 
2988 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
2989 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
2990 	}
2991 
2992 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2993 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2994 	}
2995 
2996 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2997 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2998 	}
2999 
3000 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
3001 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
3002 	}
3003 
3004 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
3005 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
3006 	}
3007 
3008 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
3009 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
3010 	}
3011 
3012 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
3013 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
3014 	}
3015 
3016 	function log(bool p0, string memory p1, address p2, address p3) internal view {
3017 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
3018 	}
3019 
3020 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
3021 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
3022 	}
3023 
3024 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
3025 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
3026 	}
3027 
3028 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
3029 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
3030 	}
3031 
3032 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
3033 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
3034 	}
3035 
3036 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
3037 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
3038 	}
3039 
3040 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
3041 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
3042 	}
3043 
3044 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
3045 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
3046 	}
3047 
3048 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
3049 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
3050 	}
3051 
3052 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
3053 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
3054 	}
3055 
3056 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
3057 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
3058 	}
3059 
3060 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
3061 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
3062 	}
3063 
3064 	function log(bool p0, bool p1, bool p2, address p3) internal view {
3065 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
3066 	}
3067 
3068 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
3069 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
3070 	}
3071 
3072 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
3073 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3074 	}
3075 
3076 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3077 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3078 	}
3079 
3080 	function log(bool p0, bool p1, address p2, address p3) internal view {
3081 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3082 	}
3083 
3084 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
3085 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
3086 	}
3087 
3088 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
3089 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
3090 	}
3091 
3092 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
3093 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
3094 	}
3095 
3096 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
3097 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
3098 	}
3099 
3100 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
3101 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
3102 	}
3103 
3104 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3105 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3106 	}
3107 
3108 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3109 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3110 	}
3111 
3112 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3113 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3114 	}
3115 
3116 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
3117 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
3118 	}
3119 
3120 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3121 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3122 	}
3123 
3124 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3125 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3126 	}
3127 
3128 	function log(bool p0, address p1, bool p2, address p3) internal view {
3129 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3130 	}
3131 
3132 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
3133 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
3134 	}
3135 
3136 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3137 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3138 	}
3139 
3140 	function log(bool p0, address p1, address p2, bool p3) internal view {
3141 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3142 	}
3143 
3144 	function log(bool p0, address p1, address p2, address p3) internal view {
3145 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3146 	}
3147 
3148 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
3149 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
3150 	}
3151 
3152 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
3153 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
3154 	}
3155 
3156 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
3157 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
3158 	}
3159 
3160 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
3161 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
3162 	}
3163 
3164 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
3165 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
3166 	}
3167 
3168 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
3169 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
3170 	}
3171 
3172 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
3173 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
3174 	}
3175 
3176 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
3177 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
3178 	}
3179 
3180 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
3181 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
3182 	}
3183 
3184 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
3185 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
3186 	}
3187 
3188 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
3189 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
3190 	}
3191 
3192 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
3193 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
3194 	}
3195 
3196 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
3197 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
3198 	}
3199 
3200 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
3201 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
3202 	}
3203 
3204 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
3205 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
3206 	}
3207 
3208 	function log(address p0, uint256 p1, address p2, address p3) internal view {
3209 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
3210 	}
3211 
3212 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
3213 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
3214 	}
3215 
3216 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
3217 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
3218 	}
3219 
3220 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
3221 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
3222 	}
3223 
3224 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
3225 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
3226 	}
3227 
3228 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
3229 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
3230 	}
3231 
3232 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3233 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3234 	}
3235 
3236 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3237 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3238 	}
3239 
3240 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3241 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3242 	}
3243 
3244 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
3245 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
3246 	}
3247 
3248 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3249 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3250 	}
3251 
3252 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3253 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3254 	}
3255 
3256 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3257 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3258 	}
3259 
3260 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
3261 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
3262 	}
3263 
3264 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3265 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3266 	}
3267 
3268 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3269 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3270 	}
3271 
3272 	function log(address p0, string memory p1, address p2, address p3) internal view {
3273 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3274 	}
3275 
3276 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
3277 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
3278 	}
3279 
3280 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
3281 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
3282 	}
3283 
3284 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
3285 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
3286 	}
3287 
3288 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
3289 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
3290 	}
3291 
3292 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
3293 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
3294 	}
3295 
3296 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3297 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3298 	}
3299 
3300 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3301 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3302 	}
3303 
3304 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3305 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3306 	}
3307 
3308 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
3309 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
3310 	}
3311 
3312 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3313 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3314 	}
3315 
3316 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3317 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3318 	}
3319 
3320 	function log(address p0, bool p1, bool p2, address p3) internal view {
3321 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3322 	}
3323 
3324 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
3325 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
3326 	}
3327 
3328 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3329 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3330 	}
3331 
3332 	function log(address p0, bool p1, address p2, bool p3) internal view {
3333 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3334 	}
3335 
3336 	function log(address p0, bool p1, address p2, address p3) internal view {
3337 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3338 	}
3339 
3340 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
3341 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
3342 	}
3343 
3344 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
3345 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
3346 	}
3347 
3348 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
3349 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
3350 	}
3351 
3352 	function log(address p0, address p1, uint256 p2, address p3) internal view {
3353 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
3354 	}
3355 
3356 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
3357 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
3358 	}
3359 
3360 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3361 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3362 	}
3363 
3364 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3365 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3366 	}
3367 
3368 	function log(address p0, address p1, string memory p2, address p3) internal view {
3369 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3370 	}
3371 
3372 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
3373 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
3374 	}
3375 
3376 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3377 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3378 	}
3379 
3380 	function log(address p0, address p1, bool p2, bool p3) internal view {
3381 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3382 	}
3383 
3384 	function log(address p0, address p1, bool p2, address p3) internal view {
3385 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3386 	}
3387 
3388 	function log(address p0, address p1, address p2, uint256 p3) internal view {
3389 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
3390 	}
3391 
3392 	function log(address p0, address p1, address p2, string memory p3) internal view {
3393 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3394 	}
3395 
3396 	function log(address p0, address p1, address p2, bool p3) internal view {
3397 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3398 	}
3399 
3400 	function log(address p0, address p1, address p2, address p3) internal view {
3401 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3402 	}
3403 
3404 }
3405 
3406 // File: contracts/nrefiletest.sol
3407 
3408 //SPDX-License-Identifier: Unlicense
3409 
3410 pragma solidity ^0.8.4;
3411 
3412 
3413 
3414 
3415 
3416 
3417 
3418 contract CoolcatsAi is ERC721A, Ownable, ReentrancyGuard {
3419     using Address for address;
3420     using Strings for uint;
3421 
3422     string  public baseTokenURI = "ipfs://bafybeidku3jt2xx7wmgqfa2b4glkb77d7nclts756ecldri5s7oifmd3ku";
3423     uint256 public MAX_SUPPLY = 500;
3424     uint256 public MAX_FREE_SUPPLY = 0;
3425     uint256 public MAX_PER_TX = 10;
3426     uint256 public PRICE = 0.003 ether;
3427     uint256 public MAX_FREE_PER_WALLET = 1;
3428     uint256 public maxFreePerTx = 1;
3429     bool public initialize = true;
3430     bool public revealed = true;
3431 
3432     mapping(address => uint256) public qtyFreeMinted;
3433 
3434     constructor() ERC721A("CoolcatsAi", "CCA") {}
3435 
3436     function PublicMint(uint256 amount) external payable
3437     {
3438         uint256 cost = PRICE;
3439         uint256 num = amount > 0 ? amount : 1;
3440         bool free = ((totalSupply() + num < MAX_FREE_SUPPLY + 1) &&
3441             (qtyFreeMinted[msg.sender] + num <= MAX_FREE_PER_WALLET));
3442         if (free) {
3443             cost = 0;
3444             qtyFreeMinted[msg.sender] += num;
3445             require(num < maxFreePerTx + 1, "Max per TX reached.");
3446         } else {
3447             require(num < MAX_PER_TX + 1, "Max per TX reached.");
3448         }
3449 
3450         require(initialize, "Minting is not live yet.");
3451         require(msg.value >= num * cost, "Please send the exact amount.");
3452         require(totalSupply() + num < MAX_SUPPLY + 1, "No more");
3453 
3454         _safeMint(msg.sender, num);
3455     }
3456 
3457     function setBaseURI(string memory baseURI) public onlyOwner
3458     {
3459         baseTokenURI = baseURI;
3460     }
3461 
3462     function withdraw() public onlyOwner nonReentrant
3463     {
3464         Address.sendValue(payable(msg.sender), address(this).balance);
3465     }
3466 
3467     function tokenURI(uint _tokenId) public view virtual override returns (string memory)
3468     {
3469         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3470 
3471         return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
3472     }
3473 
3474     function _baseURI() internal view virtual override returns (string memory)
3475     {
3476         return baseTokenURI;
3477     }
3478 
3479     function reveal(bool _revealed) external onlyOwner
3480     {
3481         revealed = _revealed;
3482     }
3483 
3484     function setInitialize(bool _initialize) external onlyOwner
3485     {
3486         initialize = _initialize;
3487     }
3488 
3489     function setPrice(uint256 _price) external onlyOwner
3490     {
3491         PRICE = _price;
3492     }
3493 
3494     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
3495     {
3496         MAX_PER_TX = _limit;
3497     }
3498 
3499     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
3500     {
3501         MAX_FREE_PER_WALLET = _limit;
3502     }
3503 
3504     function setMaxFreeAmount(uint256 _amount) external onlyOwner
3505     {
3506         MAX_FREE_SUPPLY = _amount;
3507     }
3508 }