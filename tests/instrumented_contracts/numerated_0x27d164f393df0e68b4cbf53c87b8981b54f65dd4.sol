1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-10
7 */
8 
9 //SPDX-License-Identifier:MIT
10 pragma solidity 0.8.0;
11 
12 
13 /**
14  * @title Counters
15  * @author Matt Condon (@shrugs)
16  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
17  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
18  *
19  * Include with `using Counters for Counters.Counter;`
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 library Counters {
33     struct Counter {
34         // This variable should never be directly accessed by users of the library: interactions must be restricted to
35         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
36         // this feature: see https://github.com/ethereum/solidity/issues/4637
37         uint256 _value; // default: 0
38     }
39 
40     function current(Counter storage counter) internal view returns (uint256) {
41         return counter._value;
42     }
43 
44     function increment(Counter storage counter) internal {
45         unchecked {
46             counter._value += 1;
47         }
48     }
49 
50     function decrement(Counter storage counter) internal {
51         uint256 value = counter._value;
52         require(value > 0, "Counter: decrement overflow");
53         unchecked {
54             counter._value = value - 1;
55         }
56     }
57 
58     function reset(Counter storage counter) internal {
59         counter._value = 0;
60     }
61 }
62 
63 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes calldata) {
70         return msg.data;
71     }
72 }
73 
74 
75 
76 
77 /**
78  * @dev Contract module which allows children to implement an emergency stop
79  * mechanism that can be triggered by an authorized account.
80  *
81  * This module is used through inheritance. It will make available the
82  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
83  * the functions of your contract. Note that they will not be pausable by
84  * simply including this module, only once the modifiers are put in place.
85  */
86 
87 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
88 
89 
90 
91 
92 
93 
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * By default, the owner account will be the one that deploys the contract. This
100  * can later be changed with {transferOwnership}.
101  *
102  * This module is used through inheritance. It will make available the modifier
103  * `onlyOwner`, which can be applied to your functions to restrict their use to
104  * the owner.
105  */
106 
107 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
108 
109 abstract contract Pausable is Context {
110     /**
111      * @dev Emitted when the pause is triggered by `account`.
112      */
113     event Paused(address account);
114 
115     /**
116      * @dev Emitted when the pause is lifted by `account`.
117      */
118     event Unpaused(address account);
119 
120     bool private _paused;
121 
122     /**
123      * @dev Initializes the contract in unpaused state.
124      */
125     constructor() {
126         _paused = false;
127     }
128 
129     /**
130      * @dev Returns true if the contract is paused, and false otherwise.
131      */
132     function paused() public view virtual returns (bool) {
133         return _paused;
134     }
135 
136     /**
137      * @dev Modifier to make a function callable only when the contract is not paused.
138      *
139      * Requirements:
140      *
141      * - The contract must not be paused.
142      */
143     modifier whenNotPaused() {
144         require(!paused(), "Pausable: paused");
145         _;
146     }
147 
148     /**
149      * @dev Modifier to make a function callable only when the contract is paused.
150      *
151      * Requirements:
152      *
153      * - The contract must be paused.
154      */
155     modifier whenPaused() {
156         require(paused(), "Pausable: not paused");
157         _;
158     }
159 
160     /**
161      * @dev Triggers stopped state.
162      *
163      * Requirements:
164      *
165      * - The contract must not be paused.
166      */
167     function _pause() internal virtual whenNotPaused {
168         _paused = true;
169         emit Paused(_msgSender());
170     }
171 
172     /**
173      * @dev Returns to normal state.
174      *
175      * Requirements:
176      *
177      * - The contract must be paused.
178      */
179     function _unpause() internal virtual whenPaused {
180         _paused = false;
181         emit Unpaused(_msgSender());
182     }
183 }
184 
185 
186 
187 /**
188  * @dev Implementation of the {IERC165} interface.
189  *
190  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
191  * for the additional interface id that will be supported. For example:
192  *
193  * ```solidity
194  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
195  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
196  * }
197  * ```
198  *
199  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
200  */
201 abstract contract ERC165 is IERC165 {
202     /**
203      * @dev See {IERC165-supportsInterface}.
204      */
205     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
206         return interfaceId == type(IERC165).interfaceId;
207     }
208 }
209 
210 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
211 
212 
213 
214 /**
215  * @dev String operations.
216  */
217 library Strings {
218     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
219 
220     /**
221      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
222      */
223     function toString(uint256 value) internal pure returns (string memory) {
224         // Inspired by OraclizeAPI's implementation - MIT licence
225         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
226 
227         if (value == 0) {
228             return "0";
229         }
230         uint256 temp = value;
231         uint256 digits;
232         while (temp != 0) {
233             digits++;
234             temp /= 10;
235         }
236         bytes memory buffer = new bytes(digits);
237         while (value != 0) {
238             digits -= 1;
239             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
240             value /= 10;
241         }
242         return string(buffer);
243     }
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
247      */
248     function toHexString(uint256 value) internal pure returns (string memory) {
249         if (value == 0) {
250             return "0x00";
251         }
252         uint256 temp = value;
253         uint256 length = 0;
254         while (temp != 0) {
255             length++;
256             temp >>= 8;
257         }
258         return toHexString(value, length);
259     }
260 
261     /**
262      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
263      */
264     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
265         bytes memory buffer = new bytes(2 * length + 2);
266         buffer[0] = "0";
267         buffer[1] = "x";
268         for (uint256 i = 2 * length + 1; i > 1; --i) {
269             buffer[i] = _HEX_SYMBOLS[value & 0xf];
270             value >>= 4;
271         }
272         require(value == 0, "Strings: hex length insufficient");
273         return string(buffer);
274     }
275 }
276 
277 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
278 
279 
280 /**
281  * @dev Provides information about the current execution context, including the
282  * sender of the transaction and its data. While these are generally available
283  * via msg.sender and msg.data, they should not be accessed in such a direct
284  * manner, since when dealing with meta-transactions the account sending and
285  * paying for execution may not be the actual sender (as far as an application
286  * is concerned).
287  *
288  * This contract is only required for intermediate, library-like contracts.
289  */
290 
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _setOwner(_msgSender());
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view virtual returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _setOwner(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _setOwner(newOwner);
336     }
337 
338     function _setOwner(address newOwner) private {
339         address oldOwner = _owner;
340         _owner = newOwner;
341         emit OwnershipTransferred(oldOwner, newOwner);
342     }
343 }
344 
345 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
346 
347 
348 
349 
350 /**
351  * @dev Collection of functions related to the address type
352  */
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * [IMPORTANT]
358      * ====
359      * It is unsafe to assume that an address for which this function returns
360      * false is an externally-owned account (EOA) and not a contract.
361      *
362      * Among others, `isContract` will return false for the following
363      * types of addresses:
364      *
365      *  - an externally-owned account
366      *  - a contract in construction
367      *  - an address where a contract will be created
368      *  - an address where a contract lived, but was destroyed
369      * ====
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies on extcodesize, which returns 0 for contracts in
373         // construction, since the code is only stored at the end of the
374         // constructor execution.
375 
376         uint256 size;
377         assembly {
378             size := extcodesize(account)
379         }
380         return size > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         (bool success, ) = recipient.call{value: amount}("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain `call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionCall(target, data, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but also transferring `value` wei to `target`.
445      *
446      * Requirements:
447      *
448      * - the calling contract must have an ETH balance of at least `value`.
449      * - the called Solidity function must be `payable`.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(address(this).balance >= value, "Address: insufficient balance for call");
474         require(isContract(target), "Address: call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.call{value: value}(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
487         return functionStaticCall(target, data, "Address: low-level static call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal view returns (bytes memory) {
501         require(isContract(target), "Address: static call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.staticcall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(isContract(target), "Address: delegate call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
536      * revert reason using the provided one.
537      *
538      * _Available since v4.3._
539      */
540     function verifyCallResult(
541         bool success,
542         bytes memory returndata,
543         string memory errorMessage
544     ) internal pure returns (bytes memory) {
545         if (success) {
546             return returndata;
547         } else {
548             // Look for revert reason and bubble it up if present
549             if (returndata.length > 0) {
550                 // The easiest way to bubble the revert reason is using memory via assembly
551 
552                 assembly {
553                     let returndata_size := mload(returndata)
554                     revert(add(32, returndata), returndata_size)
555                 }
556             } else {
557                 revert(errorMessage);
558             }
559         }
560     }
561 }
562 
563 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
564 
565 
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
570  * @dev See https://eips.ethereum.org/EIPS/eip-721
571  */
572 
573 
574 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
575 
576 
577 
578 /**
579  * @title ERC721 token receiver interface
580  * @dev Interface for any contract that wants to support safeTransfers
581  * from ERC721 asset contracts.
582  */
583 interface IERC721Receiver {
584     /**
585      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
586      * by `operator` from `from`, this function is called.
587      *
588      * It must return its Solidity selector to confirm the token transfer.
589      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
590      *
591      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
592      */
593     function onERC721Received(
594         address operator,
595         address from,
596         uint256 tokenId,
597         bytes calldata data
598     ) external returns (bytes4);
599 }
600 
601 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
602 
603 
604 
605 /**
606  * @dev Interface of the ERC165 standard, as defined in the
607  * https://eips.ethereum.org/EIPS/eip-165[EIP].
608  *
609  * Implementers can declare support of contract interfaces, which can then be
610  * queried by others ({ERC165Checker}).
611  *
612  * For an implementation, see {ERC165}.
613  */
614 
615 
616 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
617 
618 
619 
620 
621 /**
622  * @dev Required interface of an ERC721 compliant contract.
623  */
624 interface IERC721 is IERC165 {
625     /**
626      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
627      */
628     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
629 
630     /**
631      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
632      */
633     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
637      */
638     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
639 
640     /**
641      * @dev Returns the number of tokens in ``owner``'s account.
642      */
643     function balanceOf(address owner) external view returns (uint256 balance);
644 
645     /**
646      * @dev Returns the owner of the `tokenId` token.
647      *
648      * Requirements:
649      *
650      * - `tokenId` must exist.
651      */
652     function ownerOf(uint256 tokenId) external view returns (address owner);
653 
654     /**
655      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
656      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Transfers `tokenId` token from `from` to `to`.
676      *
677      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      *
686      * Emits a {Transfer} event.
687      */
688     function transferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) external;
693 
694     /**
695      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
696      * The approval is cleared when the token is transferred.
697      *
698      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
699      *
700      * Requirements:
701      *
702      * - The caller must own the token or be an approved operator.
703      * - `tokenId` must exist.
704      *
705      * Emits an {Approval} event.
706      */
707     function approve(address to, uint256 tokenId) external;
708 
709     /**
710      * @dev Returns the account approved for `tokenId` token.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function getApproved(uint256 tokenId) external view returns (address operator);
717 
718     /**
719      * @dev Approve or remove `operator` as an operator for the caller.
720      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
721      *
722      * Requirements:
723      *
724      * - The `operator` cannot be the caller.
725      *
726      * Emits an {ApprovalForAll} event.
727      */
728     function setApprovalForAll(address operator, bool _approved) external;
729 
730     /**
731      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
732      *
733      * See {setApprovalForAll}
734      */
735     function isApprovedForAll(address owner, address operator) external view returns (bool);
736 
737     /**
738      * @dev Safely transfers `tokenId` token from `from` to `to`.
739      *
740      * Requirements:
741      *
742      * - `from` cannot be the zero address.
743      * - `to` cannot be the zero address.
744      * - `tokenId` token must exist and be owned by `from`.
745      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes calldata data
755     ) external;
756 }
757 
758 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
759 
760 
761 
762 
763 
764 
765 
766 
767 
768 
769 /**
770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
771  * the Metadata extension, but not including the Enumerable extension, which is available separately as
772  * {ERC721Enumerable}.
773  */
774 
775 // File: Set.sol
776 
777 interface IERC721Metadata is IERC721 {
778     /**
779      * @dev Returns the token collection name.
780      */
781     function name() external view returns (string memory);
782 
783     /**
784      * @dev Returns the token collection symbol.
785      */
786     function symbol() external view returns (string memory);
787 
788     /**
789      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
790      */
791     function tokenURI(uint256 tokenId) external view returns (string memory);
792 }
793 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
794     using Address for address;
795     using Strings for uint256;
796 
797     // Token name
798     string private _name;
799 
800     // Token symbol
801     string private _symbol;
802 
803     // Mapping from token ID to owner address
804     mapping(uint256 => address) private _owners;
805 
806     // Mapping owner address to token count
807     mapping(address => uint256) private _balances;
808 
809     // Mapping from token ID to approved address
810     mapping(uint256 => address) private _tokenApprovals;
811 
812     // Mapping from owner to operator approvals
813     mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815     /**
816      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
817      */
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      */
826     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
827         return
828             interfaceId == type(IERC721).interfaceId ||
829             interfaceId == type(IERC721Metadata).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view virtual override returns (uint256) {
837         require(owner != address(0), "ERC721: balance query for the zero address");
838         return _balances[owner];
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
845         address owner = _owners[tokenId];
846         require(owner != address(0), "ERC721: owner query for nonexistent token");
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return "";
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public virtual override {
887         address owner = ERC721.ownerOf(tokenId);
888         require(to != owner, "ERC721: approval to current owner");
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             "ERC721: approve caller is not owner nor approved for all"
893         );
894 
895         _approve(to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view virtual override returns (address) {
902         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public virtual override {
911         require(operator != _msgSender(), "ERC721: approve to caller");
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         //solhint-disable-next-line max-line-length
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
934 
935         _transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, "");
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
959         _safeTransfer(from, to, tokenId, _data);
960     }
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
964      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
965      *
966      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
967      *
968      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
969      * implement alternative mechanisms to perform token transfer, such as signature-based.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must exist and be owned by `from`.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeTransfer(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) internal virtual {
986         _transfer(from, to, tokenId);
987         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      * and stop existing when they are burned (`_burn`).
997      */
998     function _exists(uint256 tokenId) internal view virtual returns (bool) {
999         return _owners[tokenId] != address(0);
1000     }
1001 
1002     /**
1003      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1010         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1011         address owner = ERC721.ownerOf(tokenId);
1012         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1013     }
1014 
1015     /**
1016      * @dev Safely mints `tokenId` and transfers it to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(address to, uint256 tokenId) internal virtual {
1026         _safeMint(to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1031      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _mint(to, tokenId);
1039         require(
1040             _checkOnERC721Received(address(0), to, tokenId, _data),
1041             "ERC721: transfer to non ERC721Receiver implementer"
1042         );
1043     }
1044 
1045     /**
1046      * @dev Mints `tokenId` and transfers it to `to`.
1047      *
1048      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must not exist.
1053      * - `to` cannot be the zero address.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 tokenId) internal virtual {
1058         require(to != address(0), "ERC721: mint to the zero address");
1059         require(!_exists(tokenId), "ERC721: token already minted");
1060 
1061         _beforeTokenTransfer(address(0), to, tokenId);
1062 
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(address(0), to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId) internal virtual {
1080         address owner = ERC721.ownerOf(tokenId);
1081 
1082         _beforeTokenTransfer(owner, address(0), tokenId);
1083 
1084         // Clear approvals
1085         _approve(address(0), tokenId);
1086 
1087         _balances[owner] -= 1;
1088         delete _owners[tokenId];
1089 
1090         emit Transfer(owner, address(0), tokenId);
1091     }
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
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
1108     ) internal virtual {
1109         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1110         require(to != address(0), "ERC721: transfer to the zero address");
1111 
1112         _beforeTokenTransfer(from, to, tokenId);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId);
1116 
1117         _balances[from] -= 1;
1118         _balances[to] += 1;
1119         _owners[tokenId] = to;
1120 
1121         emit Transfer(from, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev Approve `to` to operate on `tokenId`
1126      *
1127      * Emits a {Approval} event.
1128      */
1129     function _approve(address to, uint256 tokenId) internal virtual {
1130         _tokenApprovals[tokenId] = to;
1131         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1132     }
1133 
1134     /**
1135      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1136      * The call is not executed if the target address is not a contract.
1137      *
1138      * @param from address representing the previous owner of the given token ID
1139      * @param to target address that will receive the tokens
1140      * @param tokenId uint256 ID of the token to be transferred
1141      * @param _data bytes optional data to send along with the call
1142      * @return bool whether the call correctly returned the expected magic value
1143      */
1144     function _checkOnERC721Received(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) private returns (bool) {
1150         if (to.isContract()) {
1151             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1152                 return retval == IERC721Receiver.onERC721Received.selector;
1153             } catch (bytes memory reason) {
1154                 if (reason.length == 0) {
1155                     revert("ERC721: transfer to non ERC721Receiver implementer");
1156                 } else {
1157                     assembly {
1158                         revert(add(32, reason), mload(reason))
1159                     }
1160                 }
1161             }
1162         } else {
1163             return true;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before any token transfer. This includes minting
1169      * and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1177      * - `from` and `to` are never both zero.
1178      *
1179      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1180      */
1181     function _beforeTokenTransfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) internal virtual {}
1186 }
1187 
1188 
1189 /**
1190  * @dev External interface of AccessControl declared to support ERC165 detection.
1191  */
1192 interface IERC721Enumerable is IERC721 {
1193     /**
1194      * @dev Returns the total amount of tokens stored by the contract.
1195      */
1196     function totalSupply() external view returns (uint256);
1197 
1198     /**
1199      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1200      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1201      */
1202     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1203 
1204     /**
1205      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1206      * Use along with {totalSupply} to enumerate all tokens.
1207      */
1208     function tokenByIndex(uint256 index) external view returns (uint256);
1209 }
1210 
1211 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1212     // Mapping from owner to list of owned token IDs
1213     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1214 
1215     // Mapping from token ID to index of the owner tokens list
1216     mapping(uint256 => uint256) private _ownedTokensIndex;
1217 
1218     // Array with all token ids, used for enumeration
1219     uint256[] private _allTokens;
1220 
1221     // Mapping from token id to position in the allTokens array
1222     mapping(uint256 => uint256) private _allTokensIndex;
1223 
1224     /**
1225      * @dev See {IERC165-supportsInterface}.
1226      */
1227     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1228         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1233      */
1234     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1235         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1236         return _ownedTokens[owner][index];
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Enumerable-totalSupply}.
1241      */
1242     function totalSupply() public view virtual override returns (uint256) {
1243         return _allTokens.length;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Enumerable-tokenByIndex}.
1248      */
1249     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1250         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1251         return _allTokens[index];
1252     }
1253 
1254     /**
1255      * @dev Hook that is called before any token transfer. This includes minting
1256      * and burning.
1257      *
1258      * Calling conditions:
1259      *
1260      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1261      * transferred to `to`.
1262      * - When `from` is zero, `tokenId` will be minted for `to`.
1263      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1264      * - `from` cannot be the zero address.
1265      * - `to` cannot be the zero address.
1266      *
1267      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1268      */
1269     function _beforeTokenTransfer(
1270         address from,
1271         address to,
1272         uint256 tokenId
1273     ) internal virtual override {
1274         super._beforeTokenTransfer(from, to, tokenId);
1275 
1276         if (from == address(0)) {
1277             _addTokenToAllTokensEnumeration(tokenId);
1278         } else if (from != to) {
1279             _removeTokenFromOwnerEnumeration(from, tokenId);
1280         }
1281         if (to == address(0)) {
1282             _removeTokenFromAllTokensEnumeration(tokenId);
1283         } else if (to != from) {
1284             _addTokenToOwnerEnumeration(to, tokenId);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1290      * @param to address representing the new owner of the given token ID
1291      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1292      */
1293     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1294         uint256 length = ERC721.balanceOf(to);
1295         _ownedTokens[to][length] = tokenId;
1296         _ownedTokensIndex[tokenId] = length;
1297     }
1298 
1299     /**
1300      * @dev Private function to add a token to this extension's token tracking data structures.
1301      * @param tokenId uint256 ID of the token to be added to the tokens list
1302      */
1303     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1304         _allTokensIndex[tokenId] = _allTokens.length;
1305         _allTokens.push(tokenId);
1306     }
1307 
1308     /**
1309      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1310      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1311      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1312      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1313      * @param from address representing the previous owner of the given token ID
1314      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1315      */
1316     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1317         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1318         // then delete the last slot (swap and pop).
1319 
1320         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1321         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1322 
1323         // When the token to delete is the last token, the swap operation is unnecessary
1324         if (tokenIndex != lastTokenIndex) {
1325             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1326 
1327             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1328             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1329         }
1330 
1331         // This also deletes the contents at the last position of the array
1332         delete _ownedTokensIndex[tokenId];
1333         delete _ownedTokens[from][lastTokenIndex];
1334     }
1335 
1336     /**
1337      * @dev Private function to remove a token from this extension's token tracking data structures.
1338      * This has O(1) time complexity, but alters the order of the _allTokens array.
1339      * @param tokenId uint256 ID of the token to be removed from the tokens list
1340      */
1341     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1342         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1343         // then delete the last slot (swap and pop).
1344 
1345         uint256 lastTokenIndex = _allTokens.length - 1;
1346         uint256 tokenIndex = _allTokensIndex[tokenId];
1347 
1348         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1349         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1350         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1351         uint256 lastTokenId = _allTokens[lastTokenIndex];
1352 
1353         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1354         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1355 
1356         // This also deletes the contents at the last position of the array
1357         delete _allTokensIndex[tokenId];
1358         _allTokens.pop();
1359     }
1360 }
1361 
1362 
1363 
1364 contract PotatoPower is ERC721Enumerable, Ownable,Pausable {
1365     using Counters for Counters.Counter;
1366     
1367        struct SpecificAddresses{
1368         
1369         
1370         address userAddress;
1371         bool mint;
1372         
1373         
1374     }
1375     
1376     mapping(address => SpecificAddresses) public _whiteList;
1377     mapping(address=>bool) public _addressExist;
1378     mapping(uint256 => string) private _tokenURIs;
1379     
1380     Counters.Counter private _tokenIds;
1381 
1382     uint256 public maxSupply = 7777;
1383     uint256 public currentPrice = 0.05 ether;
1384     uint256 public maxQuantity=30;
1385     string  public tokenBaseURI;
1386     event MAX_SUPPLY_UPDATED(uint256 maxSupply);
1387     event MAX_PRICE_UPDATED(uint256 maxPrice);
1388 
1389     constructor(string memory _baseURII) ERC721("Potato Power", "PW"){tokenBaseURI=_baseURII;}
1390         function getPrice(uint256 _quantity) public view returns (uint256) {
1391        
1392            return _quantity*currentPrice ;
1393         }
1394         
1395 
1396     function mint( uint256 _quantity) whenNotPaused() public payable returns (uint256) {
1397     require(totalSupplyy()+_quantity<=maxSupply,"Quantity must be lesser then MaxSupply");
1398     require(_quantity>0,"quantity must be greater then zero");
1399     require(_quantity <= maxQuantity, "Your are not allowed to mint more than 30 tokens");
1400     require(getPrice(_quantity) == msg.value, "Ether value sent is not correct");
1401 
1402         uint256 newItemId;
1403 
1404         for (uint256 i = 0; i < _quantity; i++) {
1405        
1406         _tokenIds.increment();
1407          newItemId = _tokenIds.current();
1408         _mint(msg.sender, newItemId);
1409         _setTokenURI(newItemId, tokenBaseURI);
1410     }
1411             return newItemId;
1412 
1413     }
1414        function mintByAdmin( uint256 _quantity)  public  onlyOwner  returns (uint256) {
1415         require(_quantity <= 60, "Your are not allowed to mint more than 60 tokens");
1416         require(totalSupplyy()+_quantity<=maxSupply,"Quantity must be lesser then MaxSupply");
1417         require(_quantity>0,"quantity must be greater then zero");
1418         uint256 newItemId;
1419 
1420         for (uint256 i = 0; i < _quantity; i++) {
1421        
1422         _tokenIds.increment();
1423          newItemId = _tokenIds.current();
1424         _mint(msg.sender, newItemId);
1425         _setTokenURI(newItemId, tokenBaseURI);
1426     }
1427             return newItemId;
1428 
1429     }
1430 
1431      /**
1432      * @dev See {IERC721Enumerable-totalSupply}.
1433      */
1434     function totalSupplyy() private view returns (uint256) {
1435         return _tokenIds.current();
1436     }
1437 
1438      /**
1439      * @dev Withdraw ether from this contract (Callable by owner)
1440      */
1441     function withdraw() public onlyOwner {
1442         uint amount = address(this).balance;
1443         payable(owner()).transfer(amount);
1444     }
1445     
1446     function addWhiteList(address whiteAddress)public onlyOwner {
1447         require(!_addressExist[whiteAddress],"Address already Exist");
1448         
1449         _whiteList[whiteAddress]=SpecificAddresses({
1450             userAddress :msg.sender,
1451             mint:false
1452            });
1453            
1454            _addressExist[whiteAddress]=true;
1455         
1456     }
1457     
1458     function mintBeta() public payable{
1459         
1460         require(_addressExist[msg.sender]==true,"Address not Found in whitelist");
1461         SpecificAddresses storage myaddress = _whiteList[msg.sender];
1462         
1463         require(myaddress.mint==false,"User Already minted a token");
1464         require(msg.value==currentPrice,"Price Error");
1465         require(_tokenIds.current() < maxSupply, "Max Supply Exceeded");
1466 
1467         uint256 newItemId;
1468          _tokenIds.increment();
1469          newItemId = _tokenIds.current();
1470         _mint(msg.sender, newItemId);
1471         _setTokenURI(newItemId, tokenBaseURI);
1472         myaddress.mint=true;
1473         
1474     }
1475     
1476      function burn(uint256 tokenId) public  {
1477          require(ownerOf(tokenId)==msg.sender,"you are not owner of this id");
1478         _burn(tokenId);
1479     }
1480     
1481      function tokensOfOwner(address _owner) public view returns (uint256[] memory)
1482     {
1483         uint256 count = balanceOf(_owner);
1484         uint256[] memory result = new uint256[](count);
1485         for (uint256 index = 0; index < count; index++) {
1486             result[index] = tokenOfOwnerByIndex(_owner, index);
1487         }
1488         return result;
1489     }
1490     
1491  
1492     function _setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
1493         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1494         _tokenURIs[tokenId] = tokenURI;
1495     }
1496 
1497 
1498     function updateCurrentPrice(uint256 _price) public onlyOwner {
1499         currentPrice = _price;
1500         emit MAX_PRICE_UPDATED(_price);
1501     }
1502         
1503   
1504     
1505  function _baseURI() internal view override returns (string memory) {
1506     return tokenBaseURI ;
1507   }
1508   
1509   function updateBaseURI(string memory _baseURIII) public onlyOwner returns(string memory )
1510   {
1511       tokenBaseURI=_baseURIII;
1512       return tokenBaseURI;
1513   }
1514    function pause() public onlyOwner whenNotPaused 
1515    {
1516         _pause();
1517     }
1518     
1519      function unpause() public onlyOwner whenPaused 
1520      {
1521         _unpause();
1522     }
1523     
1524     
1525 }