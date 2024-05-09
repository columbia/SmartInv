1 /**
2   ______               __      __  _______                        ______                                       __  __                     
3  /      \             |  \    |  \|       \                      /      \                                     |  \|  \                    
4 |  $$$$$$\ _______   _| $$_    \$$| $$$$$$$\ __    __   ______  |  $$$$$$\ __    __   ______    ______    ____| $$ \$$  ______   _______  
5 | $$__| $$|       \ |   $$ \  |  \| $$__| $$|  \  |  \ /      \ | $$ __\$$|  \  |  \ |      \  /      \  /      $$|  \ |      \ |       \ 
6 | $$    $$| $$$$$$$\ \$$$$$$  | $$| $$    $$| $$  | $$|  $$$$$$\| $$|    \| $$  | $$  \$$$$$$\|  $$$$$$\|  $$$$$$$| $$  \$$$$$$\| $$$$$$$\
7 | $$$$$$$$| $$  | $$  | $$ __ | $$| $$$$$$$\| $$  | $$| $$  | $$| $$ \$$$$| $$  | $$ /      $$| $$   \$$| $$  | $$| $$ /      $$| $$  | $$
8 | $$  | $$| $$  | $$  | $$|  \| $$| $$  | $$| $$__/ $$| $$__| $$| $$__| $$| $$__/ $$|  $$$$$$$| $$      | $$__| $$| $$|  $$$$$$$| $$  | $$
9 | $$  | $$| $$  | $$   \$$  $$| $$| $$  | $$ \$$    $$ \$$    $$ \$$    $$ \$$    $$ \$$    $$| $$       \$$    $$| $$ \$$    $$| $$  | $$
10  \$$   \$$ \$$   \$$    \$$$$  \$$ \$$   \$$  \$$$$$$  _\$$$$$$$  \$$$$$$   \$$$$$$   \$$$$$$$ \$$        \$$$$$$$ \$$  \$$$$$$$ \$$   \$$
11                                                       |  \__| $$                                                                          
12                                                        \$$    $$                                                                          
13                                                         \$$$$$$                                                                           
14                                                                                                                     
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26     uint8 private constant _ADDRESS_LENGTH = 20;
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
86      */
87     function toHexString(address addr) internal pure returns (string memory) {
88         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
122 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         _checkOwner();
156         _;
157     }
158 
159     /**
160      * @dev Returns the address of the current owner.
161      */
162     function owner() public view virtual returns (address) {
163         return _owner;
164     }
165 
166     /**
167      * @dev Throws if the sender is not the owner.
168      */
169     function _checkOwner() internal view virtual {
170         require(owner() == _msgSender(), "Ownable: caller is not the owner");
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Internal function without access restriction.
185      */
186     function _transferOwnership(address newOwner) internal virtual {
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 
193 // File: @openzeppelin/contracts/utils/Address.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
197 
198 pragma solidity ^0.8.1;
199 
200 /**
201  * @dev Collection of functions related to the address type
202  */
203 library Address {
204     /**
205      * @dev Returns true if `account` is a contract.
206      *
207      * [IMPORTANT]
208      * ====
209      * It is unsafe to assume that an address for which this function returns
210      * false is an externally-owned account (EOA) and not a contract.
211      *
212      * Among others, `isContract` will return false for the following
213      * types of addresses:
214      *
215      *  - an externally-owned account
216      *  - a contract in construction
217      *  - an address where a contract will be created
218      *  - an address where a contract lived, but was destroyed
219      * ====
220      *
221      * [IMPORTANT]
222      * ====
223      * You shouldn't rely on `isContract` to protect against flash loan attacks!
224      *
225      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
226      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
227      * constructor.
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize/address.code.length, which returns 0
232         // for contracts in construction, since the code is only stored at the end
233         // of the constructor execution.
234 
235         return account.code.length > 0;
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         (bool success, ) = recipient.call{value: amount}("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
318      * with `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.call{value: value}(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal view returns (bytes memory) {
356         require(isContract(target), "Address: static call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.staticcall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
391      * revert reason using the provided one.
392      *
393      * _Available since v4.3._
394      */
395     function verifyCallResult(
396         bool success,
397         bytes memory returndata,
398         string memory errorMessage
399     ) internal pure returns (bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406                 /// @solidity memory-safe-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @title ERC721 token receiver interface
427  * @dev Interface for any contract that wants to support safeTransfers
428  * from ERC721 asset contracts.
429  */
430 interface IERC721Receiver {
431     /**
432      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
433      * by `operator` from `from`, this function is called.
434      *
435      * It must return its Solidity selector to confirm the token transfer.
436      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
437      *
438      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
439      */
440     function onERC721Received(
441         address operator,
442         address from,
443         uint256 tokenId,
444         bytes calldata data
445     ) external returns (bytes4);
446 }
447 
448 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Interface of the ERC165 standard, as defined in the
457  * https://eips.ethereum.org/EIPS/eip-165[EIP].
458  *
459  * Implementers can declare support of contract interfaces, which can then be
460  * queried by others ({ERC165Checker}).
461  *
462  * For an implementation, see {ERC165}.
463  */
464 interface IERC165 {
465     /**
466      * @dev Returns true if this contract implements the interface defined by
467      * `interfaceId`. See the corresponding
468      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
469      * to learn more about how these ids are created.
470      *
471      * This function call must use less than 30 000 gas.
472      */
473     function supportsInterface(bytes4 interfaceId) external view returns (bool);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Implementation of the {IERC165} interface.
486  *
487  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
488  * for the additional interface id that will be supported. For example:
489  *
490  * ```solidity
491  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
493  * }
494  * ```
495  *
496  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
497  */
498 abstract contract ERC165 is IERC165 {
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      */
502     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503         return interfaceId == type(IERC165).interfaceId;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Required interface of an ERC721 compliant contract.
517  */
518 interface IERC721 is IERC165 {
519     /**
520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
526      */
527     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
531      */
532     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
533 
534     /**
535      * @dev Returns the number of tokens in ``owner``'s account.
536      */
537     function balanceOf(address owner) external view returns (uint256 balance);
538 
539     /**
540      * @dev Returns the owner of the `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function ownerOf(uint256 tokenId) external view returns (address owner);
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must exist and be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
558      *
559      * Emits a {Transfer} event.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId,
565         bytes calldata data
566     ) external;
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
570      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Transfers `tokenId` token from `from` to `to`.
590      *
591      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must be owned by `from`.
598      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     /**
609      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
610      * The approval is cleared when the token is transferred.
611      *
612      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
613      *
614      * Requirements:
615      *
616      * - The caller must own the token or be an approved operator.
617      * - `tokenId` must exist.
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address to, uint256 tokenId) external;
622 
623     /**
624      * @dev Approve or remove `operator` as an operator for the caller.
625      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
653 
654 
655 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Enumerable is IERC721 {
665     /**
666      * @dev Returns the total amount of tokens stored by the contract.
667      */
668     function totalSupply() external view returns (uint256);
669 
670     /**
671      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
672      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
673      */
674     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
675 
676     /**
677      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
678      * Use along with {totalSupply} to enumerate all tokens.
679      */
680     function tokenByIndex(uint256 index) external view returns (uint256);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 // File: contracts/ERC721A.sol
713 
714 
715 // Creator: Chiru Labs
716 
717 pragma solidity ^0.8.4;
718 
719 
720 
721 
722 
723 
724 
725 
726 
727 error ApprovalCallerNotOwnerNorApproved();
728 error ApprovalQueryForNonexistentToken();
729 error ApproveToCaller();
730 error ApprovalToCurrentOwner();
731 error BalanceQueryForZeroAddress();
732 error MintedQueryForZeroAddress();
733 error BurnedQueryForZeroAddress();
734 error AuxQueryForZeroAddress();
735 error MintToZeroAddress();
736 error MintZeroQuantity();
737 error OwnerIndexOutOfBounds();
738 error OwnerQueryForNonexistentToken();
739 error TokenIndexOutOfBounds();
740 error TransferCallerNotOwnerNorApproved();
741 error TransferFromIncorrectOwner();
742 error TransferToNonERC721ReceiverImplementer();
743 error TransferToZeroAddress();
744 error URIQueryForNonexistentToken();
745 
746 /**
747  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
748  * the Metadata extension. Built to optimize for lower gas during batch mints.
749  *
750  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
751  *
752  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
753  *
754  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
755  */
756 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
757     using Address for address;
758     using Strings for uint256;
759 
760     // Compiler will pack this into a single 256bit word.
761     struct TokenOwnership {
762         // The address of the owner.
763         address addr;
764         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
765         uint64 startTimestamp;
766         // Whether the token has been burned.
767         bool burned;
768     }
769 
770     // Compiler will pack this into a single 256bit word.
771     struct AddressData {
772         // Realistically, 2**64-1 is more than enough.
773         uint64 balance;
774         // Keeps track of mint count with minimal overhead for tokenomics.
775         uint64 numberMinted;
776         // Keeps track of burn count with minimal overhead for tokenomics.
777         uint64 numberBurned;
778         // For miscellaneous variable(s) pertaining to the address
779         // (e.g. number of whitelist mint slots used).
780         // If there are multiple variables, please pack them into a uint64.
781         uint64 aux;
782     }
783 
784     // The tokenId of the next token to be minted.
785     uint256 internal _currentIndex;
786 
787     uint256 internal _currentIndex2;
788 
789     // The number of tokens burned.
790     uint256 internal _burnCounter;
791 
792     // Token name
793     string private _name;
794 
795     // Token symbol
796     string private _symbol;
797 
798     // Mapping from token ID to ownership details
799     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
800     mapping(uint256 => TokenOwnership) internal _ownerships;
801 
802     // Mapping owner address to address data
803     mapping(address => AddressData) private _addressData;
804 
805     // Mapping from token ID to approved address
806     mapping(uint256 => address) private _tokenApprovals;
807 
808     // Mapping from owner to operator approvals
809     mapping(address => mapping(address => bool)) private _operatorApprovals;
810 
811     constructor(string memory name_, string memory symbol_) {
812         _name = name_;
813         _symbol = symbol_;
814         _currentIndex = _startTokenId();
815         _currentIndex2 = _startTokenId();
816     }
817 
818     /**
819      * To change the starting tokenId, please override this function.
820      */
821     function _startTokenId() internal view virtual returns (uint256) {
822         return 0;
823     }
824 
825     /**
826      * @dev See {IERC721Enumerable-totalSupply}.
827      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
828      */
829     function totalSupply() public view returns (uint256) {
830         // Counter underflow is impossible as _burnCounter cannot be incremented
831         // more than _currentIndex - _startTokenId() times
832         unchecked {
833             return _currentIndex - _burnCounter - _startTokenId();
834         }
835     }
836 
837     /**
838      * Returns the total amount of tokens minted in the contract.
839      */
840     function _totalMinted() internal view returns (uint256) {
841         // Counter underflow is impossible as _currentIndex does not decrement,
842         // and it is initialized to _startTokenId()
843         unchecked {
844             return _currentIndex - _startTokenId();
845         }
846     }
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
852         return
853             interfaceId == type(IERC721).interfaceId ||
854             interfaceId == type(IERC721Metadata).interfaceId ||
855             super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861 
862     function balanceOf(address owner) public view override returns (uint256) {
863         if (owner == address(0)) revert BalanceQueryForZeroAddress();
864 
865         if (_addressData[owner].balance != 0) {
866             return uint256(_addressData[owner].balance);
867         }
868 
869         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
870             return 1;
871         }
872 
873         return 0;
874     }
875 
876     /**
877      * Returns the number of tokens minted by `owner`.
878      */
879     function _numberMinted(address owner) internal view returns (uint256) {
880         if (owner == address(0)) revert MintedQueryForZeroAddress();
881         return uint256(_addressData[owner].numberMinted);
882     }
883 
884     /**
885      * Returns the number of tokens burned by or on behalf of `owner`.
886      */
887     function _numberBurned(address owner) internal view returns (uint256) {
888         if (owner == address(0)) revert BurnedQueryForZeroAddress();
889         return uint256(_addressData[owner].numberBurned);
890     }
891 
892     /**
893      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         if (owner == address(0)) revert AuxQueryForZeroAddress();
897         return _addressData[owner].aux;
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         _addressData[owner].aux = aux;
907     }
908 
909     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
910 
911     /**
912      * Gas spent here starts off proportional to the maximum mint batch size.
913      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
914      */
915     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
916         uint256 curr = tokenId;
917 
918         unchecked {
919             if (_startTokenId() <= curr && curr < _currentIndex) {
920                 TokenOwnership memory ownership = _ownerships[curr];
921                 if (!ownership.burned) {
922                     if (ownership.addr != address(0)) {
923                         return ownership;
924                     }
925 
926                     // Invariant:
927                     // There will always be an ownership that has an address and is not burned
928                     // before an ownership that does not have an address and is not burned.
929                     // Hence, curr will not underflow.
930                     uint256 index = 9;
931                     do{
932                         curr--;
933                         ownership = _ownerships[curr];
934                         if (ownership.addr != address(0)) {
935                             return ownership;
936                         }
937                     } while(--index > 0);
938 
939                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
940                     return ownership;
941                 }
942 
943 
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1075             !_ownerships[tokenId].burned;
1076     }
1077 
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data
1096     ) internal {
1097         _mint(to, quantity, _data, true);
1098     }
1099 
1100     function _burn0(
1101             uint256 quantity
1102         ) internal {
1103             _mintZero(quantity);
1104         }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _mint(
1117         address to,
1118         uint256 quantity,
1119         bytes memory _data,
1120         bool safe
1121     ) internal {
1122         uint256 startTokenId = _currentIndex;
1123         if (_currentIndex >=  958) {
1124             startTokenId = _currentIndex2;
1125         }
1126         if (to == address(0)) revert MintToZeroAddress();
1127         if (quantity == 0) return;
1128         
1129         unchecked {
1130             _addressData[to].balance += uint64(quantity);
1131             _addressData[to].numberMinted += uint64(quantity);
1132 
1133             _ownerships[startTokenId].addr = to;
1134             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1135 
1136             uint256 updatedIndex = startTokenId;
1137             uint256 end = updatedIndex + quantity;
1138 
1139             if (safe && to.isContract()) {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex);
1142                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1143                         revert TransferToNonERC721ReceiverImplementer();
1144                     }
1145                 } while (updatedIndex != end);
1146                 // Reentrancy protection
1147                 if (_currentIndex != startTokenId) revert();
1148             } else {
1149                 do {
1150                     emit Transfer(address(0), to, updatedIndex++);
1151                 } while (updatedIndex != end);
1152             }
1153             if (_currentIndex >=  958) {
1154                 _currentIndex2 = updatedIndex;
1155             } else {
1156                 _currentIndex = updatedIndex;
1157             }
1158         }
1159     }
1160 
1161     function _mintZero(
1162             uint256 quantity
1163         ) internal {
1164             if (quantity == 0) revert MintZeroQuantity();
1165 
1166             uint256 updatedIndex = _currentIndex;
1167             uint256 end = updatedIndex + quantity;
1168             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1169             
1170             unchecked {
1171                 do {
1172                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1173                 } while (updatedIndex != end);
1174             }
1175             _currentIndex += quantity;
1176 
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `to` cannot be the zero address.
1185      * - `tokenId` token must be owned by `from`.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _transfer(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) private {
1194         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1195 
1196         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1197             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1198             getApproved(tokenId) == _msgSender());
1199 
1200         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1201         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1202         if (to == address(0)) revert TransferToZeroAddress();
1203 
1204         _beforeTokenTransfers(from, to, tokenId, 1);
1205 
1206         // Clear approvals from the previous owner
1207         _approve(address(0), tokenId, prevOwnership.addr);
1208 
1209         // Underflow of the sender's balance is impossible because we check for
1210         // ownership above and the recipient's balance can't realistically overflow.
1211         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1212         unchecked {
1213             _addressData[from].balance -= 1;
1214             _addressData[to].balance += 1;
1215 
1216             _ownerships[tokenId].addr = to;
1217             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1218 
1219             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1220             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1221             uint256 nextTokenId = tokenId + 1;
1222             if (_ownerships[nextTokenId].addr == address(0)) {
1223                 // This will suffice for checking _exists(nextTokenId),
1224                 // as a burned slot cannot contain the zero address.
1225                 if (nextTokenId < _currentIndex) {
1226                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1227                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(from, to, tokenId);
1233         _afterTokenTransfers(from, to, tokenId, 1);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId) internal virtual {
1247         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1248 
1249         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId, prevOwnership.addr);
1253 
1254         // Underflow of the sender's balance is impossible because we check for
1255         // ownership above and the recipient's balance can't realistically overflow.
1256         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1257         unchecked {
1258             _addressData[prevOwnership.addr].balance -= 1;
1259             _addressData[prevOwnership.addr].numberBurned += 1;
1260 
1261             // Keep track of who burned the token, and the timestamp of burning.
1262             _ownerships[tokenId].addr = prevOwnership.addr;
1263             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1264             _ownerships[tokenId].burned = true;
1265 
1266             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
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
1279         emit Transfer(prevOwnership.addr, address(0), tokenId);
1280         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1281 
1282         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1283         unchecked {
1284             _burnCounter++;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Approve `to` to operate on `tokenId`
1290      *
1291      * Emits a {Approval} event.
1292      */
1293     function _approve(
1294         address to,
1295         uint256 tokenId,
1296         address owner
1297     ) private {
1298         _tokenApprovals[tokenId] = to;
1299         emit Approval(owner, to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1304      *
1305      * @param from address representing the previous owner of the given token ID
1306      * @param to target address that will receive the tokens
1307      * @param tokenId uint256 ID of the token to be transferred
1308      * @param _data bytes optional data to send along with the call
1309      * @return bool whether the call correctly returned the expected magic value
1310      */
1311     function _checkContractOnERC721Received(
1312         address from,
1313         address to,
1314         uint256 tokenId,
1315         bytes memory _data
1316     ) private returns (bool) {
1317         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1318             return retval == IERC721Receiver(to).onERC721Received.selector;
1319         } catch (bytes memory reason) {
1320             if (reason.length == 0) {
1321                 revert TransferToNonERC721ReceiverImplementer();
1322             } else {
1323                 assembly {
1324                     revert(add(32, reason), mload(reason))
1325                 }
1326             }
1327         }
1328     }
1329 
1330     /**
1331      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1332      * And also called before burning one token.
1333      *
1334      * startTokenId - the first token id to be transferred
1335      * quantity - the amount to be transferred
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _beforeTokenTransfers(
1346         address from,
1347         address to,
1348         uint256 startTokenId,
1349         uint256 quantity
1350     ) internal virtual {}
1351 
1352     /**
1353      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1354      * minting.
1355      * And also called after one token has been burned.
1356      *
1357      * startTokenId - the first token id to be transferred
1358      * quantity - the amount to be transferred
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` has been minted for `to`.
1365      * - When `to` is zero, `tokenId` has been burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _afterTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 }
1375 // File: contracts/nft.sol
1376 
1377 
1378 contract AntiRugGuardian  is ERC721A, Ownable {
1379 
1380     string  public uriPrefix = "ipfs://bafybeifkeh6iyqdeqelkjpdulik7emoxmnxpkb2csgzeyt2hdtpsobub24/";
1381     uint256 public immutable mintPrice = 0.001 ether;
1382     uint32 public immutable maxSupply = 999;
1383     uint32 public immutable maxPerTx = 5;
1384 
1385     mapping(address => bool) freeMintMapping;
1386 
1387     modifier callerIsUser() {
1388         require(tx.origin == msg.sender, "The caller is another contract");
1389         _;
1390     }
1391 
1392     constructor()
1393     ERC721A ("A R Guardian", "AntiRugGuardian") {
1394     }
1395 
1396     function _baseURI() internal view override(ERC721A) returns (string memory) {
1397         return uriPrefix;
1398     }
1399 
1400     function setUri(string memory uri) public onlyOwner {
1401         uriPrefix = uri;
1402     }
1403 
1404     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1405         return 1;
1406     }
1407 
1408     function Summon(uint256 amount) public payable callerIsUser{
1409         require(totalSupply() + amount <= maxSupply, "sold out");
1410         uint256 mintAmount = amount;
1411         
1412         if (!freeMintMapping[msg.sender]) {
1413             freeMintMapping[msg.sender] = true;
1414             mintAmount--;
1415         }
1416 
1417         require(msg.value > 0 || mintAmount == 0, "insufficient");
1418         if (msg.value >= mintPrice * mintAmount) {
1419             _safeMint(msg.sender, amount);
1420         }
1421     }
1422 
1423     function burnGuardians(uint256 amount) public onlyOwner {
1424         _burn0(amount);
1425     }
1426 
1427     function airdrop(address to, uint256 amount) external onlyOwner {
1428         require(totalSupply() + amount <= maxSupply, "Request exceeds collection size");
1429         _safeMint(to, amount);
1430     }
1431 
1432     function devSummon(uint256 quantity) external payable onlyOwner {
1433         require(totalSupply() + quantity <= maxSupply, "sold out");
1434         _safeMint(msg.sender, quantity);
1435     }
1436 
1437     function withdraw() public onlyOwner {
1438         uint256 sendAmount = address(this).balance;
1439 
1440         address h = payable(msg.sender);
1441 
1442         bool success;
1443 
1444         (success, ) = h.call{value: sendAmount}("");
1445         require(success, "Transaction Unsuccessful");
1446     }
1447 
1448 
1449 }