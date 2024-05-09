1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.1;
8 
9 
10 
11 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Address
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         assembly {
41             size := extcodesize(account)
42         }
43         return size > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Context
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC165
249 
250 /**
251  * @dev Interface of the ERC165 standard, as defined in the
252  * https://eips.ethereum.org/EIPS/eip-165[EIP].
253  *
254  * Implementers can declare support of contract interfaces, which can then be
255  * queried by others ({ERC165Checker}).
256  *
257  * For an implementation, see {ERC165}.
258  */
259 interface IERC165 {
260     /**
261      * @dev Returns true if this contract implements the interface defined by
262      * `interfaceId`. See the corresponding
263      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
264      * to learn more about how these ids are created.
265      *
266      * This function call must use less than 30 000 gas.
267      */
268     function supportsInterface(bytes4 interfaceId) external view returns (bool);
269 }
270 
271 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC721Receiver
272 
273 /**
274  * @title ERC721 token receiver interface
275  * @dev Interface for any contract that wants to support safeTransfers
276  * from ERC721 asset contracts.
277  */
278 interface IERC721Receiver {
279     /**
280      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
281      * by `operator` from `from`, this function is called.
282      *
283      * It must return its Solidity selector to confirm the token transfer.
284      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
285      *
286      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
287      */
288     function onERC721Received(
289         address operator,
290         address from,
291         uint256 tokenId,
292         bytes calldata data
293     ) external returns (bytes4);
294 }
295 
296 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Strings
297 
298 /**
299  * @dev String operations.
300  */
301 library Strings {
302     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
303 
304     /**
305      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
306      */
307     function toString(uint256 value) internal pure returns (string memory) {
308         // Inspired by OraclizeAPI's implementation - MIT licence
309         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
310 
311         if (value == 0) {
312             return "0";
313         }
314         uint256 temp = value;
315         uint256 digits;
316         while (temp != 0) {
317             digits++;
318             temp /= 10;
319         }
320         bytes memory buffer = new bytes(digits);
321         while (value != 0) {
322             digits -= 1;
323             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
324             value /= 10;
325         }
326         return string(buffer);
327     }
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
331      */
332     function toHexString(uint256 value) internal pure returns (string memory) {
333         if (value == 0) {
334             return "0x00";
335         }
336         uint256 temp = value;
337         uint256 length = 0;
338         while (temp != 0) {
339             length++;
340             temp >>= 8;
341         }
342         return toHexString(value, length);
343     }
344 
345     /**
346      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
347      */
348     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
349         bytes memory buffer = new bytes(2 * length + 2);
350         buffer[0] = "0";
351         buffer[1] = "x";
352         for (uint256 i = 2 * length + 1; i > 1; --i) {
353             buffer[i] = _HEX_SYMBOLS[value & 0xf];
354             value >>= 4;
355         }
356         require(value == 0, "Strings: hex length insufficient");
357         return string(buffer);
358     }
359 }
360 
361 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/ERC165
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC721
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Ownable
526 
527 /**
528  * @dev Contract module which provides a basic access control mechanism, where
529  * there is an account (an owner) that can be granted exclusive access to
530  * specific functions.
531  *
532  * By default, the owner account will be the one that deploys the contract. This
533  * can later be changed with {transferOwnership}.
534  *
535  * This module is used through inheritance. It will make available the modifier
536  * `onlyOwner`, which can be applied to your functions to restrict their use to
537  * the owner.
538  */
539 abstract contract Ownable is Context {
540     address private _owner;
541 
542     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
543 
544     /**
545      * @dev Initializes the contract setting the deployer as the initial owner.
546      */
547     constructor() {
548         _transferOwnership(_msgSender());
549     }
550 
551     /**
552      * @dev Returns the address of the current owner.
553      */
554     function owner() public view virtual returns (address) {
555         return _owner;
556     }
557 
558     /**
559      * @dev Throws if called by any account other than the owner.
560      */
561     modifier onlyOwner() {
562         require(owner() == _msgSender(), "Ownable: caller is not the owner");
563         _;
564     }
565 
566     /**
567      * @dev Leaves the contract without owner. It will not be possible to call
568      * `onlyOwner` functions anymore. Can only be called by the current owner.
569      *
570      * NOTE: Renouncing ownership will leave the contract without an owner,
571      * thereby removing any functionality that is only available to the owner.
572      */
573     function renounceOwnership() public virtual onlyOwner {
574         _transferOwnership(address(0));
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Can only be called by the current owner.
580      */
581     function transferOwnership(address newOwner) public virtual onlyOwner {
582         require(newOwner != address(0), "Ownable: new owner is the zero address");
583         _transferOwnership(newOwner);
584     }
585 
586     /**
587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
588      * Internal function without access restriction.
589      */
590     function _transferOwnership(address newOwner) internal virtual {
591         address oldOwner = _owner;
592         _owner = newOwner;
593         emit OwnershipTransferred(oldOwner, newOwner);
594     }
595 }
596 
597 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Pausable
598 
599 /**
600  * @dev Contract module which allows children to implement an emergency stop
601  * mechanism that can be triggered by an authorized account.
602  *
603  * This module is used through inheritance. It will make available the
604  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
605  * the functions of your contract. Note that they will not be pausable by
606  * simply including this module, only once the modifiers are put in place.
607  */
608 abstract contract Pausable is Context {
609     /**
610      * @dev Emitted when the pause is triggered by `account`.
611      */
612     event Paused(address account);
613 
614     /**
615      * @dev Emitted when the pause is lifted by `account`.
616      */
617     event Unpaused(address account);
618 
619     bool private _paused;
620 
621     /**
622      * @dev Initializes the contract in unpaused state.
623      */
624     constructor() {
625         _paused = false;
626     }
627 
628     /**
629      * @dev Returns true if the contract is paused, and false otherwise.
630      */
631     function paused() public view virtual returns (bool) {
632         return _paused;
633     }
634 
635     /**
636      * @dev Modifier to make a function callable only when the contract is not paused.
637      *
638      * Requirements:
639      *
640      * - The contract must not be paused.
641      */
642     modifier whenNotPaused() {
643         require(!paused(), "Pausable: paused");
644         _;
645     }
646 
647     /**
648      * @dev Modifier to make a function callable only when the contract is paused.
649      *
650      * Requirements:
651      *
652      * - The contract must be paused.
653      */
654     modifier whenPaused() {
655         require(paused(), "Pausable: not paused");
656         _;
657     }
658 
659     /**
660      * @dev Triggers stopped state.
661      *
662      * Requirements:
663      *
664      * - The contract must not be paused.
665      */
666     function _pause() internal virtual whenNotPaused {
667         _paused = true;
668         emit Paused(_msgSender());
669     }
670 
671     /**
672      * @dev Returns to normal state.
673      *
674      * Requirements:
675      *
676      * - The contract must be paused.
677      */
678     function _unpause() internal virtual whenPaused {
679         _paused = false;
680         emit Unpaused(_msgSender());
681     }
682 }
683 
684 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC721Enumerable
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Enumerable is IERC721 {
691     /**
692      * @dev Returns the total amount of tokens stored by the contract.
693      */
694     function totalSupply() external view returns (uint256);
695 
696     /**
697      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
698      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
699      */
700     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
701 
702     /**
703      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
704      * Use along with {totalSupply} to enumerate all tokens.
705      */
706     function tokenByIndex(uint256 index) external view returns (uint256);
707 }
708 
709 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC721Metadata
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Metadata is IERC721 {
716     /**
717      * @dev Returns the token collection name.
718      */
719     function name() external view returns (string memory);
720 
721     /**
722      * @dev Returns the token collection symbol.
723      */
724     function symbol() external view returns (string memory);
725 
726     /**
727      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
728      */
729     function tokenURI(uint256 tokenId) external view returns (string memory);
730 }
731 
732 // Part: ERC721A
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
739  *
740  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
741  *
742  * Does not support burning tokens to address(0).
743  */
744 contract ERC721A is
745   Context,
746   ERC165,
747   IERC721,
748   IERC721Metadata,
749   IERC721Enumerable
750 {
751   using Address for address;
752   using Strings for uint256;
753 
754   struct TokenOwnership {
755     address addr;
756     uint64 startTimestamp;
757   }
758 
759   struct AddressData {
760     uint128 balance;
761     uint128 numberMinted;
762   }
763 
764   uint256 private currentIndex = 0;
765 
766   uint256 internal immutable collectionSize;
767   uint256 internal immutable maxBatchSize;
768 
769   // Token name
770   string private _name;
771 
772   // Token symbol
773   string private _symbol;
774 
775   // Mapping from token ID to ownership details
776   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
777   mapping(uint256 => TokenOwnership) private _ownerships;
778 
779   // Mapping owner address to address data
780   mapping(address => AddressData) private _addressData;
781 
782   // Mapping from token ID to approved address
783   mapping(uint256 => address) private _tokenApprovals;
784 
785   // Mapping from owner to operator approvals
786   mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788   /**
789    * @dev
790    * `maxBatchSize` refers to how much a minter can mint at a time.
791    * `collectionSize_` refers to how many tokens are in the collection.
792    */
793   constructor(
794     string memory name_,
795     string memory symbol_,
796     uint256 maxBatchSize_,
797     uint256 collectionSize_
798   ) {
799     require(
800       collectionSize_ > 0,
801       "ERC721A: collection must have a nonzero supply"
802     );
803     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
804     _name = name_;
805     _symbol = symbol_;
806     maxBatchSize = maxBatchSize_;
807     collectionSize = collectionSize_;
808   }
809 
810   /**
811    * @dev See {IERC721Enumerable-totalSupply}.
812    */
813   function totalSupply() public view override returns (uint256) {
814     return currentIndex;
815   }
816 
817   /**
818    * @dev See {IERC721Enumerable-tokenByIndex}.
819    */
820   function tokenByIndex(uint256 index) public view override returns (uint256) {
821     require(index < totalSupply(), "ERC721A: global index out of bounds");
822     return index;
823   }
824 
825   /**
826    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
827    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
828    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
829    */
830   function tokenOfOwnerByIndex(address owner, uint256 index)
831     public
832     view
833     override
834     returns (uint256)
835   {
836     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
837     uint256 numMintedSoFar = totalSupply();
838     uint256 tokenIdsIdx = 0;
839     address currOwnershipAddr = address(0);
840     for (uint256 i = 0; i < numMintedSoFar; i++) {
841       TokenOwnership memory ownership = _ownerships[i];
842       if (ownership.addr != address(0)) {
843         currOwnershipAddr = ownership.addr;
844       }
845       if (currOwnershipAddr == owner) {
846         if (tokenIdsIdx == index) {
847           return i;
848         }
849         tokenIdsIdx++;
850       }
851     }
852     revert("ERC721A: unable to get token of owner by index");
853   }
854 
855   /**
856    * @dev See {IERC165-supportsInterface}.
857    */
858   function supportsInterface(bytes4 interfaceId)
859     public
860     view
861     virtual
862     override(ERC165, IERC165)
863     returns (bool)
864   {
865     return
866       interfaceId == type(IERC721).interfaceId ||
867       interfaceId == type(IERC721Metadata).interfaceId ||
868       interfaceId == type(IERC721Enumerable).interfaceId ||
869       super.supportsInterface(interfaceId);
870   }
871 
872   /**
873    * @dev See {IERC721-balanceOf}.
874    */
875   function balanceOf(address owner) public view override returns (uint256) {
876     require(owner != address(0), "ERC721A: balance query for the zero address");
877     return uint256(_addressData[owner].balance);
878   }
879 
880   function _numberMinted(address owner) internal view returns (uint256) {
881     require(
882       owner != address(0),
883       "ERC721A: number minted query for the zero address"
884     );
885     return uint256(_addressData[owner].numberMinted);
886   }
887 
888   function ownershipOf(uint256 tokenId)
889     internal
890     view
891     returns (TokenOwnership memory)
892   {
893     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
894 
895     uint256 lowestTokenToCheck;
896     if (tokenId >= maxBatchSize) {
897       lowestTokenToCheck = tokenId - maxBatchSize + 1;
898     }
899 
900     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
901       TokenOwnership memory ownership = _ownerships[curr];
902       if (ownership.addr != address(0)) {
903         return ownership;
904       }
905     }
906 
907     revert("ERC721A: unable to determine the owner of token");
908   }
909 
910   /**
911    * @dev See {IERC721-ownerOf}.
912    */
913   function ownerOf(uint256 tokenId) public view override returns (address) {
914     return ownershipOf(tokenId).addr;
915   }
916 
917   /**
918    * @dev See {IERC721Metadata-name}.
919    */
920   function name() public view virtual override returns (string memory) {
921     return _name;
922   }
923 
924   /**
925    * @dev See {IERC721Metadata-symbol}.
926    */
927   function symbol() public view virtual override returns (string memory) {
928     return _symbol;
929   }
930 
931   /**
932    * @dev See {IERC721Metadata-tokenURI}.
933    */
934   function tokenURI(uint256 tokenId)
935     public
936     view
937     virtual
938     override
939     returns (string memory)
940   {
941     require(
942       _exists(tokenId),
943       "ERC721Metadata: URI query for nonexistent token"
944     );
945 
946     string memory baseURI = _baseURI();
947     return
948       bytes(baseURI).length > 0
949         ? string(abi.encodePacked(baseURI, tokenId.toString()))
950         : "";
951   }
952 
953   /**
954    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
955    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
956    * by default, can be overriden in child contracts.
957    */
958   function _baseURI() internal view virtual returns (string memory) {
959     return "";
960   }
961 
962   /**
963    * @dev See {IERC721-approve}.
964    */
965   function approve(address to, uint256 tokenId) public override {
966     address owner = ERC721A.ownerOf(tokenId);
967     require(to != owner, "ERC721A: approval to current owner");
968 
969     require(
970       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
971       "ERC721A: approve caller is not owner nor approved for all"
972     );
973 
974     _approve(to, tokenId, owner);
975   }
976 
977   /**
978    * @dev See {IERC721-getApproved}.
979    */
980   function getApproved(uint256 tokenId) public view override returns (address) {
981     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
982 
983     return _tokenApprovals[tokenId];
984   }
985 
986   /**
987    * @dev See {IERC721-setApprovalForAll}.
988    */
989   function setApprovalForAll(address operator, bool approved) public override {
990     require(operator != _msgSender(), "ERC721A: approve to caller");
991 
992     _operatorApprovals[_msgSender()][operator] = approved;
993     emit ApprovalForAll(_msgSender(), operator, approved);
994   }
995 
996   /**
997    * @dev See {IERC721-isApprovedForAll}.
998    */
999   function isApprovedForAll(address owner, address operator)
1000     public
1001     view
1002     virtual
1003     override
1004     returns (bool)
1005   {
1006     return _operatorApprovals[owner][operator];
1007   }
1008 
1009   /**
1010    * @dev See {IERC721-transferFrom}.
1011    */
1012   function transferFrom(
1013     address from,
1014     address to,
1015     uint256 tokenId
1016   ) public override {
1017     _transfer(from, to, tokenId);
1018   }
1019 
1020   /**
1021    * @dev See {IERC721-safeTransferFrom}.
1022    */
1023   function safeTransferFrom(
1024     address from,
1025     address to,
1026     uint256 tokenId
1027   ) public override {
1028     safeTransferFrom(from, to, tokenId, "");
1029   }
1030 
1031   /**
1032    * @dev See {IERC721-safeTransferFrom}.
1033    */
1034   function safeTransferFrom(
1035     address from,
1036     address to,
1037     uint256 tokenId,
1038     bytes memory _data
1039   ) public override {
1040     _transfer(from, to, tokenId);
1041     require(
1042       _checkOnERC721Received(from, to, tokenId, _data),
1043       "ERC721A: transfer to non ERC721Receiver implementer"
1044     );
1045   }
1046 
1047   /**
1048    * @dev Returns whether `tokenId` exists.
1049    *
1050    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051    *
1052    * Tokens start existing when they are minted (`_mint`),
1053    */
1054   function _exists(uint256 tokenId) internal view returns (bool) {
1055     return tokenId < currentIndex;
1056   }
1057 
1058   function _safeMint(address to, uint256 quantity) internal {
1059     _safeMint(to, quantity, "");
1060   }
1061 
1062   /**
1063    * @dev Mints `quantity` tokens and transfers them to `to`.
1064    *
1065    * Requirements:
1066    *
1067    * - there must be `quantity` tokens remaining unminted in the total collection.
1068    * - `to` cannot be the zero address.
1069    * - `quantity` cannot be larger than the max batch size.
1070    *
1071    * Emits a {Transfer} event.
1072    */
1073   function _safeMint(
1074     address to,
1075     uint256 quantity,
1076     bytes memory _data
1077   ) internal {
1078     uint256 startTokenId = currentIndex;
1079     require(to != address(0), "ERC721A: mint to the zero address");
1080     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1081     require(!_exists(startTokenId), "ERC721A: token already minted");
1082     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1083 
1084     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1085 
1086     AddressData memory addressData = _addressData[to];
1087     _addressData[to] = AddressData(
1088       addressData.balance + uint128(quantity),
1089       addressData.numberMinted + uint128(quantity)
1090     );
1091     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1092 
1093     uint256 updatedIndex = startTokenId;
1094 
1095     for (uint256 i = 0; i < quantity; i++) {
1096       emit Transfer(address(0), to, updatedIndex);
1097       require(
1098         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1099         "ERC721A: transfer to non ERC721Receiver implementer"
1100       );
1101       updatedIndex++;
1102     }
1103 
1104     currentIndex = updatedIndex;
1105     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106   }
1107 
1108   /**
1109    * @dev Transfers `tokenId` from `from` to `to`.
1110    *
1111    * Requirements:
1112    *
1113    * - `to` cannot be the zero address.
1114    * - `tokenId` token must be owned by `from`.
1115    *
1116    * Emits a {Transfer} event.
1117    */
1118   function _transfer(
1119     address from,
1120     address to,
1121     uint256 tokenId
1122   ) private {
1123     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1124 
1125     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1126       getApproved(tokenId) == _msgSender() ||
1127       isApprovedForAll(prevOwnership.addr, _msgSender()));
1128 
1129     require(
1130       isApprovedOrOwner,
1131       "ERC721A: transfer caller is not owner nor approved"
1132     );
1133 
1134     require(
1135       prevOwnership.addr == from,
1136       "ERC721A: transfer from incorrect owner"
1137     );
1138     require(to != address(0), "ERC721A: transfer to the zero address");
1139 
1140     _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142     // Clear approvals from the previous owner
1143     _approve(address(0), tokenId, prevOwnership.addr);
1144 
1145     _addressData[from].balance -= 1;
1146     _addressData[to].balance += 1;
1147     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1148 
1149     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1150     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1151     uint256 nextTokenId = tokenId + 1;
1152     if (_ownerships[nextTokenId].addr == address(0)) {
1153       if (_exists(nextTokenId)) {
1154         _ownerships[nextTokenId] = TokenOwnership(
1155           prevOwnership.addr,
1156           prevOwnership.startTimestamp
1157         );
1158       }
1159     }
1160 
1161     emit Transfer(from, to, tokenId);
1162     _afterTokenTransfers(from, to, tokenId, 1);
1163   }
1164 
1165   /**
1166    * @dev Approve `to` to operate on `tokenId`
1167    *
1168    * Emits a {Approval} event.
1169    */
1170   function _approve(
1171     address to,
1172     uint256 tokenId,
1173     address owner
1174   ) private {
1175     _tokenApprovals[tokenId] = to;
1176     emit Approval(owner, to, tokenId);
1177   }
1178 
1179   uint256 public nextOwnerToExplicitlySet = 0;
1180 
1181   /**
1182    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1183    */
1184   function _setOwnersExplicit(uint256 quantity) internal {
1185     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1186     require(quantity > 0, "quantity must be nonzero");
1187     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1188     if (endIndex > collectionSize - 1) {
1189       endIndex = collectionSize - 1;
1190     }
1191     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1192     require(_exists(endIndex), "not enough minted yet for this cleanup");
1193     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1194       if (_ownerships[i].addr == address(0)) {
1195         TokenOwnership memory ownership = ownershipOf(i);
1196         _ownerships[i] = TokenOwnership(
1197           ownership.addr,
1198           ownership.startTimestamp
1199         );
1200       }
1201     }
1202     nextOwnerToExplicitlySet = endIndex + 1;
1203   }
1204 
1205   /**
1206    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207    * The call is not executed if the target address is not a contract.
1208    *
1209    * @param from address representing the previous owner of the given token ID
1210    * @param to target address that will receive the tokens
1211    * @param tokenId uint256 ID of the token to be transferred
1212    * @param _data bytes optional data to send along with the call
1213    * @return bool whether the call correctly returned the expected magic value
1214    */
1215   function _checkOnERC721Received(
1216     address from,
1217     address to,
1218     uint256 tokenId,
1219     bytes memory _data
1220   ) private returns (bool) {
1221     if (to.isContract()) {
1222       try
1223         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1224       returns (bytes4 retval) {
1225         return retval == IERC721Receiver(to).onERC721Received.selector;
1226       } catch (bytes memory reason) {
1227         if (reason.length == 0) {
1228           revert("ERC721A: transfer to non ERC721Receiver implementer");
1229         } else {
1230           assembly {
1231             revert(add(32, reason), mload(reason))
1232           }
1233         }
1234       }
1235     } else {
1236       return true;
1237     }
1238   }
1239 
1240   /**
1241    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1242    *
1243    * startTokenId - the first token id to be transferred
1244    * quantity - the amount to be transferred
1245    *
1246    * Calling conditions:
1247    *
1248    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1249    * transferred to `to`.
1250    * - When `from` is zero, `tokenId` will be minted for `to`.
1251    */
1252   function _beforeTokenTransfers(
1253     address from,
1254     address to,
1255     uint256 startTokenId,
1256     uint256 quantity
1257   ) internal virtual {}
1258 
1259   /**
1260    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1261    * minting.
1262    *
1263    * startTokenId - the first token id to be transferred
1264    * quantity - the amount to be transferred
1265    *
1266    * Calling conditions:
1267    *
1268    * - when `from` and `to` are both non-zero.
1269    * - `from` and `to` are never both zero.
1270    */
1271   function _afterTokenTransfers(
1272     address from,
1273     address to,
1274     uint256 startTokenId,
1275     uint256 quantity
1276   ) internal virtual {}
1277 }
1278 
1279 // File: BoomGala.sol
1280 
1281 contract BoomGala is ERC721A, Ownable, Pausable {
1282     using Address for address;
1283 
1284     // metadata URI
1285     string private _baseTokenURI;
1286 
1287     // partner address
1288     address private _partner = 0x9B645675E8D64759E5c36E30Dcb766d8CEC3d34F;
1289 
1290     // max partner allowed mint number
1291     uint private _maxPartnerAllowed = 100;
1292 
1293     struct SaleConfig {
1294         bool wlSaleStarted; // whitelist sale started?
1295         bool publicSaleStarted; // public sale started?
1296         uint wlPrice; // whitelist sale price
1297         uint wlMaxAmount; // whitelist sale max mint amount
1298         uint publicPrice; // public sale price
1299         uint publicMaxAmount; // public sale max mint amount
1300         uint reservedAmount; // reserve amount for marketing and give away purpose
1301     }
1302 
1303     SaleConfig public saleConfig;
1304 
1305     mapping(address => bool) public allowList; // whitelist
1306 
1307     constructor(
1308         uint256 maxBatchSize_,
1309         uint256 collectionSize_,
1310         string memory baseURI_) ERC721A("BoomGala","GALA", maxBatchSize_, collectionSize_)  {
1311         setupSaleConfig(false, false, 0.2 ether, 2, 0.4 ether, 3, 200);
1312         setBaseURI(baseURI_);
1313     }
1314 
1315     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1316         uint256 tokenCount = balanceOf(_owner);
1317         if (tokenCount == 0) {
1318             // Return an empty array
1319             return new uint256[](0);
1320         } else {
1321             uint256[] memory result = new uint256[](tokenCount);
1322             uint256 index;
1323             for (index = 0; index < tokenCount; index++) {
1324                 result[index] = tokenOfOwnerByIndex(_owner, index);
1325             }
1326             return result;
1327         }
1328     }
1329 
1330     function mintToPartner(uint256 quantity) public whenNotPaused payable  {
1331         SaleConfig memory config = saleConfig;
1332 
1333         bool _publicSaleStarted = config.publicSaleStarted;
1334         bool _wlSaleStarted = config.wlSaleStarted;
1335 
1336         // the whitelist sale must be started
1337         require (
1338             _publicSaleStarted == false && _wlSaleStarted == true,
1339             "Whitelist Sale is not started yet!"
1340         );
1341 
1342         // cant exceed wallet mint limits
1343         require(
1344             numberMinted(_partner) <= _maxPartnerAllowed,
1345             "can not mint this many"
1346         );
1347 
1348         // cant exceed max supply
1349         require(totalSupply() + quantity <= collectionSize, "reached max supply");
1350 
1351         // the fund must be sufficient
1352         uint _wlPrice = config.wlPrice;
1353         require (
1354             msg.value >= _wlPrice * quantity,
1355             "Fund is not sufficient!"
1356         );
1357 
1358         _safeMint(_partner, quantity);
1359     }
1360 
1361     function wlSaleMint(uint256 quantity) public whenNotPaused payable  {
1362         SaleConfig memory config = saleConfig;
1363 
1364         bool _publicSaleStarted = config.publicSaleStarted;
1365         bool _wlSaleStarted = config.wlSaleStarted;
1366 
1367         // the public sale must be started
1368         require (
1369             _publicSaleStarted == false && _wlSaleStarted == true,
1370             "Whitelist Sale is not started yet!"
1371         );
1372 
1373         // Address must be whitelisted.
1374         require(allowList[msg.sender], "You are not whitelisted!");
1375 
1376         // cant exceed wl mint limits
1377         uint _wlMaxAmount = config.wlMaxAmount;
1378         require(
1379             quantity <= _wlMaxAmount,
1380             "can not mint this many"
1381         );
1382 
1383         // cant exceed wallet mint limits
1384         require(
1385             numberMinted(msg.sender) + quantity <= _wlMaxAmount,
1386             "can not mint this many"
1387         );
1388 
1389         // cant exceed max supply
1390         require(totalSupply() + quantity <= collectionSize, "reached max supply");
1391 
1392         // the fund must be sufficient
1393         uint _wlPrice = config.wlPrice;
1394         require (
1395             msg.value >= _wlPrice * quantity,
1396             "Fund is not sufficient!"
1397         );
1398 
1399         _safeMint(msg.sender, quantity);
1400     }
1401 
1402     function publicSaleMint(uint256 quantity) public whenNotPaused payable {
1403         SaleConfig memory config = saleConfig;
1404 
1405         bool _publicSaleStarted = config.publicSaleStarted;
1406         bool _wlSaleStarted = config.wlSaleStarted;
1407 
1408         // must not mint from contract
1409         require (
1410             msg.sender == tx.origin && !msg.sender.isContract(), "Are you bot?"
1411         );
1412 
1413         // the public sale must be started
1414         require (
1415             _publicSaleStarted == true && _wlSaleStarted == false,
1416             "Public Sale is not started yet!"
1417         );
1418         // cant exceed public mint limits
1419         uint _wlMaxAmount = config.wlMaxAmount;
1420         uint _publicMaxAmount = config.publicMaxAmount;
1421         require(
1422             quantity <= _publicMaxAmount,
1423             "can not mint this many"
1424         );
1425         // cant exceed wallet mint limits
1426         require(
1427             numberMinted(msg.sender) + quantity <= _wlMaxAmount + _publicMaxAmount,
1428             "can not mint this many"
1429         );
1430         // cant exceed max supply
1431         require(totalSupply() + quantity <= collectionSize, "reached max supply");
1432 
1433         // the fund must be sufficient
1434         uint _publicPrice = config.publicPrice;
1435         require (
1436             msg.value >= _publicPrice * quantity,
1437             "Fund is not sufficient!"
1438         );
1439 
1440         _safeMint(msg.sender, quantity);
1441     }
1442 
1443     function whitelist(address[] memory users) external onlyOwner {
1444         for(uint i = 0; i < users.length; i++) {
1445           allowList[users[i]] = true;
1446         }
1447     }
1448 
1449     function withdrawAll() external onlyOwner {
1450         require(payable(msg.sender).send(address(this).balance));
1451     }
1452 
1453     /**
1454      * Reserve some GALAs for marketing and giveaway purpose.
1455      */
1456     function reserveGiveaway(uint256 quantity) external onlyOwner {
1457         SaleConfig memory config = saleConfig;
1458         bool _publicSaleStarted = config.publicSaleStarted;
1459         bool _wlSaleStarted = config.wlSaleStarted;
1460         uint _reserved = config.reservedAmount;
1461 
1462         // the sale must not be started
1463         require (
1464             _publicSaleStarted == false && _wlSaleStarted == false,
1465             "The Reserve phase should only happen before the sale started!"
1466         );
1467 
1468         require(totalSupply() + quantity <= _reserved, "Exceeded giveaway supply");
1469 
1470         _safeMint(msg.sender, quantity);
1471     }
1472 
1473     function numberMinted(address owner) public view returns (uint256) {
1474         return _numberMinted(owner);
1475     }
1476 
1477     function _baseURI() internal view virtual override returns (string memory) {
1478         return _baseTokenURI;
1479     }
1480 
1481     function setBaseURI(string memory baseURI) public onlyOwner {
1482         _baseTokenURI = baseURI;
1483     }
1484 
1485     function setupSaleConfig(bool _wlSaleStarted, bool _publicSaleStarted, uint _wlPrice,
1486     uint _wlMaxAmount, uint _publicPrice, uint _publicMaxAmount, uint _reservedAmount) internal onlyOwner {
1487         saleConfig = SaleConfig(
1488             _wlSaleStarted,
1489             _publicSaleStarted,
1490             _wlPrice,
1491             _wlMaxAmount,
1492             _publicPrice,
1493             _publicMaxAmount,
1494             _reservedAmount
1495         );
1496     }
1497 
1498     function setWlPrice(uint _newPrice) external onlyOwner {
1499         saleConfig.wlPrice = _newPrice;
1500     }
1501 
1502     function setWlMaxAmount(uint _newAmt) external onlyOwner {
1503         saleConfig.wlMaxAmount = _newAmt;
1504     }
1505 
1506     function setPublicPrice(uint _newPrice) external onlyOwner {
1507         saleConfig.publicPrice = _newPrice;
1508     }
1509 
1510     function setPublicMaxAmount(uint _newAmt) external onlyOwner {
1511         saleConfig.publicMaxAmount = _newAmt;
1512     }
1513 
1514     function setReservedAmount(uint _newAmount) external onlyOwner {
1515         saleConfig.reservedAmount = _newAmount;
1516     }
1517 
1518     function setPartnerAddr(address _partnerAddr) external onlyOwner {
1519         _partner = _partnerAddr;
1520     }
1521 
1522     function setMaxPartnerAllowed(uint _maxPartnerAllowed_) external onlyOwner {
1523         _maxPartnerAllowed = _maxPartnerAllowed_;
1524     }
1525 
1526     function startWLSale() external onlyOwner {
1527         saleConfig.wlSaleStarted = true;
1528         saleConfig.publicSaleStarted = false;
1529     }
1530 
1531     function startPublicSale() external onlyOwner {
1532         saleConfig.wlSaleStarted = false;
1533         saleConfig.publicSaleStarted = true;
1534     }
1535 
1536     function pause() external onlyOwner {
1537         _pause();
1538     }
1539 
1540     function unpause() external onlyOwner {
1541         _unpause();
1542     }
1543 }