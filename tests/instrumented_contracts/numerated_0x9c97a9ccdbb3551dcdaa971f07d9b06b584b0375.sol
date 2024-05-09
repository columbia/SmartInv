1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Counters.sol
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @title Counters
75  * @author Matt Condon (@shrugs)
76  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
77  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
78  *
79  * Include with `using Counters for Counters.Counter;`
80  */
81 library Counters {
82     struct Counter {
83         // This variable should never be directly accessed by users of the library: interactions must be restricted to
84         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
85         // this feature: see https://github.com/ethereum/solidity/issues/4637
86         uint256 _value; // default: 0
87     }
88 
89     function current(Counter storage counter) internal view returns (uint256) {
90         return counter._value;
91     }
92 
93     function increment(Counter storage counter) internal {
94         unchecked {
95             counter._value += 1;
96         }
97     }
98 
99     function decrement(Counter storage counter) internal {
100         uint256 value = counter._value;
101         require(value > 0, "Counter: decrement overflow");
102         unchecked {
103             counter._value = value - 1;
104         }
105     }
106 
107     function reset(Counter storage counter) internal {
108         counter._value = 0;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Strings.sol
113 
114 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123     uint8 private constant _ADDRESS_LENGTH = 20;
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
127      */
128     function toString(uint256 value) internal pure returns (string memory) {
129         // Inspired by OraclizeAPI's implementation - MIT licence
130         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
131 
132         if (value == 0) {
133             return "0";
134         }
135         uint256 temp = value;
136         uint256 digits;
137         while (temp != 0) {
138             digits++;
139             temp /= 10;
140         }
141         bytes memory buffer = new bytes(digits);
142         while (value != 0) {
143             digits -= 1;
144             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
145             value /= 10;
146         }
147         return string(buffer);
148     }
149 
150     /**
151      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
152      */
153     function toHexString(uint256 value) internal pure returns (string memory) {
154         if (value == 0) {
155             return "0x00";
156         }
157         uint256 temp = value;
158         uint256 length = 0;
159         while (temp != 0) {
160             length++;
161             temp >>= 8;
162         }
163         return toHexString(value, length);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
168      */
169     function toHexString(uint256 value, uint256 length)
170         internal
171         pure
172         returns (string memory)
173     {
174         bytes memory buffer = new bytes(2 * length + 2);
175         buffer[0] = "0";
176         buffer[1] = "x";
177         for (uint256 i = 2 * length + 1; i > 1; --i) {
178             buffer[i] = _HEX_SYMBOLS[value & 0xf];
179             value >>= 4;
180         }
181         require(value == 0, "Strings: hex length insufficient");
182         return string(buffer);
183     }
184 
185     /**
186      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
187      */
188     function toHexString(address addr) internal pure returns (string memory) {
189         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
190     }
191 }
192 
193 // File: @openzeppelin/contracts/utils/Context.sol
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Contract module which provides a basic access control mechanism, where
227  * there is an account (an owner) that can be granted exclusive access to
228  * specific functions.
229  *
230  * By default, the owner account will be the one that deploys the contract. This
231  * can later be changed with {transferOwnership}.
232  *
233  * This module is used through inheritance. It will make available the modifier
234  * `onlyOwner`, which can be applied to your functions to restrict their use to
235  * the owner.
236  */
237 abstract contract Ownable is Context {
238     address private _owner;
239 
240     event OwnershipTransferred(
241         address indexed previousOwner,
242         address indexed newOwner
243     );
244 
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor() {
249         _transferOwnership(_msgSender());
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         _checkOwner();
257         _;
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if the sender is not the owner.
269      */
270     function _checkOwner() internal view virtual {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(
291             newOwner != address(0),
292             "Ownable: new owner is the zero address"
293         );
294         _transferOwnership(newOwner);
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Internal function without access restriction.
300      */
301     function _transferOwnership(address newOwner) internal virtual {
302         address oldOwner = _owner;
303         _owner = newOwner;
304         emit OwnershipTransferred(oldOwner, newOwner);
305     }
306 }
307 
308 // File: @openzeppelin/contracts/utils/Address.sol
309 
310 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
311 
312 pragma solidity ^0.8.1;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      *
335      * [IMPORTANT]
336      * ====
337      * You shouldn't rely on `isContract` to protect against flash loan attacks!
338      *
339      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
340      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
341      * constructor.
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize/address.code.length, which returns 0
346         // for contracts in construction, since the code is only stored at the end
347         // of the constructor execution.
348 
349         return account.code.length > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(
370             address(this).balance >= amount,
371             "Address: insufficient balance"
372         );
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(
376             success,
377             "Address: unable to send value, recipient may have reverted"
378         );
379     }
380 
381     /**
382      * @dev Performs a Solidity function call using a low level `call`. A
383      * plain `call` is an unsafe replacement for a function call: use this
384      * function instead.
385      *
386      * If `target` reverts with a revert reason, it is bubbled up by this
387      * function (like regular Solidity function calls).
388      *
389      * Returns the raw returned data. To convert to the expected return value,
390      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
391      *
392      * Requirements:
393      *
394      * - `target` must be a contract.
395      * - calling `target` with `data` must not revert.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(address target, bytes memory data)
400         internal
401         returns (bytes memory)
402     {
403         return functionCall(target, data, "Address: low-level call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
408      * `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, 0, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but also transferring `value` wei to `target`.
423      *
424      * Requirements:
425      *
426      * - the calling contract must have an ETH balance of at least `value`.
427      * - the called Solidity function must be `payable`.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value
435     ) internal returns (bytes memory) {
436         return
437             functionCallWithValue(
438                 target,
439                 data,
440                 value,
441                 "Address: low-level call with value failed"
442             );
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(
452         address target,
453         bytes memory data,
454         uint256 value,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(
458             address(this).balance >= value,
459             "Address: insufficient balance for call"
460         );
461         require(isContract(target), "Address: call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.call{value: value}(
464             data
465         );
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data)
476         internal
477         view
478         returns (bytes memory)
479     {
480         return
481             functionStaticCall(
482                 target,
483                 data,
484                 "Address: low-level static call failed"
485             );
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a static call.
491      *
492      * _Available since v3.3._
493      */
494     function functionStaticCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal view returns (bytes memory) {
499         require(isContract(target), "Address: static call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.staticcall(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(address target, bytes memory data)
512         internal
513         returns (bytes memory)
514     {
515         return
516             functionDelegateCall(
517                 target,
518                 data,
519                 "Address: low-level delegate call failed"
520             );
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a delegate call.
526      *
527      * _Available since v3.4._
528      */
529     function functionDelegateCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(isContract(target), "Address: delegate call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.delegatecall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
542      * revert reason using the provided one.
543      *
544      * _Available since v4.3._
545      */
546     function verifyCallResult(
547         bool success,
548         bytes memory returndata,
549         string memory errorMessage
550     ) internal pure returns (bytes memory) {
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557                 /// @solidity memory-safe-assembly
558                 assembly {
559                     let returndata_size := mload(returndata)
560                     revert(add(32, returndata), returndata_size)
561                 }
562             } else {
563                 revert(errorMessage);
564             }
565         }
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
570 
571 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @title ERC721 token receiver interface
577  * @dev Interface for any contract that wants to support safeTransfers
578  * from ERC721 asset contracts.
579  */
580 interface IERC721Receiver {
581     /**
582      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
583      * by `operator` from `from`, this function is called.
584      *
585      * It must return its Solidity selector to confirm the token transfer.
586      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
587      *
588      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
589      */
590     function onERC721Received(
591         address operator,
592         address from,
593         uint256 tokenId,
594         bytes calldata data
595     ) external returns (bytes4);
596 }
597 
598 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
599 
600 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Interface of the ERC165 standard, as defined in the
606  * https://eips.ethereum.org/EIPS/eip-165[EIP].
607  *
608  * Implementers can declare support of contract interfaces, which can then be
609  * queried by others ({ERC165Checker}).
610  *
611  * For an implementation, see {ERC165}.
612  */
613 interface IERC165 {
614     /**
615      * @dev Returns true if this contract implements the interface defined by
616      * `interfaceId`. See the corresponding
617      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
618      * to learn more about how these ids are created.
619      *
620      * This function call must use less than 30 000 gas.
621      */
622     function supportsInterface(bytes4 interfaceId) external view returns (bool);
623 }
624 
625 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
626 
627 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Implementation of the {IERC165} interface.
633  *
634  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
635  * for the additional interface id that will be supported. For example:
636  *
637  * ```solidity
638  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
640  * }
641  * ```
642  *
643  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
644  */
645 abstract contract ERC165 is IERC165 {
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId)
650         public
651         view
652         virtual
653         override
654         returns (bool)
655     {
656         return interfaceId == type(IERC165).interfaceId;
657     }
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
661 
662 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Required interface of an ERC721 compliant contract.
668  */
669 interface IERC721 is IERC165 {
670     /**
671      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
672      */
673     event Transfer(
674         address indexed from,
675         address indexed to,
676         uint256 indexed tokenId
677     );
678 
679     /**
680      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
681      */
682     event Approval(
683         address indexed owner,
684         address indexed approved,
685         uint256 indexed tokenId
686     );
687 
688     /**
689      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
690      */
691     event ApprovalForAll(
692         address indexed owner,
693         address indexed operator,
694         bool approved
695     );
696 
697     /**
698      * @dev Returns the number of tokens in ``owner``'s account.
699      */
700     function balanceOf(address owner) external view returns (uint256 balance);
701 
702     /**
703      * @dev Returns the owner of the `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function ownerOf(uint256 tokenId) external view returns (address owner);
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes calldata data
729     ) external;
730 
731     /**
732      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
733      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
741      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
742      *
743      * Emits a {Transfer} event.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) external;
750 
751     /**
752      * @dev Transfers `tokenId` token from `from` to `to`.
753      *
754      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
755      *
756      * Requirements:
757      *
758      * - `from` cannot be the zero address.
759      * - `to` cannot be the zero address.
760      * - `tokenId` token must be owned by `from`.
761      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
762      *
763      * Emits a {Transfer} event.
764      */
765     function transferFrom(
766         address from,
767         address to,
768         uint256 tokenId
769     ) external;
770 
771     /**
772      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
773      * The approval is cleared when the token is transferred.
774      *
775      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
776      *
777      * Requirements:
778      *
779      * - The caller must own the token or be an approved operator.
780      * - `tokenId` must exist.
781      *
782      * Emits an {Approval} event.
783      */
784     function approve(address to, uint256 tokenId) external;
785 
786     /**
787      * @dev Approve or remove `operator` as an operator for the caller.
788      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
789      *
790      * Requirements:
791      *
792      * - The `operator` cannot be the caller.
793      *
794      * Emits an {ApprovalForAll} event.
795      */
796     function setApprovalForAll(address operator, bool _approved) external;
797 
798     /**
799      * @dev Returns the account approved for `tokenId` token.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function getApproved(uint256 tokenId)
806         external
807         view
808         returns (address operator);
809 
810     /**
811      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
812      *
813      * See {setApprovalForAll}
814      */
815     function isApprovedForAll(address owner, address operator)
816         external
817         view
818         returns (bool);
819 }
820 
821 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
822 
823 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
829  * @dev See https://eips.ethereum.org/EIPS/eip-721
830  */
831 interface IERC721Metadata is IERC721 {
832     /**
833      * @dev Returns the token collection name.
834      */
835     function name() external view returns (string memory);
836 
837     /**
838      * @dev Returns the token collection symbol.
839      */
840     function symbol() external view returns (string memory);
841 
842     /**
843      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
844      */
845     function tokenURI(uint256 tokenId) external view returns (string memory);
846 }
847 
848 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
849 
850 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 /**
855  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
856  * the Metadata extension, but not including the Enumerable extension, which is available separately as
857  * {ERC721Enumerable}.
858  */
859 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
860     using Address for address;
861     using Strings for uint256;
862 
863     // Token name
864     string private _name;
865 
866     // Token symbol
867     string private _symbol;
868 
869     // Mapping from token ID to owner address
870     mapping(uint256 => address) private _owners;
871 
872     // Mapping owner address to token count
873     mapping(address => uint256) private _balances;
874 
875     // Mapping from token ID to approved address
876     mapping(uint256 => address) private _tokenApprovals;
877 
878     // Mapping from owner to operator approvals
879     mapping(address => mapping(address => bool)) private _operatorApprovals;
880 
881     /**
882      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
883      */
884     constructor(string memory name_, string memory symbol_) {
885         _name = name_;
886         _symbol = symbol_;
887     }
888 
889     /**
890      * @dev See {IERC165-supportsInterface}.
891      */
892     function supportsInterface(bytes4 interfaceId)
893         public
894         view
895         virtual
896         override(ERC165, IERC165)
897         returns (bool)
898     {
899         return
900             interfaceId == type(IERC721).interfaceId ||
901             interfaceId == type(IERC721Metadata).interfaceId ||
902             super.supportsInterface(interfaceId);
903     }
904 
905     /**
906      * @dev See {IERC721-balanceOf}.
907      */
908     function balanceOf(address owner)
909         public
910         view
911         virtual
912         override
913         returns (uint256)
914     {
915         require(
916             owner != address(0),
917             "ERC721: address zero is not a valid owner"
918         );
919         return _balances[owner];
920     }
921 
922     /**
923      * @dev See {IERC721-ownerOf}.
924      */
925     function ownerOf(uint256 tokenId)
926         public
927         view
928         virtual
929         override
930         returns (address)
931     {
932         address owner = _owners[tokenId];
933         require(owner != address(0), "ERC721: invalid token ID");
934         return owner;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId)
955         public
956         view
957         virtual
958         override
959         returns (string memory)
960     {
961         _requireMinted(tokenId);
962 
963         string memory baseURI = _baseURI();
964         return
965             bytes(baseURI).length > 0
966                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
967                 : "";
968     }
969 
970     /**
971      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
972      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
973      * by default, can be overridden in child contracts.
974      */
975     function _baseURI() internal view virtual returns (string memory) {
976         return "";
977     }
978 
979     /**
980      * @dev See {IERC721-approve}.
981      */
982     function approve(address to, uint256 tokenId) public virtual override {
983         address owner = ERC721.ownerOf(tokenId);
984         require(to != owner, "ERC721: approval to current owner");
985 
986         require(
987             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
988             "ERC721: approve caller is not token owner nor approved for all"
989         );
990 
991         _approve(to, tokenId);
992     }
993 
994     /**
995      * @dev See {IERC721-getApproved}.
996      */
997     function getApproved(uint256 tokenId)
998         public
999         view
1000         virtual
1001         override
1002         returns (address)
1003     {
1004         _requireMinted(tokenId);
1005 
1006         return _tokenApprovals[tokenId];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-setApprovalForAll}.
1011      */
1012     function setApprovalForAll(address operator, bool approved)
1013         public
1014         virtual
1015         override
1016     {
1017         _setApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator)
1024         public
1025         view
1026         virtual
1027         override
1028         returns (bool)
1029     {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         //solhint-disable-next-line max-line-length
1042         require(
1043             _isApprovedOrOwner(_msgSender(), tokenId),
1044             "ERC721: caller is not token owner nor approved"
1045         );
1046 
1047         _transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         safeTransferFrom(from, to, tokenId, "");
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory data
1069     ) public virtual override {
1070         require(
1071             _isApprovedOrOwner(_msgSender(), tokenId),
1072             "ERC721: caller is not token owner nor approved"
1073         );
1074         _safeTransfer(from, to, tokenId, data);
1075     }
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1079      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1080      *
1081      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1082      *
1083      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1084      * implement alternative mechanisms to perform token transfer, such as signature-based.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _safeTransfer(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory data
1100     ) internal virtual {
1101         _transfer(from, to, tokenId);
1102         require(
1103             _checkOnERC721Received(from, to, tokenId, data),
1104             "ERC721: transfer to non ERC721Receiver implementer"
1105         );
1106     }
1107 
1108     /**
1109      * @dev Returns whether `tokenId` exists.
1110      *
1111      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1112      *
1113      * Tokens start existing when they are minted (`_mint`),
1114      * and stop existing when they are burned (`_burn`).
1115      */
1116     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1117         return _owners[tokenId] != address(0);
1118     }
1119 
1120     /**
1121      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      */
1127     function _isApprovedOrOwner(address spender, uint256 tokenId)
1128         internal
1129         view
1130         virtual
1131         returns (bool)
1132     {
1133         address owner = ERC721.ownerOf(tokenId);
1134         return (spender == owner ||
1135             isApprovedForAll(owner, spender) ||
1136             getApproved(tokenId) == spender);
1137     }
1138 
1139     /**
1140      * @dev Safely mints `tokenId` and transfers it to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must not exist.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeMint(address to, uint256 tokenId) internal virtual {
1150         _safeMint(to, tokenId, "");
1151     }
1152 
1153     /**
1154      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1155      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 tokenId,
1160         bytes memory data
1161     ) internal virtual {
1162         _mint(to, tokenId);
1163         require(
1164             _checkOnERC721Received(address(0), to, tokenId, data),
1165             "ERC721: transfer to non ERC721Receiver implementer"
1166         );
1167     }
1168 
1169     /**
1170      * @dev Mints `tokenId` and transfers it to `to`.
1171      *
1172      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must not exist.
1177      * - `to` cannot be the zero address.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _mint(address to, uint256 tokenId) internal virtual {
1182         require(to != address(0), "ERC721: mint to the zero address");
1183         require(!_exists(tokenId), "ERC721: token already minted");
1184 
1185         _beforeTokenTransfer(address(0), to, tokenId);
1186 
1187         _balances[to] += 1;
1188         _owners[tokenId] = to;
1189 
1190         emit Transfer(address(0), to, tokenId);
1191 
1192         _afterTokenTransfer(address(0), to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         address owner = ERC721.ownerOf(tokenId);
1207 
1208         _beforeTokenTransfer(owner, address(0), tokenId);
1209 
1210         // Clear approvals
1211         _approve(address(0), tokenId);
1212 
1213         _balances[owner] -= 1;
1214         delete _owners[tokenId];
1215 
1216         emit Transfer(owner, address(0), tokenId);
1217 
1218         _afterTokenTransfer(owner, address(0), tokenId);
1219     }
1220 
1221     /**
1222      * @dev Transfers `tokenId` from `from` to `to`.
1223      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1224      *
1225      * Requirements:
1226      *
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must be owned by `from`.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _transfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) internal virtual {
1237         require(
1238             ERC721.ownerOf(tokenId) == from,
1239             "ERC721: transfer from incorrect owner"
1240         );
1241         require(to != address(0), "ERC721: transfer to the zero address");
1242 
1243         _beforeTokenTransfer(from, to, tokenId);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId);
1247 
1248         _balances[from] -= 1;
1249         _balances[to] += 1;
1250         _owners[tokenId] = to;
1251 
1252         emit Transfer(from, to, tokenId);
1253 
1254         _afterTokenTransfer(from, to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Approve `to` to operate on `tokenId`
1259      *
1260      * Emits an {Approval} event.
1261      */
1262     function _approve(address to, uint256 tokenId) internal virtual {
1263         _tokenApprovals[tokenId] = to;
1264         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev Approve `operator` to operate on all of `owner` tokens
1269      *
1270      * Emits an {ApprovalForAll} event.
1271      */
1272     function _setApprovalForAll(
1273         address owner,
1274         address operator,
1275         bool approved
1276     ) internal virtual {
1277         require(owner != operator, "ERC721: approve to caller");
1278         _operatorApprovals[owner][operator] = approved;
1279         emit ApprovalForAll(owner, operator, approved);
1280     }
1281 
1282     /**
1283      * @dev Reverts if the `tokenId` has not been minted yet.
1284      */
1285     function _requireMinted(uint256 tokenId) internal view virtual {
1286         require(_exists(tokenId), "ERC721: invalid token ID");
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1291      * The call is not executed if the target address is not a contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory data
1304     ) private returns (bool) {
1305         if (to.isContract()) {
1306             try
1307                 IERC721Receiver(to).onERC721Received(
1308                     _msgSender(),
1309                     from,
1310                     tokenId,
1311                     data
1312                 )
1313             returns (bytes4 retval) {
1314                 return retval == IERC721Receiver.onERC721Received.selector;
1315             } catch (bytes memory reason) {
1316                 if (reason.length == 0) {
1317                     revert(
1318                         "ERC721: transfer to non ERC721Receiver implementer"
1319                     );
1320                 } else {
1321                     /// @solidity memory-safe-assembly
1322                     assembly {
1323                         revert(add(32, reason), mload(reason))
1324                     }
1325                 }
1326             }
1327         } else {
1328             return true;
1329         }
1330     }
1331 
1332     /**
1333      * @dev Hook that is called before any token transfer. This includes minting
1334      * and burning.
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1342      * - `from` and `to` are never both zero.
1343      *
1344      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1345      */
1346     function _beforeTokenTransfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) internal virtual {}
1351 
1352     /**
1353      * @dev Hook that is called after any transfer of tokens. This includes
1354      * minting and burning.
1355      *
1356      * Calling conditions:
1357      *
1358      * - when `from` and `to` are both non-zero.
1359      * - `from` and `to` are never both zero.
1360      *
1361      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1362      */
1363     function _afterTokenTransfer(
1364         address from,
1365         address to,
1366         uint256 tokenId
1367     ) internal virtual {}
1368 }
1369 
1370 // File: contracts/HamsterJamz.sol
1371 
1372 pragma solidity >=0.7.0 <0.9.0;
1373 
1374 contract HamsterJamz is ERC721, Ownable, ReentrancyGuard {
1375     using Strings for uint256;
1376     using Counters for Counters.Counter;
1377 
1378     Counters.Counter private supply;
1379 
1380     string public uriPrefix = "";
1381     string public uriSuffix = ".json";
1382     string public hiddenMetadataUri;
1383 
1384     uint256 public cost = 10000000000000000;
1385     uint256 public maxSupply = 10000;
1386     uint256 public maxMintAmount = 200;
1387     uint256 public reservedForTeam = 1000;
1388 
1389     bool public paused = true;
1390     bool public revealed = false;
1391 
1392     mapping(address => bool) public freeMinted;
1393 
1394     constructor() ERC721("HAMSTERJAMZ", "HJAMZ") {
1395         setHiddenMetadataUri("ipfs://QmY5aEWA9q2xz7ibfbBYYVxqjP2BZSTRUrwfRX9iy75mMb/hidden.json");
1396     }
1397 
1398     modifier isPaused() {
1399         require(!paused, "The contract is paused!");
1400         _;
1401     }
1402 
1403     function totalSupply() public view returns (uint256) {
1404         return supply.current();
1405     }
1406 
1407     function mint(uint256 _mintAmount) public payable isPaused nonReentrant {
1408         uint256 tokenCount = balanceOf(msg.sender);
1409 
1410         require(tokenCount + _mintAmount <= maxMintAmount, "Limit token");
1411         require(
1412             supply.current() + _mintAmount <= maxSupply - reservedForTeam,
1413             "Max supply exceeded"
1414         );
1415 
1416         if (freeMinted[msg.sender]) {
1417             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1418         } else {
1419             require(
1420                 msg.value >= (cost * _mintAmount) - cost,
1421                 "Insufficient funds!"
1422             );
1423             freeMinted[msg.sender] = true;
1424         }
1425 
1426         _mintLoop(msg.sender, _mintAmount);
1427     }
1428 
1429     function airdrop(uint256 _mintAmount, address _to)
1430         public
1431         onlyOwner
1432         isPaused
1433         nonReentrant
1434     {
1435         require(reservedForTeam >= _mintAmount, "Limit tokens for team");
1436         reservedForTeam -= _mintAmount;
1437         _mintLoop(_to, _mintAmount);
1438     }
1439 
1440     function publicAirdrop(uint256 _mintAmount, address _to)
1441         public
1442         onlyOwner
1443         isPaused
1444         nonReentrant
1445     {
1446         require(
1447             supply.current() + _mintAmount <= maxSupply - reservedForTeam,
1448             "Max supply exceeded"
1449         );
1450 
1451         _mintLoop(_to, _mintAmount);
1452     }
1453 
1454     function walletOfOwner(address _owner)
1455         public
1456         view
1457         returns (uint256[] memory)
1458     {
1459         uint256 ownerTokenCount = balanceOf(_owner);
1460         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1461         uint256 currentTokenId = 1;
1462         uint256 ownedTokenIndex = 0;
1463 
1464         while (
1465             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1466         ) {
1467             address currentTokenOwner = ownerOf(currentTokenId);
1468 
1469             if (currentTokenOwner == _owner) {
1470                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1471 
1472                 ownedTokenIndex++;
1473             }
1474 
1475             currentTokenId++;
1476         }
1477 
1478         return ownedTokenIds;
1479     }
1480 
1481     function tokenURI(uint256 _tokenId)
1482         public
1483         view
1484         virtual
1485         override
1486         returns (string memory)
1487     {
1488         require(
1489             _exists(_tokenId),
1490             "ERC721Metadata: URI query for nonexistent token"
1491         );
1492 
1493         if (revealed == false) {
1494             return hiddenMetadataUri;
1495         }
1496 
1497         string memory currentBaseURI = _baseURI();
1498         return
1499             bytes(currentBaseURI).length > 0
1500                 ? string(
1501                     abi.encodePacked(
1502                         currentBaseURI,
1503                         _tokenId.toString(),
1504                         uriSuffix
1505                     )
1506                 )
1507                 : "";
1508     }
1509 
1510     function setRevealed(bool _state) public onlyOwner nonReentrant {
1511         revealed = _state;
1512     }
1513 
1514     function setCost(uint256 _cost) public onlyOwner nonReentrant {
1515         cost = _cost;
1516     }
1517 
1518     function setMaxMintAmount(uint256 _maxMintAmount)
1519         public
1520         onlyOwner
1521         nonReentrant
1522     {
1523         maxMintAmount = _maxMintAmount;
1524     }
1525 
1526     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1527         public
1528         onlyOwner
1529         nonReentrant
1530     {
1531         hiddenMetadataUri = _hiddenMetadataUri;
1532     }
1533 
1534     function setUriPrefix(string memory _uriPrefix)
1535         public
1536         onlyOwner
1537         nonReentrant
1538     {
1539         uriPrefix = _uriPrefix;
1540     }
1541 
1542     function setUriSuffix(string memory _uriSuffix)
1543         public
1544         onlyOwner
1545         nonReentrant
1546     {
1547         uriSuffix = _uriSuffix;
1548     }
1549 
1550     function setPaused(bool _state) public onlyOwner nonReentrant {
1551         paused = _state;
1552     }
1553 
1554     function setReservedForTeam(uint256 _count) public onlyOwner nonReentrant {
1555         reservedForTeam = _count;
1556     }
1557 
1558     function withdraw() public onlyOwner nonReentrant {
1559         uint256 amount = (address(this).balance * 25) / 100;
1560 
1561         (bool s1, ) = payable(0x5a21EB456CfB2844521bAC85584E6f1e1Aa4d019).call{value: amount}("");
1562         require(s1);
1563 
1564         (bool s2, ) = payable(0x83D8f0d7Bc878EDee5EE3d78003D5aca83E16675).call{value: amount}("");
1565         require(s2);
1566 
1567         (bool s3, ) = payable(0x674f95EC5bf01803DBbb21fB99612E64F1cc2743).call{value: amount}("");
1568         require(s3);
1569 
1570         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1571         require(os);
1572     }
1573 
1574     function emergencywithdraw() public payable onlyOwner nonReentrant {
1575         (bool fa, ) = payable(owner()).call{value: address(this).balance}("");
1576         require(fa);
1577     }
1578 
1579     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1580         for (uint256 i = 0; i < _mintAmount; i++) {
1581             supply.increment();
1582             _safeMint(_receiver, supply.current());
1583         }
1584     }
1585 
1586     function _baseURI() internal view virtual override returns (string memory) {
1587         return uriPrefix;
1588     }
1589 }