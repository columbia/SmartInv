1 // File: contracts/IERC2981Royalties.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /// @title IERC2981Royalties
7 /// @dev Interface for the ERC2981 - Token Royalty standard
8 interface IERC2981Royalties {
9     /// @notice Called with the sale price to determine how much royalty
10     //          is owed and to whom.
11     /// @param _tokenId - the NFT asset queried for royalty information
12     /// @param _value - the sale price of the NFT asset specified by _tokenId
13     /// @return _receiver - address of who should be sent the royalty payment
14     /// @return _royaltyAmount - the royalty payment amount for value sale price
15     function royaltyInfo(uint256 _tokenId, uint256 _value)
16         external
17         view
18         returns (address _receiver, uint256 _royaltyAmount);
19 }
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
88 }
89 
90 // File: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/access/Ownable.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _transferOwnership(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _transferOwnership(newOwner);
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Internal function without access restriction.
187      */
188     function _transferOwnership(address newOwner) internal virtual {
189         address oldOwner = _owner;
190         _owner = newOwner;
191         emit OwnershipTransferred(oldOwner, newOwner);
192     }
193 }
194 
195 // File: @openzeppelin/contracts/utils/Address.sol
196 
197 
198 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
199 
200 pragma solidity ^0.8.1;
201 
202 /**
203  * @dev Collection of functions related to the address type
204  */
205 library Address {
206     /**
207      * @dev Returns true if `account` is a contract.
208      *
209      * [IMPORTANT]
210      * ====
211      * It is unsafe to assume that an address for which this function returns
212      * false is an externally-owned account (EOA) and not a contract.
213      *
214      * Among others, `isContract` will return false for the following
215      * types of addresses:
216      *
217      *  - an externally-owned account
218      *  - a contract in construction
219      *  - an address where a contract will be created
220      *  - an address where a contract lived, but was destroyed
221      * ====
222      *
223      * [IMPORTANT]
224      * ====
225      * You shouldn't rely on `isContract` to protect against flash loan attacks!
226      *
227      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
228      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
229      * constructor.
230      * ====
231      */
232     function isContract(address account) internal view returns (bool) {
233         // This method relies on extcodesize/address.code.length, which returns 0
234         // for contracts in construction, since the code is only stored at the end
235         // of the constructor execution.
236 
237         return account.code.length > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{value: amount}("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain `call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionCall(target, data, "Address: low-level call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287      * `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, 0, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but also transferring `value` wei to `target`.
302      *
303      * Requirements:
304      *
305      * - the calling contract must have an ETH balance of at least `value`.
306      * - the called Solidity function must be `payable`.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value
314     ) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(address(this).balance >= value, "Address: insufficient balance for call");
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.delegatecall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
393      * revert reason using the provided one.
394      *
395      * _Available since v4.3._
396      */
397     function verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) internal pure returns (bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @title ERC721 token receiver interface
429  * @dev Interface for any contract that wants to support safeTransfers
430  * from ERC721 asset contracts.
431  */
432 interface IERC721Receiver {
433     /**
434      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
435      * by `operator` from `from`, this function is called.
436      *
437      * It must return its Solidity selector to confirm the token transfer.
438      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
439      *
440      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
441      */
442     function onERC721Received(
443         address operator,
444         address from,
445         uint256 tokenId,
446         bytes calldata data
447     ) external returns (bytes4);
448 }
449 
450 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Interface of the ERC165 standard, as defined in the
459  * https://eips.ethereum.org/EIPS/eip-165[EIP].
460  *
461  * Implementers can declare support of contract interfaces, which can then be
462  * queried by others ({ERC165Checker}).
463  *
464  * For an implementation, see {ERC165}.
465  */
466 interface IERC165 {
467     /**
468      * @dev Returns true if this contract implements the interface defined by
469      * `interfaceId`. See the corresponding
470      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
471      * to learn more about how these ids are created.
472      *
473      * This function call must use less than 30 000 gas.
474      */
475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Implementation of the {IERC165} interface.
488  *
489  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
490  * for the additional interface id that will be supported. For example:
491  *
492  * ```solidity
493  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
495  * }
496  * ```
497  *
498  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
499  */
500 abstract contract ERC165 is IERC165 {
501     /**
502      * @dev See {IERC165-supportsInterface}.
503      */
504     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505         return interfaceId == type(IERC165).interfaceId;
506     }
507 }
508 
509 // File: contracts/ERC2981Base.sol
510 
511 
512 pragma solidity ^0.8.0;
513 
514 
515 
516 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
517 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
518     struct RoyaltyInfo {
519         address recipient;
520         uint24 amount;
521     }
522 
523     /// @inheritdoc ERC165
524     function supportsInterface(bytes4 interfaceId)
525         public
526         view
527         virtual
528         override
529         returns (bool)
530     {
531         return
532             interfaceId == type(IERC2981Royalties).interfaceId ||
533             super.supportsInterface(interfaceId);
534     }
535 }
536 // File: contracts/ERC2981ContractWideRoyalties.sol
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
544 /// @dev This implementation has the same royalties for each and every tokens
545 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
546     RoyaltyInfo private _royalties;
547 
548     /// @dev Sets token royalties
549     /// @param recipient recipient of the royalties
550     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
551     function _setRoyalties(address recipient, uint256 value) internal {
552         require(value <= 10000, 'ERC2981Royalties: Too high');
553         _royalties = RoyaltyInfo(recipient, uint24(value));
554     }
555 
556     /// @inheritdoc IERC2981Royalties
557     function royaltyInfo(uint256, uint256 value)
558         external
559         view
560         override
561         returns (address receiver, uint256 royaltyAmount)
562     {
563         RoyaltyInfo memory royalties = _royalties;
564         receiver = royalties.recipient;
565         royaltyAmount = (value * royalties.amount) / 10000;
566     }
567 }
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers `tokenId` token from `from` to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - `tokenId` must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 
692     /**
693      * @dev Safely transfers `tokenId` token from `from` to `to`.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes calldata data
710     ) external;
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 
753 
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint256 => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint256) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view virtual override returns (uint256) {
805         require(owner != address(0), "ERC721: balance query for the zero address");
806         return _balances[owner];
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
813         address owner = _owners[tokenId];
814         require(owner != address(0), "ERC721: owner query for nonexistent token");
815         return owner;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId) public view virtual override returns (address) {
870         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         _setApprovalForAll(_msgSender(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         //solhint-disable-next-line max-line-length
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
924         _safeTransfer(from, to, tokenId, _data);
925     }
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
932      *
933      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
934      * implement alternative mechanisms to perform token transfer, such as signature-based.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeTransfer(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _transfer(from, to, tokenId);
952         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      * and stop existing when they are burned (`_burn`).
962      */
963     function _exists(uint256 tokenId) internal view virtual returns (bool) {
964         return _owners[tokenId] != address(0);
965     }
966 
967     /**
968      * @dev Returns whether `spender` is allowed to manage `tokenId`.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      */
974     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
975         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
976         address owner = ERC721.ownerOf(tokenId);
977         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
978     }
979 
980     /**
981      * @dev Safely mints `tokenId` and transfers it to `to`.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(address to, uint256 tokenId) internal virtual {
991         _safeMint(to, tokenId, "");
992     }
993 
994     /**
995      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
996      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
997      */
998     function _safeMint(
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) internal virtual {
1003         _mint(to, tokenId);
1004         require(
1005             _checkOnERC721Received(address(0), to, tokenId, _data),
1006             "ERC721: transfer to non ERC721Receiver implementer"
1007         );
1008     }
1009 
1010     /**
1011      * @dev Mints `tokenId` and transfers it to `to`.
1012      *
1013      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must not exist.
1018      * - `to` cannot be the zero address.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _mint(address to, uint256 tokenId) internal virtual {
1023         require(to != address(0), "ERC721: mint to the zero address");
1024         require(!_exists(tokenId), "ERC721: token already minted");
1025 
1026         _beforeTokenTransfer(address(0), to, tokenId);
1027 
1028         _balances[to] += 1;
1029         _owners[tokenId] = to;
1030 
1031         emit Transfer(address(0), to, tokenId);
1032 
1033         _afterTokenTransfer(address(0), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Destroys `tokenId`.
1038      * The approval is cleared when the token is burned.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _burn(uint256 tokenId) internal virtual {
1047         address owner = ERC721.ownerOf(tokenId);
1048 
1049         _beforeTokenTransfer(owner, address(0), tokenId);
1050 
1051         // Clear approvals
1052         _approve(address(0), tokenId);
1053 
1054         _balances[owner] -= 1;
1055         delete _owners[tokenId];
1056 
1057         emit Transfer(owner, address(0), tokenId);
1058 
1059         _afterTokenTransfer(owner, address(0), tokenId);
1060     }
1061 
1062     /**
1063      * @dev Transfers `tokenId` from `from` to `to`.
1064      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual {
1078         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1079         require(to != address(0), "ERC721: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(from, to, tokenId);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId);
1085 
1086         _balances[from] -= 1;
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(from, to, tokenId);
1091 
1092         _afterTokenTransfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `to` to operate on `tokenId`
1097      *
1098      * Emits a {Approval} event.
1099      */
1100     function _approve(address to, uint256 tokenId) internal virtual {
1101         _tokenApprovals[tokenId] = to;
1102         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Approve `operator` to operate on all of `owner` tokens
1107      *
1108      * Emits a {ApprovalForAll} event.
1109      */
1110     function _setApprovalForAll(
1111         address owner,
1112         address operator,
1113         bool approved
1114     ) internal virtual {
1115         require(owner != operator, "ERC721: approve to caller");
1116         _operatorApprovals[owner][operator] = approved;
1117         emit ApprovalForAll(owner, operator, approved);
1118     }
1119 
1120     /**
1121      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1122      * The call is not executed if the target address is not a contract.
1123      *
1124      * @param from address representing the previous owner of the given token ID
1125      * @param to target address that will receive the tokens
1126      * @param tokenId uint256 ID of the token to be transferred
1127      * @param _data bytes optional data to send along with the call
1128      * @return bool whether the call correctly returned the expected magic value
1129      */
1130     function _checkOnERC721Received(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) private returns (bool) {
1136         if (to.isContract()) {
1137             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1138                 return retval == IERC721Receiver.onERC721Received.selector;
1139             } catch (bytes memory reason) {
1140                 if (reason.length == 0) {
1141                     revert("ERC721: transfer to non ERC721Receiver implementer");
1142                 } else {
1143                     assembly {
1144                         revert(add(32, reason), mload(reason))
1145                     }
1146                 }
1147             }
1148         } else {
1149             return true;
1150         }
1151     }
1152 
1153     /**
1154      * @dev Hook that is called before any token transfer. This includes minting
1155      * and burning.
1156      *
1157      * Calling conditions:
1158      *
1159      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1160      * transferred to `to`.
1161      * - When `from` is zero, `tokenId` will be minted for `to`.
1162      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1163      * - `from` and `to` are never both zero.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _beforeTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Hook that is called after any transfer of tokens. This includes
1175      * minting and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - when `from` and `to` are both non-zero.
1180      * - `from` and `to` are never both zero.
1181      *
1182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1183      */
1184     function _afterTokenTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {}
1189 }
1190 
1191 // File: contracts/Weedy.sol
1192 
1193 
1194 pragma solidity >=0.8.4;
1195 
1196 
1197 
1198 
1199 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
1200 //%%%%%#::::=%%%:=:=-%%%======-:==::-%%*=+-=++++++++*%%*+**=%%%%%%%%%%%%=++*+++++++++%%*************%%%++******++*%%%%%%%%
1201 //%%%%%#=**=--%%:=++--%%:::-+=:-=-=:-=%*=--++++++++-+*%*+=*+%%%%%%%%%%%%**+#*+*****+++%++++++++++++=*%%+=********=*%%%%%%%
1202 //%%%%%#++=---%%:=++--%%==-====-=-=:--=*=++========--+%*+++++%%%%%%%%%%%**+******+=+++%+++++++++*++++*%+==++++++++=*%%%%%%
1203 //%%%%%#=-=---%%:=++--%%:++++==---=:--=*=+-+*******+-*%*+*+++%%%%%%%%%%%*++******+=+++%+*#########+++*%+=++*****#**+#%%%%%
1204 //%%%%%#=#+=--%%:=++--%%#---------=:--=*=**----%=*+*-*%*+++++%%%%%%%%%%%***##+++++=+++%+*##+######+++*%+=++++++***#+##%%%%
1205 //%%%%%#+-*=====:==+--%%=-::::::--=:--=*=+=--=+%+=+*-*%*++*++%%%%%%%%%%%*+*#+#**++=+++%+==+++++#*++++*%+==+*++***++++#%%%%
1206 //%%%%%#=*:=-::::::+--%%++==::::--=:--=*=++--+%%+=+*-*%*++*++%%%%%%%%%%%*+*#+*%%*+=+++%+==*++*##*++++*%+=++*+*%#*++++#%%%%
1207 //%%%%%#=#++-=--:-+:--%%+++=*--:===---=*=++--+%%+=+*-*%*++*++%%%%%%%%%%%*+*#+*%%*+=+++%+=++++#%%*++++*%+=++*+*%#*++++#%%%%
1208 //%%%%%#+=======:=++--%%++---==-====--=*=++--+%%+=+*-*%*++*++%%%%%%%%%%%*+*#++++++=+++%+==*++#%%*++++*%+=++*+*%#*++++#%%%%
1209 //%%%%%#++++++++:=++--%%+++=-++++++++-=*=++--*%%+=+*-*%*=+*++%%%%%%%%%%%*+*+****++=+++%+==*++#%%*++++*%+=++*+*%#+++++#%%%%
1210 //%%%%%%=-------:=++--%%+++=*--------+=*=++--*%%+=+*-*%*=+*++%%%%%%%%%%%*+*#=++++==+++%+==*++#%%*++++*%+=++*+*%#+++++#%%%%
1211 //%%%%%%%-------:=++--%%++==-=########%*--:--*%%+=+*-*%*=+*++%%%%%%%%%%%++*******==+++%+==*++#%%*++++*%+=++*+*%#===++#%%%%
1212 //%%%%%%%%%%%%%%:=++--%%+::=--:::::=-#%*::::::::==+*-*%*=+*+======+=#%%%*#+**+++++=+++%+==*++#%%*++++*%+========+==++#%%%%
1213 //%%%%%%%%%%%%%%:=++--%%+========-=:--#*=========++*-*%*=+*+==****+*+#%%*=*=+***+***++%+==*++#%%*++++*%+=++******=+++#%%%%
1214 //%%%%%%%%%%%%%%:=+=--%%-********-=:--=*=+++++++++++-*%*=+*==+*****+++%%*+*#+*%%*+=+++%+==*++#%%*++++*%+=+*******==++#%%%%
1215 //%%%%%%%%%%%%%%=++=--%%=+*********:--=*=++++++++++--*%*=**********+++%%*++++*%%*+**++%+==+++#%%*+*++*%+=*******+=+++#%%%%
1216 //%%%%%%%%%%%%%%----*=%%*=-=-------=++=%+------------*%%**++++++++++*+%%*+++#*%%#*++**%#*+++*#%%+++++*%#*++++++++#*+#%%%%%
1217 //%%%%%%%%%%%%%%%----*%%%+----------=++%%=-----------*%%%*+++++++++++*%%#*+++#%%%#+++#%%#*+++#%%%++++*%%#*++++++++##%%%%%%
1218 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
1219 
1220 interface MultisigContract {
1221     function getOwners() external view returns (address[] memory);
1222 }
1223 
1224 contract WEEDY is ERC721, Ownable, ERC2981ContractWideRoyalties {
1225     function supportsInterface(bytes4 interfaceId)
1226         public
1227         view
1228         virtual
1229         override(ERC721, ERC2981Base)
1230         returns (bool)
1231     {
1232         return super.supportsInterface(interfaceId);
1233     }
1234 
1235 
1236     /// @notice Allows to set the royalties on the contract
1237     /// @dev This function should be protected with a onlyAdmins, onlyMultisig (or equivalent) modifier
1238     /// @param recipient the royalties recipient
1239     /// @param value royalties value
1240     function setRoyalties(address recipient, uint256 value)
1241         public
1242         onlyAdmins
1243     {
1244         _setRoyalties(recipient, value);
1245     }
1246 
1247     MultisigContract multisigContract;
1248 
1249     bool public saleActive = false;
1250     bool public presaleActive = true;
1251     bool public promoSaleActive = true;
1252     string internal baseTokenURI;
1253 
1254     uint256 public price = 0.042 ether;
1255 
1256     //////////
1257     //LIMITS//
1258     //////////
1259     uint256 public totalSupply = 5460;
1260     uint256 public dropLimit = 2000;
1261     uint256 public maxNFTPerAddress = 10;
1262     uint256 public maxTx = 8;
1263 
1264     uint256 public nonce = 1;
1265     uint256 public discount = 50;
1266 
1267     event Mint(address owner, uint256 qty);
1268     event FreeMint(address to, uint256 qty);
1269     event DiscountMint(address to, uint256 qty);
1270     event Withdraw(uint256 amount);
1271     event Received(address, uint);
1272    
1273 
1274     address public admin;
1275     address public MultisigWallet;
1276     address[] public MultisigOwners;
1277 
1278     uint256[] public OwnersPercentage = [60, 7, 5, 5, 5, 5, 5, 5, 3];
1279 
1280     //////////////
1281     ///MODIFIERS//
1282     //////////////
1283 
1284     modifier onlyMultisig() {
1285         require(msg.sender == MultisigWallet, "Use the MultisigWallet");
1286         _;
1287     }
1288 
1289     modifier onlyAdmins() {
1290         require(
1291             msg.sender == owner() || msg.sender == admin,
1292             "Use the Admins wallets"
1293         );
1294         _;
1295     }
1296 
1297     ////////////
1298     //MAPPINGS//
1299     ////////////
1300     mapping(address => uint256) public presaleWallets;
1301     mapping(address => uint256) public FreeMintsWallets;
1302     mapping(address => uint256) public DiscoutWallets;
1303 
1304     constructor(address _multisigWallet, address _admin)
1305         ERC721("Weedy", "420L&W")
1306     {
1307         MultisigWallet = _multisigWallet;
1308         admin = _admin;
1309         multisigContract = MultisigContract(_multisigWallet);
1310     }
1311 
1312     function setPrice(uint256 newPrice) external onlyAdmins {
1313         price = newPrice;
1314     }
1315 
1316     function setDropLimit(uint256 _dropLimit) external onlyAdmins {
1317         dropLimit = _dropLimit;
1318     }
1319 
1320     function setBaseTokenURI(string calldata _uri) external onlyAdmins {
1321         baseTokenURI = _uri;
1322     }
1323 
1324     function setPresaleActive(bool val) public onlyAdmins {
1325         presaleActive = val;
1326     }
1327 
1328     function setSaleActive(bool val) public onlyAdmins {
1329         saleActive = val;
1330     }
1331 
1332     function setPromoSaleActive(bool val) public onlyAdmins {
1333         promoSaleActive = val;
1334     }
1335 
1336     ////////////////
1337     //WALLET LISTS//
1338     ////////////////
1339     function setPresaleWallets(address[] memory _a, uint256[] memory _amount)
1340         public
1341         onlyAdmins
1342     {
1343         for (uint256 i = 0; i < _a.length; i++) {
1344             presaleWallets[_a[i]] = _amount[i];
1345         }
1346     }
1347 
1348     function setFreeMintsWallets(address[] memory _a, uint256[] memory _amount)
1349         public
1350         onlyAdmins
1351     {
1352         for (uint256 i = 0; i < _a.length; i++) {
1353             FreeMintsWallets[_a[i]] = _amount[i];
1354         }
1355     }
1356 
1357     function setDiscoutWallets(address[] memory _a, uint256[] memory _amount)
1358         public
1359         onlyAdmins
1360     {
1361         for (uint256 i = 0; i < _a.length; i++) {
1362             DiscoutWallets[_a[i]] = _amount[i];
1363         }
1364     }
1365 
1366     function setMaxTx(uint256 newMax) external onlyAdmins {
1367         maxTx = newMax;
1368     }
1369 
1370     function setDiscount(uint256 _discount) external onlyAdmins {
1371         discount = _discount;
1372     }
1373 
1374     function getAssetsByOwner(address _owner)
1375         public
1376         view
1377         returns (uint256[] memory)
1378     {
1379         uint256[] memory result = new uint256[](balanceOf(_owner));
1380         uint256 counter = 0;
1381         for (uint256 i = 0; i < nonce; i++) {
1382             if (ownerOf(i) == _owner) {
1383                 result[counter] = i;
1384                 counter++;
1385             }
1386         }
1387         return result;
1388     }
1389 
1390     function _baseURI() internal view override returns (string memory) {
1391         return baseTokenURI;
1392     }
1393 
1394      receive() external payable {
1395         emit Received(msg.sender, msg.value);
1396     }
1397 
1398     /////////////////////
1399     //MINTING FUNCTIONS//
1400     /////////////////////
1401     function freeMint(uint256 qty) external payable {
1402         uint256 mintAllowance = FreeMintsWallets[msg.sender];
1403         require(qty <= mintAllowance, "You are not allowed to mint for free");
1404         require(
1405            qty + nonce <= dropLimit,
1406             "SUPPLY: Value exceeds dropLimit"
1407         );
1408 
1409         FreeMintsWallets[msg.sender] = FreeMintsWallets[msg.sender] - qty;
1410         for (uint256 i = 0; i < qty; i++) {
1411             uint256 tokenId = nonce;
1412             _safeMint(msg.sender, tokenId);
1413             nonce++;
1414         }
1415         emit FreeMint(msg.sender, qty);
1416     }
1417 
1418     function discountMint(uint256 qty) external payable {
1419         uint256 mintAllowance = DiscoutWallets[msg.sender];
1420         require(promoSaleActive, "DiscountMint is not active");
1421         require(qty <= mintAllowance, "You are not allowed to mint discounted");
1422         require(
1423             qty + nonce <= dropLimit,
1424             "SUPPLY: Value exceeds dropLimit"
1425         );
1426         require(
1427             msg.value >= (price * qty * discount) / 100,
1428             "PAYMENT: invalid value"
1429         );
1430 
1431         DiscoutWallets[msg.sender] = DiscoutWallets[msg.sender] - qty;
1432         for (uint256 i = 0; i < qty; i++) {
1433             uint256 tokenId = nonce;
1434             _safeMint(msg.sender, tokenId);
1435             nonce++;
1436         }
1437         emit DiscountMint(msg.sender, qty);
1438     }
1439 
1440     function buyPresale() external payable {
1441         uint256 mintAllowance = presaleWallets[msg.sender];
1442 
1443         require(presaleActive, "Presale is not active");
1444         require(mintAllowance>1, "You are not on Presale");
1445         require(
1446            nonce + 2 <= dropLimit,
1447             "SUPPLY: Value exceeds dropLimit"
1448         );
1449         require(
1450             balanceOf(msg.sender) + 2 <= maxNFTPerAddress,
1451             "SUPPLY: qty exeeding wallet limit"
1452         );
1453         require(msg.value >= price, "PAYMENT: invalid value");
1454         presaleWallets[msg.sender] = presaleWallets[msg.sender] - 2;
1455 
1456         _safeMint(msg.sender, nonce);
1457         nonce++;
1458         _safeMint(msg.sender, nonce);
1459         nonce++;
1460 
1461         emit Mint(msg.sender, 2);
1462     }
1463 
1464     function buy(uint256 qty) external payable {
1465         require(saleActive, "sale is not active");
1466         require(qty <= maxTx && qty > 0, "qty of mints not allowed");
1467         require(
1468             qty + nonce <= dropLimit,
1469             "SUPPLY: Value exceeds dropLimit"
1470         );
1471         require(msg.value >= price * qty, "PAYMENT: invalid value");
1472         for (uint256 i = 0; i < qty; i++) {
1473             uint256 tokenId = nonce;
1474             _safeMint(msg.sender, tokenId);
1475             nonce++;
1476         }
1477         emit Mint(msg.sender, qty);
1478     }
1479 
1480     ////////////
1481     //WITHDRAW//
1482     ////////////
1483     function withdraw() public onlyAdmins {
1484         MultisigOwners = multisigContract.getOwners();
1485         uint256 amount = address(this).balance;
1486 
1487         for (uint256 i = 0; i < MultisigOwners.length; i++) {
1488             payable(MultisigOwners[i]).transfer(
1489                 (amount * OwnersPercentage[i]) / 100
1490             );
1491         }
1492     }
1493 
1494     function ChangeOwnersPercentage(uint256[] calldata _newPercentages)
1495         public
1496         onlyMultisig
1497     {
1498         OwnersPercentage = _newPercentages;
1499     }
1500 }