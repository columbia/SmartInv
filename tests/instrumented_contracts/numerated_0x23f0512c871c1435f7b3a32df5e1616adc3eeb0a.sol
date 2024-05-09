1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59     uint8 private constant _ADDRESS_LENGTH = 20;
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
119      */
120     function toHexString(address addr) internal pure returns (string memory) {
121         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/access/Ownable.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 /**
161  * @dev Contract module which provides a basic access control mechanism, where
162  * there is an account (an owner) that can be granted exclusive access to
163  * specific functions.
164  *
165  * By default, the owner account will be the one that deploys the contract. This
166  * can later be changed with {transferOwnership}.
167  *
168  * This module is used through inheritance. It will make available the modifier
169  * `onlyOwner`, which can be applied to your functions to restrict their use to
170  * the owner.
171  */
172 abstract contract Ownable is Context {
173     address private _owner;
174 
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     /**
178      * @dev Initializes the contract setting the deployer as the initial owner.
179      */
180     constructor() {
181         _transferOwnership(_msgSender());
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         _checkOwner();
189         _;
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view virtual returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if the sender is not the owner.
201      */
202     function _checkOwner() internal view virtual {
203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
204     }
205 
206     /**
207      * @dev Leaves the contract without owner. It will not be possible to call
208      * `onlyOwner` functions anymore. Can only be called by the current owner.
209      *
210      * NOTE: Renouncing ownership will leave the contract without an owner,
211      * thereby removing any functionality that is only available to the owner.
212      */
213     function renounceOwnership() public virtual onlyOwner {
214         _transferOwnership(address(0));
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Can only be called by the current owner.
220      */
221     function transferOwnership(address newOwner) public virtual onlyOwner {
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223         _transferOwnership(newOwner);
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Internal function without access restriction.
229      */
230     function _transferOwnership(address newOwner) internal virtual {
231         address oldOwner = _owner;
232         _owner = newOwner;
233         emit OwnershipTransferred(oldOwner, newOwner);
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 interface IERC721Receiver {
475     /**
476      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
477      * by `operator` from `from`, this function is called.
478      *
479      * It must return its Solidity selector to confirm the token transfer.
480      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
481      *
482      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
483      */
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Implementation of the {IERC721Receiver} interface.
502  *
503  * Accepts all token transfers.
504  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
505  */
506 contract ERC721Holder is IERC721Receiver {
507     /**
508      * @dev See {IERC721Receiver-onERC721Received}.
509      *
510      * Always returns `IERC721Receiver.onERC721Received.selector`.
511      */
512     function onERC721Received(
513         address,
514         address,
515         uint256,
516         bytes memory
517     ) public virtual override returns (bytes4) {
518         return this.onERC721Received.selector;
519     }
520 }
521 
522 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Interface of the ERC165 standard, as defined in the
531  * https://eips.ethereum.org/EIPS/eip-165[EIP].
532  *
533  * Implementers can declare support of contract interfaces, which can then be
534  * queried by others ({ERC165Checker}).
535  *
536  * For an implementation, see {ERC165}.
537  */
538 interface IERC165 {
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30 000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) external view returns (bool);
548 }
549 
550 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Implementation of the {IERC165} interface.
560  *
561  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
562  * for the additional interface id that will be supported. For example:
563  *
564  * ```solidity
565  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
567  * }
568  * ```
569  *
570  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
571  */
572 abstract contract ERC165 is IERC165 {
573     /**
574      * @dev See {IERC165-supportsInterface}.
575      */
576     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577         return interfaceId == type(IERC165).interfaceId;
578     }
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @dev Required interface of an ERC721 compliant contract.
591  */
592 interface IERC721 is IERC165 {
593     /**
594      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
595      */
596     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
600      */
601     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
602 
603     /**
604      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
605      */
606     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
607 
608     /**
609      * @dev Returns the number of tokens in ``owner``'s account.
610      */
611     function balanceOf(address owner) external view returns (uint256 balance);
612 
613     /**
614      * @dev Returns the owner of the `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function ownerOf(uint256 tokenId) external view returns (address owner);
621 
622     /**
623      * @dev Safely transfers `tokenId` token from `from` to `to`.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId,
639         bytes calldata data
640     ) external;
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId
660     ) external;
661 
662     /**
663      * @dev Transfers `tokenId` token from `from` to `to`.
664      *
665      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must be owned by `from`.
672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
673      *
674      * Emits a {Transfer} event.
675      */
676     function transferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
684      * The approval is cleared when the token is transferred.
685      *
686      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
687      *
688      * Requirements:
689      *
690      * - The caller must own the token or be an approved operator.
691      * - `tokenId` must exist.
692      *
693      * Emits an {Approval} event.
694      */
695     function approve(address to, uint256 tokenId) external;
696 
697     /**
698      * @dev Approve or remove `operator` as an operator for the caller.
699      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
700      *
701      * Requirements:
702      *
703      * - The `operator` cannot be the caller.
704      *
705      * Emits an {ApprovalForAll} event.
706      */
707     function setApprovalForAll(address operator, bool _approved) external;
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
719      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
720      *
721      * See {setApprovalForAll}
722      */
723     function isApprovedForAll(address owner, address operator) external view returns (bool);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
736  * @dev See https://eips.ethereum.org/EIPS/eip-721
737  */
738 interface IERC721Enumerable is IERC721 {
739     /**
740      * @dev Returns the total amount of tokens stored by the contract.
741      */
742     function totalSupply() external view returns (uint256);
743 
744     /**
745      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
746      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
747      */
748     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
749 
750     /**
751      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
752      * Use along with {totalSupply} to enumerate all tokens.
753      */
754     function tokenByIndex(uint256 index) external view returns (uint256);
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
767  * @dev See https://eips.ethereum.org/EIPS/eip-721
768  */
769 interface IERC721Metadata is IERC721 {
770     /**
771      * @dev Returns the token collection name.
772      */
773     function name() external view returns (string memory);
774 
775     /**
776      * @dev Returns the token collection symbol.
777      */
778     function symbol() external view returns (string memory);
779 
780     /**
781      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
782      */
783     function tokenURI(uint256 tokenId) external view returns (string memory);
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 
795 
796 
797 
798 
799 
800 /**
801  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
802  * the Metadata extension, but not including the Enumerable extension, which is available separately as
803  * {ERC721Enumerable}.
804  */
805 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to owner address
816     mapping(uint256 => address) private _owners;
817 
818     // Mapping owner address to token count
819     mapping(address => uint256) private _balances;
820 
821     // Mapping from token ID to approved address
822     mapping(uint256 => address) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     /**
828      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
829      */
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833     }
834 
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
839         return
840             interfaceId == type(IERC721).interfaceId ||
841             interfaceId == type(IERC721Metadata).interfaceId ||
842             super.supportsInterface(interfaceId);
843     }
844 
845     /**
846      * @dev See {IERC721-balanceOf}.
847      */
848     function balanceOf(address owner) public view virtual override returns (uint256) {
849         require(owner != address(0), "ERC721: address zero is not a valid owner");
850         return _balances[owner];
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
857         address owner = _owners[tokenId];
858         require(owner != address(0), "ERC721: invalid token ID");
859         return owner;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-name}.
864      */
865     function name() public view virtual override returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-symbol}.
871      */
872     function symbol() public view virtual override returns (string memory) {
873         return _symbol;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-tokenURI}.
878      */
879     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
880         _requireMinted(tokenId);
881 
882         string memory baseURI = _baseURI();
883         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overridden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return "";
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public virtual override {
899         address owner = ERC721.ownerOf(tokenId);
900         require(to != owner, "ERC721: approval to current owner");
901 
902         require(
903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
904             "ERC721: approve caller is not token owner nor approved for all"
905         );
906 
907         _approve(to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view virtual override returns (address) {
914         _requireMinted(tokenId);
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         _setApprovalForAll(_msgSender(), operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev See {IERC721-transferFrom}.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         //solhint-disable-next-line max-line-length
942         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
943 
944         _transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         safeTransferFrom(from, to, tokenId, "");
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory data
966     ) public virtual override {
967         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
968         _safeTransfer(from, to, tokenId, data);
969     }
970 
971     /**
972      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
973      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
974      *
975      * `data` is additional data, it has no specified format and it is sent in call to `to`.
976      *
977      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
978      * implement alternative mechanisms to perform token transfer, such as signature-based.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must exist and be owned by `from`.
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeTransfer(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory data
994     ) internal virtual {
995         _transfer(from, to, tokenId);
996         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
997     }
998 
999     /**
1000      * @dev Returns whether `tokenId` exists.
1001      *
1002      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1003      *
1004      * Tokens start existing when they are minted (`_mint`),
1005      * and stop existing when they are burned (`_burn`).
1006      */
1007     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1008         return _owners[tokenId] != address(0);
1009     }
1010 
1011     /**
1012      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1019         address owner = ERC721.ownerOf(tokenId);
1020         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1021     }
1022 
1023     /**
1024      * @dev Safely mints `tokenId` and transfers it to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must not exist.
1029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(address to, uint256 tokenId) internal virtual {
1034         _safeMint(to, tokenId, "");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1039      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1040      */
1041     function _safeMint(
1042         address to,
1043         uint256 tokenId,
1044         bytes memory data
1045     ) internal virtual {
1046         _mint(to, tokenId);
1047         require(
1048             _checkOnERC721Received(address(0), to, tokenId, data),
1049             "ERC721: transfer to non ERC721Receiver implementer"
1050         );
1051     }
1052 
1053     /**
1054      * @dev Mints `tokenId` and transfers it to `to`.
1055      *
1056      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - `to` cannot be the zero address.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _mint(address to, uint256 tokenId) internal virtual {
1066         require(to != address(0), "ERC721: mint to the zero address");
1067         require(!_exists(tokenId), "ERC721: token already minted");
1068 
1069         _beforeTokenTransfer(address(0), to, tokenId);
1070 
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(address(0), to, tokenId);
1075 
1076         _afterTokenTransfer(address(0), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         address owner = ERC721.ownerOf(tokenId);
1091 
1092         _beforeTokenTransfer(owner, address(0), tokenId);
1093 
1094         // Clear approvals
1095         _approve(address(0), tokenId);
1096 
1097         _balances[owner] -= 1;
1098         delete _owners[tokenId];
1099 
1100         emit Transfer(owner, address(0), tokenId);
1101 
1102         _afterTokenTransfer(owner, address(0), tokenId);
1103     }
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {
1121         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1122         require(to != address(0), "ERC721: transfer to the zero address");
1123 
1124         _beforeTokenTransfer(from, to, tokenId);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId);
1128 
1129         _balances[from] -= 1;
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(from, to, tokenId);
1134 
1135         _afterTokenTransfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits an {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `operator` to operate on all of `owner` tokens
1150      *
1151      * Emits an {ApprovalForAll} event.
1152      */
1153     function _setApprovalForAll(
1154         address owner,
1155         address operator,
1156         bool approved
1157     ) internal virtual {
1158         require(owner != operator, "ERC721: approve to caller");
1159         _operatorApprovals[owner][operator] = approved;
1160         emit ApprovalForAll(owner, operator, approved);
1161     }
1162 
1163     /**
1164      * @dev Reverts if the `tokenId` has not been minted yet.
1165      */
1166     function _requireMinted(uint256 tokenId) internal view virtual {
1167         require(_exists(tokenId), "ERC721: invalid token ID");
1168     }
1169 
1170     /**
1171      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1172      * The call is not executed if the target address is not a contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory data
1185     ) private returns (bool) {
1186         if (to.isContract()) {
1187             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1188                 return retval == IERC721Receiver.onERC721Received.selector;
1189             } catch (bytes memory reason) {
1190                 if (reason.length == 0) {
1191                     revert("ERC721: transfer to non ERC721Receiver implementer");
1192                 } else {
1193                     /// @solidity memory-safe-assembly
1194                     assembly {
1195                         revert(add(32, reason), mload(reason))
1196                     }
1197                 }
1198             }
1199         } else {
1200             return true;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before any token transfer. This includes minting
1206      * and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` will be minted for `to`.
1213      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1214      * - `from` and `to` are never both zero.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Hook that is called after any transfer of tokens. This includes
1226      * minting and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - when `from` and `to` are both non-zero.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _afterTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {}
1240 }
1241 
1242 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1243 
1244 
1245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 
1251 /**
1252  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1253  * enumerability of all the token ids in the contract as well as all token ids owned by each
1254  * account.
1255  */
1256 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1257     // Mapping from owner to list of owned token IDs
1258     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1259 
1260     // Mapping from token ID to index of the owner tokens list
1261     mapping(uint256 => uint256) private _ownedTokensIndex;
1262 
1263     // Array with all token ids, used for enumeration
1264     uint256[] private _allTokens;
1265 
1266     // Mapping from token id to position in the allTokens array
1267     mapping(uint256 => uint256) private _allTokensIndex;
1268 
1269     /**
1270      * @dev See {IERC165-supportsInterface}.
1271      */
1272     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1273         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1278      */
1279     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1280         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1281         return _ownedTokens[owner][index];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Enumerable-totalSupply}.
1286      */
1287     function totalSupply() public view virtual override returns (uint256) {
1288         return _allTokens.length;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenByIndex}.
1293      */
1294     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1295         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1296         return _allTokens[index];
1297     }
1298 
1299     /**
1300      * @dev Hook that is called before any token transfer. This includes minting
1301      * and burning.
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` will be minted for `to`.
1308      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1309      * - `from` cannot be the zero address.
1310      * - `to` cannot be the zero address.
1311      *
1312      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1313      */
1314     function _beforeTokenTransfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) internal virtual override {
1319         super._beforeTokenTransfer(from, to, tokenId);
1320 
1321         if (from == address(0)) {
1322             _addTokenToAllTokensEnumeration(tokenId);
1323         } else if (from != to) {
1324             _removeTokenFromOwnerEnumeration(from, tokenId);
1325         }
1326         if (to == address(0)) {
1327             _removeTokenFromAllTokensEnumeration(tokenId);
1328         } else if (to != from) {
1329             _addTokenToOwnerEnumeration(to, tokenId);
1330         }
1331     }
1332 
1333     /**
1334      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1335      * @param to address representing the new owner of the given token ID
1336      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1337      */
1338     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1339         uint256 length = ERC721.balanceOf(to);
1340         _ownedTokens[to][length] = tokenId;
1341         _ownedTokensIndex[tokenId] = length;
1342     }
1343 
1344     /**
1345      * @dev Private function to add a token to this extension's token tracking data structures.
1346      * @param tokenId uint256 ID of the token to be added to the tokens list
1347      */
1348     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1349         _allTokensIndex[tokenId] = _allTokens.length;
1350         _allTokens.push(tokenId);
1351     }
1352 
1353     /**
1354      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1355      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1356      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1357      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1358      * @param from address representing the previous owner of the given token ID
1359      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1360      */
1361     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1362         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1366         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary
1369         if (tokenIndex != lastTokenIndex) {
1370             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1371 
1372             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374         }
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _ownedTokensIndex[tokenId];
1378         delete _ownedTokens[from][lastTokenIndex];
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's token tracking data structures.
1383      * This has O(1) time complexity, but alters the order of the _allTokens array.
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list
1385      */
1386     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1387         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = _allTokens.length - 1;
1391         uint256 tokenIndex = _allTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1394         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1395         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1396         uint256 lastTokenId = _allTokens[lastTokenIndex];
1397 
1398         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1399         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _allTokensIndex[tokenId];
1403         _allTokens.pop();
1404     }
1405 }
1406 
1407 // File: contracts/WCAMundial.sol
1408 
1409 //SPDX-License-Identifier: MIT
1410 pragma solidity ^0.8.17;
1411 
1412 
1413 
1414 
1415 
1416 
1417 contract WCAMundial is ERC721Enumerable, ERC721Holder, Ownable {
1418   using Counters for Counters.Counter;
1419 
1420   struct Recipient {
1421     address wallet;
1422     uint256 amount;
1423   }
1424 
1425   address public manager;
1426   Counters.Counter private NFTId;
1427   string public baseTokenURI;
1428 
1429   mapping(address => uint256) public recipientsToQuanitity;
1430   mapping(address => uint256[]) public stakerToNFTs;
1431   mapping(uint256 => address) public NFTToStaker;
1432 
1433   uint256 public constant maxSupply = 3000;
1434   uint256 public price = 0.25 ether;
1435   uint256 public maxPerMint = 5;
1436   uint256 public startClaimTimestamp = 1671490800;
1437   bool public saleLive = false;
1438 
1439   modifier onlyOwnerOrManagerOrSelf() {
1440     require(owner() == msg.sender || address(this) == msg.sender || manager == msg.sender, "Unauthorized");
1441     _;
1442   }
1443 
1444   modifier onlyOwnerOrManager() {
1445     require(owner() == msg.sender || manager == msg.sender, "Unauthorized");
1446     _;
1447   }
1448 
1449   modifier canClaim() {
1450     require(block.timestamp >= startClaimTimestamp, "You can't already claim your NFTs");
1451     _;
1452   }
1453 
1454   modifier saleIsLive() {
1455     require(saleLive, "Sale isn't live");
1456     _;
1457   }
1458 
1459   constructor(string memory _baseURI, address _manager) ERC721("WCAPES Mundial", "MUN") {
1460     baseTokenURI = _baseURI;
1461     manager = _manager;
1462   }
1463 
1464   // SETTER
1465   function setBaseTokenURI(string calldata _baseURI) external onlyOwner {
1466     baseTokenURI = _baseURI;
1467   }
1468 
1469   function setPrice(uint256 _price) external onlyOwner {
1470     price = _price;
1471   }
1472 
1473   function setMaxPerMint(uint256 _maxPerMint) external onlyOwner {
1474     maxPerMint = _maxPerMint;
1475   }
1476 
1477   function setStartClaimTimestamp(uint256 _timestamp) external onlyOwner {
1478     startClaimTimestamp = _timestamp;
1479   }
1480 
1481   function toggleSaleLive() external onlyOwner {
1482     saleLive = !saleLive;
1483   }
1484 
1485   function setManager(address _manager) external onlyOwner {
1486     manager = _manager;
1487   }
1488 
1489   // GETTER
1490   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1491     require(_tokenId > 0 && _tokenId <= NFTId.current(), "Invalid token id");
1492     return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId), ".json"));
1493   }
1494 
1495   function getMintedCount() external view returns (uint256) {
1496     return NFTId.current();
1497   }
1498 
1499   function getStaked(address staker) public view returns (uint256[] memory) {
1500     return stakerToNFTs[staker];
1501   }
1502 
1503   function getStakedCount(address staker) public view returns (uint256) {
1504     return stakerToNFTs[staker].length;
1505   }
1506 
1507   function getStakedMintCount(address staker) public view returns (uint256) {
1508     return recipientsToQuanitity[staker];
1509   }
1510 
1511   function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1512     uint256 tokenCount = balanceOf(_owner);
1513     uint256[] memory tokensIds = new uint256[](tokenCount);
1514     for (uint256 i = 0; i < tokenCount; i++) {
1515       tokensIds[i] = tokenOfOwnerByIndex(_owner, i);
1516     }
1517     return tokensIds;
1518   }
1519 
1520   // MINT
1521   function mint(address recipient, uint256 quantity) external payable saleIsLive {
1522     require(quantity > 0 && quantity <= maxPerMint, "Cannot mint specified number of NFTs");
1523     require((NFTId.current() + quantity) <= maxSupply, "Not enough NFTs left");
1524     require(msg.value >= (quantity * price), "Not enough ETH to buy specified amount of NFTs");
1525 
1526     for (uint256 i = 0; i < quantity; i++) {
1527       _mintSingleNFT(recipient);
1528     }
1529   }
1530 
1531   function mintTo(address recipient, uint256 quantity) external onlyOwnerOrManager {
1532     require(quantity > 0, "Cannot mint specified number of NFTs");
1533     require((NFTId.current() + quantity) <= maxSupply, "Not enough NFTs left");
1534 
1535     for (uint256 i = 0; i < quantity; i++) {
1536       _mintSingleNFT(recipient);
1537     }
1538   }
1539 
1540   // STAKED MINT
1541   function addToStakedMint(address recipient, uint256 quantity) external onlyOwnerOrManagerOrSelf {
1542     recipientsToQuanitity[recipient] += quantity;
1543   }
1544 
1545   function bulkAddToStakedMint(Recipient[] calldata recipients) external onlyOwnerOrManager {
1546     uint256 recipientsLength = recipients.length;
1547     for (uint256 i = 0; i < recipientsLength; i++) {
1548       this.addToStakedMint(recipients[i].wallet, recipients[i].amount);
1549     }
1550   }
1551 
1552   function removeFromStakedMint(address recipient, uint256 quantity) external onlyOwnerOrManager {
1553     if (quantity > recipientsToQuanitity[recipient]) {
1554       recipientsToQuanitity[recipient] -= recipientsToQuanitity[recipient];
1555     } else {
1556       recipientsToQuanitity[recipient] -= quantity;
1557     }
1558   }
1559 
1560   function stakedMint(address recipient, uint256 quantity) external saleIsLive {
1561     require(quantity > 0 && quantity <= recipientsToQuanitity[recipient], "Cannot mint specified number of NFTs");
1562     require((NFTId.current() + quantity) <= maxSupply, "Not enough NFTs left");
1563 
1564     for (uint256 i = 0; i < quantity; i++) {
1565       _mintSingleNFT(address(this));
1566       stakerToNFTs[recipient].push(NFTId.current());
1567       NFTToStaker[NFTId.current()] = recipient;
1568       recipientsToQuanitity[recipient] -= 1;
1569     }
1570   }
1571 
1572   // STAKE MINT TO
1573   function stakedMintTo(address recipient, uint256 quantity) external onlyOwnerOrManager {
1574     require(quantity > 0, "Cannot mint specified number of NFTs");
1575     require((NFTId.current() + quantity) <= maxSupply, "Not enough NFTs left");
1576 
1577     for (uint256 i = 0; i < quantity; i++) {
1578       _mintSingleNFT(address(this));
1579       stakerToNFTs[recipient].push(NFTId.current());
1580       NFTToStaker[NFTId.current()] = recipient;
1581     }
1582   }
1583 
1584   // STAKE TO AFTER MINT
1585   function stakeToByIds(uint256[] calldata tokenIds, address recipient) external onlyOwnerOrManager {
1586     require(this.isApprovedForAll(msg.sender, address(this)), "You first need to approve");
1587 
1588     uint256 tokenIdsLength = tokenIds.length;
1589     for (uint256 i = 0; i < tokenIdsLength; i++) {
1590       uint256 id = tokenIds[i];
1591       require(this.ownerOf(id) == msg.sender && NFTToStaker[id] == address(0), "NFT is not yours");
1592       this.transferFrom(msg.sender, address(this), id);
1593 
1594       stakerToNFTs[recipient].push(id);
1595       NFTToStaker[id] = recipient;
1596     }
1597   }
1598 
1599   function _mintSingleNFT(address _to) private {
1600     NFTId.increment();
1601     _safeMint(_to, NFTId.current());
1602   }
1603 
1604   // CLAIM
1605   function claimNFTs() external canClaim {
1606     uint256 stakedNFTsCount = getStakedCount(msg.sender);
1607     require(stakedNFTsCount > 0, "No NFTs in stake");
1608 
1609     for (uint256 i = stakedNFTsCount; i > 0; i--) {
1610       uint256 tokenId = stakerToNFTs[msg.sender][i - 1];
1611 
1612       stakerToNFTs[msg.sender].pop();
1613       NFTToStaker[tokenId] = address(0);
1614 
1615       this.transferFrom(address(this), msg.sender, tokenId);
1616     }
1617   }
1618 
1619   // WITHDRAW
1620   function withdraw(uint256 _value) external payable onlyOwner {
1621     uint256 balance = address(this).balance;
1622     require(balance > 0, "No ether left to withdraw");
1623     uint256 toWithdraw = _value;
1624     if (balance < _value || _value == 0) {
1625       toWithdraw = balance;
1626     }
1627 
1628     (bool success, ) = (owner()).call{ value: toWithdraw }("");
1629     require(success, "Transfer failed.");
1630   }
1631 }