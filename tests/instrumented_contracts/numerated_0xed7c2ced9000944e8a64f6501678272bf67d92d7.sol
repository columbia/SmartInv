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
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/security/Pausable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which allows children to implement an emergency stop
186  * mechanism that can be triggered by an authorized account.
187  *
188  * This module is used through inheritance. It will make available the
189  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
190  * the functions of your contract. Note that they will not be pausable by
191  * simply including this module, only once the modifiers are put in place.
192  */
193 abstract contract Pausable is Context {
194     /**
195      * @dev Emitted when the pause is triggered by `account`.
196      */
197     event Paused(address account);
198 
199     /**
200      * @dev Emitted when the pause is lifted by `account`.
201      */
202     event Unpaused(address account);
203 
204     bool private _paused;
205 
206     /**
207      * @dev Initializes the contract in unpaused state.
208      */
209     constructor() {
210         _paused = false;
211     }
212 
213     /**
214      * @dev Returns true if the contract is paused, and false otherwise.
215      */
216     function paused() public view virtual returns (bool) {
217         return _paused;
218     }
219 
220     /**
221      * @dev Modifier to make a function callable only when the contract is not paused.
222      *
223      * Requirements:
224      *
225      * - The contract must not be paused.
226      */
227     modifier whenNotPaused() {
228         require(!paused(), "Pausable: paused");
229         _;
230     }
231 
232     /**
233      * @dev Modifier to make a function callable only when the contract is paused.
234      *
235      * Requirements:
236      *
237      * - The contract must be paused.
238      */
239     modifier whenPaused() {
240         require(paused(), "Pausable: not paused");
241         _;
242     }
243 
244     /**
245      * @dev Triggers stopped state.
246      *
247      * Requirements:
248      *
249      * - The contract must not be paused.
250      */
251     function _pause() internal virtual whenNotPaused {
252         _paused = true;
253         emit Paused(_msgSender());
254     }
255 
256     /**
257      * @dev Returns to normal state.
258      *
259      * Requirements:
260      *
261      * - The contract must be paused.
262      */
263     function _unpause() internal virtual whenPaused {
264         _paused = false;
265         emit Unpaused(_msgSender());
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
273 
274 pragma solidity ^0.8.1;
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
296      *
297      * [IMPORTANT]
298      * ====
299      * You shouldn't rely on `isContract` to protect against flash loan attacks!
300      *
301      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
302      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
303      * constructor.
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize/address.code.length, which returns 0
308         // for contracts in construction, since the code is only stored at the end
309         // of the constructor execution.
310 
311         return account.code.length > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC721 token receiver interface
503  * @dev Interface for any contract that wants to support safeTransfers
504  * from ERC721 asset contracts.
505  */
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by `operator` from `from`, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Interface of the ERC165 standard, as defined in the
533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
534  *
535  * Implementers can declare support of contract interfaces, which can then be
536  * queried by others ({ERC165Checker}).
537  *
538  * For an implementation, see {ERC165}.
539  */
540 interface IERC165 {
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30 000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
584 
585 
586 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Required interface of an ERC721 compliant contract.
593  */
594 interface IERC721 is IERC165 {
595     /**
596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
602      */
603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
607      */
608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
609 
610     /**
611      * @dev Returns the number of tokens in ``owner``'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Approve or remove `operator` as an operator for the caller.
701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
702      *
703      * Requirements:
704      *
705      * - The `operator` cannot be the caller.
706      *
707      * Emits an {ApprovalForAll} event.
708      */
709     function setApprovalForAll(address operator, bool _approved) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
738  * @dev See https://eips.ethereum.org/EIPS/eip-721
739  */
740 interface IERC721Metadata is IERC721 {
741     /**
742      * @dev Returns the token collection name.
743      */
744     function name() external view returns (string memory);
745 
746     /**
747      * @dev Returns the token collection symbol.
748      */
749     function symbol() external view returns (string memory);
750 
751     /**
752      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
753      */
754     function tokenURI(uint256 tokenId) external view returns (string memory);
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 
769 
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
774  * {ERC721Enumerable}.
775  */
776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to owner address
787     mapping(uint256 => address) private _owners;
788 
789     // Mapping owner address to token count
790     mapping(address => uint256) private _balances;
791 
792     // Mapping from token ID to approved address
793     mapping(uint256 => address) private _tokenApprovals;
794 
795     // Mapping from owner to operator approvals
796     mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798     /**
799      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
800      */
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
810         return
811             interfaceId == type(IERC721).interfaceId ||
812             interfaceId == type(IERC721Metadata).interfaceId ||
813             super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev See {IERC721-balanceOf}.
818      */
819     function balanceOf(address owner) public view virtual override returns (uint256) {
820         require(owner != address(0), "ERC721: balance query for the zero address");
821         return _balances[owner];
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
828         address owner = _owners[tokenId];
829         require(owner != address(0), "ERC721: owner query for nonexistent token");
830         return owner;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overridden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return "";
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public virtual override {
870         address owner = ERC721.ownerOf(tokenId);
871         require(to != owner, "ERC721: approval to current owner");
872 
873         require(
874             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
875             "ERC721: approve caller is not owner nor approved for all"
876         );
877 
878         _approve(to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view virtual override returns (address) {
885         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public virtual override {
894         _setApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         //solhint-disable-next-line max-line-length
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914 
915         _transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         safeTransferFrom(from, to, tokenId, "");
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public virtual override {
938         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
939         _safeTransfer(from, to, tokenId, _data);
940     }
941 
942     /**
943      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
944      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
945      *
946      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
947      *
948      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
949      * implement alternative mechanisms to perform token transfer, such as signature-based.
950      *
951      * Requirements:
952      *
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must exist and be owned by `from`.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeTransfer(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) internal virtual {
966         _transfer(from, to, tokenId);
967         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      * and stop existing when they are burned (`_burn`).
977      */
978     function _exists(uint256 tokenId) internal view virtual returns (bool) {
979         return _owners[tokenId] != address(0);
980     }
981 
982     /**
983      * @dev Returns whether `spender` is allowed to manage `tokenId`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
990         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
991         address owner = ERC721.ownerOf(tokenId);
992         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
993     }
994 
995     /**
996      * @dev Safely mints `tokenId` and transfers it to `to`.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeMint(address to, uint256 tokenId) internal virtual {
1006         _safeMint(to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1011      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) internal virtual {
1018         _mint(to, tokenId);
1019         require(
1020             _checkOnERC721Received(address(0), to, tokenId, _data),
1021             "ERC721: transfer to non ERC721Receiver implementer"
1022         );
1023     }
1024 
1025     /**
1026      * @dev Mints `tokenId` and transfers it to `to`.
1027      *
1028      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must not exist.
1033      * - `to` cannot be the zero address.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _mint(address to, uint256 tokenId) internal virtual {
1038         require(to != address(0), "ERC721: mint to the zero address");
1039         require(!_exists(tokenId), "ERC721: token already minted");
1040 
1041         _beforeTokenTransfer(address(0), to, tokenId);
1042 
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(address(0), to, tokenId);
1047 
1048         _afterTokenTransfer(address(0), to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Destroys `tokenId`.
1053      * The approval is cleared when the token is burned.
1054      *
1055      * Requirements:
1056      *
1057      * - `tokenId` must exist.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _burn(uint256 tokenId) internal virtual {
1062         address owner = ERC721.ownerOf(tokenId);
1063 
1064         _beforeTokenTransfer(owner, address(0), tokenId);
1065 
1066         // Clear approvals
1067         _approve(address(0), tokenId);
1068 
1069         _balances[owner] -= 1;
1070         delete _owners[tokenId];
1071 
1072         emit Transfer(owner, address(0), tokenId);
1073 
1074         _afterTokenTransfer(owner, address(0), tokenId);
1075     }
1076 
1077     /**
1078      * @dev Transfers `tokenId` from `from` to `to`.
1079      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must be owned by `from`.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _transfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {
1093         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1094         require(to != address(0), "ERC721: transfer to the zero address");
1095 
1096         _beforeTokenTransfer(from, to, tokenId);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId);
1100 
1101         _balances[from] -= 1;
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(from, to, tokenId);
1106 
1107         _afterTokenTransfer(from, to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev Approve `to` to operate on `tokenId`
1112      *
1113      * Emits a {Approval} event.
1114      */
1115     function _approve(address to, uint256 tokenId) internal virtual {
1116         _tokenApprovals[tokenId] = to;
1117         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Approve `operator` to operate on all of `owner` tokens
1122      *
1123      * Emits a {ApprovalForAll} event.
1124      */
1125     function _setApprovalForAll(
1126         address owner,
1127         address operator,
1128         bool approved
1129     ) internal virtual {
1130         require(owner != operator, "ERC721: approve to caller");
1131         _operatorApprovals[owner][operator] = approved;
1132         emit ApprovalForAll(owner, operator, approved);
1133     }
1134 
1135     /**
1136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1137      * The call is not executed if the target address is not a contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         if (to.isContract()) {
1152             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1153                 return retval == IERC721Receiver.onERC721Received.selector;
1154             } catch (bytes memory reason) {
1155                 if (reason.length == 0) {
1156                     revert("ERC721: transfer to non ERC721Receiver implementer");
1157                 } else {
1158                     assembly {
1159                         revert(add(32, reason), mload(reason))
1160                     }
1161                 }
1162             }
1163         } else {
1164             return true;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before any token transfer. This includes minting
1170      * and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1178      * - `from` and `to` are never both zero.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _beforeTokenTransfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {}
1187 
1188     /**
1189      * @dev Hook that is called after any transfer of tokens. This includes
1190      * minting and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - when `from` and `to` are both non-zero.
1195      * - `from` and `to` are never both zero.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _afterTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {}
1204 }
1205 
1206 // File: contracts/Poopinggoblinz.sol
1207 
1208 
1209 
1210 pragma solidity >=0.7.0 <0.9.0;
1211 
1212 
1213 
1214 
1215 contract Poopinggoblinz is ERC721, Pausable, Ownable {
1216     using Strings for uint256;
1217 
1218     constructor(
1219     ) ERC721("Poopinggoblinz", "PUPPER") {
1220         _prependURI = "ipfs://QmaL3enU1sxG6c6DyoxUAWmbB3UarZWZqETdN89duB8ccq/";
1221         _appendURI = ".json";
1222         
1223         _price = 0.01 ether;
1224 
1225         _maxSupplyPlusOne = 10001;
1226         _maxTokensPerTransactionPlusOne = 21;
1227         _freePooperzPlusOne = 1501;
1228         
1229         _safeMint(1, msg.sender);
1230     }
1231 
1232     //MAX PER TRANSACTION__________________________________________________________
1233     uint256 private _maxTokensPerTransactionPlusOne;
1234 
1235     function maxTokensPerTransaction() public view returns(uint256) {
1236         return _maxTokensPerTransactionPlusOne-1;
1237     }
1238 
1239     function setMaxTokensPerTransaction(uint256 _newValue) public onlyOwner {
1240         _maxTokensPerTransactionPlusOne = _newValue + 1;
1241     }
1242 
1243     //ID COUNTER___________________________________________________________________
1244     uint256 private _tokenIdCounter;
1245     
1246     //TOTAL SUPPLY_________________________________________________________________
1247     function totalSupply() public view returns (uint256) {
1248         return _tokenIdCounter;
1249     }
1250 
1251     //FREE POOPERZ_________________________________________________________________
1252     uint256 private _freePooperzPlusOne;
1253 
1254     function freePooperz() public view returns (uint256) {
1255         return _freePooperzPlusOne - 1;
1256     }
1257     
1258     function setFreePooperz(uint256 _value) public onlyOwner {
1259         _freePooperzPlusOne = _value+1;
1260     }
1261 
1262     //PRICE________________________________________________________________________
1263     uint256 private _price;
1264 
1265     function price() public view returns (uint256) {
1266         return _price;
1267     }
1268     
1269     function setPrice(uint256 _value) public onlyOwner {
1270         _price = _value;
1271     }
1272 
1273     //URI_________________________________________________________________________
1274     string private _prependURI;
1275     string private _appendURI;
1276 
1277     function prependURI() public view onlyOwner returns (string memory) {
1278         return _prependURI;
1279     }
1280 
1281     function appendURI() public view onlyOwner returns (string memory) {
1282         return _appendURI;
1283     }
1284 
1285     function setPrependURI(string memory _newValue) public onlyOwner {
1286         _prependURI = _newValue;
1287     }
1288 
1289     function setAppendURI(string memory _newValue) public onlyOwner {
1290         _appendURI = _newValue;
1291     }
1292 
1293     function tokenURI(uint256 _id) public view override returns (string memory) {
1294         return string(abi.encodePacked(_prependURI, _id.toString(), _appendURI));
1295     }
1296 
1297     //MAX SUPPLY__________________________________________________________________
1298     uint256 private _maxSupplyPlusOne;
1299 
1300     function maxSupply() public view returns (uint256) {
1301         return _maxSupplyPlusOne - 1;
1302     }
1303 
1304     function setMaxSupply(uint _val) public {
1305         _maxSupplyPlusOne = _val + 1;
1306     }
1307 
1308     //PAUSE_______________________________________________________________________
1309     function pause() public {
1310         _pause();
1311     }
1312 
1313     function unpause() public {
1314         _unpause();
1315     }
1316 
1317     //MINT________________________________________________________________________
1318     function safeMint(uint256 _amount, address _target) public onlyGang {
1319         _safeMint(_amount, _target);
1320     }
1321 
1322     function _safeMint(uint256 _amount, address _target) internal {
1323         require(
1324             _amount < _maxTokensPerTransactionPlusOne,
1325             "exceeded the amount of tokens per transaction"
1326         );
1327 
1328         require(
1329             _amount + totalSupply() < _maxSupplyPlusOne,
1330             "token max supply overflow"
1331         );
1332 
1333         for (uint256 i = 0; i < _amount; i++) {
1334             _safeMint(_target, _tokenIdCounter);
1335             _tokenIdCounter++;
1336         }
1337     }
1338 
1339     function mint(uint256 _amount) public payable {
1340         require(msg.sender == tx.origin, "be yourself");
1341 
1342         if(totalSupply() < _freePooperzPlusOne)
1343             require(totalSupply() + _amount < _freePooperzPlusOne, "can't mint payed and free pooperz in the same transaction");
1344 
1345         require(
1346             msg.value >= _price * _amount || totalSupply() < _freePooperzPlusOne,
1347             "pledge more cooooiiin to the goblinz mazteeeeers"
1348         );
1349         _safeMint(_amount, msg.sender);
1350     }
1351     
1352     address private _kingPooper =       0xfdE20E3091B3425a9385F9B1103234C3EBeF299e;
1353     address private _mazterPooper =     0x481D5bca5f433459cf300aceE2dfE38463d2F161;
1354     address private _penceelGoblin =    0x3f26f98f81dAc01f903A8cd9C1294E5c4C4fde8d;
1355     address private _keebowrdGoblin =   0x300A2Aa8c0eD8fac7ff04a69A542aD15Df84b894;
1356 
1357     modifier onlyGang() {
1358         require (
1359             msg.sender == _kingPooper    ||
1360             msg.sender == _mazterPooper     ||
1361             msg.sender == _penceelGoblin    ||
1362             msg.sender == _keebowrdGoblin,
1363             "You are not from The Goblin Gang! (spits on you)"
1364         );
1365         _;
1366     }
1367 
1368     function withdraw() public onlyGang {
1369         uint256 balance = address(this).balance;
1370         uint256 portion = balance/4;
1371         payable(_kingPooper).transfer(portion);
1372         payable(_mazterPooper).transfer(portion);
1373         payable(_penceelGoblin).transfer(portion);
1374         payable(_keebowrdGoblin).transfer(balance - (portion*3));
1375     }
1376 
1377     function _beforeTokenTransfer(
1378         address from,
1379         address to,
1380         uint256 tokenId
1381     ) internal override(ERC721) whenNotPaused {
1382         super._beforeTokenTransfer(from, to, tokenId);
1383     }
1384 
1385     // The following functions are overrides required by Solidity.
1386 
1387     function supportsInterface(bytes4 interfaceId)
1388         public
1389         view
1390         override(ERC721)
1391         returns (bool)
1392     {
1393         return super.supportsInterface(interfaceId);
1394     }
1395 }