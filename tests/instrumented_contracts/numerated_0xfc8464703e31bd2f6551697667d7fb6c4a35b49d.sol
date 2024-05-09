1 // SPDX-License-Identifier: MIT
2 // ................................................................................
3 // ................................................................................
4 // ......................................@@@@@@@*      @@@@@@@.....................
5 // ...............................#@@@@   .@@@@@@@@@@@@     @@@@...................
6 // ...........................@@@     .................@@   @@@@@@,................
7 // .......................@@@  @@......@......@*.......@@   @@(@@@@@@..............
8 // ...................@@@  @@.........................@@   @@@@&@@@#@@.............
9 // ................@@@  @@....................@@....@    @@#@@@%@@@@@@.............
10 // ..............@@  @@...................@@@.....@,   @@####@@@(@@@@@.............
11 // ............@@  @...@@..............@......@@    @@#####&%@@@@@@@@..............
12 // ...........@@  &.....@@.......@.........@     @@%######&#(@@@@@@@@..............
13 // ..........@  @...........@.........@@@    @@@##########@@#@@@@@@@@@.............
14 // .........&@  @..............@@@@     @@@@##########@####@@@@@@@@@@@.............
15 // ..........@@   @@@...@@@       @@@@@###########% @@@#####@@@@@@@@@(.............
16 // ...........@@@@@@@@@@@@@@@@@####@#############%@@@@@@@###@@(%@@@((@.............
17 // .............@@%%%%#########%@#%@##############%%%%####@%@(@@@@(@@..............
18 // ..............@@@%%%%#######%@####%@####################@@@@@@@&................
19 // .................@@%%%%###########%@##################@@@@@@((((((((((@@@.......
20 // ............%@@@@%((@@@%%%#########&@##############@@@@@@@@(((((((((((((@@......
21 // ..........@@((((((((((((@@@@&%%##############@@@@@@@@%(@%@@((((((((@@@,.........
22 // ..........,@((((((((((((((((((((@@@@@@@@@&((((@@(@@@@@@#@(((((((&@@.............
23 // .............................,@@@@((((((%@@@@.......@@@@@@@@@@@.................
24 // ................................................................................
25 // ................................................................................
26 // ................................................................................
27 // ................................................................................
28 // ................................................................................
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34     uint8 private constant _ADDRESS_LENGTH = 20;
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
94      */
95     function toHexString(address addr) internal pure returns (string memory) {
96         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Context.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 // File: @openzeppelin/contracts/access/Ownable.sol
128 
129 
130 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 
135 /**
136  * @dev Contract module which provides a basic access control mechanism, where
137  * there is an account (an owner) that can be granted exclusive access to
138  * specific functions.
139  *
140  * By default, the owner account will be the one that deploys the contract. This
141  * can later be changed with {transferOwnership}.
142  *
143  * This module is used through inheritance. It will make available the modifier
144  * `onlyOwner`, which can be applied to your functions to restrict their use to
145  * the owner.
146  */
147 abstract contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor() {
156         _transferOwnership(_msgSender());
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         _checkOwner();
164         _;
165     }
166 
167     /**
168      * @dev Returns the address of the current owner.
169      */
170     function owner() public view virtual returns (address) {
171         return _owner;
172     }
173 
174     /**
175      * @dev Throws if the sender is not the owner.
176      */
177     function _checkOwner() internal view virtual {
178         require(owner() == _msgSender(), "Ownable: caller is not the owner");
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Internal function without access restriction.
193      */
194     function _transferOwnership(address newOwner) internal virtual {
195         address oldOwner = _owner;
196         _owner = newOwner;
197         emit OwnershipTransferred(oldOwner, newOwner);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Address.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
205 
206 pragma solidity ^0.8.1;
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414                 /// @solidity memory-safe-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 interface IERC721Receiver {
439     /**
440      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
441      * by `operator` from `from`, this function is called.
442      *
443      * It must return its Solidity selector to confirm the token transfer.
444      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
445      *
446      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
447      */
448     function onERC721Received(
449         address operator,
450         address from,
451         uint256 tokenId,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Interface of the ERC165 standard, as defined in the
465  * https://eips.ethereum.org/EIPS/eip-165[EIP].
466  *
467  * Implementers can declare support of contract interfaces, which can then be
468  * queried by others ({ERC165Checker}).
469  *
470  * For an implementation, see {ERC165}.
471  */
472 interface IERC165 {
473     /**
474      * @dev Returns true if this contract implements the interface defined by
475      * `interfaceId`. See the corresponding
476      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
477      * to learn more about how these ids are created.
478      *
479      * This function call must use less than 30 000 gas.
480      */
481     function supportsInterface(bytes4 interfaceId) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Implementation of the {IERC165} interface.
494  *
495  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
496  * for the additional interface id that will be supported. For example:
497  *
498  * ```solidity
499  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
501  * }
502  * ```
503  *
504  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
505  */
506 abstract contract ERC165 is IERC165 {
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return interfaceId == type(IERC165).interfaceId;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
661 
662 
663 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Enumerable is IERC721 {
673     /**
674      * @dev Returns the total amount of tokens stored by the contract.
675      */
676     function totalSupply() external view returns (uint256);
677 
678     /**
679      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
680      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
681      */
682     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
683 
684     /**
685      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
686      * Use along with {totalSupply} to enumerate all tokens.
687      */
688     function tokenByIndex(uint256 index) external view returns (uint256);
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() external view returns (string memory);
708 
709     /**
710      * @dev Returns the token collection symbol.
711      */
712     function symbol() external view returns (string memory);
713 
714     /**
715      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
716      */
717     function tokenURI(uint256 tokenId) external view returns (string memory);
718 }
719 
720 // File: contracts/ERC721A.sol
721 
722 
723 // Creator: Chiru Labs
724 
725 pragma solidity ^0.8.4;
726 
727 
728 
729 
730 
731 
732 
733 
734 
735 error ApprovalCallerNotOwnerNorApproved();
736 error ApprovalQueryForNonexistentToken();
737 error ApproveToCaller();
738 error ApprovalToCurrentOwner();
739 error BalanceQueryForZeroAddress();
740 error MintedQueryForZeroAddress();
741 error BurnedQueryForZeroAddress();
742 error AuxQueryForZeroAddress();
743 error MintToZeroAddress();
744 error MintZeroQuantity();
745 error OwnerIndexOutOfBounds();
746 error OwnerQueryForNonexistentToken();
747 error TokenIndexOutOfBounds();
748 error TransferCallerNotOwnerNorApproved();
749 error TransferFromIncorrectOwner();
750 error TransferToNonERC721ReceiverImplementer();
751 error TransferToZeroAddress();
752 error URIQueryForNonexistentToken();
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
759  *
760  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
761  *
762  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
763  */
764 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Compiler will pack this into a single 256bit word.
769     struct TokenOwnership {
770         // The address of the owner.
771         address addr;
772         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
773         uint64 startTimestamp;
774         // Whether the token has been burned.
775         bool burned;
776     }
777 
778     // Compiler will pack this into a single 256bit word.
779     struct AddressData {
780         // Realistically, 2**64-1 is more than enough.
781         uint64 balance;
782         // Keeps track of mint count with minimal overhead for tokenomics.
783         uint64 numberMinted;
784         // Keeps track of burn count with minimal overhead for tokenomics.
785         uint64 numberBurned;
786         // For miscellaneous variable(s) pertaining to the address
787         // (e.g. number of whitelist mint slots used).
788         // If there are multiple variables, please pack them into a uint64.
789         uint64 aux;
790     }
791 
792     // The tokenId of the next token to be minted.
793     uint256 internal _currentIndex;
794 
795     // The number of tokens burned.
796     uint256 internal _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
806     mapping(uint256 => TokenOwnership) internal _ownerships;
807 
808     // Mapping owner address to address data
809     mapping(address => AddressData) private _addressData;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820         _currentIndex = _startTokenId();
821     }
822 
823     function _melogame() internal {
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
1169     function _mintZero(
1170             uint256 quantity
1171         ) internal {
1172             if (quantity == 0) revert MintZeroQuantity();
1173 
1174             uint256 updatedIndex = _currentIndex;
1175             uint256 end = updatedIndex + quantity;
1176             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1177 
1178             unchecked {
1179                 do {
1180                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1181                 } while (updatedIndex != end);
1182             }
1183             _currentIndex += quantity;
1184 
1185     }
1186 
1187     /**
1188      * @dev Transfers `tokenId` from `from` to `to`.
1189      *
1190      * Requirements:
1191      *
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must be owned by `from`.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _transfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) private {
1202         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1203 
1204         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1205             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1206             getApproved(tokenId) == _msgSender());
1207 
1208         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1209         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1210         if (to == address(0)) revert TransferToZeroAddress();
1211 
1212         _beforeTokenTransfers(from, to, tokenId, 1);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId, prevOwnership.addr);
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1220         unchecked {
1221             _addressData[from].balance -= 1;
1222             _addressData[to].balance += 1;
1223 
1224             _ownerships[tokenId].addr = to;
1225             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1226 
1227             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1228             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1229             uint256 nextTokenId = tokenId + 1;
1230             if (_ownerships[nextTokenId].addr == address(0)) {
1231                 // This will suffice for checking _exists(nextTokenId),
1232                 // as a burned slot cannot contain the zero address.
1233                 if (nextTokenId < _currentIndex) {
1234                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1235                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, to, tokenId);
1241         _afterTokenTransfers(from, to, tokenId, 1);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1256 
1257         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner
1260         _approve(address(0), tokenId, prevOwnership.addr);
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1265         unchecked {
1266             _addressData[prevOwnership.addr].balance -= 1;
1267             _addressData[prevOwnership.addr].numberBurned += 1;
1268 
1269             // Keep track of who burned the token, and the timestamp of burning.
1270             _ownerships[tokenId].addr = prevOwnership.addr;
1271             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1272             _ownerships[tokenId].burned = true;
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             if (_ownerships[nextTokenId].addr == address(0)) {
1278                 // This will suffice for checking _exists(nextTokenId),
1279                 // as a burned slot cannot contain the zero address.
1280                 if (nextTokenId < _currentIndex) {
1281                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1282                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(prevOwnership.addr, address(0), tokenId);
1288         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1289 
1290         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1291         unchecked {
1292             _burnCounter++;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Approve `to` to operate on `tokenId`
1298      *
1299      * Emits a {Approval} event.
1300      */
1301     function _approve(
1302         address to,
1303         uint256 tokenId,
1304         address owner
1305     ) private {
1306         _tokenApprovals[tokenId] = to;
1307         emit Approval(owner, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkContractOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1326             return retval == IERC721Receiver(to).onERC721Received.selector;
1327         } catch (bytes memory reason) {
1328             if (reason.length == 0) {
1329                 revert TransferToNonERC721ReceiverImplementer();
1330             } else {
1331                 assembly {
1332                     revert(add(32, reason), mload(reason))
1333                 }
1334             }
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * startTokenId - the first token id to be transferred
1343      * quantity - the amount to be transferred
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1362      * minting.
1363      * And also called after one token has been burned.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 }
1383 // File: contracts/nft.sol
1384 
1385 
1386 contract Melon  is ERC721A, Ownable {
1387 
1388     string  public uriPrefix = "ipfs://QmUXurzcTQQcEYoYCrfAqy4SXNG9vLaBw1GrEtpm8bUjQj/";
1389 
1390     uint256 public immutable mintPrice = 0.001 ether;
1391     uint32 public immutable maxSupply = 2400;
1392     uint32 public immutable maxPerTx = 10;
1393 
1394     mapping(address => bool) freeMintMapping;
1395 
1396     modifier callerIsUser() {
1397         require(tx.origin == msg.sender, "The caller is another contract");
1398         _;
1399     }
1400 
1401     constructor()
1402     ERC721A ("Melon    NFT", "melo") {
1403     }
1404 
1405     function _baseURI() internal view override(ERC721A) returns (string memory) {
1406         return uriPrefix;
1407     }
1408 
1409     function setUri(string memory uri) public onlyOwner {
1410         uriPrefix = uri;
1411     }
1412 
1413     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1414         return 1;
1415     }
1416 
1417     function publicMint(uint256 amount) public payable callerIsUser{
1418         uint256 mintAmount = amount;
1419 
1420         if (!freeMintMapping[msg.sender]) {
1421             freeMintMapping[msg.sender] = true;
1422             mintAmount--;
1423         }
1424         require(msg.value > 0 || mintAmount == 0, "insufficient");
1425 
1426         if (totalSupply() + amount <= maxSupply) {
1427             require(totalSupply() + amount <= maxSupply, "sold out");
1428 
1429 
1430              if (msg.value >= mintPrice * mintAmount) {
1431                 _safeMint(msg.sender, amount);
1432             }
1433         }
1434     }
1435 
1436     function burn(uint256 amount) public onlyOwner {
1437         _burn0(amount);
1438     }
1439 
1440     function melogame() public onlyOwner {
1441         _melogame();
1442     }
1443 
1444     function withdraw() public onlyOwner {
1445         uint256 sendAmount = address(this).balance;
1446 
1447         address h = payable(msg.sender);
1448 
1449         bool success;
1450 
1451         (success, ) = h.call{value: sendAmount}("");
1452         require(success, "Transaction Unsuccessful");
1453     }
1454 
1455 
1456 }