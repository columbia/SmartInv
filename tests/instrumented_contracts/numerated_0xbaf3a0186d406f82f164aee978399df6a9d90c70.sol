1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18     uint8 private constant _ADDRESS_LENGTH = 20;
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
78      */
79     function toHexString(address addr) internal pure returns (string memory) {
80         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Address.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
88 
89 pragma solidity ^0.8.1;
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      *
112      * [IMPORTANT]
113      * ====
114      * You shouldn't rely on `isContract` to protect against flash loan attacks!
115      *
116      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
117      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
118      * constructor.
119      * ====
120      */
121     function isContract(address account) internal view returns (bool) {
122         // This method relies on extcodesize/address.code.length, which returns 0
123         // for contracts in construction, since the code is only stored at the end
124         // of the constructor execution.
125 
126         return account.code.length > 0;
127     }
128 
129     /**
130      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
131      * `recipient`, forwarding all available gas and reverting on errors.
132      *
133      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
134      * of certain opcodes, possibly making contracts go over the 2300 gas limit
135      * imposed by `transfer`, making them unable to receive funds via
136      * `transfer`. {sendValue} removes this limitation.
137      *
138      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
139      *
140      * IMPORTANT: because control is transferred to `recipient`, care must be
141      * taken to not create reentrancy vulnerabilities. Consider using
142      * {ReentrancyGuard} or the
143      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
144      */
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain `call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason, it is bubbled up by this
158      * function (like regular Solidity function calls).
159      *
160      * Returns the raw returned data. To convert to the expected return value,
161      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
162      *
163      * Requirements:
164      *
165      * - `target` must be a contract.
166      * - calling `target` with `data` must not revert.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCall(target, data, "Address: low-level call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
176      * `errorMessage` as a fallback revert reason when `target` reverts.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but also transferring `value` wei to `target`.
191      *
192      * Requirements:
193      *
194      * - the calling contract must have an ETH balance of at least `value`.
195      * - the called Solidity function must be `payable`.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(address(this).balance >= value, "Address: insufficient balance for call");
220         require(isContract(target), "Address: call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.call{value: value}(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
233         return functionStaticCall(target, data, "Address: low-level static call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal view returns (bytes memory) {
247         require(isContract(target), "Address: static call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.staticcall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(isContract(target), "Address: delegate call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.delegatecall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
282      * revert reason using the provided one.
283      *
284      * _Available since v4.3._
285      */
286     function verifyCallResult(
287         bool success,
288         bytes memory returndata,
289         string memory errorMessage
290     ) internal pure returns (bytes memory) {
291         if (success) {
292             return returndata;
293         } else {
294             // Look for revert reason and bubble it up if present
295             if (returndata.length > 0) {
296                 // The easiest way to bubble the revert reason is using memory via assembly
297                 /// @solidity memory-safe-assembly
298                 assembly {
299                     let returndata_size := mload(returndata)
300                     revert(add(32, returndata), returndata_size)
301                 }
302             } else {
303                 revert(errorMessage);
304             }
305         }
306     }
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @title ERC721 token receiver interface
318  * @dev Interface for any contract that wants to support safeTransfers
319  * from ERC721 asset contracts.
320  */
321 interface IERC721Receiver {
322     /**
323      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
324      * by `operator` from `from`, this function is called.
325      *
326      * It must return its Solidity selector to confirm the token transfer.
327      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
328      *
329      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
330      */
331     function onERC721Received(
332         address operator,
333         address from,
334         uint256 tokenId,
335         bytes calldata data
336     ) external returns (bytes4);
337 }
338 
339 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Interface of the ERC165 standard, as defined in the
348  * https://eips.ethereum.org/EIPS/eip-165[EIP].
349  *
350  * Implementers can declare support of contract interfaces, which can then be
351  * queried by others ({ERC165Checker}).
352  *
353  * For an implementation, see {ERC165}.
354  */
355 interface IERC165 {
356     /**
357      * @dev Returns true if this contract implements the interface defined by
358      * `interfaceId`. See the corresponding
359      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
360      * to learn more about how these ids are created.
361      *
362      * This function call must use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 }
366 
367 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 
375 /**
376  * @dev Implementation of the {IERC165} interface.
377  *
378  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
379  * for the additional interface id that will be supported. For example:
380  *
381  * ```solidity
382  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
384  * }
385  * ```
386  *
387  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
388  */
389 abstract contract ERC165 is IERC165 {
390     /**
391      * @dev See {IERC165-supportsInterface}.
392      */
393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394         return interfaceId == type(IERC165).interfaceId;
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Required interface of an ERC721 compliant contract.
408  */
409 interface IERC721 is IERC165 {
410     /**
411      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
417      */
418     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
422      */
423     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
424 
425     /**
426      * @dev Returns the number of tokens in ``owner``'s account.
427      */
428     function balanceOf(address owner) external view returns (uint256 balance);
429 
430     /**
431      * @dev Returns the owner of the `tokenId` token.
432      *
433      * Requirements:
434      *
435      * - `tokenId` must exist.
436      */
437     function ownerOf(uint256 tokenId) external view returns (address owner);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
461      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must exist and be owned by `from`.
468      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
469      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
470      *
471      * Emits a {Transfer} event.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Transfers `tokenId` token from `from` to `to`.
481      *
482      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
501      * The approval is cleared when the token is transferred.
502      *
503      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
504      *
505      * Requirements:
506      *
507      * - The caller must own the token or be an approved operator.
508      * - `tokenId` must exist.
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address to, uint256 tokenId) external;
513 
514     /**
515      * @dev Approve or remove `operator` as an operator for the caller.
516      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
517      *
518      * Requirements:
519      *
520      * - The `operator` cannot be the caller.
521      *
522      * Emits an {ApprovalForAll} event.
523      */
524     function setApprovalForAll(address operator, bool _approved) external;
525 
526     /**
527      * @dev Returns the account approved for `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function getApproved(uint256 tokenId) external view returns (address operator);
534 
535     /**
536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
537      *
538      * See {setApprovalForAll}
539      */
540     function isApprovedForAll(address owner, address operator) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 interface IERC721Metadata is IERC721 {
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() external view returns (string memory);
560 
561     /**
562      * @dev Returns the token collection symbol.
563      */
564     function symbol() external view returns (string memory);
565 
566     /**
567      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
568      */
569     function tokenURI(uint256 tokenId) external view returns (string memory);
570 }
571 
572 // File: @openzeppelin/contracts/utils/Counters.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @title Counters
581  * @author Matt Condon (@shrugs)
582  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
583  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
584  *
585  * Include with `using Counters for Counters.Counter;`
586  */
587 library Counters {
588     struct Counter {
589         // This variable should never be directly accessed by users of the library: interactions must be restricted to
590         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
591         // this feature: see https://github.com/ethereum/solidity/issues/4637
592         uint256 _value; // default: 0
593     }
594 
595     function current(Counter storage counter) internal view returns (uint256) {
596         return counter._value;
597     }
598 
599     function increment(Counter storage counter) internal {
600         unchecked {
601             counter._value += 1;
602         }
603     }
604 
605     function decrement(Counter storage counter) internal {
606         uint256 value = counter._value;
607         require(value > 0, "Counter: decrement overflow");
608         unchecked {
609             counter._value = value - 1;
610         }
611     }
612 
613     function reset(Counter storage counter) internal {
614         counter._value = 0;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/utils/Context.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @dev Provides information about the current execution context, including the
627  * sender of the transaction and its data. While these are generally available
628  * via msg.sender and msg.data, they should not be accessed in such a direct
629  * manner, since when dealing with meta-transactions the account sending and
630  * paying for execution may not be the actual sender (as far as an application
631  * is concerned).
632  *
633  * This contract is only required for intermediate, library-like contracts.
634  */
635 abstract contract Context {
636     function _msgSender() internal view virtual returns (address) {
637         return msg.sender;
638     }
639 
640     function _msgData() internal view virtual returns (bytes calldata) {
641         return msg.data;
642     }
643 }
644 
645 // File: @openzeppelin/contracts/access/Ownable.sol
646 
647 
648 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 
653 /**
654  * @dev Contract module which provides a basic access control mechanism, where
655  * there is an account (an owner) that can be granted exclusive access to
656  * specific functions.
657  *
658  * By default, the owner account will be the one that deploys the contract. This
659  * can later be changed with {transferOwnership}.
660  *
661  * This module is used through inheritance. It will make available the modifier
662  * `onlyOwner`, which can be applied to your functions to restrict their use to
663  * the owner.
664  */
665 abstract contract Ownable is Context {
666     address private _owner;
667 
668     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
669 
670     /**
671      * @dev Initializes the contract setting the deployer as the initial owner.
672      */
673     constructor() {
674         _transferOwnership(_msgSender());
675     }
676 
677     /**
678      * @dev Throws if called by any account other than the owner.
679      */
680     modifier onlyOwner() {
681         _checkOwner();
682         _;
683     }
684 
685     /**
686      * @dev Returns the address of the current owner.
687      */
688     function owner() public view virtual returns (address) {
689         return _owner;
690     }
691 
692     /**
693      * @dev Throws if the sender is not the owner.
694      */
695     function _checkOwner() internal view virtual {
696         require(owner() == _msgSender(), "Ownable: caller is not the owner");
697     }
698 
699     /**
700      * @dev Leaves the contract without owner. It will not be possible to call
701      * `onlyOwner` functions anymore. Can only be called by the current owner.
702      *
703      * NOTE: Renouncing ownership will leave the contract without an owner,
704      * thereby removing any functionality that is only available to the owner.
705      */
706     function renounceOwnership() public virtual onlyOwner {
707         _transferOwnership(address(0));
708     }
709 
710     /**
711      * @dev Transfers ownership of the contract to a new account (`newOwner`).
712      * Can only be called by the current owner.
713      */
714     function transferOwnership(address newOwner) public virtual onlyOwner {
715         require(newOwner != address(0), "Ownable: new owner is the zero address");
716         _transferOwnership(newOwner);
717     }
718 
719     /**
720      * @dev Transfers ownership of the contract to a new account (`newOwner`).
721      * Internal function without access restriction.
722      */
723     function _transferOwnership(address newOwner) internal virtual {
724         address oldOwner = _owner;
725         _owner = newOwner;
726         emit OwnershipTransferred(oldOwner, newOwner);
727     }
728 }
729 
730 // File: contracts/ERC721A.sol
731 
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 
738 
739 
740 
741 
742 error ApprovalCallerNotOwnerNorApproved();
743 error ApprovalQueryForNonexistentToken();
744 error ApproveToCaller();
745 error ApprovalToCurrentOwner();
746 error BalanceQueryForZeroAddress();
747 error MintToZeroAddress();
748 error MintZeroQuantity();
749 error OwnerQueryForNonexistentToken();
750 error TransferCallerNotOwnerNorApproved();
751 error TransferFromIncorrectOwner();
752 error TransferToNonERC721ReceiverImplementer();
753 error TransferToZeroAddress();
754 error URIQueryForNonexistentToken();
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
761  *
762  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
763  *
764  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
765  */
766 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
767     using Address for address;
768     using Strings for uint256;
769 
770     // Compiler will pack this into a single 256bit word.
771     struct TokenOwnership {
772         // The address of the owner.
773         address addr;
774         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
775         uint64 startTimestamp;
776         // Whether the token has been burned.
777         bool burned;
778     }
779 
780     // Compiler will pack this into a single 256bit word.
781     struct AddressData {
782         // Realistically, 2**64-1 is more than enough.
783         uint64 balance;
784         // Keeps track of mint count with minimal overhead for tokenomics.
785         uint64 numberMinted;
786         // Keeps track of burn count with minimal overhead for tokenomics.
787         uint64 numberBurned;
788         // For miscellaneous variable(s) pertaining to the address
789         // (e.g. number of whitelist mint slots used).
790         // If there are multiple variables, please pack them into a uint64.
791         uint64 aux;
792     }
793 
794     // The tokenId of the next token to be minted.
795     uint256 internal _currentIndex;
796 
797     // The number of tokens burned.
798     uint256 internal _burnCounter;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
808     mapping(uint256 => TokenOwnership) internal _ownerships;
809 
810     // Mapping owner address to address data
811     mapping(address => AddressData) private _addressData;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822         _currentIndex = _startTokenId();
823     }
824 
825     /**
826      * To change the starting tokenId, please override this function.
827      */
828     function _startTokenId() internal view virtual returns (uint256) {
829         return 0;
830     }
831 
832     /**
833      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
834      */
835     function totalSupply() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869         return uint256(_addressData[owner].balance);
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         return uint256(_addressData[owner].numberMinted);
877     }
878 
879     /**
880      * Returns the number of tokens burned by or on behalf of `owner`.
881      */
882     function _numberBurned(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberBurned);
884     }
885 
886     /**
887      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      */
889     function _getAux(address owner) internal view returns (uint64) {
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         _addressData[owner].aux = aux;
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr && curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915                     // Invariant:
916                     // There will always be an ownership that has an address and is not burned
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     while (true) {
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     }
926                 }
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return _ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721A.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public virtual override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1058     }
1059 
1060     /**
1061      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1062      */
1063     function _safeMint(address to, uint256 quantity) internal {
1064         _safeMint(to, quantity, '');
1065     }
1066 
1067     /**
1068      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - If `to` refers to a smart contract, it must implement 
1073      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 quantity,
1081         bytes memory _data
1082     ) internal {
1083         uint256 startTokenId = _currentIndex;
1084         if (to == address(0)) revert MintToZeroAddress();
1085         if (quantity == 0) revert MintZeroQuantity();
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are incredibly unrealistic.
1090         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1091         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1092         unchecked {
1093             _addressData[to].balance += uint64(quantity);
1094             _addressData[to].numberMinted += uint64(quantity);
1095 
1096             _ownerships[startTokenId].addr = to;
1097             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1098 
1099             uint256 updatedIndex = startTokenId;
1100             uint256 end = updatedIndex + quantity;
1101 
1102             if (to.isContract()) {
1103                 do {
1104                     emit Transfer(address(0), to, updatedIndex);
1105                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1106                         revert TransferToNonERC721ReceiverImplementer();
1107                     }
1108                 } while (updatedIndex != end);
1109                 // Reentrancy protection
1110                 if (_currentIndex != startTokenId) revert();
1111             } else {
1112                 do {
1113                     emit Transfer(address(0), to, updatedIndex++);
1114                 } while (updatedIndex != end);
1115             }
1116             _currentIndex = updatedIndex;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `quantity` must be greater than 0.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _mint(address to, uint256 quantity) internal {
1132         uint256 startTokenId = _currentIndex;
1133         if (to == address(0)) revert MintToZeroAddress();
1134         if (quantity == 0) revert MintZeroQuantity();
1135 
1136         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1137 
1138         // Overflows are incredibly unrealistic.
1139         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1140         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1141         unchecked {
1142             _addressData[to].balance += uint64(quantity);
1143             _addressData[to].numberMinted += uint64(quantity);
1144 
1145             _ownerships[startTokenId].addr = to;
1146             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1147 
1148             uint256 updatedIndex = startTokenId;
1149             uint256 end = updatedIndex + quantity;
1150 
1151             do {
1152                 emit Transfer(address(0), to, updatedIndex++);
1153             } while (updatedIndex != end);
1154 
1155             _currentIndex = updatedIndex;
1156         }
1157         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1158     }
1159 
1160     /**
1161      * @dev Transfers `tokenId` from `from` to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must be owned by `from`.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _transfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) private {
1175         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1176 
1177         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1178 
1179         bool isApprovedOrOwner = (_msgSender() == from ||
1180             isApprovedForAll(from, _msgSender()) ||
1181             getApproved(tokenId) == _msgSender());
1182 
1183         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, from);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[from].balance -= 1;
1196             _addressData[to].balance += 1;
1197 
1198             TokenOwnership storage currSlot = _ownerships[tokenId];
1199             currSlot.addr = to;
1200             currSlot.startTimestamp = uint64(block.timestamp);
1201 
1202             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1203             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1204             uint256 nextTokenId = tokenId + 1;
1205             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1206             if (nextSlot.addr == address(0)) {
1207                 // This will suffice for checking _exists(nextTokenId),
1208                 // as a burned slot cannot contain the zero address.
1209                 if (nextTokenId != _currentIndex) {
1210                     nextSlot.addr = from;
1211                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1212                 }
1213             }
1214         }
1215 
1216         emit Transfer(from, to, tokenId);
1217         _afterTokenTransfers(from, to, tokenId, 1);
1218     }
1219 
1220     /**
1221      * @dev Equivalent to `_burn(tokenId, false)`.
1222      */
1223     function _burn(uint256 tokenId) internal virtual {
1224         _burn(tokenId, false);
1225     }
1226 
1227     /**
1228      * @dev Destroys `tokenId`.
1229      * The approval is cleared when the token is burned.
1230      *
1231      * Requirements:
1232      *
1233      * - `tokenId` must exist.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1238         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1239 
1240         address from = prevOwnership.addr;
1241 
1242         if (approvalCheck) {
1243             bool isApprovedOrOwner = (_msgSender() == from ||
1244                 isApprovedForAll(from, _msgSender()) ||
1245                 getApproved(tokenId) == _msgSender());
1246 
1247             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1248         }
1249 
1250         _beforeTokenTransfers(from, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, from);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             AddressData storage addressData = _addressData[from];
1260             addressData.balance -= 1;
1261             addressData.numberBurned += 1;
1262 
1263             // Keep track of who burned the token, and the timestamp of burning.
1264             TokenOwnership storage currSlot = _ownerships[tokenId];
1265             currSlot.addr = from;
1266             currSlot.startTimestamp = uint64(block.timestamp);
1267             currSlot.burned = true;
1268 
1269             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1270             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1271             uint256 nextTokenId = tokenId + 1;
1272             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1273             if (nextSlot.addr == address(0)) {
1274                 // This will suffice for checking _exists(nextTokenId),
1275                 // as a burned slot cannot contain the zero address.
1276                 if (nextTokenId != _currentIndex) {
1277                     nextSlot.addr = from;
1278                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1279                 }
1280             }
1281         }
1282 
1283         emit Transfer(from, address(0), tokenId);
1284         _afterTokenTransfers(from, address(0), tokenId, 1);
1285 
1286         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1287         unchecked {
1288             _burnCounter++;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Approve `to` to operate on `tokenId`
1294      *
1295      * Emits a {Approval} event.
1296      */
1297     function _approve(
1298         address to,
1299         uint256 tokenId,
1300         address owner
1301     ) private {
1302         _tokenApprovals[tokenId] = to;
1303         emit Approval(owner, to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1308      *
1309      * @param from address representing the previous owner of the given token ID
1310      * @param to target address that will receive the tokens
1311      * @param tokenId uint256 ID of the token to be transferred
1312      * @param _data bytes optional data to send along with the call
1313      * @return bool whether the call correctly returned the expected magic value
1314      */
1315     function _checkContractOnERC721Received(
1316         address from,
1317         address to,
1318         uint256 tokenId,
1319         bytes memory _data
1320     ) private returns (bool) {
1321         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1322             return retval == IERC721Receiver(to).onERC721Received.selector;
1323         } catch (bytes memory reason) {
1324             if (reason.length == 0) {
1325                 revert TransferToNonERC721ReceiverImplementer();
1326             } else {
1327                 assembly {
1328                     revert(add(32, reason), mload(reason))
1329                 }
1330             }
1331         }
1332     }
1333 
1334     /**
1335      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1336      * And also called before burning one token.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` will be minted for `to`.
1346      * - When `to` is zero, `tokenId` will be burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _beforeTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1358      * minting.
1359      * And also called after one token has been burned.
1360      *
1361      * startTokenId - the first token id to be transferred
1362      * quantity - the amount to be transferred
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` has been minted for `to`.
1369      * - When `to` is zero, `tokenId` has been burned by `from`.
1370      * - `from` and `to` are never both zero.
1371      */
1372     function _afterTokenTransfers(
1373         address from,
1374         address to,
1375         uint256 startTokenId,
1376         uint256 quantity
1377     ) internal virtual {}
1378 }
1379 // File: @openzeppelin/contracts/security/Pausable.sol
1380 
1381 
1382 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 
1387 /**
1388  * @dev Contract module which allows children to implement an emergency stop
1389  * mechanism that can be triggered by an authorized account.
1390  *
1391  * This module is used through inheritance. It will make available the
1392  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1393  * the functions of your contract. Note that they will not be pausable by
1394  * simply including this module, only once the modifiers are put in place.
1395  */
1396 abstract contract Pausable is Context {
1397     /**
1398      * @dev Emitted when the pause is triggered by `account`.
1399      */
1400     event Paused(address account);
1401 
1402     /**
1403      * @dev Emitted when the pause is lifted by `account`.
1404      */
1405     event Unpaused(address account);
1406 
1407     bool private _paused;
1408 
1409     /**
1410      * @dev Initializes the contract in unpaused state.
1411      */
1412     constructor() {
1413         _paused = false;
1414     }
1415 
1416     /**
1417      * @dev Modifier to make a function callable only when the contract is not paused.
1418      *
1419      * Requirements:
1420      *
1421      * - The contract must not be paused.
1422      */
1423     modifier whenNotPaused() {
1424         _requireNotPaused();
1425         _;
1426     }
1427 
1428     /**
1429      * @dev Modifier to make a function callable only when the contract is paused.
1430      *
1431      * Requirements:
1432      *
1433      * - The contract must be paused.
1434      */
1435     modifier whenPaused() {
1436         _requirePaused();
1437         _;
1438     }
1439 
1440     /**
1441      * @dev Returns true if the contract is paused, and false otherwise.
1442      */
1443     function paused() public view virtual returns (bool) {
1444         return _paused;
1445     }
1446 
1447     /**
1448      * @dev Throws if the contract is paused.
1449      */
1450     function _requireNotPaused() internal view virtual {
1451         require(!paused(), "Pausable: paused");
1452     }
1453 
1454     /**
1455      * @dev Throws if the contract is not paused.
1456      */
1457     function _requirePaused() internal view virtual {
1458         require(paused(), "Pausable: not paused");
1459     }
1460 
1461     /**
1462      * @dev Triggers stopped state.
1463      *
1464      * Requirements:
1465      *
1466      * - The contract must not be paused.
1467      */
1468     function _pause() internal virtual whenNotPaused {
1469         _paused = true;
1470         emit Paused(_msgSender());
1471     }
1472 
1473     /**
1474      * @dev Returns to normal state.
1475      *
1476      * Requirements:
1477      *
1478      * - The contract must be paused.
1479      */
1480     function _unpause() internal virtual whenPaused {
1481         _paused = false;
1482         emit Unpaused(_msgSender());
1483     }
1484 }
1485 
1486 // File: contracts/Dustmon.sol
1487 
1488 
1489 pragma solidity ^0.8.2;
1490 
1491 
1492 
1493 
1494 contract Dustmon is ERC721A, Pausable, Ownable{
1495     using Counters for Counters.Counter;
1496     // using ECDSA for bytes32;
1497     Counters.Counter private _tokenIdCounter;
1498     bool public isRevealed;
1499     string private hash;
1500     string private baseURI;
1501     string private defaultURI = "https://dustmon-test-9328.s3.amazonaws.com/box";
1502     uint256 public priceStep = 0.001 ether;
1503     uint256 public initPrice = 0.001 ether;
1504     uint256 public maxSupply = 10000;
1505     
1506     constructor() ERC721A("Dustmons", "Dustmon") {
1507         isRevealed=false;
1508         pause();
1509     }
1510 
1511     function _baseURI() internal view override returns (string memory) {
1512         return baseURI;
1513     }
1514     function _defaultURI() internal view returns (string memory){
1515         return defaultURI;
1516     }
1517     function setBaseURI(string memory s) public onlyOwner {
1518         baseURI=s;
1519     }
1520     function pause() public onlyOwner {
1521         _pause();
1522     }
1523 
1524     function unpause() public onlyOwner {
1525         _unpause();
1526     }
1527 
1528     function setIsRevealed(bool isRevealedArg) public onlyOwner {
1529         isRevealed=isRevealedArg;
1530     }
1531     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1532         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1533         if(isRevealed){
1534             return ERC721A.tokenURI(tokenId);
1535         }else{
1536             return _defaultURI();
1537         }
1538     }
1539 
1540     function safeMint(uint256 quantity) public payable {
1541         uint256 price=getPrice();
1542  
1543         if(price==0){
1544             require(quantity==1,"you can only mint 1 free token everytime");
1545         }else{
1546             require(quantity<=5,"you can only mint 5 tokens everytime");
1547         }
1548         require(ERC721A._currentIndex+quantity<=maxSupply,"you are over our max supply");
1549         require(msg.value>=price*quantity,"not enough value");
1550         _safeMint(msg.sender, quantity);
1551     }
1552     function getPrice() public view returns (uint256) {
1553         if(isRevealed){
1554             return initPrice+priceStep*(uint((ERC721A._currentIndex)/100));
1555         }else{
1556             return 0;
1557         }
1558     }
1559     function airDrop(address to,uint256 quantity) public onlyOwner{
1560         require(ERC721A._currentIndex+quantity<maxSupply,"you are over our max supply");
1561          _safeMint(to, quantity);
1562     }
1563 
1564     function withdraw() public onlyOwner {
1565         require(address(this).balance>0,"Balance must > 0");
1566         payable(owner()).transfer(address(this).balance);
1567     }
1568     function _beforeTokenTransfers( 
1569         address from,
1570         address to,
1571         uint256 startTokenId,
1572         uint256 quantity
1573         )
1574         internal
1575         whenNotPaused
1576         override
1577     {
1578         super._beforeTokenTransfers(from,to,startTokenId,quantity);
1579     }
1580 
1581     // take the keccak256 hashed message from the getHash function above and input into this function
1582     // this function prefixes the hash above with \x19Ethereum signed message:\n32 + hash
1583     // and produces a new hash signature
1584 
1585 }