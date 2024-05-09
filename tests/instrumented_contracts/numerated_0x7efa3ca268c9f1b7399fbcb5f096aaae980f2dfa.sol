1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-10-03
7 */
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 
12 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21     uint8 private constant _ADDRESS_LENGTH = 20;
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 
79     /**
80      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
81      */
82     function toHexString(address addr) internal pure returns (string memory) {
83         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/access/Ownable.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         _checkOwner();
151         _;
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if the sender is not the owner.
163      */
164     function _checkOwner() internal view virtual {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/utils/Address.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
203 
204 pragma solidity ^0.8.1;
205 
206 /**
207  * @dev Collection of functions related to the address type
208  */
209 library Address {
210     /**
211      * @dev Returns true if `account` is a contract.
212      *
213      * [IMPORTANT]
214      * ====
215      * It is unsafe to assume that an address for which this function returns
216      * false is an externally-owned account (EOA) and not a contract.
217      *
218      * Among others, `isContract` will return false for the following
219      * types of addresses:
220      *
221      *  - an externally-owned account
222      *  - a contract in construction
223      *  - an address where a contract will be created
224      *  - an address where a contract lived, but was destroyed
225      * ====
226      *
227      * [IMPORTANT]
228      * ====
229      * You shouldn't rely on `isContract` to protect against flash loan attacks!
230      *
231      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
232      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
233      * constructor.
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize/address.code.length, which returns 0
238         // for contracts in construction, since the code is only stored at the end
239         // of the constructor execution.
240 
241         return account.code.length > 0;
242     }
243 
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         (bool success, ) = recipient.call{value: amount}("");
264         require(success, "Address: unable to send value, recipient may have reverted");
265     }
266 
267     /**
268      * @dev Performs a Solidity function call using a low level `call`. A
269      * plain `call` is an unsafe replacement for a function call: use this
270      * function instead.
271      *
272      * If `target` reverts with a revert reason, it is bubbled up by this
273      * function (like regular Solidity function calls).
274      *
275      * Returns the raw returned data. To convert to the expected return value,
276      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
277      *
278      * Requirements:
279      *
280      * - `target` must be a contract.
281      * - calling `target` with `data` must not revert.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionCall(target, data, "Address: low-level call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
291      * `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
324      * with `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(
329         address target,
330         bytes memory data,
331         uint256 value,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         require(address(this).balance >= value, "Address: insufficient balance for call");
335         require(isContract(target), "Address: call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.call{value: value}(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
348         return functionStaticCall(target, data, "Address: low-level static call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal view returns (bytes memory) {
362         require(isContract(target), "Address: static call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.staticcall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(isContract(target), "Address: delegate call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.delegatecall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
397      * revert reason using the provided one.
398      *
399      * _Available since v4.3._
400      */
401     function verifyCallResult(
402         bool success,
403         bytes memory returndata,
404         string memory errorMessage
405     ) internal pure returns (bytes memory) {
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412                 /// @solidity memory-safe-assembly
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
425 
426 
427 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @title ERC721 token receiver interface
433  * @dev Interface for any contract that wants to support safeTransfers
434  * from ERC721 asset contracts.
435  */
436 interface IERC721Receiver {
437     /**
438      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
439      * by `operator` from `from`, this function is called.
440      *
441      * It must return its Solidity selector to confirm the token transfer.
442      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
443      *
444      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
445      */
446     function onERC721Received(
447         address operator,
448         address from,
449         uint256 tokenId,
450         bytes calldata data
451     ) external returns (bytes4);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Interface of the ERC165 standard, as defined in the
463  * https://eips.ethereum.org/EIPS/eip-165[EIP].
464  *
465  * Implementers can declare support of contract interfaces, which can then be
466  * queried by others ({ERC165Checker}).
467  *
468  * For an implementation, see {ERC165}.
469  */
470 interface IERC165 {
471     /**
472      * @dev Returns true if this contract implements the interface defined by
473      * `interfaceId`. See the corresponding
474      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
475      * to learn more about how these ids are created.
476      *
477      * This function call must use less than 30 000 gas.
478      */
479     function supportsInterface(bytes4 interfaceId) external view returns (bool);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Implementation of the {IERC165} interface.
492  *
493  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
494  * for the additional interface id that will be supported. For example:
495  *
496  * ```solidity
497  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
498  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
499  * }
500  * ```
501  *
502  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
503  */
504 abstract contract ERC165 is IERC165 {
505     /**
506      * @dev See {IERC165-supportsInterface}.
507      */
508     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
509         return interfaceId == type(IERC165).interfaceId;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
514 
515 
516 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @dev Required interface of an ERC721 compliant contract.
523  */
524 interface IERC721 is IERC165 {
525     /**
526      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
527      */
528     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
532      */
533     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
534 
535     /**
536      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
537      */
538     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
539 
540     /**
541      * @dev Returns the number of tokens in ``owner``'s account.
542      */
543     function balanceOf(address owner) external view returns (uint256 balance);
544 
545     /**
546      * @dev Returns the owner of the `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function ownerOf(uint256 tokenId) external view returns (address owner);
553 
554     /**
555      * @dev Safely transfers `tokenId` token from `from` to `to`.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
564      *
565      * Emits a {Transfer} event.
566      */
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId,
571         bytes calldata data
572     ) external;
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
576      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     /**
595      * @dev Transfers `tokenId` token from `from` to `to`.
596      *
597      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
616      * The approval is cleared when the token is transferred.
617      *
618      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external;
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
632      *
633      * Requirements:
634      *
635      * - The `operator` cannot be the caller.
636      *
637      * Emits an {ApprovalForAll} event.
638      */
639     function setApprovalForAll(address operator, bool _approved) external;
640 
641     /**
642      * @dev Returns the account approved for `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function getApproved(uint256 tokenId) external view returns (address operator);
649 
650     /**
651      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
652      *
653      * See {setApprovalForAll}
654      */
655     function isApprovedForAll(address owner, address operator) external view returns (bool);
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
659 
660 
661 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
668  * @dev See https://eips.ethereum.org/EIPS/eip-721
669  */
670 interface IERC721Enumerable is IERC721 {
671     /**
672      * @dev Returns the total amount of tokens stored by the contract.
673      */
674     function totalSupply() external view returns (uint256);
675 
676     /**
677      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
678      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
679      */
680     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
681 
682     /**
683      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
684      * Use along with {totalSupply} to enumerate all tokens.
685      */
686     function tokenByIndex(uint256 index) external view returns (uint256);
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Metadata is IERC721 {
702     /**
703      * @dev Returns the token collection name.
704      */
705     function name() external view returns (string memory);
706 
707     /**
708      * @dev Returns the token collection symbol.
709      */
710     function symbol() external view returns (string memory);
711 
712     /**
713      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
714      */
715     function tokenURI(uint256 tokenId) external view returns (string memory);
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
719 
720 
721 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 
727 
728 
729 
730 
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension, but not including the Enumerable extension, which is available separately as
735  * {ERC721Enumerable}.
736  */
737 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
738     using Address for address;
739     using Strings for uint256;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) private _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) private _balances;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     /**
760      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
761      */
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view virtual override returns (uint256) {
781         require(owner != address(0), "ERC721: address zero is not a valid owner");
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
789         address owner = _owners[tokenId];
790         require(owner != address(0), "ERC721: invalid token ID");
791         return owner;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         _requireMinted(tokenId);
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overridden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return "";
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public virtual override {
831         address owner = ERC721.ownerOf(tokenId);
832         require(to != owner, "ERC721: approval to current owner");
833 
834         require(
835             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
836             "ERC721: approve caller is not token owner nor approved for all"
837         );
838 
839         _approve(to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view virtual override returns (address) {
846         _requireMinted(tokenId);
847 
848         return _tokenApprovals[tokenId];
849     }
850 
851     /**
852      * @dev See {IERC721-setApprovalForAll}.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         _setApprovalForAll(_msgSender(), operator, approved);
856     }
857 
858     /**
859      * @dev See {IERC721-isApprovedForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev See {IERC721-transferFrom}.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         //solhint-disable-next-line max-line-length
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
875 
876         _transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         safeTransferFrom(from, to, tokenId, "");
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory data
898     ) public virtual override {
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
900         _safeTransfer(from, to, tokenId, data);
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * `data` is additional data, it has no specified format and it is sent in call to `to`.
908      *
909      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
910      * implement alternative mechanisms to perform token transfer, such as signature-based.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeTransfer(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory data
926     ) internal virtual {
927         _transfer(from, to, tokenId);
928         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
929     }
930 
931     /**
932      * @dev Returns whether `tokenId` exists.
933      *
934      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935      *
936      * Tokens start existing when they are minted (`_mint`),
937      * and stop existing when they are burned (`_burn`).
938      */
939     function _exists(uint256 tokenId) internal view virtual returns (bool) {
940         return _owners[tokenId] != address(0);
941     }
942 
943     /**
944      * @dev Returns whether `spender` is allowed to manage `tokenId`.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      */
950     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
951         address owner = ERC721.ownerOf(tokenId);
952         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007 
1008         _afterTokenTransfer(address(0), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Destroys `tokenId`.
1013      * The approval is cleared when the token is burned.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must exist.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _burn(uint256 tokenId) internal virtual {
1022         address owner = ERC721.ownerOf(tokenId);
1023 
1024         _beforeTokenTransfer(owner, address(0), tokenId);
1025 
1026         // Clear approvals
1027         _approve(address(0), tokenId);
1028 
1029         _balances[owner] -= 1;
1030         delete _owners[tokenId];
1031 
1032         emit Transfer(owner, address(0), tokenId);
1033 
1034         _afterTokenTransfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1054         require(to != address(0), "ERC721: transfer to the zero address");
1055 
1056         _beforeTokenTransfer(from, to, tokenId);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId);
1060 
1061         _balances[from] -= 1;
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(from, to, tokenId);
1066 
1067         _afterTokenTransfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Approve `to` to operate on `tokenId`
1072      *
1073      * Emits an {Approval} event.
1074      */
1075     function _approve(address to, uint256 tokenId) internal virtual {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Approve `operator` to operate on all of `owner` tokens
1082      *
1083      * Emits an {ApprovalForAll} event.
1084      */
1085     function _setApprovalForAll(
1086         address owner,
1087         address operator,
1088         bool approved
1089     ) internal virtual {
1090         require(owner != operator, "ERC721: approve to caller");
1091         _operatorApprovals[owner][operator] = approved;
1092         emit ApprovalForAll(owner, operator, approved);
1093     }
1094 
1095     /**
1096      * @dev Reverts if the `tokenId` has not been minted yet.
1097      */
1098     function _requireMinted(uint256 tokenId) internal view virtual {
1099         require(_exists(tokenId), "ERC721: invalid token ID");
1100     }
1101 
1102     /**
1103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1104      * The call is not executed if the target address is not a contract.
1105      *
1106      * @param from address representing the previous owner of the given token ID
1107      * @param to target address that will receive the tokens
1108      * @param tokenId uint256 ID of the token to be transferred
1109      * @param data bytes optional data to send along with the call
1110      * @return bool whether the call correctly returned the expected magic value
1111      */
1112     function _checkOnERC721Received(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory data
1117     ) private returns (bool) {
1118         if (to.isContract()) {
1119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1120                 return retval == IERC721Receiver.onERC721Received.selector;
1121             } catch (bytes memory reason) {
1122                 if (reason.length == 0) {
1123                     revert("ERC721: transfer to non ERC721Receiver implementer");
1124                 } else {
1125                     /// @solidity memory-safe-assembly
1126                     assembly {
1127                         revert(add(32, reason), mload(reason))
1128                     }
1129                 }
1130             }
1131         } else {
1132             return true;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any token transfer. This includes minting
1138      * and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1146      * - `from` and `to` are never both zero.
1147      *
1148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1149      */
1150     function _beforeTokenTransfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after any transfer of tokens. This includes
1158      * minting and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - when `from` and `to` are both non-zero.
1163      * - `from` and `to` are never both zero.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _afterTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {}
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 
1183 /**
1184  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1185  * enumerability of all the token ids in the contract as well as all token ids owned by each
1186  * account.
1187  */
1188 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1189     // Mapping from owner to list of owned token IDs
1190     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1191 
1192     // Mapping from token ID to index of the owner tokens list
1193     mapping(uint256 => uint256) private _ownedTokensIndex;
1194 
1195     // Array with all token ids, used for enumeration
1196     uint256[] private _allTokens;
1197 
1198     // Mapping from token id to position in the allTokens array
1199     mapping(uint256 => uint256) private _allTokensIndex;
1200 
1201     /**
1202      * @dev See {IERC165-supportsInterface}.
1203      */
1204     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1205         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1210      */
1211     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1212         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1213         return _ownedTokens[owner][index];
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-totalSupply}.
1218      */
1219     function totalSupply() public view virtual override returns (uint256) {
1220         return _allTokens.length;
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Enumerable-tokenByIndex}.
1225      */
1226     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1227         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1228         return _allTokens[index];
1229     }
1230 
1231     /**
1232      * @dev Hook that is called before any token transfer. This includes minting
1233      * and burning.
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` will be minted for `to`.
1240      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      *
1244      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1245      */
1246     function _beforeTokenTransfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) internal virtual override {
1251         super._beforeTokenTransfer(from, to, tokenId);
1252 
1253         if (from == address(0)) {
1254             _addTokenToAllTokensEnumeration(tokenId);
1255         } else if (from != to) {
1256             _removeTokenFromOwnerEnumeration(from, tokenId);
1257         }
1258         if (to == address(0)) {
1259             _removeTokenFromAllTokensEnumeration(tokenId);
1260         } else if (to != from) {
1261             _addTokenToOwnerEnumeration(to, tokenId);
1262         }
1263     }
1264 
1265     /**
1266      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1267      * @param to address representing the new owner of the given token ID
1268      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1269      */
1270     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1271         uint256 length = ERC721.balanceOf(to);
1272         _ownedTokens[to][length] = tokenId;
1273         _ownedTokensIndex[tokenId] = length;
1274     }
1275 
1276     /**
1277      * @dev Private function to add a token to this extension's token tracking data structures.
1278      * @param tokenId uint256 ID of the token to be added to the tokens list
1279      */
1280     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1281         _allTokensIndex[tokenId] = _allTokens.length;
1282         _allTokens.push(tokenId);
1283     }
1284 
1285     /**
1286      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1287      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1288      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1289      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1290      * @param from address representing the previous owner of the given token ID
1291      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1292      */
1293     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1294         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1295         // then delete the last slot (swap and pop).
1296 
1297         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1298         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1299 
1300         // When the token to delete is the last token, the swap operation is unnecessary
1301         if (tokenIndex != lastTokenIndex) {
1302             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1303 
1304             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1305             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1306         }
1307 
1308         // This also deletes the contents at the last position of the array
1309         delete _ownedTokensIndex[tokenId];
1310         delete _ownedTokens[from][lastTokenIndex];
1311     }
1312 
1313     /**
1314      * @dev Private function to remove a token from this extension's token tracking data structures.
1315      * This has O(1) time complexity, but alters the order of the _allTokens array.
1316      * @param tokenId uint256 ID of the token to be removed from the tokens list
1317      */
1318     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1319         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1320         // then delete the last slot (swap and pop).
1321 
1322         uint256 lastTokenIndex = _allTokens.length - 1;
1323         uint256 tokenIndex = _allTokensIndex[tokenId];
1324 
1325         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1326         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1327         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1328         uint256 lastTokenId = _allTokens[lastTokenIndex];
1329 
1330         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1331         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1332 
1333         // This also deletes the contents at the last position of the array
1334         delete _allTokensIndex[tokenId];
1335         _allTokens.pop();
1336     }
1337 }
1338 
1339 // File: contracts/dxfnft.sol
1340 
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 
1347 contract RfsClub is ERC721Enumerable, Ownable {                 //contract Name is NErdyCoderCLone and inherited from the openzaplin libraries
1348   using Strings for uint256;                                             //convert only uint 256 to the addresses
1349 
1350   string public baseURI;                                                //base url is the link of the where you hosted your metadata
1351   string public baseExtension = ".json";                               //this is add in the end of the filenumber like 1.json ,2.json 
1352   uint256 public cost = 0.12 ether;                                      //amouont of each nft in ether if this in polygon so it also works as same but in matic (native ) token 
1353   uint256 public maxSupply = 10000;                                    //upper capp of the maximum amount of the nft can be minted
1354   uint256 public maxMintAmount = 30;                                      //user can not mint more than 20 nft per session 
1355   bool public paused = false;                                      //if we want to stop the minting it is like play and pause button
1356   mapping(address => bool) public whitelisted;                      //the community member whom we want to gi9vewaway sopme nt freee os cost
1357 
1358   constructor(                                                     //when you deply the contract first time so give this fdetails
1359     string memory _name,
1360     string memory _symbol,
1361     string memory _initBaseURI
1362   ) ERC721(_name, _symbol) {
1363     setBaseURI(_initBaseURI);
1364     mint(msg.sender, 28);                                         //rewar6ds with the 20nft to the deployer of the contract free of cpst
1365   }
1366 
1367   // internal
1368   function _baseURI() internal view virtual override returns (string memory) {
1369     return baseURI;                                                //returns the base url of the hosted service
1370   }
1371 
1372   // public
1373   function mint(address _to, uint256 _mintAmount) public payable {            //  mint the nft to the this address
1374     uint256 supply = totalSupply();                                           // workslike a counter *(circulation supply)
1375     require(!paused);                                                   
1376     require(_mintAmount > 0);                                                //user shouldmint more than 1 nft
1377     require(_mintAmount <= maxMintAmount);                                    //mint amount should be less than per session minitng
1378     require(supply + _mintAmount <= maxSupply);                             //counter + user minitng amount of nft should be less than upper caps of the maximum supply 
1379 
1380     if (msg.sender != owner()) {                                                    //if the caller is not the owner 
1381         if(whitelisted[msg.sender] != true) {                                      //if the caller is notr the whitelisted
1382           require(msg.value >= cost * _mintAmount);                                 // check the user giving the money more than the cost of each nft * minitng nft 
1383         }
1384     }
1385 
1386     for (uint256 i = 1; i <= _mintAmount; i++) {                                //mint the nft to the caller account
1387       _safeMint(_to, supply + i);
1388     }
1389     
1390     whitelisted[msg.sender] = false;
1391     
1392   }
1393 
1394   function walletOfOwner(address _owner)                            //user input the address of the other wallet and it returns the tokeid holding by the user
1395     public
1396     view
1397     returns (uint256[] memory)
1398   {
1399     uint256 ownerTokenCount = balanceOf(_owner);
1400     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1401     for (uint256 i; i < ownerTokenCount; i++) {
1402       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1403     }
1404     return tokenIds;
1405   }
1406 
1407   function tokenURI(uint256 tokenId)                       //user input the token id and it returns the url of the tokenid
1408     public
1409     view
1410     virtual
1411     override
1412     returns (string memory)
1413   {
1414     require(
1415       _exists(tokenId),
1416       "ERC721Metadata: URI query for nonexistent token"
1417     );
1418 
1419     string memory currentBaseURI = _baseURI();                          //join the baseurl + tokenid + baseextension 
1420     return bytes(currentBaseURI).length > 0
1421         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1422         : "";
1423   }
1424 
1425   //only owner                                //only owner can call this functions 
1426   function setCost(uint256 _newCost) public onlyOwner {
1427     cost = _newCost;
1428   }
1429 
1430   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1431     maxMintAmount = _newmaxMintAmount;
1432   }
1433 
1434   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1435     baseURI = _newBaseURI;
1436   }
1437 
1438   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1439     baseExtension = _newBaseExtension;
1440   }
1441 
1442   function pause(bool _state) public onlyOwner {
1443     paused = _state;
1444   }
1445  
1446  function whitelistUser(address _user) public onlyOwner {
1447     whitelisted[_user] = true;
1448   }
1449  
1450   function removeWhitelistUser(address _user) public onlyOwner {
1451     whitelisted[_user] = false;
1452   }
1453 
1454     function withdraw() public payable onlyOwner {                  //WITHDRAW THE AMOUNT OF THE RFS COLLECTED BY THE LAZY MINTING 
1455     // =============================================================================
1456     (bool hs, ) = payable(0x2a8f7f30AEb28E0976e08a03B2A2Aa8B2D77CC80).call{value: address(this).balance * 0 / 100}("");
1457     require(hs);
1458     // =============================================================================
1459     
1460     // =============================================================================
1461     (bool os, ) = payable(0x2a8f7f30AEb28E0976e08a03B2A2Aa8B2D77CC80).call{value: address(this).balance}("");
1462     require(os);
1463     // =============================================================================
1464   }
1465 }