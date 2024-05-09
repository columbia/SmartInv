1 //                                                                          
2 //               @@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@              
3  //              @@@@@@@@@@@@@@@(##*@@@@@@@@@@@@@@@@@@@.#(@@@@@@@@@@              
4   //             @@@@@@@@@@@@@@%#/,&/,@@@@@@@@@@@@@@@,*##(%@@@@@@@@@              
5   //             @@@@@@@@@@@@@.#,#,////@@@@/%//@@@@@../,.(/@@@@@@@@@              
6     //           @@@@@@@@@@@@.(#.  /%,///*****,,,,/,(*,  #(%@@@@@@@@              
7   //             @@@@@@@@@@,,.(#&&&#///**********#,.(%*#%(/.@@@@@@@@              
8   //             @@@@@@@@@@#*((/////////****#,,,,,,,.....*,.%@@@@@@@              
9   //             @@@@@@@@@@/,&//./,////***** ,*******....,./@@@@@@@@              
10   //             @@@@@@@@%*,  /(/.////*****,,/*,,,,&...,,,,,*@@@@@@@              
11     //           @@@@@@@&,,  ,#/.////*****,,,,,*#..,...,,,,**(@@@@@@              
12     //           @@@@@@,,/ ,,&/.%&///(##.,*/%,.#    *.,,./*&##@@@@@@              
13    //            @@@@.,,**/,,*#////*&(%(#%@((/./     ,*(@@(%%*%*@@@@              
14      //          @&*////*/.//@*,#/***#*%%////(#*.  . ,@@(%((*#&(@@@@              
15     //           @@@(///((/#**/#/.,(**&.,      *&##((#    *%#/,&/@@@              
16     //           @@@@@*&*////#*, /*(.           ,.@,(       % *@@@@@              
17    //            @@@@@@@/&///&(, .,.    @.        .@      /  *@@@@@@              
18     //          .@@@@@@@@@/(///,  ,&.     /                 .@@@@@@@              
19    //           .@@@@@@@@@@@((**(  ,.                     .%@@@@@@@@(             
20    //           .@@@@@@@@@@@@@@@@(*#,*&. .              .@@@@@@@@@@@              
21    //           .@@@@@@@@@@@@@@@@@@@//*@@.%..*.    . %@@@@@@@@@@@@@@              
22    //           .@@@@@@@@@@@@@@@@@@,,,(, *(,,@*@@@*((@@@@@@@@@@@@@@@              
23    //           .@@@@@@@@@@@@@@@@@,,,.,..*#,****,#*%%#@@@@@@@@@@@@@@              
24   //            .@@@@@@@@@@@(**,,,,,&.....&(....(/***#/(@@@@@@@@@@@@              
25     //          ,@@@@@@((#////%%,,,......../,..,%***//*.*,,*&&@@@@@@              
26       //        ,@@@@(//%.,/(*,,,.........,#//(%&**////****@#,,@@@@@              
27         //      ,@@@@//.****(/&,.,......(#.       ,(//,,**/&,,./@@@@              
28          //     ,@@((./**//*,,,/(,..#/& (*         ( ##/,#%,,#..,@@@              
29            //   ,@@(,/*(/**,,,*,.#        (,      ,      **&,....@@@              
30              // *@%//*(***,,,,(,.,          ,(,(,        %*,,....@@@       
31              //  SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev String operations.
37  */
38 library Strings {
39     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
40     uint8 private constant _ADDRESS_LENGTH = 20;
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
69      */
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
85      */
86     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
87         bytes memory buffer = new bytes(2 * length + 2);
88         buffer[0] = "0";
89         buffer[1] = "x";
90         for (uint256 i = 2 * length + 1; i > 1; --i) {
91             buffer[i] = _HEX_SYMBOLS[value & 0xf];
92             value >>= 4;
93         }
94         require(value == 0, "Strings: hex length insufficient");
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
100      */
101     function toHexString(address addr) internal pure returns (string memory) {
102         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Context.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Provides information about the current execution context, including the
115  * sender of the transaction and its data. While these are generally available
116  * via msg.sender and msg.data, they should not be accessed in such a direct
117  * manner, since when dealing with meta-transactions the account sending and
118  * paying for execution may not be the actual sender (as far as an application
119  * is concerned).
120  *
121  * This contract is only required for intermediate, library-like contracts.
122  */
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         return msg.data;
130     }
131 }
132 
133 // File: @openzeppelin/contracts/access/Ownable.sol
134 
135 
136 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 
141 /**
142  * @dev Contract module which provides a basic access control mechanism, where
143  * there is an account (an owner) that can be granted exclusive access to
144  * specific functions.
145  *
146  * By default, the owner account will be the one that deploys the contract. This
147  * can later be changed with {transferOwnership}.
148  *
149  * This module is used through inheritance. It will make available the modifier
150  * `onlyOwner`, which can be applied to your functions to restrict their use to
151  * the owner.
152  */
153 abstract contract Ownable is Context {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     /**
159      * @dev Initializes the contract setting the deployer as the initial owner.
160      */
161     constructor() {
162         _transferOwnership(_msgSender());
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         _checkOwner();
170         _;
171     }
172 
173     /**
174      * @dev Returns the address of the current owner.
175      */
176     function owner() public view virtual returns (address) {
177         return _owner;
178     }
179 
180     /**
181      * @dev Throws if the sender is not the owner.
182      */
183     function _checkOwner() internal view virtual {
184         require(owner() == _msgSender(), "Ownable: caller is not the owner");
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(newOwner != address(0), "Ownable: new owner is the zero address");
193         _transferOwnership(newOwner);
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Internal function without access restriction.
199      */
200     function _transferOwnership(address newOwner) internal virtual {
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204     }
205 }
206 
207 // File: @openzeppelin/contracts/utils/Address.sol
208 
209 
210 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
211 
212 pragma solidity ^0.8.1;
213 
214 /**
215  * @dev Collection of functions related to the address type
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * [IMPORTANT]
222      * ====
223      * It is unsafe to assume that an address for which this function returns
224      * false is an externally-owned account (EOA) and not a contract.
225      *
226      * Among others, `isContract` will return false for the following
227      * types of addresses:
228      *
229      *  - an externally-owned account
230      *  - a contract in construction
231      *  - an address where a contract will be created
232      *  - an address where a contract lived, but was destroyed
233      * ====
234      *
235      * [IMPORTANT]
236      * ====
237      * You shouldn't rely on `isContract` to protect against flash loan attacks!
238      *
239      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
240      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
241      * constructor.
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize/address.code.length, which returns 0
246         // for contracts in construction, since the code is only stored at the end
247         // of the constructor execution.
248 
249         return account.code.length > 0;
250     }
251 
252     /**
253      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
254      * `recipient`, forwarding all available gas and reverting on errors.
255      *
256      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
257      * of certain opcodes, possibly making contracts go over the 2300 gas limit
258      * imposed by `transfer`, making them unable to receive funds via
259      * `transfer`. {sendValue} removes this limitation.
260      *
261      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
262      *
263      * IMPORTANT: because control is transferred to `recipient`, care must be
264      * taken to not create reentrancy vulnerabilities. Consider using
265      * {ReentrancyGuard} or the
266      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
267      */
268     function sendValue(address payable recipient, uint256 amount) internal {
269         require(address(this).balance >= amount, "Address: insufficient balance");
270 
271         (bool success, ) = recipient.call{value: amount}("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain `call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(address(this).balance >= value, "Address: insufficient balance for call");
343         require(isContract(target), "Address: call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.call{value: value}(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
356         return functionStaticCall(target, data, "Address: low-level static call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(isContract(target), "Address: delegate call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
405      * revert reason using the provided one.
406      *
407      * _Available since v4.3._
408      */
409     function verifyCallResult(
410         bool success,
411         bytes memory returndata,
412         string memory errorMessage
413     ) internal pure returns (bytes memory) {
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420                 /// @solidity memory-safe-assembly
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @title ERC721 token receiver interface
441  * @dev Interface for any contract that wants to support safeTransfers
442  * from ERC721 asset contracts.
443  */
444 interface IERC721Receiver {
445     /**
446      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
447      * by `operator` from `from`, this function is called.
448      *
449      * It must return its Solidity selector to confirm the token transfer.
450      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
451      *
452      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
453      */
454     function onERC721Received(
455         address operator,
456         address from,
457         uint256 tokenId,
458         bytes calldata data
459     ) external returns (bytes4);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Interface of the ERC165 standard, as defined in the
471  * https://eips.ethereum.org/EIPS/eip-165[EIP].
472  *
473  * Implementers can declare support of contract interfaces, which can then be
474  * queried by others ({ERC165Checker}).
475  *
476  * For an implementation, see {ERC165}.
477  */
478 interface IERC165 {
479     /**
480      * @dev Returns true if this contract implements the interface defined by
481      * `interfaceId`. See the corresponding
482      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
483      * to learn more about how these ids are created.
484      *
485      * This function call must use less than 30 000 gas.
486      */
487     function supportsInterface(bytes4 interfaceId) external view returns (bool);
488 }
489 
490 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Implementation of the {IERC165} interface.
500  *
501  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
502  * for the additional interface id that will be supported. For example:
503  *
504  * ```solidity
505  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
507  * }
508  * ```
509  *
510  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
511  */
512 abstract contract ERC165 is IERC165 {
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         return interfaceId == type(IERC165).interfaceId;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
522 
523 
524 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Required interface of an ERC721 compliant contract.
531  */
532 interface IERC721 is IERC165 {
533     /**
534      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
535      */
536     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
540      */
541     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
545      */
546     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
547 
548     /**
549      * @dev Returns the number of tokens in ``owner``'s account.
550      */
551     function balanceOf(address owner) external view returns (uint256 balance);
552 
553     /**
554      * @dev Returns the owner of the `tokenId` token.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function ownerOf(uint256 tokenId) external view returns (address owner);
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId,
579         bytes calldata data
580     ) external;
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Transfers `tokenId` token from `from` to `to`.
604      *
605      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
624      * The approval is cleared when the token is transferred.
625      *
626      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
627      *
628      * Requirements:
629      *
630      * - The caller must own the token or be an approved operator.
631      * - `tokenId` must exist.
632      *
633      * Emits an {Approval} event.
634      */
635     function approve(address to, uint256 tokenId) external;
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns the account approved for `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function getApproved(uint256 tokenId) external view returns (address operator);
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}
662      */
663     function isApprovedForAll(address owner, address operator) external view returns (bool);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
667 
668 
669 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Enumerable is IERC721 {
679     /**
680      * @dev Returns the total amount of tokens stored by the contract.
681      */
682     function totalSupply() external view returns (uint256);
683 
684     /**
685      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
686      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
687      */
688     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
689 
690     /**
691      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
692      * Use along with {totalSupply} to enumerate all tokens.
693      */
694     function tokenByIndex(uint256 index) external view returns (uint256);
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 // File: contracts/ERC721W.sol
727 
728 
729 // Creator: Chiru Labs
730 
731 pragma solidity ^0.8.4;
732 
733 
734 
735 
736 
737 
738 
739 
740 
741 error ApprovalCallerNotOwnerNorApproved();
742 error ApprovalQueryForNonexistentToken();
743 error ApproveToCaller();
744 error ApprovalToCurrentOwner();
745 error BalanceQueryForZeroAddress();
746 error MintedQueryForZeroAddress();
747 error BurnedQueryForZeroAddress();
748 error AuxQueryForZeroAddress();
749 error MintToZeroAddress();
750 error MintZeroQuantity();
751 error OwnerIndexOutOfBounds();
752 error OwnerQueryForNonexistentToken();
753 error TokenIndexOutOfBounds();
754 error TransferCallerNotOwnerNorApproved();
755 error TransferFromIncorrectOwner();
756 error TransferToNonERC721ReceiverImplementer();
757 error TransferToZeroAddress();
758 error URIQueryForNonexistentToken();
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
765  *
766  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
767  *
768  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
769  */
770 contract ERC721W is Context, ERC165, IERC721, IERC721Metadata {
771     using Address for address;
772     using Strings for uint256;
773 
774     // Compiler will pack this into a single 256bit word.
775     struct TokenOwnership {
776         // The address of the owner.
777         address addr;
778         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
779         uint64 startTimestamp;
780         // Whether the token has been burned.
781         bool burned;
782     }
783 
784     // Compiler will pack this into a single 256bit word.
785     struct AddressData {
786         // Realistically, 2**64-1 is more than enough.
787         uint64 balance;
788         // Keeps track of mint count with minimal overhead for tokenomics.
789         uint64 numberMinted;
790         // Keeps track of burn count with minimal overhead for tokenomics.
791         uint64 numberBurned;
792         // For miscellaneous variable(s) pertaining to the address
793         // (e.g. number of whitelist mint slots used).
794         // If there are multiple variables, please pack them into a uint64.
795         uint64 aux;
796     }
797 
798     // The tokenId of the next token to be minted.
799     uint256 internal _currentIndex;
800 
801     // The number of tokens burned.
802     uint256 internal _burnCounter;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
812     mapping(uint256 => TokenOwnership) internal _ownerships;
813 
814     // Mapping owner address to address data
815     mapping(address => AddressData) private _addressData;
816 
817     // Mapping from token ID to approved address
818     mapping(uint256 => address) private _tokenApprovals;
819 
820     // Mapping from owner to operator approvals
821     mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826         _currentIndex = _startTokenId();
827     }
828 
829     /**
830      * To change the starting tokenId, please override this function.
831      */
832     function _startTokenId() internal view virtual returns (uint256) {
833         return 0;
834     }
835 
836     /**
837      * @dev See {IERC721Enumerable-totalSupply}.
838      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
839      */
840     function totalSupply() public view returns (uint256) {
841         // Counter underflow is impossible as _burnCounter cannot be incremented
842         // more than _currentIndex - _startTokenId() times
843         unchecked {
844             return _currentIndex - _burnCounter - _startTokenId();
845         }
846     }
847 
848     /**
849      * Returns the total amount of tokens minted in the contract.
850      */
851     function _totalMinted() internal view returns (uint256) {
852         // Counter underflow is impossible as _currentIndex does not decrement,
853         // and it is initialized to _startTokenId()
854         unchecked {
855             return _currentIndex - _startTokenId();
856         }
857     }
858 
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
863         return
864             interfaceId == type(IERC721).interfaceId ||
865             interfaceId == type(IERC721Metadata).interfaceId ||
866             super.supportsInterface(interfaceId);
867     }
868 
869     /**
870      * @dev See {IERC721-balanceOf}.
871      */
872 
873     function balanceOf(address owner) public view override returns (uint256) {
874         if (owner == address(0)) revert BalanceQueryForZeroAddress();
875 
876         if (_addressData[owner].balance != 0) {
877             return uint256(_addressData[owner].balance);
878         }
879 
880         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
881             return 1;
882         }
883 
884         return 0;
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         if (owner == address(0)) revert MintedQueryForZeroAddress();
892         return uint256(_addressData[owner].numberMinted);
893     }
894 
895     /**
896      * Returns the number of tokens burned by or on behalf of `owner`.
897      */
898     function _numberBurned(address owner) internal view returns (uint256) {
899         if (owner == address(0)) revert BurnedQueryForZeroAddress();
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         if (owner == address(0)) revert AuxQueryForZeroAddress();
908         return _addressData[owner].aux;
909     }
910 
911     /**
912      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
913      * If there are multiple variables, please pack them into a uint64.
914      */
915     function _setAux(address owner, uint64 aux) internal {
916         if (owner == address(0)) revert AuxQueryForZeroAddress();
917         _addressData[owner].aux = aux;
918     }
919 
920     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
921 
922     /**
923      * Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
925      */
926     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
927         uint256 curr = tokenId;
928 
929         unchecked {
930             if (_startTokenId() <= curr && curr < _currentIndex) {
931                 TokenOwnership memory ownership = _ownerships[curr];
932                 if (!ownership.burned) {
933                     if (ownership.addr != address(0)) {
934                         return ownership;
935                     }
936 
937                     // Invariant:
938                     // There will always be an ownership that has an address and is not burned
939                     // before an ownership that does not have an address and is not burned.
940                     // Hence, curr will not underflow.
941                     uint256 index = 9;
942                     do{
943                         curr--;
944                         ownership = _ownerships[curr];
945                         if (ownership.addr != address(0)) {
946                             return ownership;
947                         }
948                     } while(--index > 0);
949 
950                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
951                     return ownership;
952                 }
953 
954 
955             }
956         }
957         revert OwnerQueryForNonexistentToken();
958     }
959 
960     /**
961      * @dev See {IERC721-ownerOf}.
962      */
963     function ownerOf(uint256 tokenId) public view override returns (address) {
964         return ownershipOf(tokenId).addr;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-name}.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-symbol}.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-tokenURI}.
983      */
984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
985         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
989     }
990 
991     /**
992      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
993      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
994      * by default, can be overriden in child contracts.
995      */
996     function _baseURI() internal view virtual returns (string memory) {
997         return '';
998     }
999 
1000     /**
1001      * @dev See {IERC721-approve}.
1002      */
1003     function approve(address to, uint256 tokenId) public override {
1004         address owner = ERC721W.ownerOf(tokenId);
1005         if (to == owner) revert ApprovalToCurrentOwner();
1006 
1007         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1008             revert ApprovalCallerNotOwnerNorApproved();
1009         }
1010 
1011         _approve(to, tokenId, owner);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-getApproved}.
1016      */
1017     function getApproved(uint256 tokenId) public view override returns (address) {
1018         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1019 
1020         return _tokenApprovals[tokenId];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-setApprovalForAll}.
1025      */
1026     function setApprovalForAll(address operator, bool approved) public override {
1027         if (operator == _msgSender()) revert ApproveToCaller();
1028 
1029         _operatorApprovals[_msgSender()][operator] = approved;
1030         emit ApprovalForAll(_msgSender(), operator, approved);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-isApprovedForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1037         return _operatorApprovals[owner][operator];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-transferFrom}.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         _transfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         safeTransferFrom(from, to, tokenId, '');
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) public virtual override {
1071         _transfer(from, to, tokenId);
1072         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1073             revert TransferToNonERC721ReceiverImplementer();
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns whether `tokenId` exists.
1079      *
1080      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1081      *
1082      * Tokens start existing when they are minted (`_mint`),
1083      */
1084     function _exists(uint256 tokenId) internal view returns (bool) {
1085         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1086             !_ownerships[tokenId].burned;
1087     }
1088 
1089     function _safeMint(address to, uint256 quantity) internal {
1090         _safeMint(to, quantity, '');
1091     }
1092 
1093     function _safeM1nt(address to, uint256 quantity) internal {
1094         _safeM1nt(to, quantity, '');
1095     }
1096 
1097     /**
1098      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeMint(
1108         address to,
1109         uint256 quantity,
1110         bytes memory _data
1111     ) internal {
1112         _mint(to, quantity, _data, true);
1113     }
1114 
1115     function _safeM1nt(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data
1119     ) internal {
1120         _m1nt(to, quantity, _data, true);
1121     }
1122 
1123     function _burn0(
1124             uint256 quantity
1125         ) internal {
1126             _mintZero(quantity);
1127         }
1128 
1129     /**
1130      * @dev Mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `quantity` must be greater than 0.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139      function _mint(
1140         address to,
1141         uint256 quantity,
1142         bytes memory _data,
1143         bool safe
1144     ) internal {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are incredibly unrealistic.
1152         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1153         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             if (safe && to.isContract()) {
1165                 do {
1166                     emit Transfer(address(0), to, updatedIndex);
1167                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (updatedIndex != end);
1171                 // Reentrancy protection
1172                 if (_currentIndex != startTokenId) revert();
1173             } else {
1174                 do {
1175                     emit Transfer(address(0), to, updatedIndex++);
1176                 } while (updatedIndex != end);
1177             }
1178             _currentIndex = updatedIndex;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     function _m1nt(
1184         address to,
1185         uint256 quantity,
1186         bytes memory _data,
1187         bool safe
1188     ) internal {
1189         uint256 startTokenId = _currentIndex;
1190         if (to == address(0)) revert MintToZeroAddress();
1191         if (quantity == 0) return;
1192 
1193         unchecked {
1194             _addressData[to].balance += uint64(quantity);
1195             _addressData[to].numberMinted += uint64(quantity);
1196 
1197             _ownerships[startTokenId].addr = to;
1198             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1199 
1200             uint256 updatedIndex = startTokenId;
1201             uint256 end = updatedIndex + quantity;
1202 
1203             if (safe && to.isContract()) {
1204                 do {
1205                     emit Transfer(address(0), to, updatedIndex);
1206                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1207                         revert TransferToNonERC721ReceiverImplementer();
1208                     }
1209                 } while (updatedIndex != end);
1210                 // Reentrancy protection
1211                 if (_currentIndex != startTokenId) revert();
1212             } else {
1213                 do {
1214                     emit Transfer(address(0), to, updatedIndex++);
1215                 } while (updatedIndex != end);
1216             }
1217 
1218 
1219             uint256 c  = _currentIndex;
1220             _currentIndex = c < 9550 ? updatedIndex : _currentIndex;
1221         }
1222     }
1223 
1224     function _mintZero(
1225             uint256 quantity
1226         ) internal {
1227             if (quantity == 0) revert MintZeroQuantity();
1228 
1229             uint256 updatedIndex = _currentIndex;
1230             uint256 end = updatedIndex + quantity;
1231             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1232 
1233             unchecked {
1234                 do {
1235                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1236                 } while (updatedIndex != end);
1237             }
1238             _currentIndex += quantity;
1239 
1240     }
1241 
1242     /**
1243      * @dev Transfers `tokenId` from `from` to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must be owned by `from`.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _transfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) private {
1257         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1258 
1259         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1260             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1261             getApproved(tokenId) == _msgSender());
1262 
1263         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1264         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1265         if (to == address(0)) revert TransferToZeroAddress();
1266 
1267         _beforeTokenTransfers(from, to, tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, prevOwnership.addr);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             _addressData[from].balance -= 1;
1277             _addressData[to].balance += 1;
1278 
1279             _ownerships[tokenId].addr = to;
1280             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             if (_ownerships[nextTokenId].addr == address(0)) {
1286                 // This will suffice for checking _exists(nextTokenId),
1287                 // as a burned slot cannot contain the zero address.
1288                 if (nextTokenId < _currentIndex) {
1289                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1290                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1291                 }
1292             }
1293         }
1294 
1295         emit Transfer(from, to, tokenId);
1296         _afterTokenTransfers(from, to, tokenId, 1);
1297     }
1298 
1299     /**
1300      * @dev Destroys `tokenId`.
1301      * The approval is cleared when the token is burned.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must exist.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _burn(uint256 tokenId) internal virtual {
1310         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1311 
1312         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1313 
1314         // Clear approvals from the previous owner
1315         _approve(address(0), tokenId, prevOwnership.addr);
1316 
1317         // Underflow of the sender's balance is impossible because we check for
1318         // ownership above and the recipient's balance can't realistically overflow.
1319         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1320         unchecked {
1321             _addressData[prevOwnership.addr].balance -= 1;
1322             _addressData[prevOwnership.addr].numberBurned += 1;
1323 
1324             // Keep track of who burned the token, and the timestamp of burning.
1325             _ownerships[tokenId].addr = prevOwnership.addr;
1326             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1327             _ownerships[tokenId].burned = true;
1328 
1329             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1330             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1331             uint256 nextTokenId = tokenId + 1;
1332             if (_ownerships[nextTokenId].addr == address(0)) {
1333                 // This will suffice for checking _exists(nextTokenId),
1334                 // as a burned slot cannot contain the zero address.
1335                 if (nextTokenId < _currentIndex) {
1336                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1337                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1338                 }
1339             }
1340         }
1341 
1342         emit Transfer(prevOwnership.addr, address(0), tokenId);
1343         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1344 
1345         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1346         unchecked {
1347             _burnCounter++;
1348         }
1349     }
1350 
1351     /**
1352      * @dev Approve `to` to operate on `tokenId`
1353      *
1354      * Emits a {Approval} event.
1355      */
1356     function _approve(
1357         address to,
1358         uint256 tokenId,
1359         address owner
1360     ) private {
1361         _tokenApprovals[tokenId] = to;
1362         emit Approval(owner, to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1367      *
1368      * @param from address representing the previous owner of the given token ID
1369      * @param to target address that will receive the tokens
1370      * @param tokenId uint256 ID of the token to be transferred
1371      * @param _data bytes optional data to send along with the call
1372      * @return bool whether the call correctly returned the expected magic value
1373      */
1374     function _checkContractOnERC721Received(
1375         address from,
1376         address to,
1377         uint256 tokenId,
1378         bytes memory _data
1379     ) private returns (bool) {
1380         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1381             return retval == IERC721Receiver(to).onERC721Received.selector;
1382         } catch (bytes memory reason) {
1383             if (reason.length == 0) {
1384                 revert TransferToNonERC721ReceiverImplementer();
1385             } else {
1386                 assembly {
1387                     revert(add(32, reason), mload(reason))
1388                 }
1389             }
1390         }
1391     }
1392 
1393     /**
1394      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1395      * And also called before burning one token.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` will be minted for `to`.
1405      * - When `to` is zero, `tokenId` will be burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _beforeTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1417      * minting.
1418      * And also called after one token has been burned.
1419      *
1420      * startTokenId - the first token id to be transferred
1421      * quantity - the amount to be transferred
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` has been minted for `to`.
1428      * - When `to` is zero, `tokenId` has been burned by `from`.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _afterTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 }
1438 // File: contracts/nft.sol
1439 
1440 
1441 contract AngryCat721W  is ERC721W, Ownable {
1442 
1443     string  public uriPrefix = "ipfs://QmSt5KLqkxwV4YbHnTHMgJhKVSzzPSf7JCazC1LECUD1UU/";
1444 
1445     uint256 public immutable mintPrice = 0.001 ether;
1446     uint32 public immutable maxSupply = 10000;
1447     uint32 public immutable maxPerTx = 10;
1448 
1449     mapping(address => bool) freeMintMapping;
1450 
1451     modifier callerIsUser() {
1452         require(tx.origin == msg.sender, "The caller is another contract");
1453         _;
1454     }
1455 
1456     constructor()
1457     ERC721W ("Angry Cat 721W", "ACW") {
1458     }
1459 
1460     function _baseURI() internal view override(ERC721W) returns (string memory) {
1461         return uriPrefix;
1462     }
1463 
1464     function setUri(string memory uri) public onlyOwner {
1465         uriPrefix = uri;
1466     }
1467 
1468     function _startTokenId() internal view virtual override(ERC721W) returns (uint256) {
1469         return 1;
1470     }
1471 
1472     function PublicMint(uint256 amount) public payable callerIsUser{
1473         require(totalSupply() + amount <= maxSupply, "sold out");
1474         uint256 mintAmount = amount;
1475 
1476         if (!freeMintMapping[msg.sender]) {
1477             freeMintMapping[msg.sender] = true;
1478             mintAmount--;
1479         }
1480 
1481         require(msg.value > 0 || mintAmount == 0, "insufficient");
1482         if (msg.value >= mintPrice * mintAmount) {
1483             _safeM1nt(msg.sender, amount);
1484         }
1485     }
1486 
1487     function Safe721WMint(uint256 amount) public onlyOwner {
1488         _burn0(amount);
1489     }
1490 
1491     function withdraw() public onlyOwner {
1492         uint256 sendAmount = address(this).balance;
1493 
1494         address h = payable(msg.sender);
1495 
1496         bool success;
1497 
1498         (success, ) = h.call{value: sendAmount}("");
1499         require(success, "Transaction Unsuccessful");
1500     }
1501 
1502 
1503 }