1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/security/Pausable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which allows children to implement an emergency stop
108  * mechanism that can be triggered by an authorized account.
109  *
110  * This module is used through inheritance. It will make available the
111  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
112  * the functions of your contract. Note that they will not be pausable by
113  * simply including this module, only once the modifiers are put in place.
114  */
115 abstract contract Pausable is Context {
116     /**
117      * @dev Emitted when the pause is triggered by `account`.
118      */
119     event Paused(address account);
120 
121     /**
122      * @dev Emitted when the pause is lifted by `account`.
123      */
124     event Unpaused(address account);
125 
126     bool private _paused;
127 
128     /**
129      * @dev Initializes the contract in unpaused state.
130      */
131     constructor() {
132         _paused = false;
133     }
134 
135     /**
136      * @dev Returns true if the contract is paused, and false otherwise.
137      */
138     function paused() public view virtual returns (bool) {
139         return _paused;
140     }
141 
142     /**
143      * @dev Modifier to make a function callable only when the contract is not paused.
144      *
145      * Requirements:
146      *
147      * - The contract must not be paused.
148      */
149     modifier whenNotPaused() {
150         require(!paused(), "Pausable: paused");
151         _;
152     }
153 
154     /**
155      * @dev Modifier to make a function callable only when the contract is paused.
156      *
157      * Requirements:
158      *
159      * - The contract must be paused.
160      */
161     modifier whenPaused() {
162         require(paused(), "Pausable: not paused");
163         _;
164     }
165 
166     /**
167      * @dev Triggers stopped state.
168      *
169      * Requirements:
170      *
171      * - The contract must not be paused.
172      */
173     function _pause() internal virtual whenNotPaused {
174         _paused = true;
175         emit Paused(_msgSender());
176     }
177 
178     /**
179      * @dev Returns to normal state.
180      *
181      * Requirements:
182      *
183      * - The contract must be paused.
184      */
185     function _unpause() internal virtual whenPaused {
186         _paused = false;
187         emit Unpaused(_msgSender());
188     }
189 }
190 
191 // File: @openzeppelin/contracts/access/Ownable.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Contract module which provides a basic access control mechanism, where
201  * there is an account (an owner) that can be granted exclusive access to
202  * specific functions.
203  *
204  * By default, the owner account will be the one that deploys the contract. This
205  * can later be changed with {transferOwnership}.
206  *
207  * This module is used through inheritance. It will make available the modifier
208  * `onlyOwner`, which can be applied to your functions to restrict their use to
209  * the owner.
210  */
211 abstract contract Ownable is Context {
212     address private _owner;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216     /**
217      * @dev Initializes the contract setting the deployer as the initial owner.
218      */
219     constructor() {
220         _transferOwnership(_msgSender());
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view virtual returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     /**
239      * @dev Leaves the contract without owner. It will not be possible to call
240      * `onlyOwner` functions anymore. Can only be called by the current owner.
241      *
242      * NOTE: Renouncing ownership will leave the contract without an owner,
243      * thereby removing any functionality that is only available to the owner.
244      */
245     function renounceOwnership() public virtual onlyOwner {
246         _transferOwnership(address(0));
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         _transferOwnership(newOwner);
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Internal function without access restriction.
261      */
262     function _transferOwnership(address newOwner) internal virtual {
263         address oldOwner = _owner;
264         _owner = newOwner;
265         emit OwnershipTransferred(oldOwner, newOwner);
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         assembly {
304             size := extcodesize(account)
305         }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         (bool success, ) = recipient.call{value: amount}("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain `call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462      * revert reason using the provided one.
463      *
464      * _Available since v4.3._
465      */
466     function verifyCallResult(
467         bool success,
468         bytes memory returndata,
469         string memory errorMessage
470     ) internal pure returns (bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @title ERC721 token receiver interface
498  * @dev Interface for any contract that wants to support safeTransfers
499  * from ERC721 asset contracts.
500  */
501 interface IERC721Receiver {
502     /**
503      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
504      * by `operator` from `from`, this function is called.
505      *
506      * It must return its Solidity selector to confirm the token transfer.
507      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
508      *
509      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
510      */
511     function onERC721Received(
512         address operator,
513         address from,
514         uint256 tokenId,
515         bytes calldata data
516     ) external returns (bytes4);
517 }
518 
519 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Interface of the ERC165 standard, as defined in the
528  * https://eips.ethereum.org/EIPS/eip-165[EIP].
529  *
530  * Implementers can declare support of contract interfaces, which can then be
531  * queried by others ({ERC165Checker}).
532  *
533  * For an implementation, see {ERC165}.
534  */
535 interface IERC165 {
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30 000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) external view returns (bool);
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
597      */
598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
604 
605     /**
606      * @dev Returns the number of tokens in ``owner``'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Returns the account approved for `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function getApproved(uint256 tokenId) external view returns (address operator);
682 
683     /**
684      * @dev Approve or remove `operator` as an operator for the caller.
685      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
686      *
687      * Requirements:
688      *
689      * - The `operator` cannot be the caller.
690      *
691      * Emits an {ApprovalForAll} event.
692      */
693     function setApprovalForAll(address operator, bool _approved) external;
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes calldata data
720     ) external;
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 
761 
762 
763 
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
769  * {ERC721Enumerable}.
770  */
771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to owner address
782     mapping(uint256 => address) private _owners;
783 
784     // Mapping owner address to token count
785     mapping(address => uint256) private _balances;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     /**
794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view virtual override returns (uint256) {
815         require(owner != address(0), "ERC721: balance query for the zero address");
816         return _balances[owner];
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
823         address owner = _owners[tokenId];
824         require(owner != address(0), "ERC721: owner query for nonexistent token");
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
880         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved) public virtual override {
889         _setApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         //solhint-disable-next-line max-line-length
908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
909 
910         _transfer(from, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, "");
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public virtual override {
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
934         _safeTransfer(from, to, tokenId, _data);
935     }
936 
937     /**
938      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
939      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
940      *
941      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
942      *
943      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
944      * implement alternative mechanisms to perform token transfer, such as signature-based.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeTransfer(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _transfer(from, to, tokenId);
962         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      * and stop existing when they are burned (`_burn`).
972      */
973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
974         return _owners[tokenId] != address(0);
975     }
976 
977     /**
978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
985         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
986         address owner = ERC721.ownerOf(tokenId);
987         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
988     }
989 
990     /**
991      * @dev Safely mints `tokenId` and transfers it to `to`.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must not exist.
996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _safeMint(address to, uint256 tokenId) internal virtual {
1001         _safeMint(to, tokenId, "");
1002     }
1003 
1004     /**
1005      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1006      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1007      */
1008     function _safeMint(
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _mint(to, tokenId);
1014         require(
1015             _checkOnERC721Received(address(0), to, tokenId, _data),
1016             "ERC721: transfer to non ERC721Receiver implementer"
1017         );
1018     }
1019 
1020     /**
1021      * @dev Mints `tokenId` and transfers it to `to`.
1022      *
1023      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1024      *
1025      * Requirements:
1026      *
1027      * - `tokenId` must not exist.
1028      * - `to` cannot be the zero address.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _mint(address to, uint256 tokenId) internal virtual {
1033         require(to != address(0), "ERC721: mint to the zero address");
1034         require(!_exists(tokenId), "ERC721: token already minted");
1035 
1036         _beforeTokenTransfer(address(0), to, tokenId);
1037 
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(address(0), to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Destroys `tokenId`.
1046      * The approval is cleared when the token is burned.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must exist.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _burn(uint256 tokenId) internal virtual {
1055         address owner = ERC721.ownerOf(tokenId);
1056 
1057         _beforeTokenTransfer(owner, address(0), tokenId);
1058 
1059         // Clear approvals
1060         _approve(address(0), tokenId);
1061 
1062         _balances[owner] -= 1;
1063         delete _owners[tokenId];
1064 
1065         emit Transfer(owner, address(0), tokenId);
1066     }
1067 
1068     /**
1069      * @dev Transfers `tokenId` from `from` to `to`.
1070      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _transfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {
1084         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1085         require(to != address(0), "ERC721: transfer to the zero address");
1086 
1087         _beforeTokenTransfer(from, to, tokenId);
1088 
1089         // Clear approvals from the previous owner
1090         _approve(address(0), tokenId);
1091 
1092         _balances[from] -= 1;
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Approve `to` to operate on `tokenId`
1101      *
1102      * Emits a {Approval} event.
1103      */
1104     function _approve(address to, uint256 tokenId) internal virtual {
1105         _tokenApprovals[tokenId] = to;
1106         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Approve `operator` to operate on all of `owner` tokens
1111      *
1112      * Emits a {ApprovalForAll} event.
1113      */
1114     function _setApprovalForAll(
1115         address owner,
1116         address operator,
1117         bool approved
1118     ) internal virtual {
1119         require(owner != operator, "ERC721: approve to caller");
1120         _operatorApprovals[owner][operator] = approved;
1121         emit ApprovalForAll(owner, operator, approved);
1122     }
1123 
1124     /**
1125      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1126      * The call is not executed if the target address is not a contract.
1127      *
1128      * @param from address representing the previous owner of the given token ID
1129      * @param to target address that will receive the tokens
1130      * @param tokenId uint256 ID of the token to be transferred
1131      * @param _data bytes optional data to send along with the call
1132      * @return bool whether the call correctly returned the expected magic value
1133      */
1134     function _checkOnERC721Received(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) private returns (bool) {
1140         if (to.isContract()) {
1141             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1142                 return retval == IERC721Receiver.onERC721Received.selector;
1143             } catch (bytes memory reason) {
1144                 if (reason.length == 0) {
1145                     revert("ERC721: transfer to non ERC721Receiver implementer");
1146                 } else {
1147                     assembly {
1148                         revert(add(32, reason), mload(reason))
1149                     }
1150                 }
1151             }
1152         } else {
1153             return true;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before any token transfer. This includes minting
1159      * and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` will be minted for `to`.
1166      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1167      * - `from` and `to` are never both zero.
1168      *
1169      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1170      */
1171     function _beforeTokenTransfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {}
1176 }
1177 
1178 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1179 
1180 
1181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 /**
1187  * @dev ERC721 token with storage based token URI management.
1188  */
1189 abstract contract ERC721URIStorage is ERC721 {
1190     using Strings for uint256;
1191 
1192     // Optional mapping for token URIs
1193     mapping(uint256 => string) private _tokenURIs;
1194 
1195     /**
1196      * @dev See {IERC721Metadata-tokenURI}.
1197      */
1198     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1199         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1200 
1201         string memory _tokenURI = _tokenURIs[tokenId];
1202         string memory base = _baseURI();
1203 
1204         // If there is no base URI, return the token URI.
1205         if (bytes(base).length == 0) {
1206             return _tokenURI;
1207         }
1208         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1209         if (bytes(_tokenURI).length > 0) {
1210             return string(abi.encodePacked(base, _tokenURI));
1211         }
1212 
1213         return super.tokenURI(tokenId);
1214     }
1215 
1216     /**
1217      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      */
1223     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1224         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1225         _tokenURIs[tokenId] = _tokenURI;
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId) internal virtual override {
1239         super._burn(tokenId);
1240 
1241         if (bytes(_tokenURIs[tokenId]).length != 0) {
1242             delete _tokenURIs[tokenId];
1243         }
1244     }
1245 }
1246 
1247 // File: contracts/LilHeroes.sol
1248 
1249 //SPDX-License-Identifier: UNLICENSED
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 
1254 /**
1255  * @dev Implementation of Non-Fungible Token Standard (ERC-721)
1256  * This contract is designed to be ready-to-use and versatile.
1257  */
1258 contract LilHeroes is ERC721URIStorage, Ownable, Pausable {
1259 
1260     // General constants
1261     enum mintTypes {PRIVATE, WHITELIST, RAFFLE, PUBLIC}
1262     uint256 public maxItems                       = 7777; // Maximum items in the collection
1263     uint256 public price                          = 0.4 ether; // Price for minting one NFT
1264     uint256 public totalSupply;                             // number of NFTs minted thus far
1265     address internal __walletTreasury;                      // Address of the treasury wallet
1266     address internal __walletSignature;                     // Address of the treasury wallet
1267     string internal __baseURI;                              // Base URI for the metadata
1268     string internal __extensionURI                  = "";   // Extension of the URI
1269 
1270     // Constants for the private
1271     uint256 public privateMaxMintsPerTx             = 10;   // Maximum number of mints per transaction
1272     uint256 public privateMaxMintsPerWallet         = 50;   // Maximum number of mint per wallet
1273     uint256 public privateStartTime                 = 1642352400; // UTC timestamp when minting is open
1274     bool public privateIsActive                     = false; // If the mint is active
1275     mapping(address => uint256) public privateAmountMinted; // Keep track of the amount mint during the private
1276 
1277     // Constants for the whitelist
1278     uint256 public whitelistMaxMintsPerTx           = 2;    // Maximum number of mints per transaction
1279     uint256 public whitelistMaxMintsPerWallet       = 2;    // Maximum number of mint per wallet
1280     uint256 public whitelistStartTime               = 1642352400; // UTC timestamp when minting is open
1281     bool public whitelistIsActive                   = false; // If the mint is active
1282     mapping(address => uint256) public whitelistAmountMinted; // Keep track of the amount mint during the whitelist
1283 
1284     // Constants for the raffle
1285     uint256 public raffleMaxMintsPerTx              = 2;    // Maximum number of mints per transaction
1286     uint256 public raffleMaxMintsPerWallet          = 2;    // Maximum number of mint per wallet
1287     uint256 public raffleStartTime                  = 1642359600; // UTC timestamp when minting is open
1288     bool public raffleIsActive                      = false; // If the mint is active
1289     mapping(address => uint256) public raffleAmountMinted; // Keep track of the amount mint during the raffle
1290 
1291     // Constants for the public sale
1292     uint256 public publicMaxMintsPerTx              = 2;    // Maximum number of mints per transaction
1293     bool public publicIsActive                      = false; // If the mint is active
1294 
1295     constructor(
1296         string memory name_,
1297         string memory symbol_,
1298         address walletTreasury_,
1299         address walletSignature_,
1300         string memory baseURI_
1301     ) ERC721(name_, symbol_) {
1302         __baseURI = baseURI_;
1303         __walletTreasury = walletTreasury_;
1304         __walletSignature = walletSignature_;
1305     }
1306 
1307     /**
1308     * Set the new mint per tx allowed
1309     * @param _type The type of of maximum tx to change
1310     * @param _newMax The new maximum per tx allowed
1311     **/
1312     function setMaxMintsPerTx(uint256 _type, uint256 _newMax) external onlyOwner {
1313         if (_type == uint256(mintTypes.WHITELIST)) {
1314             whitelistMaxMintsPerTx = _newMax;
1315         } else if (_type == uint256(mintTypes.PRIVATE)) {
1316             privateMaxMintsPerTx = _newMax;
1317         } else if (_type == uint256(mintTypes.RAFFLE)) {
1318             raffleMaxMintsPerTx = _newMax;
1319         } else if (_type == uint256(mintTypes.PUBLIC)) {
1320             publicMaxMintsPerTx = _newMax;
1321         }
1322     }
1323 
1324     /**
1325     * Set the new mint per wallet allowed
1326     * @param _type The type of of maximum tx to change
1327     * @param _newMax The new maximum per tx allowed
1328     **/
1329     function setMaxMintsPerWallet(uint256 _type, uint256 _newMax) external onlyOwner {
1330         if (_type == uint256(mintTypes.WHITELIST)) {
1331             whitelistMaxMintsPerWallet = _newMax;
1332         } else if (_type == uint256(mintTypes.PRIVATE)) {
1333             privateMaxMintsPerWallet = _newMax;
1334         } else if (_type == uint256(mintTypes.RAFFLE)) {
1335             raffleMaxMintsPerWallet = _newMax;
1336         }
1337     }
1338 
1339     /**
1340     * Set the new start time
1341     * @param _type The type of of maximum tx to change
1342     * @param _startTime The new start time (format: timestamp)
1343     **/
1344     function setStartTime(uint256 _type, uint256 _startTime) external onlyOwner {
1345         if (_type == uint256(mintTypes.WHITELIST)) {
1346             whitelistStartTime = _startTime;
1347         } else if (_type == uint256(mintTypes.PRIVATE)) {
1348             privateStartTime = _startTime;
1349         } else if (_type == uint256(mintTypes.RAFFLE)) {
1350             raffleStartTime = _startTime;
1351         }
1352     }
1353 
1354     /**
1355     * Set if the mint is active
1356     * @param _type The type of of maximum tx to change
1357     * @param _isActive The new state
1358     **/
1359     function setIsActive(uint256 _type, bool _isActive) external onlyOwner {
1360         if (_type == uint256(mintTypes.WHITELIST)) {
1361             whitelistIsActive = _isActive;
1362         } else if (_type == uint256(mintTypes.PRIVATE)) {
1363             privateIsActive = _isActive;
1364         } else if (_type == uint256(mintTypes.RAFFLE)) {
1365             raffleIsActive = _isActive;
1366         } else if (_type == uint256(mintTypes.PUBLIC)) {
1367             publicIsActive = _isActive;
1368         }
1369     }
1370 
1371     /**
1372     * Set the new price
1373     * @param _price The new price
1374     **/
1375     function setPrice(uint256 _price) external onlyOwner {
1376         price = _price;
1377     }
1378 
1379     /**
1380     * Set the new max items
1381     * @param _max The new price
1382     **/
1383     function setMaxItems(uint256 _max) external onlyOwner {
1384         maxItems = _max;
1385     }
1386 
1387     /**
1388     * Set the new wallet treasury
1389     * @param _wallet The eth address
1390     **/
1391     function setWalletTreasury(address _wallet) external onlyOwner {
1392         __walletTreasury = _wallet;
1393     }
1394 
1395     /**
1396     * Set the new wallet signature
1397     * @param _wallet The eth address
1398     **/
1399     function setWalletSignature(address _wallet) external onlyOwner {
1400         __walletSignature = _wallet;
1401     }
1402 
1403     /**
1404     * Set the new base uri for metadata
1405     * @param _newBaseURI The new base uri
1406     **/
1407     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1408         __baseURI = _newBaseURI;
1409     }
1410 
1411     /**
1412     * Set the new extension of the uri
1413     * @param _newExtensionURI The new base uri
1414     **/
1415     function setExtensionURI(string memory _newExtensionURI) external onlyOwner {
1416         __extensionURI = _newExtensionURI;
1417     }
1418 
1419     /**
1420     * Get the base url
1421     **/
1422     function _baseURI() internal view override returns (string memory) {
1423         return __baseURI;
1424     }
1425 
1426     /**
1427     * Get the token uri of the metadata for a specific token
1428     * @param tokenId The token id
1429     **/
1430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1431         if (bytes(__extensionURI).length == 0){
1432             return super.tokenURI(tokenId);
1433         }
1434 
1435         return string(abi.encodePacked(super.tokenURI(tokenId), __extensionURI));
1436     }
1437 
1438     /**
1439     * Mint for the private sale. We check if the wallet is authorized and how mint it has already done
1440     * @param numToMint The number of token to mint
1441     * @param signature The signature
1442     **/
1443     function mintPrivate(uint256 numToMint, bytes memory signature) external payable {
1444         require(block.timestamp > privateStartTime, "minting not open yet");
1445         require(privateIsActive == true, "minting not activated");
1446         require(verify(signature, msg.sender), "wallet is not whitelisted");
1447         require(privateAmountMinted[msg.sender] + numToMint <= privateMaxMintsPerWallet, "too many tokens allowed per wallet");
1448         require(msg.value >= price * numToMint, "not enough eth provided");
1449         require(numToMint > 0, "not enough token to mint");
1450         require((numToMint + totalSupply) <= maxItems, "would exceed max supply");
1451         require(numToMint <= privateMaxMintsPerTx, "too many tokens per tx");
1452 
1453         for(uint256 i=totalSupply; i < (totalSupply + numToMint); i++){
1454             _mint(msg.sender, i+1);
1455         }
1456 
1457         privateAmountMinted[msg.sender] = privateAmountMinted[msg.sender] + numToMint;
1458         totalSupply += numToMint;
1459     }
1460 
1461     /**
1462     * Mint for the whitelist. We check if the wallet is authorized and how mint it has already done
1463     * @param numToMint The number of token to mint
1464     * @param signature The signature
1465     **/
1466     function mintWhitelist(uint256 numToMint, bytes memory signature) external payable {
1467         require(block.timestamp > whitelistStartTime, "minting not open yet");
1468         require(whitelistIsActive == true, "minting not activated");
1469         require(verify(signature, msg.sender), "wallet is not whitelisted");
1470         require(whitelistAmountMinted[msg.sender] + numToMint <= whitelistMaxMintsPerWallet, "too many tokens allowed per wallet");
1471         require(msg.value >= price * numToMint, "not enough eth provided");
1472         require(numToMint > 0, "not enough token to mint");
1473         require((numToMint + totalSupply) <= maxItems, "would exceed max supply");
1474         require(numToMint <= whitelistMaxMintsPerTx, "too many tokens per tx");
1475 
1476         for(uint256 i=totalSupply; i < (totalSupply + numToMint); i++){
1477             _mint(msg.sender, i+1);
1478         }
1479 
1480         whitelistAmountMinted[msg.sender] = whitelistAmountMinted[msg.sender] + numToMint;
1481         totalSupply += numToMint;
1482     }
1483 
1484     /**
1485     * Mint for the raffle. We check if the wallet is authorized and how mint it has already done
1486     * @param numToMint The number of token to mint
1487     * @param signature The signature
1488     **/
1489     function mintRaffle(uint256 numToMint, bytes memory signature) external payable {
1490         require(block.timestamp > raffleStartTime, "minting not open yet");
1491         require(raffleIsActive == true, "minting not activated");
1492         require(verify(signature, msg.sender), "wallet is not whitelisted");
1493         require(raffleAmountMinted[msg.sender] + numToMint <= raffleMaxMintsPerWallet, "too many tokens allowed per wallet");
1494         require(msg.value >= price * numToMint, "not enough eth provided");
1495         require(numToMint > 0, "not enough token to mint");
1496         require((numToMint + totalSupply) <= maxItems, "would exceed max supply");
1497         require(numToMint <= raffleMaxMintsPerTx, "too many tokens per tx");
1498 
1499         for(uint256 i=totalSupply; i < (totalSupply + numToMint); i++){
1500             _mint(msg.sender, i+1);
1501         }
1502 
1503         raffleAmountMinted[msg.sender] = raffleAmountMinted[msg.sender] + numToMint;
1504         totalSupply += numToMint;
1505     }
1506 
1507     /**
1508     * Mint for the public.
1509     * @param numToMint The number of token to mint
1510     **/
1511     function mintPublic(uint256 numToMint) external payable whenNotPaused {
1512         require(publicIsActive == true, "minting not activated");
1513         require(msg.value >= price * numToMint, "not enough eth provided");
1514         require(numToMint > 0, "not enough token to mint");
1515         require((numToMint + totalSupply) <= maxItems, "would exceed max supply");
1516         require(numToMint <= publicMaxMintsPerTx, "too many tokens per tx");
1517 
1518         for(uint256 i=totalSupply; i < (totalSupply + numToMint); i++){
1519             _mint(msg.sender, i+1);
1520         }
1521 
1522         totalSupply += numToMint;
1523     }
1524 
1525     /**
1526     * Airdrop
1527     * @param recipients The list of address to send to
1528     * @param amounts The amount to send to each of address
1529     **/
1530     function airdrop(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
1531         require(recipients.length == amounts.length, "arrays have different lengths");
1532 
1533         for (uint256 i=0; i < recipients.length; i++){
1534             for(uint256 j=totalSupply; j < (totalSupply + amounts[i]); j++){
1535                 _mint(recipients[i], j+1);
1536             }
1537 
1538             totalSupply += amounts[i];
1539         }
1540     }
1541 
1542     /**
1543     * Verify if the signature is legit
1544     * @param signature The signature to verify
1545     * @param target The target address to find
1546     **/
1547     function verify(bytes memory signature, address target) public view returns (bool) {
1548         uint8 v;
1549         bytes32 r;
1550         bytes32 s;
1551         (v, r, s) = splitSignature(signature);
1552         bytes32 senderHash = keccak256(abi.encodePacked(target));
1553 
1554         //return (owner() == address(ecrecover(senderHash, v, r, s)));
1555         return (__walletSignature == address(ecrecover(senderHash, v, r, s)));
1556     }
1557 
1558     /**
1559     * Split the signature to verify
1560     * @param signature The signature to verify
1561     **/
1562     function splitSignature(bytes memory signature) public pure returns (uint8, bytes32, bytes32) {
1563         require(signature.length == 65);
1564 
1565         bytes32 r;
1566         bytes32 s;
1567         uint8 v;
1568         assembly {
1569         // first 32 bytes, after the length prefix
1570             r := mload(add(signature, 32))
1571         // second 32 bytes
1572             s := mload(add(signature, 64))
1573         // final byte (first byte of the next 32 bytes)
1574             v := byte(0, mload(add(signature, 96)))
1575         }
1576 
1577         return (v, r, s);
1578     }
1579 
1580     /**
1581     * Burns `tokenId`. See {ERC721-_burn}. The caller must own `tokenId` or be an approved operator.
1582     * @param tokenId The ID of the token to burn
1583    */
1584     function burn(uint256 tokenId) public virtual {
1585         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
1586 
1587         _burn(tokenId);
1588     }
1589 
1590     /**
1591     * Withdraw the balance from the contract
1592     */
1593     function withdraw() external payable onlyOwner returns (bool success) {
1594         (success,) = payable(__walletTreasury).call{value: address(this).balance}("");
1595     }
1596 }