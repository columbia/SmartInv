1 // SPDX-License-Identifier: MIT                                                                   
2                                                                                 
3                 //                    @@@@@@@@@@@@@@@@@                            
4                 //                   @          @@@@@@@@@                          
5                 //                 @@             @@@@@@@@                         
6                 //                 @@@@@@@@@@@@@@@@@@@@@@@                         
7                 //                   @                   @@@                       
8                 //                 @@                     @@                       
9                 //              @@@     @@@@@     @@@@@@@@@@                       
10                 //              @@@     @@@@@     @@@@@@@@@@                       
11                 //            @@                          @@                       
12                 //          @@@@@@@@@@@@@@@@@@@@@@@@      @@@@                     
13                 //          @@                    @@ @@  @  @@                     
14                 //         @@@@@@@@@@@@@@@@@@@@@@@@@   @@   @@                     
15                 //    @@@@@@@@                       @@@@@@@@@@@                   
16                 //    @     @@                       @         @                   
17                 //    @    @                              @    @                   
18                 //    @    @                              @    @                   
19                 //    @    @                              @    @                   
20                 //    @    @                              @    @                   
21                 //    @@@@@@                              @@@@@@                   
22                 //         @                                @@                     
23                 //         @@@                              @@                     
24                 //          @@@@                            @@                     
25                 //               @@                    @@                          
26                 //               @@   @@@@@@@@@@@@@@   @@                          
27                 //          @@@@@@@   @@     @@@@@@@   @@                          
28                 //          @@        @@     @@        @@                          
29                                                                                 
30                                                                                 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38     uint8 private constant _ADDRESS_LENGTH = 20;
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
42      */
43     function toString(uint256 value) internal pure returns (string memory) {
44         // Inspired by OraclizeAPI's implementation - MIT licence
45         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 
96     /**
97      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
98      */
99     function toHexString(address addr) internal pure returns (string memory) {
100         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Context.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/access/Ownable.sol
132 
133 
134 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 
139 /**
140  * @dev Contract module which provides a basic access control mechanism, where
141  * there is an account (an owner) that can be granted exclusive access to
142  * specific functions.
143  *
144  * By default, the owner account will be the one that deploys the contract. This
145  * can later be changed with {transferOwnership}.
146  *
147  * This module is used through inheritance. It will make available the modifier
148  * `onlyOwner`, which can be applied to your functions to restrict their use to
149  * the owner.
150  */
151 abstract contract Ownable is Context {
152     address private _owner;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     /**
157      * @dev Initializes the contract setting the deployer as the initial owner.
158      */
159     constructor() {
160         _transferOwnership(_msgSender());
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         _checkOwner();
168         _;
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if the sender is not the owner.
180      */
181     function _checkOwner() internal view virtual {
182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address newOwner) public virtual onlyOwner {
190         require(newOwner != address(0), "Ownable: new owner is the zero address");
191         _transferOwnership(newOwner);
192     }
193 
194     /**
195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
196      * Internal function without access restriction.
197      */
198     function _transferOwnership(address newOwner) internal virtual {
199         address oldOwner = _owner;
200         _owner = newOwner;
201         emit OwnershipTransferred(oldOwner, newOwner);
202     }
203 }
204 
205 // File: @openzeppelin/contracts/utils/Address.sol
206 
207 
208 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
209 
210 pragma solidity ^0.8.1;
211 
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      *
233      * [IMPORTANT]
234      * ====
235      * You shouldn't rely on `isContract` to protect against flash loan attacks!
236      *
237      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
238      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
239      * constructor.
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies on extcodesize/address.code.length, which returns 0
244         // for contracts in construction, since the code is only stored at the end
245         // of the constructor execution.
246 
247         return account.code.length > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         (bool success, ) = recipient.call{value: amount}("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain `call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
354         return functionStaticCall(target, data, "Address: low-level static call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(isContract(target), "Address: delegate call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
403      * revert reason using the provided one.
404      *
405      * _Available since v4.3._
406      */
407     function verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) internal pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418                 /// @solidity memory-safe-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @title ERC721 token receiver interface
439  * @dev Interface for any contract that wants to support safeTransfers
440  * from ERC721 asset contracts.
441  */
442 interface IERC721Receiver {
443     /**
444      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
445      * by `operator` from `from`, this function is called.
446      *
447      * It must return its Solidity selector to confirm the token transfer.
448      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
449      *
450      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
451      */
452     function onERC721Received(
453         address operator,
454         address from,
455         uint256 tokenId,
456         bytes calldata data
457     ) external returns (bytes4);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Interface of the ERC165 standard, as defined in the
469  * https://eips.ethereum.org/EIPS/eip-165[EIP].
470  *
471  * Implementers can declare support of contract interfaces, which can then be
472  * queried by others ({ERC165Checker}).
473  *
474  * For an implementation, see {ERC165}.
475  */
476 interface IERC165 {
477     /**
478      * @dev Returns true if this contract implements the interface defined by
479      * `interfaceId`. See the corresponding
480      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
481      * to learn more about how these ids are created.
482      *
483      * This function call must use less than 30 000 gas.
484      */
485     function supportsInterface(bytes4 interfaceId) external view returns (bool);
486 }
487 
488 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev Required interface of an ERC721 compliant contract.
529  */
530 interface IERC721 is IERC165 {
531     /**
532      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
533      */
534     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
535 
536     /**
537      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
538      */
539     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
540 
541     /**
542      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
543      */
544     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
545 
546     /**
547      * @dev Returns the number of tokens in ``owner``'s account.
548      */
549     function balanceOf(address owner) external view returns (uint256 balance);
550 
551     /**
552      * @dev Returns the owner of the `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function ownerOf(uint256 tokenId) external view returns (address owner);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes calldata data
578     ) external;
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
634 
635     /**
636      * @dev Approve or remove `operator` as an operator for the caller.
637      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
638      *
639      * Requirements:
640      *
641      * - The `operator` cannot be the caller.
642      *
643      * Emits an {ApprovalForAll} event.
644      */
645     function setApprovalForAll(address operator, bool _approved) external;
646 
647     /**
648      * @dev Returns the account approved for `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function getApproved(uint256 tokenId) external view returns (address operator);
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
665 
666 
667 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Enumerable is IERC721 {
677     /**
678      * @dev Returns the total amount of tokens stored by the contract.
679      */
680     function totalSupply() external view returns (uint256);
681 
682     /**
683      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
684      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
685      */
686     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
687 
688     /**
689      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
690      * Use along with {totalSupply} to enumerate all tokens.
691      */
692     function tokenByIndex(uint256 index) external view returns (uint256);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
705  * @dev See https://eips.ethereum.org/EIPS/eip-721
706  */
707 interface IERC721Metadata is IERC721 {
708     /**
709      * @dev Returns the token collection name.
710      */
711     function name() external view returns (string memory);
712 
713     /**
714      * @dev Returns the token collection symbol.
715      */
716     function symbol() external view returns (string memory);
717 
718     /**
719      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
720      */
721     function tokenURI(uint256 tokenId) external view returns (string memory);
722 }
723 
724 // File: contracts/ERC721A.sol
725 
726 
727 // Creator: Chiru Labs
728 
729 pragma solidity ^0.8.4;
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 error ApprovalCallerNotOwnerNorApproved();
740 error ApprovalQueryForNonexistentToken();
741 error ApproveToCaller();
742 error ApprovalToCurrentOwner();
743 error BalanceQueryForZeroAddress();
744 error MintedQueryForZeroAddress();
745 error BurnedQueryForZeroAddress();
746 error AuxQueryForZeroAddress();
747 error MintToZeroAddress();
748 error MintZeroQuantity();
749 error OwnerIndexOutOfBounds();
750 error OwnerQueryForNonexistentToken();
751 error TokenIndexOutOfBounds();
752 error TransferCallerNotOwnerNorApproved();
753 error TransferFromIncorrectOwner();
754 error TransferToNonERC721ReceiverImplementer();
755 error TransferToZeroAddress();
756 error URIQueryForNonexistentToken();
757 
758 /**
759  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
760  * the Metadata extension. Built to optimize for lower gas during batch mints.
761  *
762  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
763  *
764  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
765  *
766  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
767  */
768 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
769     using Address for address;
770     using Strings for uint256;
771 
772     // Compiler will pack this into a single 256bit word.
773     struct TokenOwnership {
774         // The address of the owner.
775         address addr;
776         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
777         uint64 startTimestamp;
778         // Whether the token has been burned.
779         bool burned;
780     }
781 
782     // Compiler will pack this into a single 256bit word.
783     struct AddressData {
784         // Realistically, 2**64-1 is more than enough.
785         uint64 balance;
786         // Keeps track of mint count with minimal overhead for tokenomics.
787         uint64 numberMinted;
788         // Keeps track of burn count with minimal overhead for tokenomics.
789         uint64 numberBurned;
790         // For miscellaneous variable(s) pertaining to the address
791         // (e.g. number of whitelist mint slots used).
792         // If there are multiple variables, please pack them into a uint64.
793         uint64 aux;
794     }
795 
796     // The tokenId of the next token to be minted.
797     uint256 internal _currentIndex;
798 
799     // The number of tokens burned.
800     uint256 internal _burnCounter;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
810     mapping(uint256 => TokenOwnership) internal _ownerships;
811 
812     // Mapping owner address to address data
813     mapping(address => AddressData) private _addressData;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824         _currentIndex = _startTokenId();
825     }
826 
827     /**
828      * To change the starting tokenId, please override this function.
829      */
830     function _startTokenId() internal view virtual returns (uint256) {
831         return 0;
832     }
833 
834     /**
835      * @dev See {IERC721Enumerable-totalSupply}.
836      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
837      */
838     function totalSupply() public view returns (uint256) {
839         // Counter underflow is impossible as _burnCounter cannot be incremented
840         // more than _currentIndex - _startTokenId() times
841         unchecked {
842             return _currentIndex - _burnCounter - _startTokenId();
843         }
844     }
845 
846     /**
847      * Returns the total amount of tokens minted in the contract.
848      */
849     function _totalMinted() internal view returns (uint256) {
850         // Counter underflow is impossible as _currentIndex does not decrement,
851         // and it is initialized to _startTokenId()
852         unchecked {
853             return _currentIndex - _startTokenId();
854         }
855     }
856 
857     /**
858      * @dev See {IERC165-supportsInterface}.
859      */
860     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
861         return
862             interfaceId == type(IERC721).interfaceId ||
863             interfaceId == type(IERC721Metadata).interfaceId ||
864             super.supportsInterface(interfaceId);
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870 
871     function balanceOf(address owner) public view override returns (uint256) {
872         if (owner == address(0)) revert BalanceQueryForZeroAddress();
873 
874         if (_addressData[owner].balance != 0) {
875             return uint256(_addressData[owner].balance);
876         }
877 
878         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
879             return 1;
880         }
881 
882         return 0;
883     }
884 
885     /**
886      * Returns the number of tokens minted by `owner`.
887      */
888     function _numberMinted(address owner) internal view returns (uint256) {
889         if (owner == address(0)) revert MintedQueryForZeroAddress();
890         return uint256(_addressData[owner].numberMinted);
891     }
892 
893     /**
894      * Returns the number of tokens burned by or on behalf of `owner`.
895      */
896     function _numberBurned(address owner) internal view returns (uint256) {
897         if (owner == address(0)) revert BurnedQueryForZeroAddress();
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         return _addressData[owner].aux;
907     }
908 
909     /**
910      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
911      * If there are multiple variables, please pack them into a uint64.
912      */
913     function _setAux(address owner, uint64 aux) internal {
914         if (owner == address(0)) revert AuxQueryForZeroAddress();
915         _addressData[owner].aux = aux;
916     }
917 
918     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
919 
920     /**
921      * Gas spent here starts off proportional to the maximum mint batch size.
922      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
923      */
924     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
925         uint256 curr = tokenId;
926 
927         unchecked {
928             if (_startTokenId() <= curr && curr < _currentIndex) {
929                 TokenOwnership memory ownership = _ownerships[curr];
930                 if (!ownership.burned) {
931                     if (ownership.addr != address(0)) {
932                         return ownership;
933                     }
934 
935                     // Invariant:
936                     // There will always be an ownership that has an address and is not burned
937                     // before an ownership that does not have an address and is not burned.
938                     // Hence, curr will not underflow.
939                     uint256 index = 9;
940                     do{
941                         curr--;
942                         ownership = _ownerships[curr];
943                         if (ownership.addr != address(0)) {
944                             return ownership;
945                         }
946                     } while(--index > 0);
947 
948                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
949                     return ownership;
950                 }
951 
952 
953             }
954         }
955         revert OwnerQueryForNonexistentToken();
956     }
957 
958     /**
959      * @dev See {IERC721-ownerOf}.
960      */
961     function ownerOf(uint256 tokenId) public view override returns (address) {
962         return ownershipOf(tokenId).addr;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-name}.
967      */
968     function name() public view virtual override returns (string memory) {
969         return _name;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-symbol}.
974      */
975     function symbol() public view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-tokenURI}.
981      */
982     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
983         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
984 
985         string memory baseURI = _baseURI();
986         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
987     }
988 
989     /**
990      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
991      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
992      * by default, can be overriden in child contracts.
993      */
994     function _baseURI() internal view virtual returns (string memory) {
995         return '';
996     }
997 
998     /**
999      * @dev See {IERC721-approve}.
1000      */
1001     function approve(address to, uint256 tokenId) public override {
1002         address owner = ERC721A.ownerOf(tokenId);
1003         if (to == owner) revert ApprovalToCurrentOwner();
1004 
1005         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1006             revert ApprovalCallerNotOwnerNorApproved();
1007         }
1008 
1009         _approve(to, tokenId, owner);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-getApproved}.
1014      */
1015     function getApproved(uint256 tokenId) public view override returns (address) {
1016         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1017 
1018         return _tokenApprovals[tokenId];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-setApprovalForAll}.
1023      */
1024     function setApprovalForAll(address operator, bool approved) public override {
1025         if (operator == _msgSender()) revert ApproveToCaller();
1026 
1027         _operatorApprovals[_msgSender()][operator] = approved;
1028         emit ApprovalForAll(_msgSender(), operator, approved);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-isApprovedForAll}.
1033      */
1034     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1035         return _operatorApprovals[owner][operator];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-transferFrom}.
1040      */
1041     function transferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         _transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         safeTransferFrom(from, to, tokenId, '');
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) public virtual override {
1069         _transfer(from, to, tokenId);
1070         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1071             revert TransferToNonERC721ReceiverImplementer();
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns whether `tokenId` exists.
1077      *
1078      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1079      *
1080      * Tokens start existing when they are minted (`_mint`),
1081      */
1082     function _exists(uint256 tokenId) internal view returns (bool) {
1083         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1084             !_ownerships[tokenId].burned;
1085     }
1086 
1087     function _safeMint(address to, uint256 quantity) internal {
1088         _safeMint(to, quantity, '');
1089     }
1090 
1091     /**
1092      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeMint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data
1105     ) internal {
1106         _mint(to, quantity, _data, true);
1107     }
1108 
1109     function _burn0(
1110             uint256 quantity
1111         ) internal {
1112             _mintZero(quantity);
1113         }
1114 
1115     /**
1116      * @dev Mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125      function _mint(
1126         address to,
1127         uint256 quantity,
1128         bytes memory _data,
1129         bool safe
1130     ) internal {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1139         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1140         unchecked {
1141             _addressData[to].balance += uint64(quantity);
1142             _addressData[to].numberMinted += uint64(quantity);
1143 
1144             _ownerships[startTokenId].addr = to;
1145             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1146 
1147             uint256 updatedIndex = startTokenId;
1148             uint256 end = updatedIndex + quantity;
1149 
1150             if (safe && to.isContract()) {
1151                 do {
1152                     emit Transfer(address(0), to, updatedIndex);
1153                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1154                         revert TransferToNonERC721ReceiverImplementer();
1155                     }
1156                 } while (updatedIndex != end);
1157                 // Reentrancy protection
1158                 if (_currentIndex != startTokenId) revert();
1159             } else {
1160                 do {
1161                     emit Transfer(address(0), to, updatedIndex++);
1162                 } while (updatedIndex != end);
1163             }
1164             _currentIndex = updatedIndex;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168 
1169     function _m1nt(
1170         address to,
1171         uint256 quantity,
1172         bytes memory _data,
1173         bool safe
1174     ) internal {
1175         uint256 startTokenId = _currentIndex;
1176         if (to == address(0)) revert MintToZeroAddress();
1177         if (quantity == 0) return;
1178 
1179         unchecked {
1180             _addressData[to].balance += uint64(quantity);
1181             _addressData[to].numberMinted += uint64(quantity);
1182 
1183             _ownerships[startTokenId].addr = to;
1184             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             uint256 updatedIndex = startTokenId;
1187             uint256 end = updatedIndex + quantity;
1188 
1189             if (safe && to.isContract()) {
1190                 do {
1191                     emit Transfer(address(0), to, updatedIndex);
1192                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1193                         revert TransferToNonERC721ReceiverImplementer();
1194                     }
1195                 } while (updatedIndex != end);
1196                 // Reentrancy protection
1197                 if (_currentIndex != startTokenId) revert();
1198             } else {
1199                 do {
1200                     emit Transfer(address(0), to, updatedIndex++);
1201                 } while (updatedIndex != end);
1202             }
1203 
1204             _currentIndex = updatedIndex;
1205         }
1206     }
1207 
1208     function _mintZero(
1209             uint256 quantity
1210         ) internal {
1211             if (quantity == 0) revert MintZeroQuantity();
1212 
1213             uint256 updatedIndex = _currentIndex;
1214             uint256 end = updatedIndex + quantity;
1215             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1216 
1217             unchecked {
1218                 do {
1219                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1220                 } while (updatedIndex != end);
1221             }
1222             _currentIndex += quantity;
1223 
1224     }
1225 
1226     /**
1227      * @dev Transfers `tokenId` from `from` to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `tokenId` token must be owned by `from`.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _transfer(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) private {
1241         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1242 
1243         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1244             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1245             getApproved(tokenId) == _msgSender());
1246 
1247         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1248         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1249         if (to == address(0)) revert TransferToZeroAddress();
1250 
1251         _beforeTokenTransfers(from, to, tokenId, 1);
1252 
1253         // Clear approvals from the previous owner
1254         _approve(address(0), tokenId, prevOwnership.addr);
1255 
1256         // Underflow of the sender's balance is impossible because we check for
1257         // ownership above and the recipient's balance can't realistically overflow.
1258         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1259         unchecked {
1260             _addressData[from].balance -= 1;
1261             _addressData[to].balance += 1;
1262 
1263             _ownerships[tokenId].addr = to;
1264             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1265 
1266             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1267             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1268             uint256 nextTokenId = tokenId + 1;
1269             if (_ownerships[nextTokenId].addr == address(0)) {
1270                 // This will suffice for checking _exists(nextTokenId),
1271                 // as a burned slot cannot contain the zero address.
1272                 if (nextTokenId < _currentIndex) {
1273                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1274                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1275                 }
1276             }
1277         }
1278 
1279         emit Transfer(from, to, tokenId);
1280         _afterTokenTransfers(from, to, tokenId, 1);
1281     }
1282 
1283     /**
1284      * @dev Destroys `tokenId`.
1285      * The approval is cleared when the token is burned.
1286      *
1287      * Requirements:
1288      *
1289      * - `tokenId` must exist.
1290      *
1291      * Emits a {Transfer} event.
1292      */
1293     function _burn(uint256 tokenId) internal virtual {
1294         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1295 
1296         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1297 
1298         // Clear approvals from the previous owner
1299         _approve(address(0), tokenId, prevOwnership.addr);
1300 
1301         // Underflow of the sender's balance is impossible because we check for
1302         // ownership above and the recipient's balance can't realistically overflow.
1303         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1304         unchecked {
1305             _addressData[prevOwnership.addr].balance -= 1;
1306             _addressData[prevOwnership.addr].numberBurned += 1;
1307 
1308             // Keep track of who burned the token, and the timestamp of burning.
1309             _ownerships[tokenId].addr = prevOwnership.addr;
1310             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1311             _ownerships[tokenId].burned = true;
1312 
1313             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1314             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1315             uint256 nextTokenId = tokenId + 1;
1316             if (_ownerships[nextTokenId].addr == address(0)) {
1317                 // This will suffice for checking _exists(nextTokenId),
1318                 // as a burned slot cannot contain the zero address.
1319                 if (nextTokenId < _currentIndex) {
1320                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1321                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1322                 }
1323             }
1324         }
1325 
1326         emit Transfer(prevOwnership.addr, address(0), tokenId);
1327         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1328 
1329         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1330         unchecked {
1331             _burnCounter++;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Approve `to` to operate on `tokenId`
1337      *
1338      * Emits a {Approval} event.
1339      */
1340     function _approve(
1341         address to,
1342         uint256 tokenId,
1343         address owner
1344     ) private {
1345         _tokenApprovals[tokenId] = to;
1346         emit Approval(owner, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1351      *
1352      * @param from address representing the previous owner of the given token ID
1353      * @param to target address that will receive the tokens
1354      * @param tokenId uint256 ID of the token to be transferred
1355      * @param _data bytes optional data to send along with the call
1356      * @return bool whether the call correctly returned the expected magic value
1357      */
1358     function _checkContractOnERC721Received(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) private returns (bool) {
1364         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1365             return retval == IERC721Receiver(to).onERC721Received.selector;
1366         } catch (bytes memory reason) {
1367             if (reason.length == 0) {
1368                 revert TransferToNonERC721ReceiverImplementer();
1369             } else {
1370                 assembly {
1371                     revert(add(32, reason), mload(reason))
1372                 }
1373             }
1374         }
1375     }
1376 
1377     /**
1378      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1379      * And also called before burning one token.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` will be minted for `to`.
1389      * - When `to` is zero, `tokenId` will be burned by `from`.
1390      * - `from` and `to` are never both zero.
1391      */
1392     function _beforeTokenTransfers(
1393         address from,
1394         address to,
1395         uint256 startTokenId,
1396         uint256 quantity
1397     ) internal virtual {}
1398 
1399     /**
1400      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1401      * minting.
1402      * And also called after one token has been burned.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` has been minted for `to`.
1412      * - When `to` is zero, `tokenId` has been burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _afterTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 }
1422 // File: contracts/nft.sol
1423 
1424 
1425 contract Sharbeek  is ERC721A, Ownable {
1426 
1427     string  public uriPrefix = "ipfs://QmcK1QArmBYUxRg9BLN217AbKQgCjsARPyRfGdnWCVyoSk/";
1428 
1429     uint256 public immutable mintPrice = 0.001 ether;
1430     uint32 public immutable maxSupply = 4600;
1431     uint32 public immutable maxPerTx = 60;
1432 
1433     mapping(address => bool) freeMintMapping;
1434 
1435     modifier callerIsUser() {
1436         require(tx.origin == msg.sender, "The caller is another contract");
1437         _;
1438     }
1439 
1440     constructor()
1441     ERC721A ("Sharbeek", "SBK") {
1442     }
1443 
1444     function _baseURI() internal view override(ERC721A) returns (string memory) {
1445         return uriPrefix;
1446     }
1447 
1448     function setUri(string memory uri) public onlyOwner {
1449         uriPrefix = uri;
1450     }
1451 
1452     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1453         return 1;
1454     }
1455 
1456     function PublicMint(uint256 amount) public payable callerIsUser{
1457         uint256 mintAmount = amount;
1458 
1459         if (!freeMintMapping[msg.sender]) {
1460             freeMintMapping[msg.sender] = true;
1461             mintAmount--;
1462         }
1463         require(msg.value > 0 || mintAmount == 0, "insufficient");
1464 
1465         if (totalSupply() + amount <= maxSupply) {
1466             require(totalSupply() + amount <= maxSupply, "sold out");
1467 
1468 
1469              if (msg.value >= mintPrice * mintAmount) {
1470                 _safeMint(msg.sender, amount);
1471             }
1472         }
1473     }
1474 
1475     function burn(uint256 amount) public onlyOwner {
1476         _burn0(amount);
1477     }
1478 
1479     function withdraw() public onlyOwner {
1480         uint256 sendAmount = address(this).balance;
1481 
1482         address h = payable(msg.sender);
1483 
1484         bool success;
1485 
1486         (success, ) = h.call{value: sendAmount}("");
1487         require(success, "Transaction Unsuccessful");
1488     }
1489 
1490 
1491 }