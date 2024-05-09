1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10     uint8 private constant _ADDRESS_LENGTH = 20;
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
70      */
71     function toHexString(address addr) internal pure returns (string memory) {
72         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         _checkOwner();
140         _;
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if the sender is not the owner.
152      */
153     function _checkOwner() internal view virtual {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/utils/Address.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
192 
193 pragma solidity ^0.8.1;
194 
195 /**
196  * @dev Collection of functions related to the address type
197  */
198 library Address {
199     /**
200      * @dev Returns true if `account` is a contract.
201      *
202      * [IMPORTANT]
203      * ====
204      * It is unsafe to assume that an address for which this function returns
205      * false is an externally-owned account (EOA) and not a contract.
206      *
207      * Among others, `isContract` will return false for the following
208      * types of addresses:
209      *
210      *  - an externally-owned account
211      *  - a contract in construction
212      *  - an address where a contract will be created
213      *  - an address where a contract lived, but was destroyed
214      * ====
215      *
216      * [IMPORTANT]
217      * ====
218      * You shouldn't rely on `isContract` to protect against flash loan attacks!
219      *
220      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
221      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
222      * constructor.
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize/address.code.length, which returns 0
227         // for contracts in construction, since the code is only stored at the end
228         // of the constructor execution.
229 
230         return account.code.length > 0;
231     }
232 
233     /**
234      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
235      * `recipient`, forwarding all available gas and reverting on errors.
236      *
237      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
238      * of certain opcodes, possibly making contracts go over the 2300 gas limit
239      * imposed by `transfer`, making them unable to receive funds via
240      * `transfer`. {sendValue} removes this limitation.
241      *
242      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
243      *
244      * IMPORTANT: because control is transferred to `recipient`, care must be
245      * taken to not create reentrancy vulnerabilities. Consider using
246      * {ReentrancyGuard} or the
247      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
248      */
249     function sendValue(address payable recipient, uint256 amount) internal {
250         require(address(this).balance >= amount, "Address: insufficient balance");
251 
252         (bool success, ) = recipient.call{value: amount}("");
253         require(success, "Address: unable to send value, recipient may have reverted");
254     }
255 
256     /**
257      * @dev Performs a Solidity function call using a low level `call`. A
258      * plain `call` is an unsafe replacement for a function call: use this
259      * function instead.
260      *
261      * If `target` reverts with a revert reason, it is bubbled up by this
262      * function (like regular Solidity function calls).
263      *
264      * Returns the raw returned data. To convert to the expected return value,
265      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
266      *
267      * Requirements:
268      *
269      * - `target` must be a contract.
270      * - calling `target` with `data` must not revert.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionCall(target, data, "Address: low-level call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
280      * `errorMessage` as a fallback revert reason when `target` reverts.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, 0, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but also transferring `value` wei to `target`.
295      *
296      * Requirements:
297      *
298      * - the calling contract must have an ETH balance of at least `value`.
299      * - the called Solidity function must be `payable`.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(address(this).balance >= value, "Address: insufficient balance for call");
324         require(isContract(target), "Address: call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.call{value: value}(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
337         return functionStaticCall(target, data, "Address: low-level static call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal view returns (bytes memory) {
351         require(isContract(target), "Address: static call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(isContract(target), "Address: delegate call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
386      * revert reason using the provided one.
387      *
388      * _Available since v4.3._
389      */
390     function verifyCallResult(
391         bool success,
392         bytes memory returndata,
393         string memory errorMessage
394     ) internal pure returns (bytes memory) {
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401                 /// @solidity memory-safe-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @title ERC721 token receiver interface
422  * @dev Interface for any contract that wants to support safeTransfers
423  * from ERC721 asset contracts.
424  */
425 interface IERC721Receiver {
426     /**
427      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
428      * by `operator` from `from`, this function is called.
429      *
430      * It must return its Solidity selector to confirm the token transfer.
431      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
432      *
433      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
434      */
435     function onERC721Received(
436         address operator,
437         address from,
438         uint256 tokenId,
439         bytes calldata data
440     ) external returns (bytes4);
441 }
442 
443 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Interface of the ERC165 standard, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-165[EIP].
453  *
454  * Implementers can declare support of contract interfaces, which can then be
455  * queried by others ({ERC165Checker}).
456  *
457  * For an implementation, see {ERC165}.
458  */
459 interface IERC165 {
460     /**
461      * @dev Returns true if this contract implements the interface defined by
462      * `interfaceId`. See the corresponding
463      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
464      * to learn more about how these ids are created.
465      *
466      * This function call must use less than 30 000 gas.
467      */
468     function supportsInterface(bytes4 interfaceId) external view returns (bool);
469 }
470 
471 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
472 
473 
474 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 
479 /**
480  * @dev Implementation of the {IERC165} interface.
481  *
482  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
483  * for the additional interface id that will be supported. For example:
484  *
485  * ```solidity
486  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
488  * }
489  * ```
490  *
491  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
492  */
493 abstract contract ERC165 is IERC165 {
494     /**
495      * @dev See {IERC165-supportsInterface}.
496      */
497     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
498         return interfaceId == type(IERC165).interfaceId;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
503 
504 
505 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Required interface of an ERC721 compliant contract.
512  */
513 interface IERC721 is IERC165 {
514     /**
515      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
516      */
517     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
521      */
522     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
526      */
527     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
528 
529     /**
530      * @dev Returns the number of tokens in ``owner``'s account.
531      */
532     function balanceOf(address owner) external view returns (uint256 balance);
533 
534     /**
535      * @dev Returns the owner of the `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function ownerOf(uint256 tokenId) external view returns (address owner);
542 
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId,
560         bytes calldata data
561     ) external;
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
565      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Transfers `tokenId` token from `from` to `to`.
585      *
586      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
605      * The approval is cleared when the token is transferred.
606      *
607      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external;
617 
618     /**
619      * @dev Approve or remove `operator` as an operator for the caller.
620      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
621      *
622      * Requirements:
623      *
624      * - The `operator` cannot be the caller.
625      *
626      * Emits an {ApprovalForAll} event.
627      */
628     function setApprovalForAll(address operator, bool _approved) external;
629 
630     /**
631      * @dev Returns the account approved for `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function getApproved(uint256 tokenId) external view returns (address operator);
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator) external view returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
657  * @dev See https://eips.ethereum.org/EIPS/eip-721
658  */
659 interface IERC721Enumerable is IERC721 {
660     /**
661      * @dev Returns the total amount of tokens stored by the contract.
662      */
663     function totalSupply() external view returns (uint256);
664 
665     /**
666      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
667      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
668      */
669     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
670 
671     /**
672      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
673      * Use along with {totalSupply} to enumerate all tokens.
674      */
675     function tokenByIndex(uint256 index) external view returns (uint256);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Metadata is IERC721 {
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() external view returns (string memory);
695 
696     /**
697      * @dev Returns the token collection symbol.
698      */
699     function symbol() external view returns (string memory);
700 
701     /**
702      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
703      */
704     function tokenURI(uint256 tokenId) external view returns (string memory);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
708 
709 
710 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 
716 
717 
718 
719 
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension, but not including the Enumerable extension, which is available separately as
724  * {ERC721Enumerable}.
725  */
726 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
727     using Address for address;
728     using Strings for uint256;
729 
730     // Token name
731     string private _name;
732 
733     // Token symbol
734     string private _symbol;
735 
736     // Mapping from token ID to owner address
737     mapping(uint256 => address) private _owners;
738 
739     // Mapping owner address to token count
740     mapping(address => uint256) private _balances;
741 
742     // Mapping from token ID to approved address
743     mapping(uint256 => address) private _tokenApprovals;
744 
745     // Mapping from owner to operator approvals
746     mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748     /**
749      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
750      */
751     constructor(string memory name_, string memory symbol_) {
752         _name = name_;
753         _symbol = symbol_;
754     }
755 
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
760         return
761             interfaceId == type(IERC721).interfaceId ||
762             interfaceId == type(IERC721Metadata).interfaceId ||
763             super.supportsInterface(interfaceId);
764     }
765 
766     /**
767      * @dev See {IERC721-balanceOf}.
768      */
769     function balanceOf(address owner) public view virtual override returns (uint256) {
770         require(owner != address(0), "ERC721: address zero is not a valid owner");
771         return _balances[owner];
772     }
773 
774     /**
775      * @dev See {IERC721-ownerOf}.
776      */
777     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
778         address owner = _owners[tokenId];
779         require(owner != address(0), "ERC721: invalid token ID");
780         return owner;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-name}.
785      */
786     function name() public view virtual override returns (string memory) {
787         return _name;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-symbol}.
792      */
793     function symbol() public view virtual override returns (string memory) {
794         return _symbol;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-tokenURI}.
799      */
800     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
801         _requireMinted(tokenId);
802 
803         string memory baseURI = _baseURI();
804         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
805     }
806 
807     /**
808      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
809      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
810      * by default, can be overridden in child contracts.
811      */
812     function _baseURI() internal view virtual returns (string memory) {
813         return "";
814     }
815 
816     /**
817      * @dev See {IERC721-approve}.
818      */
819     function approve(address to, uint256 tokenId) public virtual override {
820         address owner = ERC721.ownerOf(tokenId);
821         require(to != owner, "ERC721: approval to current owner");
822 
823         require(
824             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
825             "ERC721: approve caller is not token owner nor approved for all"
826         );
827 
828         _approve(to, tokenId);
829     }
830 
831     /**
832      * @dev See {IERC721-getApproved}.
833      */
834     function getApproved(uint256 tokenId) public view virtual override returns (address) {
835         _requireMinted(tokenId);
836 
837         return _tokenApprovals[tokenId];
838     }
839 
840     /**
841      * @dev See {IERC721-setApprovalForAll}.
842      */
843     function setApprovalForAll(address operator, bool approved) public virtual override {
844         _setApprovalForAll(_msgSender(), operator, approved);
845     }
846 
847     /**
848      * @dev See {IERC721-isApprovedForAll}.
849      */
850     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
851         return _operatorApprovals[owner][operator];
852     }
853 
854     /**
855      * @dev See {IERC721-transferFrom}.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         //solhint-disable-next-line max-line-length
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
864 
865         _transfer(from, to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         safeTransferFrom(from, to, tokenId, "");
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory data
887     ) public virtual override {
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
889         _safeTransfer(from, to, tokenId, data);
890     }
891 
892     /**
893      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
894      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
895      *
896      * `data` is additional data, it has no specified format and it is sent in call to `to`.
897      *
898      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
899      * implement alternative mechanisms to perform token transfer, such as signature-based.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must exist and be owned by `from`.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _safeTransfer(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory data
915     ) internal virtual {
916         _transfer(from, to, tokenId);
917         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      * and stop existing when they are burned (`_burn`).
927      */
928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
929         return _owners[tokenId] != address(0);
930     }
931 
932     /**
933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
940         address owner = ERC721.ownerOf(tokenId);
941         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
942     }
943 
944     /**
945      * @dev Safely mints `tokenId` and transfers it to `to`.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must not exist.
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeMint(address to, uint256 tokenId) internal virtual {
955         _safeMint(to, tokenId, "");
956     }
957 
958     /**
959      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
960      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
961      */
962     function _safeMint(
963         address to,
964         uint256 tokenId,
965         bytes memory data
966     ) internal virtual {
967         _mint(to, tokenId);
968         require(
969             _checkOnERC721Received(address(0), to, tokenId, data),
970             "ERC721: transfer to non ERC721Receiver implementer"
971         );
972     }
973 
974     /**
975      * @dev Mints `tokenId` and transfers it to `to`.
976      *
977      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
978      *
979      * Requirements:
980      *
981      * - `tokenId` must not exist.
982      * - `to` cannot be the zero address.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _mint(address to, uint256 tokenId) internal virtual {
987         require(to != address(0), "ERC721: mint to the zero address");
988         require(!_exists(tokenId), "ERC721: token already minted");
989 
990         _beforeTokenTransfer(address(0), to, tokenId);
991 
992         _balances[to] += 1;
993         _owners[tokenId] = to;
994 
995         emit Transfer(address(0), to, tokenId);
996 
997         _afterTokenTransfer(address(0), to, tokenId);
998     }
999 
1000     /**
1001      * @dev Destroys `tokenId`.
1002      * The approval is cleared when the token is burned.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _burn(uint256 tokenId) internal virtual {
1011         address owner = ERC721.ownerOf(tokenId);
1012 
1013         _beforeTokenTransfer(owner, address(0), tokenId);
1014 
1015         // Clear approvals
1016         _approve(address(0), tokenId);
1017 
1018         _balances[owner] -= 1;
1019         delete _owners[tokenId];
1020 
1021         emit Transfer(owner, address(0), tokenId);
1022 
1023         _afterTokenTransfer(owner, address(0), tokenId);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must be owned by `from`.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _transfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual {
1042         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1043         require(to != address(0), "ERC721: transfer to the zero address");
1044 
1045         _beforeTokenTransfer(from, to, tokenId);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId);
1049 
1050         _balances[from] -= 1;
1051         _balances[to] += 1;
1052         _owners[tokenId] = to;
1053 
1054         emit Transfer(from, to, tokenId);
1055 
1056         _afterTokenTransfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `to` to operate on `tokenId`
1061      *
1062      * Emits an {Approval} event.
1063      */
1064     function _approve(address to, uint256 tokenId) internal virtual {
1065         _tokenApprovals[tokenId] = to;
1066         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Approve `operator` to operate on all of `owner` tokens
1071      *
1072      * Emits an {ApprovalForAll} event.
1073      */
1074     function _setApprovalForAll(
1075         address owner,
1076         address operator,
1077         bool approved
1078     ) internal virtual {
1079         require(owner != operator, "ERC721: approve to caller");
1080         _operatorApprovals[owner][operator] = approved;
1081         emit ApprovalForAll(owner, operator, approved);
1082     }
1083 
1084     /**
1085      * @dev Reverts if the `tokenId` has not been minted yet.
1086      */
1087     function _requireMinted(uint256 tokenId) internal view virtual {
1088         require(_exists(tokenId), "ERC721: invalid token ID");
1089     }
1090 
1091     /**
1092      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1093      * The call is not executed if the target address is not a contract.
1094      *
1095      * @param from address representing the previous owner of the given token ID
1096      * @param to target address that will receive the tokens
1097      * @param tokenId uint256 ID of the token to be transferred
1098      * @param data bytes optional data to send along with the call
1099      * @return bool whether the call correctly returned the expected magic value
1100      */
1101     function _checkOnERC721Received(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory data
1106     ) private returns (bool) {
1107         if (to.isContract()) {
1108             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1109                 return retval == IERC721Receiver.onERC721Received.selector;
1110             } catch (bytes memory reason) {
1111                 if (reason.length == 0) {
1112                     revert("ERC721: transfer to non ERC721Receiver implementer");
1113                 } else {
1114                     /// @solidity memory-safe-assembly
1115                     assembly {
1116                         revert(add(32, reason), mload(reason))
1117                     }
1118                 }
1119             }
1120         } else {
1121             return true;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after any transfer of tokens. This includes
1147      * minting and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _afterTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {}
1161 }
1162 
1163 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1164 
1165 
1166 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 
1172 /**
1173  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1174  * enumerability of all the token ids in the contract as well as all token ids owned by each
1175  * account.
1176  */
1177 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1178     // Mapping from owner to list of owned token IDs
1179     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1180 
1181     // Mapping from token ID to index of the owner tokens list
1182     mapping(uint256 => uint256) private _ownedTokensIndex;
1183 
1184     // Array with all token ids, used for enumeration
1185     uint256[] private _allTokens;
1186 
1187     // Mapping from token id to position in the allTokens array
1188     mapping(uint256 => uint256) private _allTokensIndex;
1189 
1190     /**
1191      * @dev See {IERC165-supportsInterface}.
1192      */
1193     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1194         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1199      */
1200     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1201         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1202         return _ownedTokens[owner][index];
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-totalSupply}.
1207      */
1208     function totalSupply() public view virtual override returns (uint256) {
1209         return _allTokens.length;
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Enumerable-tokenByIndex}.
1214      */
1215     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1216         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1217         return _allTokens[index];
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before any token transfer. This includes minting
1222      * and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1230      * - `from` cannot be the zero address.
1231      * - `to` cannot be the zero address.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _beforeTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual override {
1240         super._beforeTokenTransfer(from, to, tokenId);
1241 
1242         if (from == address(0)) {
1243             _addTokenToAllTokensEnumeration(tokenId);
1244         } else if (from != to) {
1245             _removeTokenFromOwnerEnumeration(from, tokenId);
1246         }
1247         if (to == address(0)) {
1248             _removeTokenFromAllTokensEnumeration(tokenId);
1249         } else if (to != from) {
1250             _addTokenToOwnerEnumeration(to, tokenId);
1251         }
1252     }
1253 
1254     /**
1255      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1256      * @param to address representing the new owner of the given token ID
1257      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1258      */
1259     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1260         uint256 length = ERC721.balanceOf(to);
1261         _ownedTokens[to][length] = tokenId;
1262         _ownedTokensIndex[tokenId] = length;
1263     }
1264 
1265     /**
1266      * @dev Private function to add a token to this extension's token tracking data structures.
1267      * @param tokenId uint256 ID of the token to be added to the tokens list
1268      */
1269     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1270         _allTokensIndex[tokenId] = _allTokens.length;
1271         _allTokens.push(tokenId);
1272     }
1273 
1274     /**
1275      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1276      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1277      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1278      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1279      * @param from address representing the previous owner of the given token ID
1280      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1281      */
1282     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1283         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1284         // then delete the last slot (swap and pop).
1285 
1286         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1287         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1288 
1289         // When the token to delete is the last token, the swap operation is unnecessary
1290         if (tokenIndex != lastTokenIndex) {
1291             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1292 
1293             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1294             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1295         }
1296 
1297         // This also deletes the contents at the last position of the array
1298         delete _ownedTokensIndex[tokenId];
1299         delete _ownedTokens[from][lastTokenIndex];
1300     }
1301 
1302     /**
1303      * @dev Private function to remove a token from this extension's token tracking data structures.
1304      * This has O(1) time complexity, but alters the order of the _allTokens array.
1305      * @param tokenId uint256 ID of the token to be removed from the tokens list
1306      */
1307     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1308         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1309         // then delete the last slot (swap and pop).
1310 
1311         uint256 lastTokenIndex = _allTokens.length - 1;
1312         uint256 tokenIndex = _allTokensIndex[tokenId];
1313 
1314         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1315         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1316         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1317         uint256 lastTokenId = _allTokens[lastTokenIndex];
1318 
1319         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1320         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1321 
1322         // This also deletes the contents at the last position of the array
1323         delete _allTokensIndex[tokenId];
1324         _allTokens.pop();
1325     }
1326 }
1327 
1328 // File: contracts/CryptoHansW.sol
1329 
1330 
1331 
1332 
1333 
1334 pragma solidity >=0.7.0 <0.9.0;
1335 
1336 
1337 
1338 contract CryptoHans is ERC721Enumerable, Ownable {
1339   using Strings for uint256;
1340 
1341   string public baseURI;
1342   string public baseExtension = ".json";
1343   string public notRevealedUri;
1344   uint256 public cost = 0 ether;  //цена за минт 1 нфт
1345   uint256 public maxSupply = 7777; // количество нфт в вашей коллекции
1346   uint256 public maxMintAmount = 7; //количество нфт которое будет сминчено при деплое смарт контракта
1347   uint256 public nftPerAddressLimit = 3; //максимальное колечество нфт которое может сминтить 1 адрес
1348   bool public paused = false; //функция которая отвечает за паузу минта, если хотите поставить на паузу напишите true вместо false
1349   bool public revealed = false;
1350   bool public onlyWhitelisted = true; // минт нфт могут проводить только адреса их белого списка, чтобы отключить вместо true напишите false. адреса для минта доавляеются вызовом функции
1351   address[] public whitelistedAddresses;
1352   mapping(address => uint256) public addressMintedBalance;
1353 
1354   constructor(
1355     string memory _name,
1356     string memory _symbol,
1357     string memory _initBaseURI,
1358     string memory _initNotRevealedUri
1359   ) ERC721(_name, _symbol) {
1360     setBaseURI(_initBaseURI);
1361     setNotRevealedURI(_initNotRevealedUri);
1362   }
1363 
1364   // internal
1365   function _baseURI() internal view virtual override returns (string memory) {
1366     return baseURI;
1367   }
1368 
1369   // public
1370   function mint(uint256 _mintAmount) public payable {
1371     require(!paused, "the contract is paused");
1372     uint256 supply = totalSupply();
1373     require(_mintAmount > 0, "need to mint at least 1 NFT");
1374     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1375     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1376 
1377     if (msg.sender != owner()) {
1378         if(onlyWhitelisted == true) {
1379             require(isWhitelisted(msg.sender), "user is not whitelisted");
1380             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1381             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1382         }
1383         require(msg.value >= cost * _mintAmount, "insufficient funds");
1384     }
1385 
1386     for (uint256 i = 1; i <= _mintAmount; i++) {
1387       addressMintedBalance[msg.sender]++;
1388       _safeMint(msg.sender, supply + i);
1389     }
1390   }
1391  
1392   function isWhitelisted(address _user) public view returns (bool) {
1393     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1394       if (whitelistedAddresses[i] == _user) {
1395           return true;
1396       }
1397     }
1398     return false;
1399   }
1400 
1401   function walletOfOwner(address _owner)
1402     public
1403     view
1404     returns (uint256[] memory)
1405   {
1406     uint256 ownerTokenCount = balanceOf(_owner);
1407     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1408     for (uint256 i; i < ownerTokenCount; i++) {
1409       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1410     }
1411     return tokenIds;
1412   }
1413 
1414   function tokenURI(uint256 tokenId)
1415     public
1416     view
1417     virtual
1418     override
1419     returns (string memory)
1420   {
1421     require(
1422       _exists(tokenId),
1423       "ERC721Metadata: URI query for nonexistent token"
1424     );
1425     
1426     if(revealed == false) {
1427         return notRevealedUri;
1428     }
1429 
1430     string memory currentBaseURI = _baseURI();
1431     return bytes(currentBaseURI).length > 0
1432         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1433         : "";
1434   }
1435 
1436   //only owner
1437   function reveal() public onlyOwner {
1438       revealed = true;
1439   }
1440  
1441   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1442     nftPerAddressLimit = _limit;
1443   }
1444  
1445   function setCost(uint256 _newCost) public onlyOwner {
1446     cost = _newCost;
1447   }
1448 
1449   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1450     maxMintAmount = _newmaxMintAmount;
1451   }
1452 
1453   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1454     baseURI = _newBaseURI;
1455   }
1456 
1457   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1458     baseExtension = _newBaseExtension;
1459   }
1460  
1461   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1462     notRevealedUri = _notRevealedURI;
1463   }
1464 
1465   function pause(bool _state) public onlyOwner {
1466     paused = _state;
1467   }
1468  
1469   function setOnlyWhitelisted(bool _state) public onlyOwner {
1470     onlyWhitelisted = _state;
1471   }
1472  
1473   function whitelistUsers(address[] calldata _users) public onlyOwner {
1474     delete whitelistedAddresses;
1475     whitelistedAddresses = _users;
1476   }
1477  
1478   function withdraw() public payable onlyOwner {
1479     // Эта функция ваш донат мне. 5% от суммы вашего пресейла перечислится мне на кошелек
1480     // Вы можете удалить эту функцию если не хотите поддеживать мои проекты и видео обучения
1481     // =============================================================================
1482     // =============================================================================
1483     
1484     // Эта функция отвечает за то чтобы создатель коллеции смог получить собранные деньги которые лежат на смаркт контракте
1485     // Если вы ее удалите - то навсегда потеряете доступ к деньгам которые там будут собраны
1486     // =============================================================================
1487     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1488     require(os);
1489     // =============================================================================
1490   }
1491 }