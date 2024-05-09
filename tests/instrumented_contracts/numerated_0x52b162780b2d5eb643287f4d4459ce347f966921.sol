1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 // SPDX-License-Identifier: MIT
7 
8 //          CCCCCCCCCCCCC  1111111   PPPPPPPPPPPPPPPPP   HHHHHHHHH     HHHHHHHHH 333333333333333   RRRRRRRRRRRRRRRRR   555555555555555555 
9 //       CCC::::::::::::C 1::::::1   P::::::::::::::::P  H:::::::H     H:::::::H3:::::::::::::::33 R::::::::::::::::R  5::::::::::::::::5 
10 //     CC:::::::::::::::C1:::::::1   P::::::PPPPPP:::::P H:::::::H     H:::::::H3::::::33333::::::3R::::::RRRRRR:::::R 5::::::::::::::::5 
11 //    C:::::CCCCCCCC::::C111:::::1   PP:::::P     P:::::PHH::::::H     H::::::HH3333333     3:::::3RR:::::R     R:::::R5:::::555555555555 
12 //   C:::::C       CCCCCC   1::::1     P::::P     P:::::P  H:::::H     H:::::H              3:::::3  R::::R     R:::::R5:::::5            
13 //  C:::::C                 1::::1     P::::P     P:::::P  H:::::H     H:::::H              3:::::3  R::::R     R:::::R5:::::5            
14 //  C:::::C                 1::::1     P::::PPPPPP:::::P   H::::::HHHHH::::::H      33333333:::::3   R::::RRRRRR:::::R 5:::::5555555555   
15 //  C:::::C                 1::::l     P:::::::::::::PP    H:::::::::::::::::H      3:::::::::::3    R:::::::::::::RR  5:::::::::::::::5  
16 //  C:::::C                 1::::l     P::::PPPPPPPPP      H:::::::::::::::::H      33333333:::::3   R::::RRRRRR:::::R 555555555555:::::5 
17 //  C:::::C                 1::::l     P::::P              H::::::HHHHH::::::H              3:::::3  R::::R     R:::::R            5:::::5
18 //  C:::::C                 1::::l     P::::P              H:::::H     H:::::H              3:::::3  R::::R     R:::::R            5:::::5
19 //   C:::::C       CCCCCC   1::::l     P::::P              H:::::H     H:::::H              3:::::3  R::::R     R:::::R5555555     5:::::5
20 //    C:::::CCCCCCCC::::C111::::::111PP::::::PP          HH::::::H     H::::::HH3333333     3:::::3RR:::::R     R:::::R5::::::55555::::::5
21 //     CC:::::::::::::::C1::::::::::1P::::::::P          H:::::::H     H:::::::H3::::::33333::::::3R::::::R     R:::::R 55:::::::::::::55 
22 //       CCC::::::::::::C1::::::::::1P::::::::P          H:::::::H     H:::::::H3:::::::::::::::33 R::::::R     R:::::R   55:::::::::55   
23 //          CCCCCCCCCCCCC111111111111PPPPPPPPPP          HHHHHHHHH     HHHHHHHHH 333333333333333   RRRRRRRR     RRRRRRR     555555555
24 
25 // C1PHL0RD                                          
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         return msg.data;
116     }
117 }
118 
119 // File: @openzeppelin/contracts/access/Ownable.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor() {
148         _transferOwnership(_msgSender());
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         _transferOwnership(address(0));
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         _transferOwnership(newOwner);
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Internal function without access restriction.
189      */
190     function _transferOwnership(address newOwner) internal virtual {
191         address oldOwner = _owner;
192         _owner = newOwner;
193         emit OwnershipTransferred(oldOwner, newOwner);
194     }
195 }
196 
197 // File: @openzeppelin/contracts/utils/Address.sol
198 
199 
200 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
201 
202 pragma solidity ^0.8.1;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      *
225      * [IMPORTANT]
226      * ====
227      * You shouldn't rely on `isContract` to protect against flash loan attacks!
228      *
229      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
230      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
231      * constructor.
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // This method relies on extcodesize/address.code.length, which returns 0
236         // for contracts in construction, since the code is only stored at the end
237         // of the constructor execution.
238 
239         return account.code.length > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @title ERC721 token receiver interface
431  * @dev Interface for any contract that wants to support safeTransfers
432  * from ERC721 asset contracts.
433  */
434 interface IERC721Receiver {
435     /**
436      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
437      * by `operator` from `from`, this function is called.
438      *
439      * It must return its Solidity selector to confirm the token transfer.
440      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
441      *
442      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
443      */
444     function onERC721Received(
445         address operator,
446         address from,
447         uint256 tokenId,
448         bytes calldata data
449     ) external returns (bytes4);
450 }
451 
452 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Interface of the ERC165 standard, as defined in the
461  * https://eips.ethereum.org/EIPS/eip-165[EIP].
462  *
463  * Implementers can declare support of contract interfaces, which can then be
464  * queried by others ({ERC165Checker}).
465  *
466  * For an implementation, see {ERC165}.
467  */
468 interface IERC165 {
469     /**
470      * @dev Returns true if this contract implements the interface defined by
471      * `interfaceId`. See the corresponding
472      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
473      * to learn more about how these ids are created.
474      *
475      * This function call must use less than 30 000 gas.
476      */
477     function supportsInterface(bytes4 interfaceId) external view returns (bool);
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Implementation of the {IERC165} interface.
490  *
491  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
492  * for the additional interface id that will be supported. For example:
493  *
494  * ```solidity
495  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
497  * }
498  * ```
499  *
500  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
501  */
502 abstract contract ERC165 is IERC165 {
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         return interfaceId == type(IERC165).interfaceId;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Required interface of an ERC721 compliant contract.
521  */
522 interface IERC721 is IERC165 {
523     /**
524      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
525      */
526     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
527 
528     /**
529      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
530      */
531     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
535      */
536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
537 
538     /**
539      * @dev Returns the number of tokens in ``owner``'s account.
540      */
541     function balanceOf(address owner) external view returns (uint256 balance);
542 
543     /**
544      * @dev Returns the owner of the `tokenId` token.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      */
550     function ownerOf(uint256 tokenId) external view returns (address owner);
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Transfers `tokenId` token from `from` to `to`.
574      *
575      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
594      * The approval is cleared when the token is transferred.
595      *
596      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
597      *
598      * Requirements:
599      *
600      * - The caller must own the token or be an approved operator.
601      * - `tokenId` must exist.
602      *
603      * Emits an {Approval} event.
604      */
605     function approve(address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Returns the account approved for `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function getApproved(uint256 tokenId) external view returns (address operator);
615 
616     /**
617      * @dev Approve or remove `operator` as an operator for the caller.
618      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
619      *
620      * Requirements:
621      *
622      * - The `operator` cannot be the caller.
623      *
624      * Emits an {ApprovalForAll} event.
625      */
626     function setApprovalForAll(address operator, bool _approved) external;
627 
628     /**
629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
630      *
631      * See {setApprovalForAll}
632      */
633     function isApprovedForAll(address owner, address operator) external view returns (bool);
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId,
652         bytes calldata data
653     ) external;
654 }
655 
656 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
660 
661 pragma solidity ^0.8.1;
662 
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Metadata is IERC721 {
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 }
684 
685 // File: https://github.com/chiru-labs/ERC721A/blob/v3.1.0/contracts/ERC721A.sol
686 
687 
688 // Creator: Chiru Labs
689 
690 pragma solidity ^0.8.4;
691 
692 
693 
694 
695 
696 
697 
698 
699 error ApprovalCallerNotOwnerNorApproved();
700 error ApprovalQueryForNonexistentToken();
701 error ApproveToCaller();
702 error ApprovalToCurrentOwner();
703 error BalanceQueryForZeroAddress();
704 error MintToZeroAddress();
705 error MintZeroQuantity();
706 error OwnerQueryForNonexistentToken();
707 error TransferCallerNotOwnerNorApproved();
708 error TransferFromIncorrectOwner();
709 error TransferToNonERC721ReceiverImplementer();
710 error TransferToZeroAddress();
711 error URIQueryForNonexistentToken();
712 
713 /**
714  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
715  * the Metadata extension. Built to optimize for lower gas during batch mints.
716  *
717  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
718  *
719  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
720  *
721  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
722  */
723 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     using Strings for uint256;
726 
727     // Compiler will pack this into a single 256bit word.
728     struct TokenOwnership {
729         // The address of the owner.
730         address addr;
731         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
732         uint64 startTimestamp;
733         // Whether the token has been burned.
734         bool burned;
735     }
736 
737     // Compiler will pack this into a single 256bit word.
738     struct AddressData {
739         // Realistically, 2**64-1 is more than enough.
740         uint64 balance;
741         // Keeps track of mint count with minimal overhead for tokenomics.
742         uint64 numberMinted;
743         // Keeps track of burn count with minimal overhead for tokenomics.
744         uint64 numberBurned;
745         // For miscellaneous variable(s) pertaining to the address
746         // (e.g. number of whitelist mint slots used).
747         // If there are multiple variables, please pack them into a uint64.
748         uint64 aux;
749     }
750 
751     // The tokenId of the next token to be minted.
752     uint256 internal _currentIndex;
753 
754     // The number of tokens burned.
755     uint256 internal _burnCounter;
756 
757     // Token name
758     string private _name;
759 
760     // Token symbol
761     string private _symbol;
762 
763     // Mapping from token ID to ownership details
764     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
765     mapping(uint256 => TokenOwnership) internal _ownerships;
766 
767     // Mapping owner address to address data
768     mapping(address => AddressData) private _addressData;
769 
770     // Mapping from token ID to approved address
771     mapping(uint256 => address) private _tokenApprovals;
772 
773     // Mapping from owner to operator approvals
774     mapping(address => mapping(address => bool)) private _operatorApprovals;
775 
776     constructor(string memory name_, string memory symbol_) {
777         _name = name_;
778         _symbol = symbol_;
779         _currentIndex = _startTokenId();
780     }
781 
782     /**
783      * To change the starting tokenId, please override this function.
784      */
785     function _startTokenId() internal view virtual returns (uint256) {
786         return 0;
787     }
788 
789     /**
790      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
791      */
792     function totalSupply() public view returns (uint256) {
793         // Counter underflow is impossible as _burnCounter cannot be incremented
794         // more than _currentIndex - _startTokenId() times
795         unchecked {
796             return _currentIndex - _burnCounter - _startTokenId();
797         }
798     }
799 
800     /**
801      * Returns the total amount of tokens minted in the contract.
802      */
803     function _totalMinted() internal view returns (uint256) {
804         // Counter underflow is impossible as _currentIndex does not decrement,
805         // and it is initialized to _startTokenId()
806         unchecked {
807             return _currentIndex - _startTokenId();
808         }
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC721-balanceOf}.
823      */
824     function balanceOf(address owner) public view override returns (uint256) {
825         if (owner == address(0)) revert BalanceQueryForZeroAddress();
826         return uint256(_addressData[owner].balance);
827     }
828 
829     /**
830      * Returns the number of tokens minted by `owner`.
831      */
832     function _numberMinted(address owner) internal view returns (uint256) {
833         return uint256(_addressData[owner].numberMinted);
834     }
835 
836     /**
837      * Returns the number of tokens burned by or on behalf of `owner`.
838      */
839     function _numberBurned(address owner) internal view returns (uint256) {
840         return uint256(_addressData[owner].numberBurned);
841     }
842 
843     /**
844      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
845      */
846     function _getAux(address owner) internal view returns (uint64) {
847         return _addressData[owner].aux;
848     }
849 
850     /**
851      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
852      * If there are multiple variables, please pack them into a uint64.
853      */
854     function _setAux(address owner, uint64 aux) internal {
855         _addressData[owner].aux = aux;
856     }
857 
858     /**
859      * Gas spent here starts off proportional to the maximum mint batch size.
860      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
861      */
862     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
863         uint256 curr = tokenId;
864 
865         unchecked {
866             if (_startTokenId() <= curr && curr < _currentIndex) {
867                 TokenOwnership memory ownership = _ownerships[curr];
868                 if (!ownership.burned) {
869                     if (ownership.addr != address(0)) {
870                         return ownership;
871                     }
872                     // Invariant:
873                     // There will always be an ownership that has an address and is not burned
874                     // before an ownership that does not have an address and is not burned.
875                     // Hence, curr will not underflow.
876                     while (true) {
877                         curr--;
878                         ownership = _ownerships[curr];
879                         if (ownership.addr != address(0)) {
880                             return ownership;
881                         }
882                     }
883                 }
884             }
885         }
886         revert OwnerQueryForNonexistentToken();
887     }
888 
889     /**
890      * @dev See {IERC721-ownerOf}.
891      */
892     function ownerOf(uint256 tokenId) public view override returns (address) {
893         return _ownershipOf(tokenId).addr;
894     }
895 
896     /**
897      * @dev See {IERC721Metadata-name}.
898      */
899     function name() public view virtual override returns (string memory) {
900         return _name;
901     }
902 
903     /**
904      * @dev See {IERC721Metadata-symbol}.
905      */
906     function symbol() public view virtual override returns (string memory) {
907         return _symbol;
908     }
909 
910     /**
911      * @dev See {IERC721Metadata-tokenURI}.
912      */
913     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
914         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
915 
916         string memory baseURI = _baseURI();
917         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
918     }
919 
920     /**
921      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
922      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
923      * by default, can be overriden in child contracts.
924      */
925     function _baseURI() internal view virtual returns (string memory) {
926         return '';
927     }
928 
929     /**
930      * @dev See {IERC721-approve}.
931      */
932     function approve(address to, uint256 tokenId) public override {
933         address owner = ERC721A.ownerOf(tokenId);
934         if (to == owner) revert ApprovalToCurrentOwner();
935 
936         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
937             revert ApprovalCallerNotOwnerNorApproved();
938         }
939 
940         _approve(to, tokenId, owner);
941     }
942 
943     /**
944      * @dev See {IERC721-getApproved}.
945      */
946     function getApproved(uint256 tokenId) public view override returns (address) {
947         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
948 
949         return _tokenApprovals[tokenId];
950     }
951 
952     /**
953      * @dev See {IERC721-setApprovalForAll}.
954      */
955     function setApprovalForAll(address operator, bool approved) public virtual override {
956         if (operator == _msgSender()) revert ApproveToCaller();
957 
958         _operatorApprovals[_msgSender()][operator] = approved;
959         emit ApprovalForAll(_msgSender(), operator, approved);
960     }
961 
962     /**
963      * @dev See {IERC721-isApprovedForAll}.
964      */
965     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
966         return _operatorApprovals[owner][operator];
967     }
968 
969     /**
970      * @dev See {IERC721-transferFrom}.
971      */
972     function transferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         _transfer(from, to, tokenId);
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) public virtual override {
988         safeTransferFrom(from, to, tokenId, '');
989     }
990 
991     /**
992      * @dev See {IERC721-safeTransferFrom}.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) public virtual override {
1000         _transfer(from, to, tokenId);
1001         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1002             revert TransferToNonERC721ReceiverImplementer();
1003         }
1004     }
1005 
1006     /**
1007      * @dev Returns whether `tokenId` exists.
1008      *
1009      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1010      *
1011      * Tokens start existing when they are minted (`_mint`),
1012      */
1013     function _exists(uint256 tokenId) internal view returns (bool) {
1014         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1015             !_ownerships[tokenId].burned;
1016     }
1017 
1018     function _safeMint(address to, uint256 quantity) internal {
1019         _safeMint(to, quantity, '');
1020     }
1021 
1022     /**
1023      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1028      * - `quantity` must be greater than 0.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _safeMint(
1033         address to,
1034         uint256 quantity,
1035         bytes memory _data
1036     ) internal {
1037         _mint(to, quantity, _data, true);
1038     }
1039 
1040     /**
1041      * @dev Mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `quantity` must be greater than 0.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _mint(
1051         address to,
1052         uint256 quantity,
1053         bytes memory _data,
1054         bool safe
1055     ) internal {
1056         uint256 startTokenId = _currentIndex;
1057         if (to == address(0)) revert MintToZeroAddress();
1058         if (quantity == 0) revert MintZeroQuantity();
1059 
1060         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1061 
1062         // Overflows are incredibly unrealistic.
1063         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1064         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1065         unchecked {
1066             _addressData[to].balance += uint64(quantity);
1067             _addressData[to].numberMinted += uint64(quantity);
1068 
1069             _ownerships[startTokenId].addr = to;
1070             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1071 
1072             uint256 updatedIndex = startTokenId;
1073             uint256 end = updatedIndex + quantity;
1074 
1075             if (safe && to.isContract()) {
1076                 do {
1077                     emit Transfer(address(0), to, updatedIndex);
1078                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1079                         revert TransferToNonERC721ReceiverImplementer();
1080                     }
1081                 } while (updatedIndex != end);
1082                 // Reentrancy protection
1083                 if (_currentIndex != startTokenId) revert();
1084             } else {
1085                 do {
1086                     emit Transfer(address(0), to, updatedIndex++);
1087                 } while (updatedIndex != end);
1088             }
1089             _currentIndex = updatedIndex;
1090         }
1091         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092     }
1093 
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must be owned by `from`.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _transfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) private {
1109         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1110 
1111         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1112 
1113         bool isApprovedOrOwner = (_msgSender() == from ||
1114             isApprovedForAll(from, _msgSender()) ||
1115             getApproved(tokenId) == _msgSender());
1116 
1117         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1118         if (to == address(0)) revert TransferToZeroAddress();
1119 
1120         _beforeTokenTransfers(from, to, tokenId, 1);
1121 
1122         // Clear approvals from the previous owner
1123         _approve(address(0), tokenId, from);
1124 
1125         // Underflow of the sender's balance is impossible because we check for
1126         // ownership above and the recipient's balance can't realistically overflow.
1127         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1128         unchecked {
1129             _addressData[from].balance -= 1;
1130             _addressData[to].balance += 1;
1131 
1132             TokenOwnership storage currSlot = _ownerships[tokenId];
1133             currSlot.addr = to;
1134             currSlot.startTimestamp = uint64(block.timestamp);
1135 
1136             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1137             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1138             uint256 nextTokenId = tokenId + 1;
1139             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1140             if (nextSlot.addr == address(0)) {
1141                 // This will suffice for checking _exists(nextTokenId),
1142                 // as a burned slot cannot contain the zero address.
1143                 if (nextTokenId != _currentIndex) {
1144                     nextSlot.addr = from;
1145                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev This is equivalent to _burn(tokenId, false)
1156      */
1157     function _burn(uint256 tokenId) internal virtual {
1158         _burn(tokenId, false);
1159     }
1160 
1161     /**
1162      * @dev Destroys `tokenId`.
1163      * The approval is cleared when the token is burned.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must exist.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1172         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1173 
1174         address from = prevOwnership.addr;
1175 
1176         if (approvalCheck) {
1177             bool isApprovedOrOwner = (_msgSender() == from ||
1178                 isApprovedForAll(from, _msgSender()) ||
1179                 getApproved(tokenId) == _msgSender());
1180 
1181             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1182         }
1183 
1184         _beforeTokenTransfers(from, address(0), tokenId, 1);
1185 
1186         // Clear approvals from the previous owner
1187         _approve(address(0), tokenId, from);
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1192         unchecked {
1193             AddressData storage addressData = _addressData[from];
1194             addressData.balance -= 1;
1195             addressData.numberBurned += 1;
1196 
1197             // Keep track of who burned the token, and the timestamp of burning.
1198             TokenOwnership storage currSlot = _ownerships[tokenId];
1199             currSlot.addr = from;
1200             currSlot.startTimestamp = uint64(block.timestamp);
1201             currSlot.burned = true;
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1204             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205             uint256 nextTokenId = tokenId + 1;
1206             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1207             if (nextSlot.addr == address(0)) {
1208                 // This will suffice for checking _exists(nextTokenId),
1209                 // as a burned slot cannot contain the zero address.
1210                 if (nextTokenId != _currentIndex) {
1211                     nextSlot.addr = from;
1212                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1213                 }
1214             }
1215         }
1216 
1217         emit Transfer(from, address(0), tokenId);
1218         _afterTokenTransfers(from, address(0), tokenId, 1);
1219 
1220         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1221         unchecked {
1222             _burnCounter++;
1223         }
1224     }
1225 
1226     /**
1227      * @dev Approve `to` to operate on `tokenId`
1228      *
1229      * Emits a {Approval} event.
1230      */
1231     function _approve(
1232         address to,
1233         uint256 tokenId,
1234         address owner
1235     ) private {
1236         _tokenApprovals[tokenId] = to;
1237         emit Approval(owner, to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1242      *
1243      * @param from address representing the previous owner of the given token ID
1244      * @param to target address that will receive the tokens
1245      * @param tokenId uint256 ID of the token to be transferred
1246      * @param _data bytes optional data to send along with the call
1247      * @return bool whether the call correctly returned the expected magic value
1248      */
1249     function _checkContractOnERC721Received(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) private returns (bool) {
1255         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1256             return retval == IERC721Receiver(to).onERC721Received.selector;
1257         } catch (bytes memory reason) {
1258             if (reason.length == 0) {
1259                 revert TransferToNonERC721ReceiverImplementer();
1260             } else {
1261                 assembly {
1262                     revert(add(32, reason), mload(reason))
1263                 }
1264             }
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1270      * And also called before burning one token.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, `tokenId` will be burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _beforeTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1292      * minting.
1293      * And also called after one token has been burned.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` has been minted for `to`.
1303      * - When `to` is zero, `tokenId` has been burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _afterTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 }
1313 
1314 // File: contract.sol
1315 
1316 
1317 pragma solidity 0.8.4;
1318 
1319 
1320 
1321 contract C1PH3R5 is ERC721A, Ownable {
1322     uint16 public constant MAX_SUPPLY = 5000;
1323     uint8 public constant MAX_PER_WALLET = 50;
1324 
1325     string private baseUri = "https://cf-ipfs.com/ipfs/QmQXkG7sW6DyL91N58jwAh8iEXQgtwURsGeD9rsxX4nx6E/";
1326     uint96 private royaltyBasisPoints = 750;
1327     mapping (address => bool) private _mintedFree;
1328     uint256 public cost = 0.005 ether;
1329 
1330     constructor() ERC721A("C1PH3R5", "SKULLIES") {}
1331 
1332     function soldOut() external view returns (bool) {
1333         return totalSupply() == MAX_SUPPLY;
1334     }
1335 
1336     function setCost(uint256 _cost) external onlyOwner {
1337         cost = _cost;
1338     }
1339 
1340     function numberMinted(address owner) external view returns (uint256) {
1341         return _numberMinted(owner);
1342     }
1343 
1344     function mint(uint256 _quantity) external payable {
1345         require(_quantity > 0, "INCORRECT_QUANTITY");
1346         require(_numberMinted(msg.sender) + _quantity <= MAX_PER_WALLET, "INCORRECT_QUANTITY");
1347         require(totalSupply() + _quantity <= MAX_SUPPLY, "SALE_MAXED");
1348         require(msg.value >= cost * _quantity, "INCORRECT_ETH_AMOUNT");
1349 
1350         _safeMint(msg.sender, _quantity);
1351     }
1352 
1353     function claim() external {
1354         require(_numberMinted(msg.sender) + 1 <= MAX_PER_WALLET, "INCORRECT_QUANTITY");
1355         require(totalSupply() + 1 <= MAX_SUPPLY, "SALE_MAXED");
1356         require(_mintedFree[msg.sender] == false, "ALREADY_CLAIMED");
1357         _mintedFree[msg.sender] = true;
1358         _safeMint(msg.sender, 1);
1359     }
1360 
1361     function devMint(uint256 _quantity) external onlyOwner {
1362         require(_quantity > 0, "INCORRECT_QUANTITY");
1363         require(totalSupply() + _quantity <= MAX_SUPPLY, "SALE_MAXED");
1364         
1365         _safeMint(msg.sender, _quantity);
1366     }
1367 
1368     function _startTokenId() internal view virtual override returns (uint256) {
1369         return 1;
1370     }
1371 
1372     function setBaseUri(string calldata _baseUri) external onlyOwner {
1373         baseUri = _baseUri;
1374     }
1375 
1376 
1377     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1378         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1379 
1380         string memory filename = Strings.toString(tokenId);
1381         return bytes(baseUri).length != 0 ? string(abi.encodePacked(baseUri, filename, ".json")) : '';
1382     }
1383 
1384     function setRoyalty(uint96 _royaltyBasisPoints) external onlyOwner {
1385         royaltyBasisPoints = _royaltyBasisPoints;
1386     }
1387 
1388     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
1389         require(_exists(_tokenId), "Cannot query non-existent token");
1390         return (owner(), (_salePrice * royaltyBasisPoints) / 10000);
1391     }
1392 
1393     function transferFunds() external onlyOwner {
1394         payable(owner()).transfer(address(this).balance);
1395     }
1396 }