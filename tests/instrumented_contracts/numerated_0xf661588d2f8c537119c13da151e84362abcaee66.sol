1 // File: RichieBank_flat_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/security/Pausable.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /**
118  * @dev Contract module which allows children to implement an emergency stop
119  * mechanism that can be triggered by an authorized account.
120  *
121  * This module is used through inheritance. It will make available the
122  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
123  * the functions of your contract. Note that they will not be pausable by
124  * simply including this module, only once the modifiers are put in place.
125  */
126 abstract contract Pausable is Context {
127     /**
128      * @dev Emitted when the pause is triggered by `account`.
129      */
130     event Paused(address account);
131 
132     /**
133      * @dev Emitted when the pause is lifted by `account`.
134      */
135     event Unpaused(address account);
136 
137     bool private _paused;
138 
139     /**
140      * @dev Initializes the contract in unpaused state.
141      */
142     constructor() {
143         _paused = false;
144     }
145 
146     /**
147      * @dev Modifier to make a function callable only when the contract is not paused.
148      *
149      * Requirements:
150      *
151      * - The contract must not be paused.
152      */
153     modifier whenNotPaused() {
154         _requireNotPaused();
155         _;
156     }
157 
158     /**
159      * @dev Modifier to make a function callable only when the contract is paused.
160      *
161      * Requirements:
162      *
163      * - The contract must be paused.
164      */
165     modifier whenPaused() {
166         _requirePaused();
167         _;
168     }
169 
170     /**
171      * @dev Returns true if the contract is paused, and false otherwise.
172      */
173     function paused() public view virtual returns (bool) {
174         return _paused;
175     }
176 
177     /**
178      * @dev Throws if the contract is paused.
179      */
180     function _requireNotPaused() internal view virtual {
181         require(!paused(), "Pausable: paused");
182     }
183 
184     /**
185      * @dev Throws if the contract is not paused.
186      */
187     function _requirePaused() internal view virtual {
188         require(paused(), "Pausable: not paused");
189     }
190 
191     /**
192      * @dev Triggers stopped state.
193      *
194      * Requirements:
195      *
196      * - The contract must not be paused.
197      */
198     function _pause() internal virtual whenNotPaused {
199         _paused = true;
200         emit Paused(_msgSender());
201     }
202 
203     /**
204      * @dev Returns to normal state.
205      *
206      * Requirements:
207      *
208      * - The contract must be paused.
209      */
210     function _unpause() internal virtual whenPaused {
211         _paused = false;
212         emit Unpaused(_msgSender());
213     }
214 }
215 
216 // File: @openzeppelin/contracts/access/Ownable.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 
224 /**
225  * @dev Contract module which provides a basic access control mechanism, where
226  * there is an account (an owner) that can be granted exclusive access to
227  * specific functions.
228  *
229  * By default, the owner account will be the one that deploys the contract. This
230  * can later be changed with {transferOwnership}.
231  *
232  * This module is used through inheritance. It will make available the modifier
233  * `onlyOwner`, which can be applied to your functions to restrict their use to
234  * the owner.
235  */
236 abstract contract Ownable is Context {
237     address private _owner;
238 
239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240 
241     /**
242      * @dev Initializes the contract setting the deployer as the initial owner.
243      */
244     constructor() {
245         _transferOwnership(_msgSender());
246     }
247 
248     /**
249      * @dev Throws if called by any account other than the owner.
250      */
251     modifier onlyOwner() {
252         _checkOwner();
253         _;
254     }
255 
256     /**
257      * @dev Returns the address of the current owner.
258      */
259     function owner() public view virtual returns (address) {
260         return _owner;
261     }
262 
263     /**
264      * @dev Throws if the sender is not the owner.
265      */
266     function _checkOwner() internal view virtual {
267         require(owner() == _msgSender(), "Ownable: caller is not the owner");
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() public virtual onlyOwner {
278         _transferOwnership(address(0));
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Can only be called by the current owner.
284      */
285     function transferOwnership(address newOwner) public virtual onlyOwner {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         _transferOwnership(newOwner);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Internal function without access restriction.
293      */
294     function _transferOwnership(address newOwner) internal virtual {
295         address oldOwner = _owner;
296         _owner = newOwner;
297         emit OwnershipTransferred(oldOwner, newOwner);
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Address.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
305 
306 pragma solidity ^0.8.1;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      *
329      * [IMPORTANT]
330      * ====
331      * You shouldn't rely on `isContract` to protect against flash loan attacks!
332      *
333      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
334      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
335      * constructor.
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize/address.code.length, which returns 0
340         // for contracts in construction, since the code is only stored at the end
341         // of the constructor execution.
342 
343         return account.code.length > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514                 /// @solidity memory-safe-assembly
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
527 
528 
529 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
547      */
548     function onERC721Received(
549         address operator,
550         address from,
551         uint256 tokenId,
552         bytes calldata data
553     ) external returns (bytes4);
554 }
555 
556 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Interface of the ERC165 standard, as defined in the
565  * https://eips.ethereum.org/EIPS/eip-165[EIP].
566  *
567  * Implementers can declare support of contract interfaces, which can then be
568  * queried by others ({ERC165Checker}).
569  *
570  * For an implementation, see {ERC165}.
571  */
572 interface IERC165 {
573     /**
574      * @dev Returns true if this contract implements the interface defined by
575      * `interfaceId`. See the corresponding
576      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
577      * to learn more about how these ids are created.
578      *
579      * This function call must use less than 30 000 gas.
580      */
581     function supportsInterface(bytes4 interfaceId) external view returns (bool);
582 }
583 
584 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
616 
617 
618 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Required interface of an ERC721 compliant contract.
625  */
626 interface IERC721 is IERC165 {
627     /**
628      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
629      */
630     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
631 
632     /**
633      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
634      */
635     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
639      */
640     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
641 
642     /**
643      * @dev Returns the number of tokens in ``owner``'s account.
644      */
645     function balanceOf(address owner) external view returns (uint256 balance);
646 
647     /**
648      * @dev Returns the owner of the `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function ownerOf(uint256 tokenId) external view returns (address owner);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes calldata data
674     ) external;
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
678      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Transfers `tokenId` token from `from` to `to`.
698      *
699      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must be owned by `from`.
706      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      *
708      * Emits a {Transfer} event.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external;
715 
716     /**
717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
718      * The approval is cleared when the token is transferred.
719      *
720      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
721      *
722      * Requirements:
723      *
724      * - The caller must own the token or be an approved operator.
725      * - `tokenId` must exist.
726      *
727      * Emits an {Approval} event.
728      */
729     function approve(address to, uint256 tokenId) external;
730 
731     /**
732      * @dev Approve or remove `operator` as an operator for the caller.
733      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
734      *
735      * Requirements:
736      *
737      * - The `operator` cannot be the caller.
738      *
739      * Emits an {ApprovalForAll} event.
740      */
741     function setApprovalForAll(address operator, bool _approved) external;
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) external view returns (address operator);
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}
756      */
757     function isApprovedForAll(address owner, address operator) external view returns (bool);
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 }
788 
789 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
790 
791 
792 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 
797 
798 
799 
800 
801 
802 
803 /**
804  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
805  * the Metadata extension, but not including the Enumerable extension, which is available separately as
806  * {ERC721Enumerable}.
807  */
808 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
809     using Address for address;
810     using Strings for uint256;
811 
812     // Token name
813     string private _name;
814 
815     // Token symbol
816     string private _symbol;
817 
818     // Mapping from token ID to owner address
819     mapping(uint256 => address) private _owners;
820 
821     // Mapping owner address to token count
822     mapping(address => uint256) private _balances;
823 
824     // Mapping from token ID to approved address
825     mapping(uint256 => address) private _tokenApprovals;
826 
827     // Mapping from owner to operator approvals
828     mapping(address => mapping(address => bool)) private _operatorApprovals;
829 
830     /**
831      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
832      */
833     constructor(string memory name_, string memory symbol_) {
834         _name = name_;
835         _symbol = symbol_;
836     }
837 
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
842         return
843             interfaceId == type(IERC721).interfaceId ||
844             interfaceId == type(IERC721Metadata).interfaceId ||
845             super.supportsInterface(interfaceId);
846     }
847 
848     /**
849      * @dev See {IERC721-balanceOf}.
850      */
851     function balanceOf(address owner) public view virtual override returns (uint256) {
852         require(owner != address(0), "ERC721: address zero is not a valid owner");
853         return _balances[owner];
854     }
855 
856     /**
857      * @dev See {IERC721-ownerOf}.
858      */
859     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
860         address owner = _owners[tokenId];
861         require(owner != address(0), "ERC721: invalid token ID");
862         return owner;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-name}.
867      */
868     function name() public view virtual override returns (string memory) {
869         return _name;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-symbol}.
874      */
875     function symbol() public view virtual override returns (string memory) {
876         return _symbol;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-tokenURI}.
881      */
882     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
883         _requireMinted(tokenId);
884 
885         string memory baseURI = _baseURI();
886         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
887     }
888 
889     /**
890      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
891      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
892      * by default, can be overridden in child contracts.
893      */
894     function _baseURI() internal view virtual returns (string memory) {
895         return "";
896     }
897 
898     /**
899      * @dev See {IERC721-approve}.
900      */
901     function approve(address to, uint256 tokenId) public virtual override {
902         address owner = ERC721.ownerOf(tokenId);
903         require(to != owner, "ERC721: approval to current owner");
904 
905         require(
906             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
907             "ERC721: approve caller is not token owner nor approved for all"
908         );
909 
910         _approve(to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-getApproved}.
915      */
916     function getApproved(uint256 tokenId) public view virtual override returns (address) {
917         _requireMinted(tokenId);
918 
919         return _tokenApprovals[tokenId];
920     }
921 
922     /**
923      * @dev See {IERC721-setApprovalForAll}.
924      */
925     function setApprovalForAll(address operator, bool approved) public virtual override {
926         _setApprovalForAll(_msgSender(), operator, approved);
927     }
928 
929     /**
930      * @dev See {IERC721-isApprovedForAll}.
931      */
932     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
933         return _operatorApprovals[owner][operator];
934     }
935 
936     /**
937      * @dev See {IERC721-transferFrom}.
938      */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public virtual override {
944         //solhint-disable-next-line max-line-length
945         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
946 
947         _transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         safeTransferFrom(from, to, tokenId, "");
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory data
969     ) public virtual override {
970         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
971         _safeTransfer(from, to, tokenId, data);
972     }
973 
974     /**
975      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
976      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
977      *
978      * `data` is additional data, it has no specified format and it is sent in call to `to`.
979      *
980      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
981      * implement alternative mechanisms to perform token transfer, such as signature-based.
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must exist and be owned by `from`.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _safeTransfer(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory data
997     ) internal virtual {
998         _transfer(from, to, tokenId);
999         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1000     }
1001 
1002     /**
1003      * @dev Returns whether `tokenId` exists.
1004      *
1005      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1006      *
1007      * Tokens start existing when they are minted (`_mint`),
1008      * and stop existing when they are burned (`_burn`).
1009      */
1010     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1011         return _owners[tokenId] != address(0);
1012     }
1013 
1014     /**
1015      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      */
1021     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1022         address owner = ERC721.ownerOf(tokenId);
1023         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1024     }
1025 
1026     /**
1027      * @dev Safely mints `tokenId` and transfers it to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must not exist.
1032      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _safeMint(address to, uint256 tokenId) internal virtual {
1037         _safeMint(to, tokenId, "");
1038     }
1039 
1040     /**
1041      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1042      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1043      */
1044     function _safeMint(
1045         address to,
1046         uint256 tokenId,
1047         bytes memory data
1048     ) internal virtual {
1049         _mint(to, tokenId);
1050         require(
1051             _checkOnERC721Received(address(0), to, tokenId, data),
1052             "ERC721: transfer to non ERC721Receiver implementer"
1053         );
1054     }
1055 
1056     /**
1057      * @dev Mints `tokenId` and transfers it to `to`.
1058      *
1059      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must not exist.
1064      * - `to` cannot be the zero address.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 tokenId) internal virtual {
1069         require(to != address(0), "ERC721: mint to the zero address");
1070         require(!_exists(tokenId), "ERC721: token already minted");
1071 
1072         _beforeTokenTransfer(address(0), to, tokenId);
1073 
1074         _balances[to] += 1;
1075         _owners[tokenId] = to;
1076 
1077         emit Transfer(address(0), to, tokenId);
1078 
1079         _afterTokenTransfer(address(0), to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId) internal virtual {
1093         address owner = ERC721.ownerOf(tokenId);
1094 
1095         _beforeTokenTransfer(owner, address(0), tokenId);
1096 
1097         // Clear approvals
1098         _approve(address(0), tokenId);
1099 
1100         _balances[owner] -= 1;
1101         delete _owners[tokenId];
1102 
1103         emit Transfer(owner, address(0), tokenId);
1104 
1105         _afterTokenTransfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1125         require(to != address(0), "ERC721: transfer to the zero address");
1126 
1127         _beforeTokenTransfer(from, to, tokenId);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId);
1131 
1132         _balances[from] -= 1;
1133         _balances[to] += 1;
1134         _owners[tokenId] = to;
1135 
1136         emit Transfer(from, to, tokenId);
1137 
1138         _afterTokenTransfer(from, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Approve `to` to operate on `tokenId`
1143      *
1144      * Emits an {Approval} event.
1145      */
1146     function _approve(address to, uint256 tokenId) internal virtual {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Approve `operator` to operate on all of `owner` tokens
1153      *
1154      * Emits an {ApprovalForAll} event.
1155      */
1156     function _setApprovalForAll(
1157         address owner,
1158         address operator,
1159         bool approved
1160     ) internal virtual {
1161         require(owner != operator, "ERC721: approve to caller");
1162         _operatorApprovals[owner][operator] = approved;
1163         emit ApprovalForAll(owner, operator, approved);
1164     }
1165 
1166     /**
1167      * @dev Reverts if the `tokenId` has not been minted yet.
1168      */
1169     function _requireMinted(uint256 tokenId) internal view virtual {
1170         require(_exists(tokenId), "ERC721: invalid token ID");
1171     }
1172 
1173     /**
1174      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1175      * The call is not executed if the target address is not a contract.
1176      *
1177      * @param from address representing the previous owner of the given token ID
1178      * @param to target address that will receive the tokens
1179      * @param tokenId uint256 ID of the token to be transferred
1180      * @param data bytes optional data to send along with the call
1181      * @return bool whether the call correctly returned the expected magic value
1182      */
1183     function _checkOnERC721Received(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory data
1188     ) private returns (bool) {
1189         if (to.isContract()) {
1190             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1191                 return retval == IERC721Receiver.onERC721Received.selector;
1192             } catch (bytes memory reason) {
1193                 if (reason.length == 0) {
1194                     revert("ERC721: transfer to non ERC721Receiver implementer");
1195                 } else {
1196                     /// @solidity memory-safe-assembly
1197                     assembly {
1198                         revert(add(32, reason), mload(reason))
1199                     }
1200                 }
1201             }
1202         } else {
1203             return true;
1204         }
1205     }
1206 
1207     /**
1208      * @dev Hook that is called before any token transfer. This includes minting
1209      * and burning.
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` will be minted for `to`.
1216      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1217      * - `from` and `to` are never both zero.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {}
1226 
1227     /**
1228      * @dev Hook that is called after any transfer of tokens. This includes
1229      * minting and burning.
1230      *
1231      * Calling conditions:
1232      *
1233      * - when `from` and `to` are both non-zero.
1234      * - `from` and `to` are never both zero.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _afterTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual {}
1243 }
1244 
1245 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1246 
1247 
1248 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 /**
1254  * @dev ERC721 token with storage based token URI management.
1255  */
1256 abstract contract ERC721URIStorage is ERC721 {
1257     using Strings for uint256;
1258 
1259     // Optional mapping for token URIs
1260     mapping(uint256 => string) private _tokenURIs;
1261 
1262     /**
1263      * @dev See {IERC721Metadata-tokenURI}.
1264      */
1265     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1266         _requireMinted(tokenId);
1267 
1268         string memory _tokenURI = _tokenURIs[tokenId];
1269         string memory base = _baseURI();
1270 
1271         // If there is no base URI, return the token URI.
1272         if (bytes(base).length == 0) {
1273             return _tokenURI;
1274         }
1275         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1276         if (bytes(_tokenURI).length > 0) {
1277             return string(abi.encodePacked(base, _tokenURI));
1278         }
1279 
1280         return super.tokenURI(tokenId);
1281     }
1282 
1283     /**
1284      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1285      *
1286      * Requirements:
1287      *
1288      * - `tokenId` must exist.
1289      */
1290     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1291         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1292         _tokenURIs[tokenId] = _tokenURI;
1293     }
1294 
1295     /**
1296      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1297      * token-specific URI was set for the token, and if so, it deletes the token URI from
1298      * the storage mapping.
1299      */
1300     function _burn(uint256 tokenId) internal virtual override {
1301         super._burn(tokenId);
1302 
1303         if (bytes(_tokenURIs[tokenId]).length != 0) {
1304             delete _tokenURIs[tokenId];
1305         }
1306     }
1307 }
1308 
1309 // File: contracts/RichieBank.sol
1310 
1311 //SPDX-License-Identifier: UNLICENSED
1312 pragma solidity ^0.8.0;
1313 
1314 
1315 
1316 /**
1317  * @dev Implementation of Non-Fungible Token Standard (ERC-721)
1318  * This contract is designed to be ready-to-use and versatile.
1319  */
1320 contract RichieBank is ERC721URIStorage, Ownable, Pausable {
1321 
1322     // General constants
1323     uint256 public totalSupply;                             // number of NFTs minted thus far
1324     address internal __walletTreasury;                      // Address of the treasury wallet
1325     string internal __baseURI;                              // Base URI for the metadata
1326     string internal __extensionURI                  = ".json";   // Extension of the URI
1327 
1328     constructor(
1329         string memory name_,
1330         string memory symbol_,
1331         address walletTreasury_,
1332         string memory baseURI_
1333     ) ERC721(name_, symbol_) {
1334         __baseURI = baseURI_;
1335         __walletTreasury = walletTreasury_;
1336     }
1337 
1338     /**
1339     * Set the new wallet treasury
1340     * @param _wallet The eth address
1341     **/
1342     function setWalletTreasury(address _wallet) external onlyOwner {
1343         __walletTreasury = _wallet;
1344     }
1345 
1346     /**
1347     * Set the new base uri for metadata
1348     * @param _newBaseURI The new base uri
1349     **/
1350     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1351         __baseURI = _newBaseURI;
1352     }
1353 
1354     /**
1355     * Set the new extension of the uri
1356     * @param _newExtensionURI The new base uri
1357     **/
1358     function setExtensionURI(string memory _newExtensionURI) external onlyOwner {
1359         __extensionURI = _newExtensionURI;
1360     }
1361 
1362     /**
1363     * Get the base url
1364     **/
1365     function _baseURI() internal view override returns (string memory) {
1366         return __baseURI;
1367     }
1368 
1369     /**
1370     * Get the token uri of the metadata for a specific token
1371     * @param tokenId The token id
1372     **/
1373     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1374         if (bytes(__extensionURI).length == 0){
1375             return super.tokenURI(tokenId);
1376         }
1377 
1378         return string(abi.encodePacked(super.tokenURI(tokenId), __extensionURI));
1379     }
1380 
1381     /**
1382     * Airdrop
1383     * @param recipients The list of address to send to
1384     * @param amounts The amount to send to each of address
1385     **/
1386     function airdrop(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
1387         require(recipients.length == amounts.length, "arrays have different lengths");
1388 
1389         for (uint256 i=0; i < recipients.length; i++){
1390             for(uint256 j=totalSupply; j < (totalSupply + amounts[i]); j++){
1391                 _mint(recipients[i], j+1);
1392             }
1393 
1394             totalSupply += amounts[i];
1395         }
1396     }
1397 
1398     /**
1399     * Burns `tokenId`. See {ERC721-_burn}. The caller must own `tokenId` or be an approved operator.
1400     * @param tokenId The ID of the token to burn
1401    */
1402     function burn(uint256 tokenId) public virtual {
1403         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
1404 
1405         _burn(tokenId);
1406     }
1407 
1408     /**
1409     * Withdraw the balance from the contract
1410     */
1411     function withdraw() external payable onlyOwner returns (bool success) {
1412         (success,) = payable(__walletTreasury).call{value: address(this).balance}("");
1413     }
1414 }