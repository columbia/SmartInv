1 // _______    ______    ______  ________   ______                                         
2 //|       \  /      \  /      \|        \ /      \                                        
3 //| $$$$$$$\|  $$$$$$\|  $$$$$$\\$$$$$$$$|  $$$$$$\                                       
4 //| $$__/ $$| $$__| $$| $$___\$$  | $$   | $$__| $$                                       
5 //| $$    $$| $$    $$ \$$    \   | $$   | $$    $$                                       
6 //| $$$$$$$ | $$$$$$$$ _\$$$$$$\  | $$   | $$$$$$$$                                       
7 //| $$      | $$  | $$|  \__| $$  | $$   | $$  | $$                                       
8 //| $$      | $$  | $$ \$$    $$  | $$   | $$  | $$                                       
9 // \$$       \$$   \$$  \$$$$$$    \$$    \$$   \$$                                 
10 //  ______   _______    ______    ______   __    __  ________  ________  ________  ______ 
11 // /      \ |       \  /      \  /      \ |  \  |  \|        \|        \|        \|      \
12 //|  $$$$$$\| $$$$$$$\|  $$$$$$\|  $$$$$$\| $$  | $$| $$$$$$$$ \$$$$$$$$ \$$$$$$$$ \$$$$$$
13 //| $$___\$$| $$__/ $$| $$__| $$| $$ __\$$| $$__| $$| $$__       | $$      | $$     | $$  
14 // \$$    \ | $$    $$| $$    $$| $$|    \| $$    $$| $$  \      | $$      | $$     | $$  
15 // _\$$$$$$\| $$$$$$$ | $$$$$$$$| $$ \$$$$| $$$$$$$$| $$$$$      | $$      | $$     | $$  
16 //|  \__| $$| $$      | $$  | $$| $$__| $$| $$  | $$| $$_____    | $$      | $$    _| $$_ 
17 // \$$    $$| $$      | $$  | $$ \$$    $$| $$  | $$| $$     \   | $$      | $$   |   $$ \
18 //  \$$$$$$  \$$       \$$   \$$  \$$$$$$  \$$   \$$ \$$$$$$$$    \$$       \$$    \$$$$$$                                                                                      
19 // _______  ______  ________  ________   ______                                           
20 //|       \|      \|        \|        \ /      \                                          
21 //| $$$$$$$\\$$$$$$ \$$$$$$$$ \$$$$$$$$|  $$$$$$\                                         
22 //| $$__/ $$ | $$      /  $$     /  $$ | $$__| $$                                         
23 //| $$    $$ | $$     /  $$     /  $$  | $$    $$                                         
24 //| $$$$$$$  | $$    /  $$     /  $$   | $$$$$$$$                                         
25 //| $$      _| $$_  /  $$___  /  $$___ | $$  | $$                                         
26 //| $$     |   $$ \|  $$    \|  $$    \| $$  | $$                                         
27 // \$$      \$$$$$$ \$$$$$$$$ \$$$$$$$$ \$$   \$$                                                   
28 
29 
30 
31 // SPDX-License-Identifier: MIT
32 
33 // File: @openzeppelin/contracts/utils/Strings.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev String operations.
42  */
43 library Strings {
44     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
45     uint8 private constant _ADDRESS_LENGTH = 20;
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
49      */
50     function toString(uint256 value) internal pure returns (string memory) {
51         // Inspired by OraclizeAPI's implementation - MIT licence
52         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = _HEX_SYMBOLS[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
105      */
106     function toHexString(address addr) internal pure returns (string memory) {
107         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Address.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
115 
116 pragma solidity ^0.8.1;
117 
118 /**
119  * @dev Collection of functions related to the address type
120  */
121 library Address {
122     /**
123      * @dev Returns true if `account` is a contract.
124      *
125      * [IMPORTANT]
126      * ====
127      * It is unsafe to assume that an address for which this function returns
128      * false is an externally-owned account (EOA) and not a contract.
129      *
130      * Among others, `isContract` will return false for the following
131      * types of addresses:
132      *
133      *  - an externally-owned account
134      *  - a contract in construction
135      *  - an address where a contract will be created
136      *  - an address where a contract lived, but was destroyed
137      * ====
138      *
139      * [IMPORTANT]
140      * ====
141      * You shouldn't rely on `isContract` to protect against flash loan attacks!
142      *
143      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
144      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
145      * constructor.
146      * ====
147      */
148     function isContract(address account) internal view returns (bool) {
149         // This method relies on extcodesize/address.code.length, which returns 0
150         // for contracts in construction, since the code is only stored at the end
151         // of the constructor execution.
152 
153         return account.code.length > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
203      * `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but also transferring `value` wei to `target`.
218      *
219      * Requirements:
220      *
221      * - the calling contract must have an ETH balance of at least `value`.
222      * - the called Solidity function must be `payable`.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
236      * with `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.delegatecall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324                 /// @solidity memory-safe-assembly
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Contract module that helps prevent reentrant calls to a function.
345  *
346  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
347  * available, which can be applied to functions to make sure there are no nested
348  * (reentrant) calls to them.
349  *
350  * Note that because there is a single `nonReentrant` guard, functions marked as
351  * `nonReentrant` may not call one another. This can be worked around by making
352  * those functions `private`, and then adding `external` `nonReentrant` entry
353  * points to them.
354  *
355  * TIP: If you would like to learn more about reentrancy and alternative ways
356  * to protect against it, check out our blog post
357  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
358  */
359 abstract contract ReentrancyGuard {
360     // Booleans are more expensive than uint256 or any type that takes up a full
361     // word because each write operation emits an extra SLOAD to first read the
362     // slot's contents, replace the bits taken up by the boolean, and then write
363     // back. This is the compiler's defense against contract upgrades and
364     // pointer aliasing, and it cannot be disabled.
365 
366     // The values being non-zero value makes deployment a bit more expensive,
367     // but in exchange the refund on every call to nonReentrant will be lower in
368     // amount. Since refunds are capped to a percentage of the total
369     // transaction's gas, it is best to keep them low in cases like this one, to
370     // increase the likelihood of the full refund coming into effect.
371     uint256 private constant _NOT_ENTERED = 1;
372     uint256 private constant _ENTERED = 2;
373 
374     uint256 private _status;
375 
376     constructor() {
377         _status = _NOT_ENTERED;
378     }
379 
380     /**
381      * @dev Prevents a contract from calling itself, directly or indirectly.
382      * Calling a `nonReentrant` function from another `nonReentrant`
383      * function is not supported. It is possible to prevent this from happening
384      * by making the `nonReentrant` function external, and making it call a
385      * `private` function that does the actual work.
386      */
387     modifier nonReentrant() {
388         // On the first call to nonReentrant, _notEntered will be true
389         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
390 
391         // Any calls to nonReentrant after this point will fail
392         _status = _ENTERED;
393 
394         _;
395 
396         // By storing the original value once again, a refund is triggered (see
397         // https://eips.ethereum.org/EIPS/eip-2200)
398         _status = _NOT_ENTERED;
399     }
400 }
401 
402 // File: @openzeppelin/contracts/utils/Context.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Provides information about the current execution context, including the
411  * sender of the transaction and its data. While these are generally available
412  * via msg.sender and msg.data, they should not be accessed in such a direct
413  * manner, since when dealing with meta-transactions the account sending and
414  * paying for execution may not be the actual sender (as far as an application
415  * is concerned).
416  *
417  * This contract is only required for intermediate, library-like contracts.
418  */
419 abstract contract Context {
420     function _msgSender() internal view virtual returns (address) {
421         return msg.sender;
422     }
423 
424     function _msgData() internal view virtual returns (bytes calldata) {
425         return msg.data;
426     }
427 }
428 
429 // File: @openzeppelin/contracts/access/Ownable.sol
430 
431 
432 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Contract module which provides a basic access control mechanism, where
439  * there is an account (an owner) that can be granted exclusive access to
440  * specific functions.
441  *
442  * By default, the owner account will be the one that deploys the contract. This
443  * can later be changed with {transferOwnership}.
444  *
445  * This module is used through inheritance. It will make available the modifier
446  * `onlyOwner`, which can be applied to your functions to restrict their use to
447  * the owner.
448  */
449 abstract contract Ownable is Context {
450     address private _owner;
451 
452     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454     /**
455      * @dev Initializes the contract setting the deployer as the initial owner.
456      */
457     constructor() {
458         _transferOwnership(_msgSender());
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         _checkOwner();
466         _;
467     }
468 
469     /**
470      * @dev Returns the address of the current owner.
471      */
472     function owner() public view virtual returns (address) {
473         return _owner;
474     }
475 
476     /**
477      * @dev Throws if the sender is not the owner.
478      */
479     function _checkOwner() internal view virtual {
480         require(owner() == _msgSender(), "Ownable: caller is not the owner");
481     }
482 
483     /**
484      * @dev Leaves the contract without owner. It will not be possible to call
485      * `onlyOwner` functions anymore. Can only be called by the current owner.
486      *
487      * NOTE: Renouncing ownership will leave the contract without an owner,
488      * thereby removing any functionality that is only available to the owner.
489      */
490     function renounceOwnership() public virtual onlyOwner {
491         _transferOwnership(address(0));
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         _transferOwnership(newOwner);
501     }
502 
503     /**
504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
505      * Internal function without access restriction.
506      */
507     function _transferOwnership(address newOwner) internal virtual {
508         address oldOwner = _owner;
509         _owner = newOwner;
510         emit OwnershipTransferred(oldOwner, newOwner);
511     }
512 }
513 
514 // File: erc721a/contracts/IERC721A.sol
515 
516 
517 // ERC721A Contracts v4.1.0
518 // Creator: Chiru Labs
519 
520 pragma solidity ^0.8.4;
521 
522 /**
523  * @dev Interface of an ERC721A compliant contract.
524  */
525 interface IERC721A {
526     /**
527      * The caller must own the token or be an approved operator.
528      */
529     error ApprovalCallerNotOwnerNorApproved();
530 
531     /**
532      * The token does not exist.
533      */
534     error ApprovalQueryForNonexistentToken();
535 
536     /**
537      * The caller cannot approve to their own address.
538      */
539     error ApproveToCaller();
540 
541     /**
542      * Cannot query the balance for the zero address.
543      */
544     error BalanceQueryForZeroAddress();
545 
546     /**
547      * Cannot mint to the zero address.
548      */
549     error MintToZeroAddress();
550 
551     /**
552      * The quantity of tokens minted must be more than zero.
553      */
554     error MintZeroQuantity();
555 
556     /**
557      * The token does not exist.
558      */
559     error OwnerQueryForNonexistentToken();
560 
561     /**
562      * The caller must own the token or be an approved operator.
563      */
564     error TransferCallerNotOwnerNorApproved();
565 
566     /**
567      * The token must be owned by `from`.
568      */
569     error TransferFromIncorrectOwner();
570 
571     /**
572      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
573      */
574     error TransferToNonERC721ReceiverImplementer();
575 
576     /**
577      * Cannot transfer to the zero address.
578      */
579     error TransferToZeroAddress();
580 
581     /**
582      * The token does not exist.
583      */
584     error URIQueryForNonexistentToken();
585 
586     /**
587      * The `quantity` minted with ERC2309 exceeds the safety limit.
588      */
589     error MintERC2309QuantityExceedsLimit();
590 
591     /**
592      * The `extraData` cannot be set on an unintialized ownership slot.
593      */
594     error OwnershipNotInitializedForExtraData();
595 
596     struct TokenOwnership {
597         // The address of the owner.
598         address addr;
599         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
600         uint64 startTimestamp;
601         // Whether the token has been burned.
602         bool burned;
603         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
604         uint24 extraData;
605     }
606 
607     /**
608      * @dev Returns the total amount of tokens stored by the contract.
609      *
610      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
611      */
612     function totalSupply() external view returns (uint256);
613 
614     // ==============================
615     //            IERC165
616     // ==============================
617 
618     /**
619      * @dev Returns true if this contract implements the interface defined by
620      * `interfaceId`. See the corresponding
621      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
622      * to learn more about how these ids are created.
623      *
624      * This function call must use less than 30 000 gas.
625      */
626     function supportsInterface(bytes4 interfaceId) external view returns (bool);
627 
628     // ==============================
629     //            IERC721
630     // ==============================
631 
632     /**
633      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
634      */
635     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
639      */
640     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
641 
642     /**
643      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
644      */
645     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
646 
647     /**
648      * @dev Returns the number of tokens in ``owner``'s account.
649      */
650     function balanceOf(address owner) external view returns (uint256 balance);
651 
652     /**
653      * @dev Returns the owner of the `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function ownerOf(uint256 tokenId) external view returns (address owner);
660 
661     /**
662      * @dev Safely transfers `tokenId` token from `from` to `to`.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must exist and be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId,
678         bytes calldata data
679     ) external;
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
683      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must exist and be owned by `from`.
690      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
691      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692      *
693      * Emits a {Transfer} event.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) external;
700 
701     /**
702      * @dev Transfers `tokenId` token from `from` to `to`.
703      *
704      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must be owned by `from`.
711      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
712      *
713      * Emits a {Transfer} event.
714      */
715     function transferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external;
720 
721     /**
722      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
723      * The approval is cleared when the token is transferred.
724      *
725      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
726      *
727      * Requirements:
728      *
729      * - The caller must own the token or be an approved operator.
730      * - `tokenId` must exist.
731      *
732      * Emits an {Approval} event.
733      */
734     function approve(address to, uint256 tokenId) external;
735 
736     /**
737      * @dev Approve or remove `operator` as an operator for the caller.
738      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
739      *
740      * Requirements:
741      *
742      * - The `operator` cannot be the caller.
743      *
744      * Emits an {ApprovalForAll} event.
745      */
746     function setApprovalForAll(address operator, bool _approved) external;
747 
748     /**
749      * @dev Returns the account approved for `tokenId` token.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must exist.
754      */
755     function getApproved(uint256 tokenId) external view returns (address operator);
756 
757     /**
758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
759      *
760      * See {setApprovalForAll}
761      */
762     function isApprovedForAll(address owner, address operator) external view returns (bool);
763 
764     // ==============================
765     //        IERC721Metadata
766     // ==============================
767 
768     /**
769      * @dev Returns the token collection name.
770      */
771     function name() external view returns (string memory);
772 
773     /**
774      * @dev Returns the token collection symbol.
775      */
776     function symbol() external view returns (string memory);
777 
778     /**
779      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
780      */
781     function tokenURI(uint256 tokenId) external view returns (string memory);
782 
783     // ==============================
784     //            IERC2309
785     // ==============================
786 
787     /**
788      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
789      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
790      */
791     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
792 }
793 
794 // File: erc721a/contracts/ERC721A.sol
795 
796 
797 // ERC721A Contracts v4.1.0
798 // Creator: Chiru Labs
799 
800 pragma solidity ^0.8.4;
801 
802 
803 /**
804  * @dev ERC721 token receiver interface.
805  */
806 interface ERC721A__IERC721Receiver {
807     function onERC721Received(
808         address operator,
809         address from,
810         uint256 tokenId,
811         bytes calldata data
812     ) external returns (bytes4);
813 }
814 
815 /**
816  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
817  * including the Metadata extension. Built to optimize for lower gas during batch mints.
818  *
819  * Assumes serials are sequentially minted starting at `_startTokenId()`
820  * (defaults to 0, e.g. 0, 1, 2, 3..).
821  *
822  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
823  *
824  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
825  */
826 contract ERC721A is IERC721A {
827     // Mask of an entry in packed address data.
828     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
829 
830     // The bit position of `numberMinted` in packed address data.
831     uint256 private constant BITPOS_NUMBER_MINTED = 64;
832 
833     // The bit position of `numberBurned` in packed address data.
834     uint256 private constant BITPOS_NUMBER_BURNED = 128;
835 
836     // The bit position of `aux` in packed address data.
837     uint256 private constant BITPOS_AUX = 192;
838 
839     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
840     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
841 
842     // The bit position of `startTimestamp` in packed ownership.
843     uint256 private constant BITPOS_START_TIMESTAMP = 160;
844 
845     // The bit mask of the `burned` bit in packed ownership.
846     uint256 private constant BITMASK_BURNED = 1 << 224;
847 
848     // The bit position of the `nextInitialized` bit in packed ownership.
849     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
850 
851     // The bit mask of the `nextInitialized` bit in packed ownership.
852     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
853 
854     // The bit position of `extraData` in packed ownership.
855     uint256 private constant BITPOS_EXTRA_DATA = 232;
856 
857     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
858     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
859 
860     // The mask of the lower 160 bits for addresses.
861     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
862 
863     // The maximum `quantity` that can be minted with `_mintERC2309`.
864     // This limit is to prevent overflows on the address data entries.
865     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
866     // is required to cause an overflow, which is unrealistic.
867     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
868 
869     // The tokenId of the next token to be minted.
870     uint256 private _currentIndex;
871 
872     // The number of tokens burned.
873     uint256 private _burnCounter;
874 
875     // Token name
876     string private _name;
877 
878     // Token symbol
879     string private _symbol;
880 
881     // Mapping from token ID to ownership details
882     // An empty struct value does not necessarily mean the token is unowned.
883     // See `_packedOwnershipOf` implementation for details.
884     //
885     // Bits Layout:
886     // - [0..159]   `addr`
887     // - [160..223] `startTimestamp`
888     // - [224]      `burned`
889     // - [225]      `nextInitialized`
890     // - [232..255] `extraData`
891     mapping(uint256 => uint256) private _packedOwnerships;
892 
893     // Mapping owner address to address data.
894     //
895     // Bits Layout:
896     // - [0..63]    `balance`
897     // - [64..127]  `numberMinted`
898     // - [128..191] `numberBurned`
899     // - [192..255] `aux`
900     mapping(address => uint256) private _packedAddressData;
901 
902     // Mapping from token ID to approved address.
903     mapping(uint256 => address) private _tokenApprovals;
904 
905     // Mapping from owner to operator approvals
906     mapping(address => mapping(address => bool)) private _operatorApprovals;
907 
908     constructor(string memory name_, string memory symbol_) {
909         _name = name_;
910         _symbol = symbol_;
911         _currentIndex = _startTokenId();
912     }
913 
914     /**
915      * @dev Returns the starting token ID.
916      * To change the starting token ID, please override this function.
917      */
918     function _startTokenId() internal view virtual returns (uint256) {
919         return 0;
920     }
921 
922     /**
923      * @dev Returns the next token ID to be minted.
924      */
925     function _nextTokenId() internal view returns (uint256) {
926         return _currentIndex;
927     }
928 
929     /**
930      * @dev Returns the total number of tokens in existence.
931      * Burned tokens will reduce the count.
932      * To get the total number of tokens minted, please see `_totalMinted`.
933      */
934     function totalSupply() public view override returns (uint256) {
935         // Counter underflow is impossible as _burnCounter cannot be incremented
936         // more than `_currentIndex - _startTokenId()` times.
937         unchecked {
938             return _currentIndex - _burnCounter - _startTokenId();
939         }
940     }
941 
942     /**
943      * @dev Returns the total amount of tokens minted in the contract.
944      */
945     function _totalMinted() internal view returns (uint256) {
946         // Counter underflow is impossible as _currentIndex does not decrement,
947         // and it is initialized to `_startTokenId()`
948         unchecked {
949             return _currentIndex - _startTokenId();
950         }
951     }
952 
953     /**
954      * @dev Returns the total number of tokens burned.
955      */
956     function _totalBurned() internal view returns (uint256) {
957         return _burnCounter;
958     }
959 
960     /**
961      * @dev See {IERC165-supportsInterface}.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
964         // The interface IDs are constants representing the first 4 bytes of the XOR of
965         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
966         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
967         return
968             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
969             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
970             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
971     }
972 
973     /**
974      * @dev See {IERC721-balanceOf}.
975      */
976     function balanceOf(address owner) public view override returns (uint256) {
977         if (owner == address(0)) revert BalanceQueryForZeroAddress();
978         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
979     }
980 
981     /**
982      * Returns the number of tokens minted by `owner`.
983      */
984     function _numberMinted(address owner) internal view returns (uint256) {
985         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
986     }
987 
988     /**
989      * Returns the number of tokens burned by or on behalf of `owner`.
990      */
991     function _numberBurned(address owner) internal view returns (uint256) {
992         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
993     }
994 
995     /**
996      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
997      */
998     function _getAux(address owner) internal view returns (uint64) {
999         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1000     }
1001 
1002     /**
1003      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1004      * If there are multiple variables, please pack them into a uint64.
1005      */
1006     function _setAux(address owner, uint64 aux) internal {
1007         uint256 packed = _packedAddressData[owner];
1008         uint256 auxCasted;
1009         // Cast `aux` with assembly to avoid redundant masking.
1010         assembly {
1011             auxCasted := aux
1012         }
1013         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1014         _packedAddressData[owner] = packed;
1015     }
1016 
1017     /**
1018      * Returns the packed ownership data of `tokenId`.
1019      */
1020     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1021         uint256 curr = tokenId;
1022 
1023         unchecked {
1024             if (_startTokenId() <= curr)
1025                 if (curr < _currentIndex) {
1026                     uint256 packed = _packedOwnerships[curr];
1027                     // If not burned.
1028                     if (packed & BITMASK_BURNED == 0) {
1029                         // Invariant:
1030                         // There will always be an ownership that has an address and is not burned
1031                         // before an ownership that does not have an address and is not burned.
1032                         // Hence, curr will not underflow.
1033                         //
1034                         // We can directly compare the packed value.
1035                         // If the address is zero, packed is zero.
1036                         while (packed == 0) {
1037                             packed = _packedOwnerships[--curr];
1038                         }
1039                         return packed;
1040                     }
1041                 }
1042         }
1043         revert OwnerQueryForNonexistentToken();
1044     }
1045 
1046     /**
1047      * Returns the unpacked `TokenOwnership` struct from `packed`.
1048      */
1049     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1050         ownership.addr = address(uint160(packed));
1051         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1052         ownership.burned = packed & BITMASK_BURNED != 0;
1053         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1054     }
1055 
1056     /**
1057      * Returns the unpacked `TokenOwnership` struct at `index`.
1058      */
1059     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1060         return _unpackedOwnership(_packedOwnerships[index]);
1061     }
1062 
1063     /**
1064      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1065      */
1066     function _initializeOwnershipAt(uint256 index) internal {
1067         if (_packedOwnerships[index] == 0) {
1068             _packedOwnerships[index] = _packedOwnershipOf(index);
1069         }
1070     }
1071 
1072     /**
1073      * Gas spent here starts off proportional to the maximum mint batch size.
1074      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1075      */
1076     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1077         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1078     }
1079 
1080     /**
1081      * @dev Packs ownership data into a single uint256.
1082      */
1083     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1084         assembly {
1085             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1086             owner := and(owner, BITMASK_ADDRESS)
1087             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1088             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1089         }
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-ownerOf}.
1094      */
1095     function ownerOf(uint256 tokenId) public view override returns (address) {
1096         return address(uint160(_packedOwnershipOf(tokenId)));
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Metadata-name}.
1101      */
1102     function name() public view virtual override returns (string memory) {
1103         return _name;
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Metadata-symbol}.
1108      */
1109     function symbol() public view virtual override returns (string memory) {
1110         return _symbol;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Metadata-tokenURI}.
1115      */
1116     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1117         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1118 
1119         string memory baseURI = _baseURI();
1120         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1121     }
1122 
1123     /**
1124      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1125      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1126      * by default, it can be overridden in child contracts.
1127      */
1128     function _baseURI() internal view virtual returns (string memory) {
1129         return '';
1130     }
1131 
1132     /**
1133      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1134      */
1135     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1136         // For branchless setting of the `nextInitialized` flag.
1137         assembly {
1138             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1139             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1140         }
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-approve}.
1145      */
1146     function approve(address to, uint256 tokenId) public override {
1147         address owner = ownerOf(tokenId);
1148 
1149         if (_msgSenderERC721A() != owner)
1150             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1151                 revert ApprovalCallerNotOwnerNorApproved();
1152             }
1153 
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(owner, to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-getApproved}.
1160      */
1161     function getApproved(uint256 tokenId) public view override returns (address) {
1162         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1163 
1164         return _tokenApprovals[tokenId];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-setApprovalForAll}.
1169      */
1170     function setApprovalForAll(address operator, bool approved) public virtual override {
1171         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1172 
1173         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1174         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-isApprovedForAll}.
1179      */
1180     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1181         return _operatorApprovals[owner][operator];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         safeTransferFrom(from, to, tokenId, '');
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) public virtual override {
1204         transferFrom(from, to, tokenId);
1205         if (to.code.length != 0)
1206             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1207                 revert TransferToNonERC721ReceiverImplementer();
1208             }
1209     }
1210 
1211     /**
1212      * @dev Returns whether `tokenId` exists.
1213      *
1214      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1215      *
1216      * Tokens start existing when they are minted (`_mint`),
1217      */
1218     function _exists(uint256 tokenId) internal view returns (bool) {
1219         return
1220             _startTokenId() <= tokenId &&
1221             tokenId < _currentIndex && // If within bounds,
1222             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1223     }
1224 
1225     /**
1226      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1227      */
1228     function _safeMint(address to, uint256 quantity) internal {
1229         _safeMint(to, quantity, '');
1230     }
1231 
1232     /**
1233      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - If `to` refers to a smart contract, it must implement
1238      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1239      * - `quantity` must be greater than 0.
1240      *
1241      * See {_mint}.
1242      *
1243      * Emits a {Transfer} event for each mint.
1244      */
1245     function _safeMint(
1246         address to,
1247         uint256 quantity,
1248         bytes memory _data
1249     ) internal {
1250         _mint(to, quantity);
1251 
1252         unchecked {
1253             if (to.code.length != 0) {
1254                 uint256 end = _currentIndex;
1255                 uint256 index = end - quantity;
1256                 do {
1257                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1258                         revert TransferToNonERC721ReceiverImplementer();
1259                     }
1260                 } while (index < end);
1261                 // Reentrancy protection.
1262                 if (_currentIndex != end) revert();
1263             }
1264         }
1265     }
1266 
1267     /**
1268      * @dev Mints `quantity` tokens and transfers them to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - `to` cannot be the zero address.
1273      * - `quantity` must be greater than 0.
1274      *
1275      * Emits a {Transfer} event for each mint.
1276      */
1277     function _mint(address to, uint256 quantity) internal {
1278         uint256 startTokenId = _currentIndex;
1279         if (to == address(0)) revert MintToZeroAddress();
1280         if (quantity == 0) revert MintZeroQuantity();
1281 
1282         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1283 
1284         // Overflows are incredibly unrealistic.
1285         // `balance` and `numberMinted` have a maximum limit of 2**64.
1286         // `tokenId` has a maximum limit of 2**256.
1287         unchecked {
1288             // Updates:
1289             // - `balance += quantity`.
1290             // - `numberMinted += quantity`.
1291             //
1292             // We can directly add to the `balance` and `numberMinted`.
1293             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1294 
1295             // Updates:
1296             // - `address` to the owner.
1297             // - `startTimestamp` to the timestamp of minting.
1298             // - `burned` to `false`.
1299             // - `nextInitialized` to `quantity == 1`.
1300             _packedOwnerships[startTokenId] = _packOwnershipData(
1301                 to,
1302                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1303             );
1304 
1305             uint256 tokenId = startTokenId;
1306             uint256 end = startTokenId + quantity;
1307             do {
1308                 emit Transfer(address(0), to, tokenId++);
1309             } while (tokenId < end);
1310 
1311             _currentIndex = end;
1312         }
1313         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1314     }
1315 
1316     /**
1317      * @dev Mints `quantity` tokens and transfers them to `to`.
1318      *
1319      * This function is intended for efficient minting only during contract creation.
1320      *
1321      * It emits only one {ConsecutiveTransfer} as defined in
1322      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1323      * instead of a sequence of {Transfer} event(s).
1324      *
1325      * Calling this function outside of contract creation WILL make your contract
1326      * non-compliant with the ERC721 standard.
1327      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1328      * {ConsecutiveTransfer} event is only permissible during contract creation.
1329      *
1330      * Requirements:
1331      *
1332      * - `to` cannot be the zero address.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {ConsecutiveTransfer} event.
1336      */
1337     function _mintERC2309(address to, uint256 quantity) internal {
1338         uint256 startTokenId = _currentIndex;
1339         if (to == address(0)) revert MintToZeroAddress();
1340         if (quantity == 0) revert MintZeroQuantity();
1341         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1342 
1343         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1344 
1345         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1346         unchecked {
1347             // Updates:
1348             // - `balance += quantity`.
1349             // - `numberMinted += quantity`.
1350             //
1351             // We can directly add to the `balance` and `numberMinted`.
1352             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1353 
1354             // Updates:
1355             // - `address` to the owner.
1356             // - `startTimestamp` to the timestamp of minting.
1357             // - `burned` to `false`.
1358             // - `nextInitialized` to `quantity == 1`.
1359             _packedOwnerships[startTokenId] = _packOwnershipData(
1360                 to,
1361                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1362             );
1363 
1364             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1365 
1366             _currentIndex = startTokenId + quantity;
1367         }
1368         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1369     }
1370 
1371     /**
1372      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1373      */
1374     function _getApprovedAddress(uint256 tokenId)
1375         private
1376         view
1377         returns (uint256 approvedAddressSlot, address approvedAddress)
1378     {
1379         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1380         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1381         assembly {
1382             // Compute the slot.
1383             mstore(0x00, tokenId)
1384             mstore(0x20, tokenApprovalsPtr.slot)
1385             approvedAddressSlot := keccak256(0x00, 0x40)
1386             // Load the slot's value from storage.
1387             approvedAddress := sload(approvedAddressSlot)
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1393      */
1394     function _isOwnerOrApproved(
1395         address approvedAddress,
1396         address from,
1397         address msgSender
1398     ) private pure returns (bool result) {
1399         assembly {
1400             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1401             from := and(from, BITMASK_ADDRESS)
1402             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1403             msgSender := and(msgSender, BITMASK_ADDRESS)
1404             // `msgSender == from || msgSender == approvedAddress`.
1405             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1406         }
1407     }
1408 
1409     /**
1410      * @dev Transfers `tokenId` from `from` to `to`.
1411      *
1412      * Requirements:
1413      *
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must be owned by `from`.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function transferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) public virtual override {
1424         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1425 
1426         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1427 
1428         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1429 
1430         // The nested ifs save around 20+ gas over a compound boolean condition.
1431         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1432             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1433 
1434         if (to == address(0)) revert TransferToZeroAddress();
1435 
1436         _beforeTokenTransfers(from, to, tokenId, 1);
1437 
1438         // Clear approvals from the previous owner.
1439         assembly {
1440             if approvedAddress {
1441                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1442                 sstore(approvedAddressSlot, 0)
1443             }
1444         }
1445 
1446         // Underflow of the sender's balance is impossible because we check for
1447         // ownership above and the recipient's balance can't realistically overflow.
1448         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1449         unchecked {
1450             // We can directly increment and decrement the balances.
1451             --_packedAddressData[from]; // Updates: `balance -= 1`.
1452             ++_packedAddressData[to]; // Updates: `balance += 1`.
1453 
1454             // Updates:
1455             // - `address` to the next owner.
1456             // - `startTimestamp` to the timestamp of transfering.
1457             // - `burned` to `false`.
1458             // - `nextInitialized` to `true`.
1459             _packedOwnerships[tokenId] = _packOwnershipData(
1460                 to,
1461                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1462             );
1463 
1464             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1465             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1466                 uint256 nextTokenId = tokenId + 1;
1467                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1468                 if (_packedOwnerships[nextTokenId] == 0) {
1469                     // If the next slot is within bounds.
1470                     if (nextTokenId != _currentIndex) {
1471                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1472                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1473                     }
1474                 }
1475             }
1476         }
1477 
1478         emit Transfer(from, to, tokenId);
1479         _afterTokenTransfers(from, to, tokenId, 1);
1480     }
1481 
1482     /**
1483      * @dev Equivalent to `_burn(tokenId, false)`.
1484      */
1485     function _burn(uint256 tokenId) internal virtual {
1486         _burn(tokenId, false);
1487     }
1488 
1489     /**
1490      * @dev Destroys `tokenId`.
1491      * The approval is cleared when the token is burned.
1492      *
1493      * Requirements:
1494      *
1495      * - `tokenId` must exist.
1496      *
1497      * Emits a {Transfer} event.
1498      */
1499     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1500         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1501 
1502         address from = address(uint160(prevOwnershipPacked));
1503 
1504         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1505 
1506         if (approvalCheck) {
1507             // The nested ifs save around 20+ gas over a compound boolean condition.
1508             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1509                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1510         }
1511 
1512         _beforeTokenTransfers(from, address(0), tokenId, 1);
1513 
1514         // Clear approvals from the previous owner.
1515         assembly {
1516             if approvedAddress {
1517                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1518                 sstore(approvedAddressSlot, 0)
1519             }
1520         }
1521 
1522         // Underflow of the sender's balance is impossible because we check for
1523         // ownership above and the recipient's balance can't realistically overflow.
1524         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1525         unchecked {
1526             // Updates:
1527             // - `balance -= 1`.
1528             // - `numberBurned += 1`.
1529             //
1530             // We can directly decrement the balance, and increment the number burned.
1531             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1532             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1533 
1534             // Updates:
1535             // - `address` to the last owner.
1536             // - `startTimestamp` to the timestamp of burning.
1537             // - `burned` to `true`.
1538             // - `nextInitialized` to `true`.
1539             _packedOwnerships[tokenId] = _packOwnershipData(
1540                 from,
1541                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1542             );
1543 
1544             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1545             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1546                 uint256 nextTokenId = tokenId + 1;
1547                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1548                 if (_packedOwnerships[nextTokenId] == 0) {
1549                     // If the next slot is within bounds.
1550                     if (nextTokenId != _currentIndex) {
1551                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1552                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1553                     }
1554                 }
1555             }
1556         }
1557 
1558         emit Transfer(from, address(0), tokenId);
1559         _afterTokenTransfers(from, address(0), tokenId, 1);
1560 
1561         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1562         unchecked {
1563             _burnCounter++;
1564         }
1565     }
1566 
1567     /**
1568      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1569      *
1570      * @param from address representing the previous owner of the given token ID
1571      * @param to target address that will receive the tokens
1572      * @param tokenId uint256 ID of the token to be transferred
1573      * @param _data bytes optional data to send along with the call
1574      * @return bool whether the call correctly returned the expected magic value
1575      */
1576     function _checkContractOnERC721Received(
1577         address from,
1578         address to,
1579         uint256 tokenId,
1580         bytes memory _data
1581     ) private returns (bool) {
1582         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1583             bytes4 retval
1584         ) {
1585             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1586         } catch (bytes memory reason) {
1587             if (reason.length == 0) {
1588                 revert TransferToNonERC721ReceiverImplementer();
1589             } else {
1590                 assembly {
1591                     revert(add(32, reason), mload(reason))
1592                 }
1593             }
1594         }
1595     }
1596 
1597     /**
1598      * @dev Directly sets the extra data for the ownership data `index`.
1599      */
1600     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1601         uint256 packed = _packedOwnerships[index];
1602         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1603         uint256 extraDataCasted;
1604         // Cast `extraData` with assembly to avoid redundant masking.
1605         assembly {
1606             extraDataCasted := extraData
1607         }
1608         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1609         _packedOwnerships[index] = packed;
1610     }
1611 
1612     /**
1613      * @dev Returns the next extra data for the packed ownership data.
1614      * The returned result is shifted into position.
1615      */
1616     function _nextExtraData(
1617         address from,
1618         address to,
1619         uint256 prevOwnershipPacked
1620     ) private view returns (uint256) {
1621         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1622         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1623     }
1624 
1625     /**
1626      * @dev Called during each token transfer to set the 24bit `extraData` field.
1627      * Intended to be overridden by the cosumer contract.
1628      *
1629      * `previousExtraData` - the value of `extraData` before transfer.
1630      *
1631      * Calling conditions:
1632      *
1633      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1634      * transferred to `to`.
1635      * - When `from` is zero, `tokenId` will be minted for `to`.
1636      * - When `to` is zero, `tokenId` will be burned by `from`.
1637      * - `from` and `to` are never both zero.
1638      */
1639     function _extraData(
1640         address from,
1641         address to,
1642         uint24 previousExtraData
1643     ) internal view virtual returns (uint24) {}
1644 
1645     /**
1646      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1647      * This includes minting.
1648      * And also called before burning one token.
1649      *
1650      * startTokenId - the first token id to be transferred
1651      * quantity - the amount to be transferred
1652      *
1653      * Calling conditions:
1654      *
1655      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1656      * transferred to `to`.
1657      * - When `from` is zero, `tokenId` will be minted for `to`.
1658      * - When `to` is zero, `tokenId` will be burned by `from`.
1659      * - `from` and `to` are never both zero.
1660      */
1661     function _beforeTokenTransfers(
1662         address from,
1663         address to,
1664         uint256 startTokenId,
1665         uint256 quantity
1666     ) internal virtual {}
1667 
1668     /**
1669      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1670      * This includes minting.
1671      * And also called after one token has been burned.
1672      *
1673      * startTokenId - the first token id to be transferred
1674      * quantity - the amount to be transferred
1675      *
1676      * Calling conditions:
1677      *
1678      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1679      * transferred to `to`.
1680      * - When `from` is zero, `tokenId` has been minted for `to`.
1681      * - When `to` is zero, `tokenId` has been burned by `from`.
1682      * - `from` and `to` are never both zero.
1683      */
1684     function _afterTokenTransfers(
1685         address from,
1686         address to,
1687         uint256 startTokenId,
1688         uint256 quantity
1689     ) internal virtual {}
1690 
1691     /**
1692      * @dev Returns the message sender (defaults to `msg.sender`).
1693      *
1694      * If you are writing GSN compatible contracts, you need to override this function.
1695      */
1696     function _msgSenderERC721A() internal view virtual returns (address) {
1697         return msg.sender;
1698     }
1699 
1700     /**
1701      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1702      */
1703     function _toString(uint256 value) internal pure returns (string memory ptr) {
1704         assembly {
1705             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1706             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1707             // We will need 1 32-byte word to store the length,
1708             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1709             ptr := add(mload(0x40), 128)
1710             // Update the free memory pointer to allocate.
1711             mstore(0x40, ptr)
1712 
1713             // Cache the end of the memory to calculate the length later.
1714             let end := ptr
1715 
1716             // We write the string from the rightmost digit to the leftmost digit.
1717             // The following is essentially a do-while loop that also handles the zero case.
1718             // Costs a bit more than early returning for the zero case,
1719             // but cheaper in terms of deployment and overall runtime costs.
1720             for {
1721                 // Initialize and perform the first pass without check.
1722                 let temp := value
1723                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1724                 ptr := sub(ptr, 1)
1725                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1726                 mstore8(ptr, add(48, mod(temp, 10)))
1727                 temp := div(temp, 10)
1728             } temp {
1729                 // Keep dividing `temp` until zero.
1730                 temp := div(temp, 10)
1731             } {
1732                 // Body of the for loop.
1733                 ptr := sub(ptr, 1)
1734                 mstore8(ptr, add(48, mod(temp, 10)))
1735             }
1736 
1737             let length := sub(end, ptr)
1738             // Move the pointer 32 bytes leftwards to make room for the length.
1739             ptr := sub(ptr, 32)
1740             // Store the length.
1741             mstore(ptr, length)
1742         }
1743     }
1744 }
1745 
1746 // File: contracts/TheItalians.sol
1747 
1748 pragma solidity ^0.8.0;
1749 
1750 contract TheItalians is ERC721A, Ownable, ReentrancyGuard {
1751   using Address for address;
1752   using Strings for uint;
1753 
1754   string  public  baseTokenURI = "";
1755 
1756   uint256 public  maxSupply = 4444;
1757   uint256 public  FREE_MINTS_PER_TX = 2;
1758   uint256 public  FREE_MINT_PRICE = 0.000 ether;
1759   uint256 public  TOTAL_FREE_MINTS = 4444;
1760   bool public isPublicSaleActive = false;
1761 
1762   constructor() ERC721A("The Italians", "ITALIANS") {
1763 
1764   }
1765 
1766   function mint(uint256 numberOfTokens)
1767       external
1768       payable
1769   {
1770     require(isPublicSaleActive, "Public sale is not open");
1771     require( totalSupply() + numberOfTokens <= maxSupply,"Maximum supply exceeded");
1772     require( numberOfTokens <= FREE_MINTS_PER_TX ,"Maximum two minuted per txn.");
1773    
1774 
1775     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1776         require(
1777             (FREE_MINT_PRICE * numberOfTokens) <= msg.value,
1778             "Incorrect ETH value sent"
1779         );
1780         
1781     }
1782          require(balanceOf(msg.sender) <= 2, "Maximum 3 total minted per wallet.");
1783 
1784     _safeMint(msg.sender, numberOfTokens);
1785   }
1786 
1787   function setBaseURI(string memory baseURI)
1788     public
1789     onlyOwner
1790   {
1791     baseTokenURI = baseURI;
1792   }
1793 
1794   function _startTokenId() internal view virtual override returns (uint256) {
1795         return 1;
1796     }
1797 
1798   function treasuryMint(uint quantity, address user)
1799     public
1800     onlyOwner
1801   {
1802     require(
1803       quantity > 0,
1804       "Invalid mint amount"
1805     );
1806     require(
1807       totalSupply() + quantity <= maxSupply,
1808       "Maximum supply exceeded"
1809     );
1810     _safeMint(user, quantity);
1811   }
1812 
1813   function withdraw()
1814     public
1815     onlyOwner
1816     nonReentrant
1817   {
1818     Address.sendValue(payable(msg.sender), address(this).balance);
1819   }
1820 
1821   function tokenURI(uint _tokenId)
1822     public
1823     view
1824     virtual
1825     override
1826     returns (string memory)
1827   {
1828     require(
1829       _exists(_tokenId),
1830       "ERC721Metadata: URI query for nonexistent token"
1831     );
1832     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1833   }
1834 
1835   function _baseURI()
1836     internal
1837     view
1838     virtual
1839     override
1840     returns (string memory)
1841   {
1842     return baseTokenURI;
1843   }
1844 
1845   function setIsPublicSaleActive(bool _isPublicSaleActive)
1846       external
1847       onlyOwner
1848   {
1849       isPublicSaleActive = _isPublicSaleActive;
1850   }
1851 
1852   function setNumFreeMints(uint256 _numfreemints)
1853       external
1854       onlyOwner
1855   {
1856       TOTAL_FREE_MINTS = _numfreemints;
1857   }
1858 
1859   function setMaxLimitPerTransaction(uint256 _limit)
1860       external
1861       onlyOwner
1862   {
1863       FREE_MINTS_PER_TX = _limit;
1864   }
1865 
1866 }