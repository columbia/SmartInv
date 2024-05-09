1 //  sdSS_SSSSSSbs   .S    S.     sSSs         .S_SSSs      sSSs   .S   .S_SSSs     .S_sSSs      sSSs  
2 //  YSSS~S%SSSSSP  .SS    SS.   d%%SP        .SS~SSSSS    d%%SP  .SS  .SS~SSSSS   .SS~YS%%b    d%%SP  
3 //       S%S       S%S    S%S  d%S'          S%S   SSSS  d%S'    S%S  S%S   SSSS  S%S   `S%b  d%S'    
4 //       S%S       S%S    S%S  S%S           S%S    S%S  S%|     S%S  S%S    S%S  S%S    S%S  S%|     
5 //       S&S       S%S SSSS%S  S&S           S%S SSSS%S  S&S     S&S  S%S SSSS%S  S%S    S&S  S&S     
6 //       S&S       S&S  SSS&S  S&S_Ss        S&S  SSS%S  Y&Ss    S&S  S&S  SSS%S  S&S    S&S  Y&Ss    
7 //       S&S       S&S    S&S  S&S~SP        S&S    S&S  `S&&S   S&S  S&S    S&S  S&S    S&S  `S&&S   
8 //       S&S       S&S    S&S  S&S           S&S    S&S    `S*S  S&S  S&S    S&S  S&S    S&S    `S*S  
9 //       S*S       S*S    S*S  S*b           S*S    S&S     l*S  S*S  S*S    S&S  S*S    S*S     l*S  
10 //       S*S       S*S    S*S  S*S.          S*S    S*S    .S*P  S*S  S*S    S*S  S*S    S*S    .S*P  
11 //       S*S       S*S    S*S   SSSbs        S*S    S*S  sSS*S   S*S  S*S    S*S  S*S    S*S  sSS*S   
12 //       S*S       SSS    S*S    YSSP        SSS    S*S  YSS'    S*S  SSS    S*S  S*S    SSS  YSS'    
13 //       SP               SP                        SP           SP          SP   SP                  
14 //       Y                Y                         Y            Y           Y    Y                   
15 //                                                 
16 
17 
18 
19 // SPDX-License-Identifier: MIT
20 
21 // File: @openzeppelin/contracts/utils/Strings.sol
22 
23 
24 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33     uint8 private constant _ADDRESS_LENGTH = 20;
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
93      */
94     function toHexString(address addr) internal pure returns (string memory) {
95         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Address.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
103 
104 pragma solidity ^0.8.1;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      *
127      * [IMPORTANT]
128      * ====
129      * You shouldn't rely on `isContract` to protect against flash loan attacks!
130      *
131      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
132      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
133      * constructor.
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140 
141         return account.code.length > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312                 /// @solidity memory-safe-assembly
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Contract module that helps prevent reentrant calls to a function.
333  *
334  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
335  * available, which can be applied to functions to make sure there are no nested
336  * (reentrant) calls to them.
337  *
338  * Note that because there is a single `nonReentrant` guard, functions marked as
339  * `nonReentrant` may not call one another. This can be worked around by making
340  * those functions `private`, and then adding `external` `nonReentrant` entry
341  * points to them.
342  *
343  * TIP: If you would like to learn more about reentrancy and alternative ways
344  * to protect against it, check out our blog post
345  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
346  */
347 abstract contract ReentrancyGuard {
348     // Booleans are more expensive than uint256 or any type that takes up a full
349     // word because each write operation emits an extra SLOAD to first read the
350     // slot's contents, replace the bits taken up by the boolean, and then write
351     // back. This is the compiler's defense against contract upgrades and
352     // pointer aliasing, and it cannot be disabled.
353 
354     // The values being non-zero value makes deployment a bit more expensive,
355     // but in exchange the refund on every call to nonReentrant will be lower in
356     // amount. Since refunds are capped to a percentage of the total
357     // transaction's gas, it is best to keep them low in cases like this one, to
358     // increase the likelihood of the full refund coming into effect.
359     uint256 private constant _NOT_ENTERED = 1;
360     uint256 private constant _ENTERED = 2;
361 
362     uint256 private _status;
363 
364     constructor() {
365         _status = _NOT_ENTERED;
366     }
367 
368     /**
369      * @dev Prevents a contract from calling itself, directly or indirectly.
370      * Calling a `nonReentrant` function from another `nonReentrant`
371      * function is not supported. It is possible to prevent this from happening
372      * by making the `nonReentrant` function external, and making it call a
373      * `private` function that does the actual work.
374      */
375     modifier nonReentrant() {
376         // On the first call to nonReentrant, _notEntered will be true
377         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
378 
379         // Any calls to nonReentrant after this point will fail
380         _status = _ENTERED;
381 
382         _;
383 
384         // By storing the original value once again, a refund is triggered (see
385         // https://eips.ethereum.org/EIPS/eip-2200)
386         _status = _NOT_ENTERED;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Context.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes calldata) {
413         return msg.data;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/access/Ownable.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Contract module which provides a basic access control mechanism, where
427  * there is an account (an owner) that can be granted exclusive access to
428  * specific functions.
429  *
430  * By default, the owner account will be the one that deploys the contract. This
431  * can later be changed with {transferOwnership}.
432  *
433  * This module is used through inheritance. It will make available the modifier
434  * `onlyOwner`, which can be applied to your functions to restrict their use to
435  * the owner.
436  */
437 abstract contract Ownable is Context {
438     address private _owner;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441 
442     /**
443      * @dev Initializes the contract setting the deployer as the initial owner.
444      */
445     constructor() {
446         _transferOwnership(_msgSender());
447     }
448 
449     /**
450      * @dev Throws if called by any account other than the owner.
451      */
452     modifier onlyOwner() {
453         _checkOwner();
454         _;
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view virtual returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if the sender is not the owner.
466      */
467     function _checkOwner() internal view virtual {
468         require(owner() == _msgSender(), "Ownable: caller is not the owner");
469     }
470 
471     /**
472      * @dev Leaves the contract without owner. It will not be possible to call
473      * `onlyOwner` functions anymore. Can only be called by the current owner.
474      *
475      * NOTE: Renouncing ownership will leave the contract without an owner,
476      * thereby removing any functionality that is only available to the owner.
477      */
478     function renounceOwnership() public virtual onlyOwner {
479         _transferOwnership(address(0));
480     }
481 
482     /**
483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
484      * Can only be called by the current owner.
485      */
486     function transferOwnership(address newOwner) public virtual onlyOwner {
487         require(newOwner != address(0), "Ownable: new owner is the zero address");
488         _transferOwnership(newOwner);
489     }
490 
491     /**
492      * @dev Transfers ownership of the contract to a new account (`newOwner`).
493      * Internal function without access restriction.
494      */
495     function _transferOwnership(address newOwner) internal virtual {
496         address oldOwner = _owner;
497         _owner = newOwner;
498         emit OwnershipTransferred(oldOwner, newOwner);
499     }
500 }
501 
502 // File: erc721a/contracts/IERC721A.sol
503 
504 
505 // ERC721A Contracts v4.1.0
506 // Creator: Chiru Labs
507 
508 pragma solidity ^0.8.4;
509 
510 /**
511  * @dev Interface of an ERC721A compliant contract.
512  */
513 interface IERC721A {
514     /**
515      * The caller must own the token or be an approved operator.
516      */
517     error ApprovalCallerNotOwnerNorApproved();
518 
519     /**
520      * The token does not exist.
521      */
522     error ApprovalQueryForNonexistentToken();
523 
524     /**
525      * The caller cannot approve to their own address.
526      */
527     error ApproveToCaller();
528 
529     /**
530      * Cannot query the balance for the zero address.
531      */
532     error BalanceQueryForZeroAddress();
533 
534     /**
535      * Cannot mint to the zero address.
536      */
537     error MintToZeroAddress();
538 
539     /**
540      * The quantity of tokens minted must be more than zero.
541      */
542     error MintZeroQuantity();
543 
544     /**
545      * The token does not exist.
546      */
547     error OwnerQueryForNonexistentToken();
548 
549     /**
550      * The caller must own the token or be an approved operator.
551      */
552     error TransferCallerNotOwnerNorApproved();
553 
554     /**
555      * The token must be owned by `from`.
556      */
557     error TransferFromIncorrectOwner();
558 
559     /**
560      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
561      */
562     error TransferToNonERC721ReceiverImplementer();
563 
564     /**
565      * Cannot transfer to the zero address.
566      */
567     error TransferToZeroAddress();
568 
569     /**
570      * The token does not exist.
571      */
572     error URIQueryForNonexistentToken();
573 
574     /**
575      * The `quantity` minted with ERC2309 exceeds the safety limit.
576      */
577     error MintERC2309QuantityExceedsLimit();
578 
579     /**
580      * The `extraData` cannot be set on an unintialized ownership slot.
581      */
582     error OwnershipNotInitializedForExtraData();
583 
584     struct TokenOwnership {
585         // The address of the owner.
586         address addr;
587         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
588         uint64 startTimestamp;
589         // Whether the token has been burned.
590         bool burned;
591         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
592         uint24 extraData;
593     }
594 
595     /**
596      * @dev Returns the total amount of tokens stored by the contract.
597      *
598      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
599      */
600     function totalSupply() external view returns (uint256);
601 
602     // ==============================
603     //            IERC165
604     // ==============================
605 
606     /**
607      * @dev Returns true if this contract implements the interface defined by
608      * `interfaceId`. See the corresponding
609      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
610      * to learn more about how these ids are created.
611      *
612      * This function call must use less than 30 000 gas.
613      */
614     function supportsInterface(bytes4 interfaceId) external view returns (bool);
615 
616     // ==============================
617     //            IERC721
618     // ==============================
619 
620     /**
621      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
622      */
623     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
627      */
628     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
629 
630     /**
631      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
632      */
633     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
634 
635     /**
636      * @dev Returns the number of tokens in ``owner``'s account.
637      */
638     function balanceOf(address owner) external view returns (uint256 balance);
639 
640     /**
641      * @dev Returns the owner of the `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function ownerOf(uint256 tokenId) external view returns (address owner);
648 
649     /**
650      * @dev Safely transfers `tokenId` token from `from` to `to`.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must exist and be owned by `from`.
657      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes calldata data
667     ) external;
668 
669     /**
670      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
671      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
680      *
681      * Emits a {Transfer} event.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) external;
688 
689     /**
690      * @dev Transfers `tokenId` token from `from` to `to`.
691      *
692      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
693      *
694      * Requirements:
695      *
696      * - `from` cannot be the zero address.
697      * - `to` cannot be the zero address.
698      * - `tokenId` token must be owned by `from`.
699      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
700      *
701      * Emits a {Transfer} event.
702      */
703     function transferFrom(
704         address from,
705         address to,
706         uint256 tokenId
707     ) external;
708 
709     /**
710      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
711      * The approval is cleared when the token is transferred.
712      *
713      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
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
726      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
727      *
728      * Requirements:
729      *
730      * - The `operator` cannot be the caller.
731      *
732      * Emits an {ApprovalForAll} event.
733      */
734     function setApprovalForAll(address operator, bool _approved) external;
735 
736     /**
737      * @dev Returns the account approved for `tokenId` token.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must exist.
742      */
743     function getApproved(uint256 tokenId) external view returns (address operator);
744 
745     /**
746      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
747      *
748      * See {setApprovalForAll}
749      */
750     function isApprovedForAll(address owner, address operator) external view returns (bool);
751 
752     // ==============================
753     //        IERC721Metadata
754     // ==============================
755 
756     /**
757      * @dev Returns the token collection name.
758      */
759     function name() external view returns (string memory);
760 
761     /**
762      * @dev Returns the token collection symbol.
763      */
764     function symbol() external view returns (string memory);
765 
766     /**
767      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
768      */
769     function tokenURI(uint256 tokenId) external view returns (string memory);
770 
771     // ==============================
772     //            IERC2309
773     // ==============================
774 
775     /**
776      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
777      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
778      */
779     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
780 }
781 
782 // File: erc721a/contracts/ERC721A.sol
783 
784 
785 // ERC721A Contracts v4.1.0
786 // Creator: Chiru Labs
787 
788 pragma solidity ^0.8.4;
789 
790 
791 /**
792  * @dev ERC721 token receiver interface.
793  */
794 interface ERC721A__IERC721Receiver {
795     function onERC721Received(
796         address operator,
797         address from,
798         uint256 tokenId,
799         bytes calldata data
800     ) external returns (bytes4);
801 }
802 
803 /**
804  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
805  * including the Metadata extension. Built to optimize for lower gas during batch mints.
806  *
807  * Assumes serials are sequentially minted starting at `_startTokenId()`
808  * (defaults to 0, e.g. 0, 1, 2, 3..).
809  *
810  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
811  *
812  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
813  */
814 contract ERC721A is IERC721A {
815     // Mask of an entry in packed address data.
816     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
817 
818     // The bit position of `numberMinted` in packed address data.
819     uint256 private constant BITPOS_NUMBER_MINTED = 64;
820 
821     // The bit position of `numberBurned` in packed address data.
822     uint256 private constant BITPOS_NUMBER_BURNED = 128;
823 
824     // The bit position of `aux` in packed address data.
825     uint256 private constant BITPOS_AUX = 192;
826 
827     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
828     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
829 
830     // The bit position of `startTimestamp` in packed ownership.
831     uint256 private constant BITPOS_START_TIMESTAMP = 160;
832 
833     // The bit mask of the `burned` bit in packed ownership.
834     uint256 private constant BITMASK_BURNED = 1 << 224;
835 
836     // The bit position of the `nextInitialized` bit in packed ownership.
837     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
838 
839     // The bit mask of the `nextInitialized` bit in packed ownership.
840     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
841 
842     // The bit position of `extraData` in packed ownership.
843     uint256 private constant BITPOS_EXTRA_DATA = 232;
844 
845     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
846     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
847 
848     // The mask of the lower 160 bits for addresses.
849     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
850 
851     // The maximum `quantity` that can be minted with `_mintERC2309`.
852     // This limit is to prevent overflows on the address data entries.
853     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
854     // is required to cause an overflow, which is unrealistic.
855     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
856 
857     // The tokenId of the next token to be minted.
858     uint256 private _currentIndex;
859 
860     // The number of tokens burned.
861     uint256 private _burnCounter;
862 
863     // Token name
864     string private _name;
865 
866     // Token symbol
867     string private _symbol;
868 
869     // Mapping from token ID to ownership details
870     // An empty struct value does not necessarily mean the token is unowned.
871     // See `_packedOwnershipOf` implementation for details.
872     //
873     // Bits Layout:
874     // - [0..159]   `addr`
875     // - [160..223] `startTimestamp`
876     // - [224]      `burned`
877     // - [225]      `nextInitialized`
878     // - [232..255] `extraData`
879     mapping(uint256 => uint256) private _packedOwnerships;
880 
881     // Mapping owner address to address data.
882     //
883     // Bits Layout:
884     // - [0..63]    `balance`
885     // - [64..127]  `numberMinted`
886     // - [128..191] `numberBurned`
887     // - [192..255] `aux`
888     mapping(address => uint256) private _packedAddressData;
889 
890     // Mapping from token ID to approved address.
891     mapping(uint256 => address) private _tokenApprovals;
892 
893     // Mapping from owner to operator approvals
894     mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899         _currentIndex = _startTokenId();
900     }
901 
902     /**
903      * @dev Returns the starting token ID.
904      * To change the starting token ID, please override this function.
905      */
906     function _startTokenId() internal view virtual returns (uint256) {
907         return 0;
908     }
909 
910     /**
911      * @dev Returns the next token ID to be minted.
912      */
913     function _nextTokenId() internal view returns (uint256) {
914         return _currentIndex;
915     }
916 
917     /**
918      * @dev Returns the total number of tokens in existence.
919      * Burned tokens will reduce the count.
920      * To get the total number of tokens minted, please see `_totalMinted`.
921      */
922     function totalSupply() public view override returns (uint256) {
923         // Counter underflow is impossible as _burnCounter cannot be incremented
924         // more than `_currentIndex - _startTokenId()` times.
925         unchecked {
926             return _currentIndex - _burnCounter - _startTokenId();
927         }
928     }
929 
930     /**
931      * @dev Returns the total amount of tokens minted in the contract.
932      */
933     function _totalMinted() internal view returns (uint256) {
934         // Counter underflow is impossible as _currentIndex does not decrement,
935         // and it is initialized to `_startTokenId()`
936         unchecked {
937             return _currentIndex - _startTokenId();
938         }
939     }
940 
941     /**
942      * @dev Returns the total number of tokens burned.
943      */
944     function _totalBurned() internal view returns (uint256) {
945         return _burnCounter;
946     }
947 
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952         // The interface IDs are constants representing the first 4 bytes of the XOR of
953         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
954         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
955         return
956             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
957             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
958             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
959     }
960 
961     /**
962      * @dev See {IERC721-balanceOf}.
963      */
964     function balanceOf(address owner) public view override returns (uint256) {
965         if (owner == address(0)) revert BalanceQueryForZeroAddress();
966         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
967     }
968 
969     /**
970      * Returns the number of tokens minted by `owner`.
971      */
972     function _numberMinted(address owner) internal view returns (uint256) {
973         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
974     }
975 
976     /**
977      * Returns the number of tokens burned by or on behalf of `owner`.
978      */
979     function _numberBurned(address owner) internal view returns (uint256) {
980         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
981     }
982 
983     /**
984      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
985      */
986     function _getAux(address owner) internal view returns (uint64) {
987         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
988     }
989 
990     /**
991      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
992      * If there are multiple variables, please pack them into a uint64.
993      */
994     function _setAux(address owner, uint64 aux) internal {
995         uint256 packed = _packedAddressData[owner];
996         uint256 auxCasted;
997         // Cast `aux` with assembly to avoid redundant masking.
998         assembly {
999             auxCasted := aux
1000         }
1001         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1002         _packedAddressData[owner] = packed;
1003     }
1004 
1005     /**
1006      * Returns the packed ownership data of `tokenId`.
1007      */
1008     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1009         uint256 curr = tokenId;
1010 
1011         unchecked {
1012             if (_startTokenId() <= curr)
1013                 if (curr < _currentIndex) {
1014                     uint256 packed = _packedOwnerships[curr];
1015                     // If not burned.
1016                     if (packed & BITMASK_BURNED == 0) {
1017                         // Invariant:
1018                         // There will always be an ownership that has an address and is not burned
1019                         // before an ownership that does not have an address and is not burned.
1020                         // Hence, curr will not underflow.
1021                         //
1022                         // We can directly compare the packed value.
1023                         // If the address is zero, packed is zero.
1024                         while (packed == 0) {
1025                             packed = _packedOwnerships[--curr];
1026                         }
1027                         return packed;
1028                     }
1029                 }
1030         }
1031         revert OwnerQueryForNonexistentToken();
1032     }
1033 
1034     /**
1035      * Returns the unpacked `TokenOwnership` struct from `packed`.
1036      */
1037     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1038         ownership.addr = address(uint160(packed));
1039         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1040         ownership.burned = packed & BITMASK_BURNED != 0;
1041         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1042     }
1043 
1044     /**
1045      * Returns the unpacked `TokenOwnership` struct at `index`.
1046      */
1047     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1048         return _unpackedOwnership(_packedOwnerships[index]);
1049     }
1050 
1051     /**
1052      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1053      */
1054     function _initializeOwnershipAt(uint256 index) internal {
1055         if (_packedOwnerships[index] == 0) {
1056             _packedOwnerships[index] = _packedOwnershipOf(index);
1057         }
1058     }
1059 
1060     /**
1061      * Gas spent here starts off proportional to the maximum mint batch size.
1062      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1063      */
1064     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1065         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1066     }
1067 
1068     /**
1069      * @dev Packs ownership data into a single uint256.
1070      */
1071     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1072         assembly {
1073             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1074             owner := and(owner, BITMASK_ADDRESS)
1075             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1076             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1077         }
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-ownerOf}.
1082      */
1083     function ownerOf(uint256 tokenId) public view override returns (address) {
1084         return address(uint160(_packedOwnershipOf(tokenId)));
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-name}.
1089      */
1090     function name() public view virtual override returns (string memory) {
1091         return _name;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Metadata-symbol}.
1096      */
1097     function symbol() public view virtual override returns (string memory) {
1098         return _symbol;
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Metadata-tokenURI}.
1103      */
1104     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1105         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1106 
1107         string memory baseURI = _baseURI();
1108         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1109     }
1110 
1111     /**
1112      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1113      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1114      * by default, it can be overridden in child contracts.
1115      */
1116     function _baseURI() internal view virtual returns (string memory) {
1117         return '';
1118     }
1119 
1120     /**
1121      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1122      */
1123     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1124         // For branchless setting of the `nextInitialized` flag.
1125         assembly {
1126             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1127             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1128         }
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-approve}.
1133      */
1134     function approve(address to, uint256 tokenId) public override {
1135         address owner = ownerOf(tokenId);
1136 
1137         if (_msgSenderERC721A() != owner)
1138             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1139                 revert ApprovalCallerNotOwnerNorApproved();
1140             }
1141 
1142         _tokenApprovals[tokenId] = to;
1143         emit Approval(owner, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-getApproved}.
1148      */
1149     function getApproved(uint256 tokenId) public view override returns (address) {
1150         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1151 
1152         return _tokenApprovals[tokenId];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-setApprovalForAll}.
1157      */
1158     function setApprovalForAll(address operator, bool approved) public virtual override {
1159         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1160 
1161         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1162         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-isApprovedForAll}.
1167      */
1168     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1169         return _operatorApprovals[owner][operator];
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-safeTransferFrom}.
1174      */
1175     function safeTransferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) public virtual override {
1180         safeTransferFrom(from, to, tokenId, '');
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-safeTransferFrom}.
1185      */
1186     function safeTransferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) public virtual override {
1192         transferFrom(from, to, tokenId);
1193         if (to.code.length != 0)
1194             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1195                 revert TransferToNonERC721ReceiverImplementer();
1196             }
1197     }
1198 
1199     /**
1200      * @dev Returns whether `tokenId` exists.
1201      *
1202      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1203      *
1204      * Tokens start existing when they are minted (`_mint`),
1205      */
1206     function _exists(uint256 tokenId) internal view returns (bool) {
1207         return
1208             _startTokenId() <= tokenId &&
1209             tokenId < _currentIndex && // If within bounds,
1210             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1211     }
1212 
1213     /**
1214      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1215      */
1216     function _safeMint(address to, uint256 quantity) internal {
1217         _safeMint(to, quantity, '');
1218     }
1219 
1220     /**
1221      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1222      *
1223      * Requirements:
1224      *
1225      * - If `to` refers to a smart contract, it must implement
1226      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * See {_mint}.
1230      *
1231      * Emits a {Transfer} event for each mint.
1232      */
1233     function _safeMint(
1234         address to,
1235         uint256 quantity,
1236         bytes memory _data
1237     ) internal {
1238         _mint(to, quantity);
1239 
1240         unchecked {
1241             if (to.code.length != 0) {
1242                 uint256 end = _currentIndex;
1243                 uint256 index = end - quantity;
1244                 do {
1245                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1246                         revert TransferToNonERC721ReceiverImplementer();
1247                     }
1248                 } while (index < end);
1249                 // Reentrancy protection.
1250                 if (_currentIndex != end) revert();
1251             }
1252         }
1253     }
1254 
1255     /**
1256      * @dev Mints `quantity` tokens and transfers them to `to`.
1257      *
1258      * Requirements:
1259      *
1260      * - `to` cannot be the zero address.
1261      * - `quantity` must be greater than 0.
1262      *
1263      * Emits a {Transfer} event for each mint.
1264      */
1265     function _mint(address to, uint256 quantity) internal {
1266         uint256 startTokenId = _currentIndex;
1267         if (to == address(0)) revert MintToZeroAddress();
1268         if (quantity == 0) revert MintZeroQuantity();
1269 
1270         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1271 
1272         // Overflows are incredibly unrealistic.
1273         // `balance` and `numberMinted` have a maximum limit of 2**64.
1274         // `tokenId` has a maximum limit of 2**256.
1275         unchecked {
1276             // Updates:
1277             // - `balance += quantity`.
1278             // - `numberMinted += quantity`.
1279             //
1280             // We can directly add to the `balance` and `numberMinted`.
1281             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1282 
1283             // Updates:
1284             // - `address` to the owner.
1285             // - `startTimestamp` to the timestamp of minting.
1286             // - `burned` to `false`.
1287             // - `nextInitialized` to `quantity == 1`.
1288             _packedOwnerships[startTokenId] = _packOwnershipData(
1289                 to,
1290                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1291             );
1292 
1293             uint256 tokenId = startTokenId;
1294             uint256 end = startTokenId + quantity;
1295             do {
1296                 emit Transfer(address(0), to, tokenId++);
1297             } while (tokenId < end);
1298 
1299             _currentIndex = end;
1300         }
1301         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1302     }
1303 
1304     /**
1305      * @dev Mints `quantity` tokens and transfers them to `to`.
1306      *
1307      * This function is intended for efficient minting only during contract creation.
1308      *
1309      * It emits only one {ConsecutiveTransfer} as defined in
1310      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1311      * instead of a sequence of {Transfer} event(s).
1312      *
1313      * Calling this function outside of contract creation WILL make your contract
1314      * non-compliant with the ERC721 standard.
1315      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1316      * {ConsecutiveTransfer} event is only permissible during contract creation.
1317      *
1318      * Requirements:
1319      *
1320      * - `to` cannot be the zero address.
1321      * - `quantity` must be greater than 0.
1322      *
1323      * Emits a {ConsecutiveTransfer} event.
1324      */
1325     function _mintERC2309(address to, uint256 quantity) internal {
1326         uint256 startTokenId = _currentIndex;
1327         if (to == address(0)) revert MintToZeroAddress();
1328         if (quantity == 0) revert MintZeroQuantity();
1329         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1330 
1331         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1332 
1333         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1334         unchecked {
1335             // Updates:
1336             // - `balance += quantity`.
1337             // - `numberMinted += quantity`.
1338             //
1339             // We can directly add to the `balance` and `numberMinted`.
1340             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1341 
1342             // Updates:
1343             // - `address` to the owner.
1344             // - `startTimestamp` to the timestamp of minting.
1345             // - `burned` to `false`.
1346             // - `nextInitialized` to `quantity == 1`.
1347             _packedOwnerships[startTokenId] = _packOwnershipData(
1348                 to,
1349                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1350             );
1351 
1352             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1353 
1354             _currentIndex = startTokenId + quantity;
1355         }
1356         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1357     }
1358 
1359     /**
1360      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1361      */
1362     function _getApprovedAddress(uint256 tokenId)
1363         private
1364         view
1365         returns (uint256 approvedAddressSlot, address approvedAddress)
1366     {
1367         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1368         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1369         assembly {
1370             // Compute the slot.
1371             mstore(0x00, tokenId)
1372             mstore(0x20, tokenApprovalsPtr.slot)
1373             approvedAddressSlot := keccak256(0x00, 0x40)
1374             // Load the slot's value from storage.
1375             approvedAddress := sload(approvedAddressSlot)
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1381      */
1382     function _isOwnerOrApproved(
1383         address approvedAddress,
1384         address from,
1385         address msgSender
1386     ) private pure returns (bool result) {
1387         assembly {
1388             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1389             from := and(from, BITMASK_ADDRESS)
1390             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1391             msgSender := and(msgSender, BITMASK_ADDRESS)
1392             // `msgSender == from || msgSender == approvedAddress`.
1393             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1394         }
1395     }
1396 
1397     /**
1398      * @dev Transfers `tokenId` from `from` to `to`.
1399      *
1400      * Requirements:
1401      *
1402      * - `to` cannot be the zero address.
1403      * - `tokenId` token must be owned by `from`.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function transferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) public virtual override {
1412         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1413 
1414         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1415 
1416         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1417 
1418         // The nested ifs save around 20+ gas over a compound boolean condition.
1419         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1420             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1421 
1422         if (to == address(0)) revert TransferToZeroAddress();
1423 
1424         _beforeTokenTransfers(from, to, tokenId, 1);
1425 
1426         // Clear approvals from the previous owner.
1427         assembly {
1428             if approvedAddress {
1429                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1430                 sstore(approvedAddressSlot, 0)
1431             }
1432         }
1433 
1434         // Underflow of the sender's balance is impossible because we check for
1435         // ownership above and the recipient's balance can't realistically overflow.
1436         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1437         unchecked {
1438             // We can directly increment and decrement the balances.
1439             --_packedAddressData[from]; // Updates: `balance -= 1`.
1440             ++_packedAddressData[to]; // Updates: `balance += 1`.
1441 
1442             // Updates:
1443             // - `address` to the next owner.
1444             // - `startTimestamp` to the timestamp of transfering.
1445             // - `burned` to `false`.
1446             // - `nextInitialized` to `true`.
1447             _packedOwnerships[tokenId] = _packOwnershipData(
1448                 to,
1449                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1450             );
1451 
1452             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1453             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1454                 uint256 nextTokenId = tokenId + 1;
1455                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1456                 if (_packedOwnerships[nextTokenId] == 0) {
1457                     // If the next slot is within bounds.
1458                     if (nextTokenId != _currentIndex) {
1459                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1460                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1461                     }
1462                 }
1463             }
1464         }
1465 
1466         emit Transfer(from, to, tokenId);
1467         _afterTokenTransfers(from, to, tokenId, 1);
1468     }
1469 
1470     /**
1471      * @dev Equivalent to `_burn(tokenId, false)`.
1472      */
1473     function _burn(uint256 tokenId) internal virtual {
1474         _burn(tokenId, false);
1475     }
1476 
1477     /**
1478      * @dev Destroys `tokenId`.
1479      * The approval is cleared when the token is burned.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1488         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1489 
1490         address from = address(uint160(prevOwnershipPacked));
1491 
1492         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1493 
1494         if (approvalCheck) {
1495             // The nested ifs save around 20+ gas over a compound boolean condition.
1496             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1497                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1498         }
1499 
1500         _beforeTokenTransfers(from, address(0), tokenId, 1);
1501 
1502         // Clear approvals from the previous owner.
1503         assembly {
1504             if approvedAddress {
1505                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1506                 sstore(approvedAddressSlot, 0)
1507             }
1508         }
1509 
1510         // Underflow of the sender's balance is impossible because we check for
1511         // ownership above and the recipient's balance can't realistically overflow.
1512         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1513         unchecked {
1514             // Updates:
1515             // - `balance -= 1`.
1516             // - `numberBurned += 1`.
1517             //
1518             // We can directly decrement the balance, and increment the number burned.
1519             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1520             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1521 
1522             // Updates:
1523             // - `address` to the last owner.
1524             // - `startTimestamp` to the timestamp of burning.
1525             // - `burned` to `true`.
1526             // - `nextInitialized` to `true`.
1527             _packedOwnerships[tokenId] = _packOwnershipData(
1528                 from,
1529                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1530             );
1531 
1532             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1533             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1534                 uint256 nextTokenId = tokenId + 1;
1535                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1536                 if (_packedOwnerships[nextTokenId] == 0) {
1537                     // If the next slot is within bounds.
1538                     if (nextTokenId != _currentIndex) {
1539                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1540                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1541                     }
1542                 }
1543             }
1544         }
1545 
1546         emit Transfer(from, address(0), tokenId);
1547         _afterTokenTransfers(from, address(0), tokenId, 1);
1548 
1549         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1550         unchecked {
1551             _burnCounter++;
1552         }
1553     }
1554 
1555     /**
1556      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1557      *
1558      * @param from address representing the previous owner of the given token ID
1559      * @param to target address that will receive the tokens
1560      * @param tokenId uint256 ID of the token to be transferred
1561      * @param _data bytes optional data to send along with the call
1562      * @return bool whether the call correctly returned the expected magic value
1563      */
1564     function _checkContractOnERC721Received(
1565         address from,
1566         address to,
1567         uint256 tokenId,
1568         bytes memory _data
1569     ) private returns (bool) {
1570         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1571             bytes4 retval
1572         ) {
1573             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1574         } catch (bytes memory reason) {
1575             if (reason.length == 0) {
1576                 revert TransferToNonERC721ReceiverImplementer();
1577             } else {
1578                 assembly {
1579                     revert(add(32, reason), mload(reason))
1580                 }
1581             }
1582         }
1583     }
1584 
1585     /**
1586      * @dev Directly sets the extra data for the ownership data `index`.
1587      */
1588     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1589         uint256 packed = _packedOwnerships[index];
1590         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1591         uint256 extraDataCasted;
1592         // Cast `extraData` with assembly to avoid redundant masking.
1593         assembly {
1594             extraDataCasted := extraData
1595         }
1596         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1597         _packedOwnerships[index] = packed;
1598     }
1599 
1600     /**
1601      * @dev Returns the next extra data for the packed ownership data.
1602      * The returned result is shifted into position.
1603      */
1604     function _nextExtraData(
1605         address from,
1606         address to,
1607         uint256 prevOwnershipPacked
1608     ) private view returns (uint256) {
1609         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1610         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1611     }
1612 
1613     /**
1614      * @dev Called during each token transfer to set the 24bit `extraData` field.
1615      * Intended to be overridden by the cosumer contract.
1616      *
1617      * `previousExtraData` - the value of `extraData` before transfer.
1618      *
1619      * Calling conditions:
1620      *
1621      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1622      * transferred to `to`.
1623      * - When `from` is zero, `tokenId` will be minted for `to`.
1624      * - When `to` is zero, `tokenId` will be burned by `from`.
1625      * - `from` and `to` are never both zero.
1626      */
1627     function _extraData(
1628         address from,
1629         address to,
1630         uint24 previousExtraData
1631     ) internal view virtual returns (uint24) {}
1632 
1633     /**
1634      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1635      * This includes minting.
1636      * And also called before burning one token.
1637      *
1638      * startTokenId - the first token id to be transferred
1639      * quantity - the amount to be transferred
1640      *
1641      * Calling conditions:
1642      *
1643      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1644      * transferred to `to`.
1645      * - When `from` is zero, `tokenId` will be minted for `to`.
1646      * - When `to` is zero, `tokenId` will be burned by `from`.
1647      * - `from` and `to` are never both zero.
1648      */
1649     function _beforeTokenTransfers(
1650         address from,
1651         address to,
1652         uint256 startTokenId,
1653         uint256 quantity
1654     ) internal virtual {}
1655 
1656     /**
1657      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1658      * This includes minting.
1659      * And also called after one token has been burned.
1660      *
1661      * startTokenId - the first token id to be transferred
1662      * quantity - the amount to be transferred
1663      *
1664      * Calling conditions:
1665      *
1666      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1667      * transferred to `to`.
1668      * - When `from` is zero, `tokenId` has been minted for `to`.
1669      * - When `to` is zero, `tokenId` has been burned by `from`.
1670      * - `from` and `to` are never both zero.
1671      */
1672     function _afterTokenTransfers(
1673         address from,
1674         address to,
1675         uint256 startTokenId,
1676         uint256 quantity
1677     ) internal virtual {}
1678 
1679     /**
1680      * @dev Returns the message sender (defaults to `msg.sender`).
1681      *
1682      * If you are writing GSN compatible contracts, you need to override this function.
1683      */
1684     function _msgSenderERC721A() internal view virtual returns (address) {
1685         return msg.sender;
1686     }
1687 
1688     /**
1689      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1690      */
1691     function _toString(uint256 value) internal pure returns (string memory ptr) {
1692         assembly {
1693             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1694             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1695             // We will need 1 32-byte word to store the length,
1696             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1697             ptr := add(mload(0x40), 128)
1698             // Update the free memory pointer to allocate.
1699             mstore(0x40, ptr)
1700 
1701             // Cache the end of the memory to calculate the length later.
1702             let end := ptr
1703 
1704             // We write the string from the rightmost digit to the leftmost digit.
1705             // The following is essentially a do-while loop that also handles the zero case.
1706             // Costs a bit more than early returning for the zero case,
1707             // but cheaper in terms of deployment and overall runtime costs.
1708             for {
1709                 // Initialize and perform the first pass without check.
1710                 let temp := value
1711                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1712                 ptr := sub(ptr, 1)
1713                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1714                 mstore8(ptr, add(48, mod(temp, 10)))
1715                 temp := div(temp, 10)
1716             } temp {
1717                 // Keep dividing `temp` until zero.
1718                 temp := div(temp, 10)
1719             } {
1720                 // Body of the for loop.
1721                 ptr := sub(ptr, 1)
1722                 mstore8(ptr, add(48, mod(temp, 10)))
1723             }
1724 
1725             let length := sub(end, ptr)
1726             // Move the pointer 32 bytes leftwards to make room for the length.
1727             ptr := sub(ptr, 32)
1728             // Store the length.
1729             mstore(ptr, length)
1730         }
1731     }
1732 }
1733 
1734 // File: contracts/TheAsians.sol
1735 
1736 //  sdSS_SSSSSSbs   .S    S.     sSSs         .S_SSSs      sSSs   .S   .S_SSSs     .S_sSSs      sSSs  
1737 //  YSSS~S%SSSSSP  .SS    SS.   d%%SP        .SS~SSSSS    d%%SP  .SS  .SS~SSSSS   .SS~YS%%b    d%%SP  
1738 //       S%S       S%S    S%S  d%S'          S%S   SSSS  d%S'    S%S  S%S   SSSS  S%S   `S%b  d%S'    
1739 //       S%S       S%S    S%S  S%S           S%S    S%S  S%|     S%S  S%S    S%S  S%S    S%S  S%|     
1740 //       S&S       S%S SSSS%S  S&S           S%S SSSS%S  S&S     S&S  S%S SSSS%S  S%S    S&S  S&S     
1741 //       S&S       S&S  SSS&S  S&S_Ss        S&S  SSS%S  Y&Ss    S&S  S&S  SSS%S  S&S    S&S  Y&Ss    
1742 //       S&S       S&S    S&S  S&S~SP        S&S    S&S  `S&&S   S&S  S&S    S&S  S&S    S&S  `S&&S   
1743 //       S&S       S&S    S&S  S&S           S&S    S&S    `S*S  S&S  S&S    S&S  S&S    S&S    `S*S  
1744 //       S*S       S*S    S*S  S*b           S*S    S&S     l*S  S*S  S*S    S&S  S*S    S*S     l*S  
1745 //       S*S       S*S    S*S  S*S.          S*S    S*S    .S*P  S*S  S*S    S*S  S*S    S*S    .S*P  
1746 //       S*S       S*S    S*S   SSSbs        S*S    S*S  sSS*S   S*S  S*S    S*S  S*S    S*S  sSS*S   
1747 //       S*S       SSS    S*S    YSSP        SSS    S*S  YSS'    S*S  SSS    S*S  S*S    SSS  YSS'    
1748 //       SP               SP                        SP           SP          SP   SP                  
1749 //       Y                Y                         Y            Y           Y    Y                   
1750 //                                                 
1751 
1752 
1753 pragma solidity ^0.8.0;
1754 
1755 
1756 
1757 
1758 
1759 
1760 contract TheAsians is ERC721A, Ownable, ReentrancyGuard {
1761   using Address for address;
1762   using Strings for uint;
1763 
1764   string  public  baseTokenURI = "ipfs://QmbFMFtzAJUK4gNpSn7x9iaWjj8jr8bYkg8aQGsHEtkMew/";
1765 
1766   uint256 public  maxSupply = 5555;
1767   uint256 public  MAX_MINTS_PER_TX = 5;
1768   uint256 public  FREE_MINTS_PER_TX = 2;
1769   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1770   uint256 public  TOTAL_FREE_MINTS = 2000;
1771   bool public isPublicSaleActive = false;
1772 
1773   constructor() ERC721A("The Asians", "ASIANS") {
1774 
1775   }
1776 
1777   function mint(uint256 numberOfTokens)
1778       external
1779       payable
1780   {
1781     require(isPublicSaleActive, "Public sale is not open");
1782     require(
1783       totalSupply() + numberOfTokens <= maxSupply,
1784       "Maximum supply exceeded"
1785     );
1786     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1787         require(
1788             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1789             "Incorrect ETH value sent"
1790         );
1791     }
1792     _safeMint(msg.sender, numberOfTokens);
1793   }
1794 
1795   function setBaseURI(string memory baseURI)
1796     public
1797     onlyOwner
1798   {
1799     baseTokenURI = baseURI;
1800   }
1801 
1802   function _startTokenId() internal view virtual override returns (uint256) {
1803         return 1;
1804     }
1805 
1806   function treasuryMint(uint quantity, address user)
1807     public
1808     onlyOwner
1809   {
1810     require(
1811       quantity > 0,
1812       "Invalid mint amount"
1813     );
1814     require(
1815       totalSupply() + quantity <= maxSupply,
1816       "Maximum supply exceeded"
1817     );
1818     _safeMint(user, quantity);
1819   }
1820 
1821   function withdraw()
1822     public
1823     onlyOwner
1824     nonReentrant
1825   {
1826     Address.sendValue(payable(msg.sender), address(this).balance);
1827   }
1828 
1829   function tokenURI(uint _tokenId)
1830     public
1831     view
1832     virtual
1833     override
1834     returns (string memory)
1835   {
1836     require(
1837       _exists(_tokenId),
1838       "ERC721Metadata: URI query for nonexistent token"
1839     );
1840     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1841   }
1842 
1843   function _baseURI()
1844     internal
1845     view
1846     virtual
1847     override
1848     returns (string memory)
1849   {
1850     return baseTokenURI;
1851   }
1852 
1853   function setIsPublicSaleActive(bool _isPublicSaleActive)
1854       external
1855       onlyOwner
1856   {
1857       isPublicSaleActive = _isPublicSaleActive;
1858   }
1859 
1860   function setNumFreeMints(uint256 _numfreemints)
1861       external
1862       onlyOwner
1863   {
1864       TOTAL_FREE_MINTS = _numfreemints;
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