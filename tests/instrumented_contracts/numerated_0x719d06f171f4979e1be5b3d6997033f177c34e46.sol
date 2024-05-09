1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 interface IERC721Receiver {
456     /**
457      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
458      * by `operator` from `from`, this function is called.
459      *
460      * It must return its Solidity selector to confirm the token transfer.
461      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
462      *
463      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
464      */
465     function onERC721Received(
466         address operator,
467         address from,
468         uint256 tokenId,
469         bytes calldata data
470     ) external returns (bytes4);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Metadata is IERC721 {
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
710 
711 
712 
713 pragma solidity ^0.8.4;
714 
715 error BalanceQueryForZeroAddress();
716 error OwnerQueryForNonexistentToken();
717 error URIQueryForNonexistentToken();
718 error ApprovalToCurrentOwner();
719 error ApprovalCallerNotOwnerNorApproved();
720 error ApprovalQueryForNonexistentToken();
721 error ApproveToCaller();
722 error TransferToNonERC721ReceiverImplementer();
723 error MintToZeroAddress();
724 error MintZeroQuantity();
725 error TransferFromIncorrectOwner();
726 error TransferCallerNotOwnerNorApproved();
727 error TransferToZeroAddress();
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension. Built to optimize for lower gas during batch mints.
731  *
732  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
733  *
734  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
735  *
736  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
737  */
738 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
739     using Address for address;
740     using Strings for uint256;
741 
742     // Compiler will pack this into a single 256bit word.
743     struct TokenOwnership {
744         // The address of the owner.
745         address addr;
746         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
747         uint64 startTimestamp;
748         // Whether the token has been burned.
749         bool burned;
750     }
751 
752     // Compiler will pack this into a single 256bit word.
753     struct AddressData {
754         // Realistically, 2**64-1 is more than enough.
755         uint64 balance;
756         // Keeps track of mint count with minimal overhead for tokenomics.
757         uint64 numberMinted;
758         // Keeps track of burn count with minimal overhead for tokenomics.
759         uint64 numberBurned;
760         // For miscellaneous variable(s) pertaining to the address
761         // (e.g. number of whitelist mint slots used).
762         // If there are multiple variables, please pack them into a uint64.
763         uint64 aux;
764     }
765 
766     // The tokenId of the next token to be minted.
767     uint256 internal _currentIndex;
768 
769     // The number of tokens burned.
770     uint256 internal _burnCounter;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794         _currentIndex = _startTokenId();
795     }
796 
797     /**
798      * To change the starting tokenId, please override this function.
799      */
800     function _startTokenId() internal view virtual returns (uint256) {
801         return 0;
802     }
803 
804     /**
805      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
806      */
807     function totalSupply() public view returns (uint256) {
808         // Counter underflow is impossible as _burnCounter cannot be incremented
809         // more than _currentIndex - _startTokenId() times
810         unchecked {
811             return _currentIndex - _burnCounter - _startTokenId();
812         }
813     }
814 
815     /**
816      * Returns the total amount of tokens minted in the contract.
817      */
818     function _totalMinted() internal view returns (uint256) {
819         // Counter underflow is impossible as _currentIndex does not decrement,
820         // and it is initialized to _startTokenId()
821         unchecked {
822             return _currentIndex - _startTokenId();
823         }
824     }
825 
826     /**
827      * @dev See {IERC165-supportsInterface}.
828      */
829     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
830         return
831             interfaceId == type(IERC721).interfaceId ||
832             interfaceId == type(IERC721Metadata).interfaceId ||
833             super.supportsInterface(interfaceId);
834     }
835 
836     /**
837      * @dev See {IERC721-balanceOf}.
838      */
839     function balanceOf(address owner) public view override returns (uint256) {
840         if (owner == address(0)) revert BalanceQueryForZeroAddress();
841         return uint256(_addressData[owner].balance);
842     }
843 
844     /**
845      * Returns the number of tokens minted by `owner`.
846      */
847     function _numberMinted(address owner) internal view returns (uint256) {
848         return uint256(_addressData[owner].numberMinted);
849     }
850 
851     /**
852      * Returns the number of tokens burned by or on behalf of `owner`.
853      */
854     function _numberBurned(address owner) internal view returns (uint256) {
855         return uint256(_addressData[owner].numberBurned);
856     }
857 
858     /**
859      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
860      */
861     function _getAux(address owner) internal view returns (uint64) {
862         return _addressData[owner].aux;
863     }
864 
865     /**
866      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      * If there are multiple variables, please pack them into a uint64.
868      */
869     function _setAux(address owner, uint64 aux) internal {
870         _addressData[owner].aux = aux;
871     }
872 
873     /**
874      * Gas spent here starts off proportional to the maximum mint batch size.
875      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
876      */
877     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
878         uint256 curr = tokenId;
879 
880         unchecked {
881             if (_startTokenId() <= curr && curr < _currentIndex) {
882                 TokenOwnership memory ownership = _ownerships[curr];
883                 if (!ownership.burned) {
884                     if (ownership.addr != address(0)) {
885                         return ownership;
886                     }
887                     // Invariant:
888                     // There will always be an ownership that has an address and is not burned
889                     // before an ownership that does not have an address and is not burned.
890                     // Hence, curr will not underflow.
891                     while (true) {
892                         curr--;
893                         ownership = _ownerships[curr];
894                         if (ownership.addr != address(0)) {
895                             return ownership;
896                         }
897                     }
898                 }
899             }
900         }
901         revert OwnerQueryForNonexistentToken();
902     }
903 
904     /**
905      * @dev See {IERC721-ownerOf}.
906      */
907     function ownerOf(uint256 tokenId) public view override returns (address) {
908         return _ownershipOf(tokenId).addr;
909     }
910 
911     /**
912      * @dev See {IERC721Metadata-name}.
913      */
914     function name() public view virtual override returns (string memory) {
915         return _name;
916     }
917 
918     /**
919      * @dev See {IERC721Metadata-symbol}.
920      */
921     function symbol() public view virtual override returns (string memory) {
922         return _symbol;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-tokenURI}.
927      */
928     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
929         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
930 
931         string memory baseURI = _baseURI();
932         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
933     }
934 
935     /**
936      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
937      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
938      * by default, can be overriden in child contracts.
939      */
940     function _baseURI() internal view virtual returns (string memory) {
941         return '';
942     }
943 
944     /**
945      * @dev See {IERC721-approve}.
946      */
947     function approve(address to, uint256 tokenId) public override {
948         address owner = ERC721A.ownerOf(tokenId);
949         if (to == owner) revert ApprovalToCurrentOwner();
950 
951         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
952             revert ApprovalCallerNotOwnerNorApproved();
953         }
954 
955         _approve(to, tokenId, owner);
956     }
957 
958     /**
959      * @dev See {IERC721-getApproved}.
960      */
961     function getApproved(uint256 tokenId) public view override returns (address) {
962         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
963 
964         return _tokenApprovals[tokenId];
965     }
966 
967     /**
968      * @dev See {IERC721-setApprovalForAll}.
969      */
970     function setApprovalForAll(address operator, bool approved) public virtual override {
971         if (operator == _msgSender()) revert ApproveToCaller();
972 
973         _operatorApprovals[_msgSender()][operator] = approved;
974         emit ApprovalForAll(_msgSender(), operator, approved);
975     }
976 
977     /**
978      * @dev See {IERC721-isApprovedForAll}.
979      */
980     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
981         return _operatorApprovals[owner][operator];
982     }
983 
984     /**
985      * @dev See {IERC721-transferFrom}.
986      */
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public virtual override {
992         _transfer(from, to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         safeTransferFrom(from, to, tokenId, '');
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) public virtual override {
1015         _transfer(from, to, tokenId);
1016         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1017             revert TransferToNonERC721ReceiverImplementer();
1018         }
1019     }
1020 
1021     /**
1022      * @dev Returns whether `tokenId` exists.
1023      *
1024      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025      *
1026      * Tokens start existing when they are minted (`_mint`),
1027      */
1028     function _exists(uint256 tokenId) internal view returns (bool) {
1029         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1030     }
1031 
1032     function _safeMint(address to, uint256 quantity) internal {
1033         _safeMint(to, quantity, '');
1034     }
1035 
1036     /**
1037      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1038      *
1039      * Requirements:
1040      *
1041      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1042      * - `quantity` must be greater than 0.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _safeMint(
1047         address to,
1048         uint256 quantity,
1049         bytes memory _data
1050     ) internal {
1051         _mint(to, quantity, _data, true);
1052     }
1053 
1054     /**
1055      * @dev Mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `to` cannot be the zero address.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _mint(
1065         address to,
1066         uint256 quantity,
1067         bytes memory _data,
1068         bool safe
1069     ) internal {
1070         uint256 startTokenId = _currentIndex;
1071         if (to == address(0)) revert MintToZeroAddress();
1072         if (quantity == 0) revert MintZeroQuantity();
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         // Overflows are incredibly unrealistic.
1077         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1078         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1079         unchecked {
1080             _addressData[to].balance += uint64(quantity);
1081             _addressData[to].numberMinted += uint64(quantity);
1082 
1083             _ownerships[startTokenId].addr = to;
1084             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1085 
1086             uint256 updatedIndex = startTokenId;
1087             uint256 end = updatedIndex + quantity;
1088 
1089             if (safe && to.isContract()) {
1090                 do {
1091                     emit Transfer(address(0), to, updatedIndex);
1092                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1093                         revert TransferToNonERC721ReceiverImplementer();
1094                     }
1095                 } while (updatedIndex != end);
1096                 // Reentrancy protection
1097                 if (_currentIndex != startTokenId) revert();
1098             } else {
1099                 do {
1100                     emit Transfer(address(0), to, updatedIndex++);
1101                 } while (updatedIndex != end);
1102             }
1103             _currentIndex = updatedIndex;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) private {
1123         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1124 
1125         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1126 
1127         bool isApprovedOrOwner = (_msgSender() == from ||
1128             isApprovedForAll(from, _msgSender()) ||
1129             getApproved(tokenId) == _msgSender());
1130 
1131         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1132         if (to == address(0)) revert TransferToZeroAddress();
1133 
1134         _beforeTokenTransfers(from, to, tokenId, 1);
1135 
1136         // Clear approvals from the previous owner
1137         _approve(address(0), tokenId, from);
1138 
1139         // Underflow of the sender's balance is impossible because we check for
1140         // ownership above and the recipient's balance can't realistically overflow.
1141         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1142         unchecked {
1143             _addressData[from].balance -= 1;
1144             _addressData[to].balance += 1;
1145 
1146             TokenOwnership storage currSlot = _ownerships[tokenId];
1147             currSlot.addr = to;
1148             currSlot.startTimestamp = uint64(block.timestamp);
1149 
1150             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1151             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1152             uint256 nextTokenId = tokenId + 1;
1153             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1154             if (nextSlot.addr == address(0)) {
1155                 // This will suffice for checking _exists(nextTokenId),
1156                 // as a burned slot cannot contain the zero address.
1157                 if (nextTokenId != _currentIndex) {
1158                     nextSlot.addr = from;
1159                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, to, tokenId);
1165         _afterTokenTransfers(from, to, tokenId, 1);
1166     }
1167 
1168     /**
1169      * @dev This is equivalent to _burn(tokenId, false)
1170      */
1171     function _burn(uint256 tokenId) internal virtual {
1172         _burn(tokenId, false);
1173     }
1174 
1175     /**
1176      * @dev Destroys `tokenId`.
1177      * The approval is cleared when the token is burned.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1186         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1187 
1188         address from = prevOwnership.addr;
1189 
1190         if (approvalCheck) {
1191             bool isApprovedOrOwner = (_msgSender() == from ||
1192                 isApprovedForAll(from, _msgSender()) ||
1193                 getApproved(tokenId) == _msgSender());
1194 
1195             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1196         }
1197 
1198         _beforeTokenTransfers(from, address(0), tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, from);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             AddressData storage addressData = _addressData[from];
1208             addressData.balance -= 1;
1209             addressData.numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             TokenOwnership storage currSlot = _ownerships[tokenId];
1213             currSlot.addr = from;
1214             currSlot.startTimestamp = uint64(block.timestamp);
1215             currSlot.burned = true;
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1221             if (nextSlot.addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId != _currentIndex) {
1225                     nextSlot.addr = from;
1226                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, address(0), tokenId);
1232         _afterTokenTransfers(from, address(0), tokenId, 1);
1233 
1234         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1235         unchecked {
1236             _burnCounter++;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Approve `to` to operate on `tokenId`
1242      *
1243      * Emits a {Approval} event.
1244      */
1245     function _approve(
1246         address to,
1247         uint256 tokenId,
1248         address owner
1249     ) private {
1250         _tokenApprovals[tokenId] = to;
1251         emit Approval(owner, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1256      *
1257      * @param from address representing the previous owner of the given token ID
1258      * @param to target address that will receive the tokens
1259      * @param tokenId uint256 ID of the token to be transferred
1260      * @param _data bytes optional data to send along with the call
1261      * @return bool whether the call correctly returned the expected magic value
1262      */
1263     function _checkContractOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1270             return retval == IERC721Receiver(to).onERC721Received.selector;
1271         } catch (bytes memory reason) {
1272             if (reason.length == 0) {
1273                 revert TransferToNonERC721ReceiverImplementer();
1274             } else {
1275                 assembly {
1276                     revert(add(32, reason), mload(reason))
1277                 }
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1284      * And also called before burning one token.
1285      *
1286      * startTokenId - the first token id to be transferred
1287      * quantity - the amount to be transferred
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, `tokenId` will be burned by `from`.
1295      * - `from` and `to` are never both zero.
1296      */
1297     function _beforeTokenTransfers(
1298         address from,
1299         address to,
1300         uint256 startTokenId,
1301         uint256 quantity
1302     ) internal virtual {}
1303 
1304     /**
1305      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1306      * minting.
1307      * And also called after one token has been burned.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` has been minted for `to`.
1317      * - When `to` is zero, `tokenId` has been burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _afterTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 }
1327 
1328 
1329 pragma solidity >=0.7.0 <0.9.0;
1330 
1331 
1332 contract BoredSers is ERC721A, Ownable {
1333   using Strings for uint256;
1334   using Counters for Counters.Counter;
1335 
1336   Counters.Counter private supply;
1337 
1338   string public uriPrefix = "";
1339   string public uriSuffix = ".json";
1340   string public hiddenMetadataUri;
1341   
1342   uint256 public cost = 0.015 ether;
1343   uint256 public maxSupply = 5555;
1344   uint256 public maxMintAmountPerTx = 10;
1345   uint256 public freeMintAmount = 10;
1346   mapping(address => uint256) public addressMintedBalance;
1347 
1348   bool public paused = false;
1349   bool public revealed = false;
1350 
1351   constructor() ERC721A("BoredSers", "BOREDSERS") {
1352     setHiddenMetadataUri("ipfs://QmRzhKwS1pTCVy25kd4xZNU3jYjXZp39LBJU8HrdzHiEo6/hidden.json");
1353     
1354   }
1355 
1356   modifier mintCompliance(uint256 _mintAmount) {
1357         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1358         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1359     _;
1360   }
1361 
1362   //function totalSupply() public view returns (uint256) {
1363   //  return supply.current();
1364   //}
1365 
1366   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1367     require(!paused, "The contract is paused!");
1368 
1369     if(supply.current() <= freeMintAmount) {
1370             
1371             require(_mintAmount <= 5, "Max of 5 free NFT's");
1372 
1373         }
1374     if(supply.current() > freeMintAmount){
1375             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1376         }
1377 
1378     _mintLoop(msg.sender, _mintAmount);
1379   }
1380   
1381   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1382     _mintLoop(_receiver, _mintAmount);
1383   }
1384 
1385   function walletOfOwner(address _owner)
1386     public
1387     view
1388     returns (uint256[] memory)
1389   {
1390     uint256 ownerTokenCount = balanceOf(_owner);
1391     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1392     uint256 currentTokenId = 1;
1393     uint256 ownedTokenIndex = 0;
1394 
1395     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1396       address currentTokenOwner = ownerOf(currentTokenId);
1397 
1398       if (currentTokenOwner == _owner) {
1399         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1400 
1401         ownedTokenIndex++;
1402       }
1403 
1404       currentTokenId++;
1405     }
1406 
1407     return ownedTokenIds;
1408   }
1409 
1410   function tokenURI(uint256 _tokenId)
1411     public
1412     view
1413     virtual
1414     override
1415     returns (string memory)
1416   {
1417     require(
1418       _exists(_tokenId),
1419       "ERC721Metadata: URI query for nonexistent token"
1420     );
1421 
1422     if (revealed == false) {
1423       return hiddenMetadataUri;
1424     }
1425 
1426     string memory currentBaseURI = _baseURI();
1427     return bytes(currentBaseURI).length > 0
1428         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1429         : "";
1430   }
1431 
1432   function setRevealed(bool _state) public onlyOwner {
1433     revealed = _state;
1434   }
1435 
1436   function setCost(uint256 _cost) public onlyOwner {
1437     cost = _cost;
1438   }
1439 
1440   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1441     maxMintAmountPerTx = _maxMintAmountPerTx;
1442   }
1443 
1444   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1445     hiddenMetadataUri = _hiddenMetadataUri;
1446   }
1447 
1448   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1449     uriPrefix = _uriPrefix;
1450   }
1451 
1452   function setFreeMintAmount(uint256 _freeMintAmount) public onlyOwner {
1453       freeMintAmount = _freeMintAmount;
1454   }
1455 
1456   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1457     uriSuffix = _uriSuffix;
1458   }
1459 
1460   function setPaused(bool _state) public onlyOwner {
1461     paused = _state;
1462   }
1463 
1464   function withdraw() public onlyOwner {
1465     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1466     require(os);
1467   }
1468 
1469   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1470     _safeMint(_receiver, _mintAmount);
1471     
1472   }
1473 
1474   function _baseURI() internal view virtual override returns (string memory) {
1475     return uriPrefix;
1476   }
1477 }