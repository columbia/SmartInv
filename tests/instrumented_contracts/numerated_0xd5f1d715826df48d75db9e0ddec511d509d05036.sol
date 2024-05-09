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
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Enumerable is IERC721 {
736     /**
737      * @dev Returns the total amount of tokens stored by the contract.
738      */
739     function totalSupply() external view returns (uint256);
740 
741     /**
742      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
743      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
744      */
745     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
746 
747     /**
748      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
749      * Use along with {totalSupply} to enumerate all tokens.
750      */
751     function tokenByIndex(uint256 index) external view returns (uint256);
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
764  * @dev See https://eips.ethereum.org/EIPS/eip-721
765  */
766 interface IERC721Metadata is IERC721 {
767     /**
768      * @dev Returns the token collection name.
769      */
770     function name() external view returns (string memory);
771 
772     /**
773      * @dev Returns the token collection symbol.
774      */
775     function symbol() external view returns (string memory);
776 
777     /**
778      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
779      */
780     function tokenURI(uint256 tokenId) external view returns (string memory);
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 
792 
793 
794 
795 
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata extension, but not including the Enumerable extension, which is available separately as
800  * {ERC721Enumerable}.
801  */
802 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
803     using Address for address;
804     using Strings for uint256;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to owner address
813     mapping(uint256 => address) private _owners;
814 
815     // Mapping owner address to token count
816     mapping(address => uint256) private _balances;
817 
818     // Mapping from token ID to approved address
819     mapping(uint256 => address) private _tokenApprovals;
820 
821     // Mapping from owner to operator approvals
822     mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824     /**
825      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
826      */
827     constructor(string memory name_, string memory symbol_) {
828         _name = name_;
829         _symbol = symbol_;
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view virtual override returns (uint256) {
846         require(owner != address(0), "ERC721: balance query for the zero address");
847         return _balances[owner];
848     }
849 
850     /**
851      * @dev See {IERC721-ownerOf}.
852      */
853     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
854         address owner = _owners[tokenId];
855         require(owner != address(0), "ERC721: owner query for nonexistent token");
856         return owner;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-name}.
861      */
862     function name() public view virtual override returns (string memory) {
863         return _name;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-symbol}.
868      */
869     function symbol() public view virtual override returns (string memory) {
870         return _symbol;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-tokenURI}.
875      */
876     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
877         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
878 
879         string memory baseURI = _baseURI();
880         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
881     }
882 
883     /**
884      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
885      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
886      * by default, can be overriden in child contracts.
887      */
888     function _baseURI() internal view virtual returns (string memory) {
889         return "";
890     }
891 
892     /**
893      * @dev See {IERC721-approve}.
894      */
895     function approve(address to, uint256 tokenId) public virtual override {
896         address owner = ERC721.ownerOf(tokenId);
897         require(to != owner, "ERC721: approval to current owner");
898 
899         require(
900             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
901             "ERC721: approve caller is not owner nor approved for all"
902         );
903 
904         _approve(to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-getApproved}.
909      */
910     function getApproved(uint256 tokenId) public view virtual override returns (address) {
911         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         _setApprovalForAll(_msgSender(), operator, approved);
921     }
922 
923     /**
924      * @dev See {IERC721-isApprovedForAll}.
925      */
926     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927         return _operatorApprovals[owner][operator];
928     }
929 
930     /**
931      * @dev See {IERC721-transferFrom}.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         //solhint-disable-next-line max-line-length
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940 
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, "");
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965         _safeTransfer(from, to, tokenId, _data);
966     }
967 
968     /**
969      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
970      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
971      *
972      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
973      *
974      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
975      * implement alternative mechanisms to perform token transfer, such as signature-based.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must exist and be owned by `from`.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeTransfer(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) internal virtual {
992         _transfer(from, to, tokenId);
993         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      * and stop existing when they are burned (`_burn`).
1003      */
1004     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005         return _owners[tokenId] != address(0);
1006     }
1007 
1008     /**
1009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1016         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1017         address owner = ERC721.ownerOf(tokenId);
1018         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1019     }
1020 
1021     /**
1022      * @dev Safely mints `tokenId` and transfers it to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(address to, uint256 tokenId) internal virtual {
1032         _safeMint(to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038      */
1039     function _safeMint(
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _mint(to, tokenId);
1045         require(
1046             _checkOnERC721Received(address(0), to, tokenId, _data),
1047             "ERC721: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         address owner = ERC721.ownerOf(tokenId);
1087 
1088         _beforeTokenTransfer(owner, address(0), tokenId);
1089 
1090         // Clear approvals
1091         _approve(address(0), tokenId);
1092 
1093         _balances[owner] -= 1;
1094         delete _owners[tokenId];
1095 
1096         emit Transfer(owner, address(0), tokenId);
1097     }
1098 
1099     /**
1100      * @dev Transfers `tokenId` from `from` to `to`.
1101      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {
1115         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1116         require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(from, to, tokenId);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId);
1122 
1123         _balances[from] -= 1;
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(address to, uint256 tokenId) internal virtual {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `operator` to operate on all of `owner` tokens
1142      *
1143      * Emits a {ApprovalForAll} event.
1144      */
1145     function _setApprovalForAll(
1146         address owner,
1147         address operator,
1148         bool approved
1149     ) internal virtual {
1150         require(owner != operator, "ERC721: approve to caller");
1151         _operatorApprovals[owner][operator] = approved;
1152         emit ApprovalForAll(owner, operator, approved);
1153     }
1154 
1155     /**
1156      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1157      * The call is not executed if the target address is not a contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         if (to.isContract()) {
1172             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1173                 return retval == IERC721Receiver.onERC721Received.selector;
1174             } catch (bytes memory reason) {
1175                 if (reason.length == 0) {
1176                     revert("ERC721: transfer to non ERC721Receiver implementer");
1177                 } else {
1178                     assembly {
1179                         revert(add(32, reason), mload(reason))
1180                     }
1181                 }
1182             }
1183         } else {
1184             return true;
1185         }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any token transfer. This includes minting
1190      * and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1198      * - `from` and `to` are never both zero.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual {}
1207 }
1208 
1209 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1210 
1211 
1212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 
1217 
1218 /**
1219  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1220  * enumerability of all the token ids in the contract as well as all token ids owned by each
1221  * account.
1222  */
1223 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1224     // Mapping from owner to list of owned token IDs
1225     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1226 
1227     // Mapping from token ID to index of the owner tokens list
1228     mapping(uint256 => uint256) private _ownedTokensIndex;
1229 
1230     // Array with all token ids, used for enumeration
1231     uint256[] private _allTokens;
1232 
1233     // Mapping from token id to position in the allTokens array
1234     mapping(uint256 => uint256) private _allTokensIndex;
1235 
1236     /**
1237      * @dev See {IERC165-supportsInterface}.
1238      */
1239     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1240         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1245      */
1246     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1247         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1248         return _ownedTokens[owner][index];
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Enumerable-totalSupply}.
1253      */
1254     function totalSupply() public view virtual override returns (uint256) {
1255         return _allTokens.length;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Enumerable-tokenByIndex}.
1260      */
1261     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1262         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1263         return _allTokens[index];
1264     }
1265 
1266     /**
1267      * @dev Hook that is called before any token transfer. This includes minting
1268      * and burning.
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` will be minted for `to`.
1275      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1276      * - `from` cannot be the zero address.
1277      * - `to` cannot be the zero address.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _beforeTokenTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) internal virtual override {
1286         super._beforeTokenTransfer(from, to, tokenId);
1287 
1288         if (from == address(0)) {
1289             _addTokenToAllTokensEnumeration(tokenId);
1290         } else if (from != to) {
1291             _removeTokenFromOwnerEnumeration(from, tokenId);
1292         }
1293         if (to == address(0)) {
1294             _removeTokenFromAllTokensEnumeration(tokenId);
1295         } else if (to != from) {
1296             _addTokenToOwnerEnumeration(to, tokenId);
1297         }
1298     }
1299 
1300     /**
1301      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1302      * @param to address representing the new owner of the given token ID
1303      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1304      */
1305     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1306         uint256 length = ERC721.balanceOf(to);
1307         _ownedTokens[to][length] = tokenId;
1308         _ownedTokensIndex[tokenId] = length;
1309     }
1310 
1311     /**
1312      * @dev Private function to add a token to this extension's token tracking data structures.
1313      * @param tokenId uint256 ID of the token to be added to the tokens list
1314      */
1315     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1316         _allTokensIndex[tokenId] = _allTokens.length;
1317         _allTokens.push(tokenId);
1318     }
1319 
1320     /**
1321      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1322      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1323      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1324      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1325      * @param from address representing the previous owner of the given token ID
1326      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1327      */
1328     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1329         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1330         // then delete the last slot (swap and pop).
1331 
1332         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1333         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1334 
1335         // When the token to delete is the last token, the swap operation is unnecessary
1336         if (tokenIndex != lastTokenIndex) {
1337             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1338 
1339             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1340             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1341         }
1342 
1343         // This also deletes the contents at the last position of the array
1344         delete _ownedTokensIndex[tokenId];
1345         delete _ownedTokens[from][lastTokenIndex];
1346     }
1347 
1348     /**
1349      * @dev Private function to remove a token from this extension's token tracking data structures.
1350      * This has O(1) time complexity, but alters the order of the _allTokens array.
1351      * @param tokenId uint256 ID of the token to be removed from the tokens list
1352      */
1353     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1354         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1355         // then delete the last slot (swap and pop).
1356 
1357         uint256 lastTokenIndex = _allTokens.length - 1;
1358         uint256 tokenIndex = _allTokensIndex[tokenId];
1359 
1360         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1361         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1362         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1363         uint256 lastTokenId = _allTokens[lastTokenIndex];
1364 
1365         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1366         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1367 
1368         // This also deletes the contents at the last position of the array
1369         delete _allTokensIndex[tokenId];
1370         _allTokens.pop();
1371     }
1372 }
1373 
1374 // File: contracts/SAAC.sol
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 
1380 
1381 
1382 contract StarryApes is ERC721Enumerable, Ownable {
1383     using Strings for uint256;
1384 
1385     uint256 public constant MAX_APES = 10000;
1386     uint256 public constant MAX_PER_MINT = 10;
1387     uint256 public PRICE = 0.00 ether;
1388     uint256 public numAPESMinted;
1389     string public baseTokenURI;
1390     string public baseExtension = ".json";
1391     bool public publicSaleStarted;
1392 
1393     mapping(address => uint256) private _totalClaimed;
1394 
1395     event BaseURIChanged(string baseURI);
1396     event PublicSaleMint(address minter, uint256 amountOfAPES);
1397 
1398     modifier whenPublicSaleStarted() {
1399         require(publicSaleStarted, "Public sale has not started");
1400         _;
1401     }
1402     
1403     constructor(string memory baseURI) ERC721("StarryApes", "SAAC") {
1404         baseTokenURI = baseURI;
1405     }
1406 
1407     function amountClaimedBy(address owner) external view returns (uint256) {
1408         require(owner != address(0), "Cannot add null address");
1409 
1410         return _totalClaimed[owner];
1411     }
1412 
1413     function mint(uint256 amountOfAPES) external payable whenPublicSaleStarted {
1414         require(totalSupply() < MAX_APES, "All tokens have been minted");
1415         require(amountOfAPES <= MAX_PER_MINT, "Cannot purchase this many tokens in a transaction");
1416         require(totalSupply() + amountOfAPES <= MAX_APES, "Minting would exceed max supply");
1417         require(amountOfAPES > 0, "Must mint at least one Ape");
1418         require(PRICE * amountOfAPES == msg.value, "ETH amount is incorrect");
1419 
1420         for (uint256 i = 0; i < amountOfAPES; i++) {
1421             uint256 tokenId = numAPESMinted + 1;
1422 
1423             numAPESMinted += 1;
1424             _totalClaimed[msg.sender] += 1;
1425             _safeMint(msg.sender, tokenId);
1426         }
1427 
1428         emit PublicSaleMint(msg.sender, amountOfAPES);
1429     }
1430 
1431     function togglePublicSaleStarted() external onlyOwner {
1432         publicSaleStarted = !publicSaleStarted;
1433     }
1434 
1435     function _baseURI() internal view virtual override returns (string memory) {
1436         return baseTokenURI;
1437     }
1438 
1439     function setBaseURI(string memory baseURI) public onlyOwner {
1440         baseTokenURI = baseURI;
1441         emit BaseURIChanged(baseURI);
1442     }
1443     
1444     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1445         baseExtension = _newBaseExtension;
1446    }
1447     
1448    function setPrice(uint256 _newPrice) public onlyOwner() {
1449         PRICE = _newPrice;
1450    }
1451 
1452     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1453         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1454         string memory currentBaseURI = _baseURI();
1455         return bytes(currentBaseURI).length > 0
1456         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1457         : "";
1458     }
1459     
1460     function withdraw() public payable onlyOwner {
1461         uint256 balance = address(this).balance;
1462         require(balance > 0, "Insufficent balance");
1463         (bool success, ) = payable(msg.sender).call{value: balance}("");
1464         require(success);
1465   }
1466 }