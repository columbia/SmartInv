1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Counters.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @title Counters
77  * @author Matt Condon (@shrugs)
78  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
79  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
80  *
81  * Include with `using Counters for Counters.Counter;`
82  */
83 library Counters {
84     struct Counter {
85         // This variable should never be directly accessed by users of the library: interactions must be restricted to
86         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
87         // this feature: see https://github.com/ethereum/solidity/issues/4637
88         uint256 _value; // default: 0
89     }
90 
91     function current(Counter storage counter) internal view returns (uint256) {
92         return counter._value;
93     }
94 
95     function increment(Counter storage counter) internal {
96         unchecked {
97             counter._value += 1;
98         }
99     }
100 
101     function decrement(Counter storage counter) internal {
102         uint256 value = counter._value;
103         require(value > 0, "Counter: decrement overflow");
104         unchecked {
105             counter._value = value - 1;
106         }
107     }
108 
109     function reset(Counter storage counter) internal {
110         counter._value = 0;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126     uint8 private constant _ADDRESS_LENGTH = 20;
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 
184     /**
185      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
186      */
187     function toHexString(address addr) internal pure returns (string memory) {
188         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
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
221 
222 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         _checkOwner();
256         _;
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if the sender is not the owner.
268      */
269     function _checkOwner() internal view virtual {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Address.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
308 
309 pragma solidity ^0.8.1;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      *
332      * [IMPORTANT]
333      * ====
334      * You shouldn't rely on `isContract` to protect against flash loan attacks!
335      *
336      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
337      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
338      * constructor.
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize/address.code.length, which returns 0
343         // for contracts in construction, since the code is only stored at the end
344         // of the constructor execution.
345 
346         return account.code.length > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517                 /// @solidity memory-safe-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @title ERC721 token receiver interface
538  * @dev Interface for any contract that wants to support safeTransfers
539  * from ERC721 asset contracts.
540  */
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Interface of the ERC165 standard, as defined in the
568  * https://eips.ethereum.org/EIPS/eip-165[EIP].
569  *
570  * Implementers can declare support of contract interfaces, which can then be
571  * queried by others ({ERC165Checker}).
572  *
573  * For an implementation, see {ERC165}.
574  */
575 interface IERC165 {
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30 000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) external view returns (bool);
585 }
586 
587 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
619 
620 
621 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Required interface of an ERC721 compliant contract.
628  */
629 interface IERC721 is IERC165 {
630     /**
631      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
637      */
638     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
644 
645     /**
646      * @dev Returns the number of tokens in ``owner``'s account.
647      */
648     function balanceOf(address owner) external view returns (uint256 balance);
649 
650     /**
651      * @dev Returns the owner of the `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function ownerOf(uint256 tokenId) external view returns (address owner);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes calldata data
677     ) external;
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
681      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Transfers `tokenId` token from `from` to `to`.
701      *
702      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must be owned by `from`.
709      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
710      *
711      * Emits a {Transfer} event.
712      */
713     function transferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) external;
718 
719     /**
720      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
721      * The approval is cleared when the token is transferred.
722      *
723      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
724      *
725      * Requirements:
726      *
727      * - The caller must own the token or be an approved operator.
728      * - `tokenId` must exist.
729      *
730      * Emits an {Approval} event.
731      */
732     function approve(address to, uint256 tokenId) external;
733 
734     /**
735      * @dev Approve or remove `operator` as an operator for the caller.
736      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
737      *
738      * Requirements:
739      *
740      * - The `operator` cannot be the caller.
741      *
742      * Emits an {ApprovalForAll} event.
743      */
744     function setApprovalForAll(address operator, bool _approved) external;
745 
746     /**
747      * @dev Returns the account approved for `tokenId` token.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function getApproved(uint256 tokenId) external view returns (address operator);
754 
755     /**
756      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
757      *
758      * See {setApprovalForAll}
759      */
760     function isApprovedForAll(address owner, address operator) external view returns (bool);
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Metadata is IERC721 {
776     /**
777      * @dev Returns the token collection name.
778      */
779     function name() external view returns (string memory);
780 
781     /**
782      * @dev Returns the token collection symbol.
783      */
784     function symbol() external view returns (string memory);
785 
786     /**
787      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
788      */
789     function tokenURI(uint256 tokenId) external view returns (string memory);
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
793 
794 
795 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 
801 
802 
803 
804 
805 
806 /**
807  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
808  * the Metadata extension, but not including the Enumerable extension, which is available separately as
809  * {ERC721Enumerable}.
810  */
811 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
812     using Address for address;
813     using Strings for uint256;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to owner address
822     mapping(uint256 => address) private _owners;
823 
824     // Mapping owner address to token count
825     mapping(address => uint256) private _balances;
826 
827     // Mapping from token ID to approved address
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     /**
834      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
835      */
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner) public view virtual override returns (uint256) {
855         require(owner != address(0), "ERC721: address zero is not a valid owner");
856         return _balances[owner];
857     }
858 
859     /**
860      * @dev See {IERC721-ownerOf}.
861      */
862     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
863         address owner = _owners[tokenId];
864         require(owner != address(0), "ERC721: invalid token ID");
865         return owner;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-name}.
870      */
871     function name() public view virtual override returns (string memory) {
872         return _name;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-symbol}.
877      */
878     function symbol() public view virtual override returns (string memory) {
879         return _symbol;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-tokenURI}.
884      */
885     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
886         _requireMinted(tokenId);
887 
888         string memory baseURI = _baseURI();
889         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
890     }
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, can be overridden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return "";
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public virtual override {
905         address owner = ERC721.ownerOf(tokenId);
906         require(to != owner, "ERC721: approval to current owner");
907 
908         require(
909             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
910             "ERC721: approve caller is not token owner nor approved for all"
911         );
912 
913         _approve(to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view virtual override returns (address) {
920         _requireMinted(tokenId);
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         _setApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         //solhint-disable-next-line max-line-length
948         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
949 
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         safeTransferFrom(from, to, tokenId, "");
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory data
972     ) public virtual override {
973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
974         _safeTransfer(from, to, tokenId, data);
975     }
976 
977     /**
978      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
979      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
980      *
981      * `data` is additional data, it has no specified format and it is sent in call to `to`.
982      *
983      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
984      * implement alternative mechanisms to perform token transfer, such as signature-based.
985      *
986      * Requirements:
987      *
988      * - `from` cannot be the zero address.
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must exist and be owned by `from`.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _safeTransfer(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory data
1000     ) internal virtual {
1001         _transfer(from, to, tokenId);
1002         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1003     }
1004 
1005     /**
1006      * @dev Returns whether `tokenId` exists.
1007      *
1008      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1009      *
1010      * Tokens start existing when they are minted (`_mint`),
1011      * and stop existing when they are burned (`_burn`).
1012      */
1013     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1014         return _owners[tokenId] != address(0);
1015     }
1016 
1017     /**
1018      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1025         address owner = ERC721.ownerOf(tokenId);
1026         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1027     }
1028 
1029     /**
1030      * @dev Safely mints `tokenId` and transfers it to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must not exist.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _safeMint(address to, uint256 tokenId) internal virtual {
1040         _safeMint(to, tokenId, "");
1041     }
1042 
1043     /**
1044      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1045      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1046      */
1047     function _safeMint(
1048         address to,
1049         uint256 tokenId,
1050         bytes memory data
1051     ) internal virtual {
1052         _mint(to, tokenId);
1053         require(
1054             _checkOnERC721Received(address(0), to, tokenId, data),
1055             "ERC721: transfer to non ERC721Receiver implementer"
1056         );
1057     }
1058 
1059     /**
1060      * @dev Mints `tokenId` and transfers it to `to`.
1061      *
1062      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must not exist.
1067      * - `to` cannot be the zero address.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(address to, uint256 tokenId) internal virtual {
1072         require(to != address(0), "ERC721: mint to the zero address");
1073         require(!_exists(tokenId), "ERC721: token already minted");
1074 
1075         _beforeTokenTransfer(address(0), to, tokenId);
1076 
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(address(0), to, tokenId);
1081 
1082         _afterTokenTransfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107 
1108         _afterTokenTransfer(owner, address(0), tokenId);
1109     }
1110 
1111     /**
1112      * @dev Transfers `tokenId` from `from` to `to`.
1113      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `tokenId` token must be owned by `from`.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {
1127         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1128         require(to != address(0), "ERC721: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, tokenId);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId);
1134 
1135         _balances[from] -= 1;
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(from, to, tokenId);
1140 
1141         _afterTokenTransfer(from, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Approve `to` to operate on `tokenId`
1146      *
1147      * Emits an {Approval} event.
1148      */
1149     function _approve(address to, uint256 tokenId) internal virtual {
1150         _tokenApprovals[tokenId] = to;
1151         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Approve `operator` to operate on all of `owner` tokens
1156      *
1157      * Emits an {ApprovalForAll} event.
1158      */
1159     function _setApprovalForAll(
1160         address owner,
1161         address operator,
1162         bool approved
1163     ) internal virtual {
1164         require(owner != operator, "ERC721: approve to caller");
1165         _operatorApprovals[owner][operator] = approved;
1166         emit ApprovalForAll(owner, operator, approved);
1167     }
1168 
1169     /**
1170      * @dev Reverts if the `tokenId` has not been minted yet.
1171      */
1172     function _requireMinted(uint256 tokenId) internal view virtual {
1173         require(_exists(tokenId), "ERC721: invalid token ID");
1174     }
1175 
1176     /**
1177      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1178      * The call is not executed if the target address is not a contract.
1179      *
1180      * @param from address representing the previous owner of the given token ID
1181      * @param to target address that will receive the tokens
1182      * @param tokenId uint256 ID of the token to be transferred
1183      * @param data bytes optional data to send along with the call
1184      * @return bool whether the call correctly returned the expected magic value
1185      */
1186     function _checkOnERC721Received(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory data
1191     ) private returns (bool) {
1192         if (to.isContract()) {
1193             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1194                 return retval == IERC721Receiver.onERC721Received.selector;
1195             } catch (bytes memory reason) {
1196                 if (reason.length == 0) {
1197                     revert("ERC721: transfer to non ERC721Receiver implementer");
1198                 } else {
1199                     /// @solidity memory-safe-assembly
1200                     assembly {
1201                         revert(add(32, reason), mload(reason))
1202                     }
1203                 }
1204             }
1205         } else {
1206             return true;
1207         }
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any token transfer. This includes minting
1212      * and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` will be minted for `to`.
1219      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _beforeTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Hook that is called after any transfer of tokens. This includes
1232      * minting and burning.
1233      *
1234      * Calling conditions:
1235      *
1236      * - when `from` and `to` are both non-zero.
1237      * - `from` and `to` are never both zero.
1238      *
1239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1240      */
1241     function _afterTokenTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {}
1246 }
1247 
1248 // File: contracts/blockchainfrenz.sol
1249 
1250 
1251 
1252 /*
1253 -------------------------------------------------------------------------------------------------
1254 
1255  :::====  :::      :::====  :::===== :::  === :::===== :::  === :::====  ::: :::= ===      :::===== :::====  :::===== :::= === :::=====
1256  :::  === :::      :::  === :::      ::: ===  :::      :::  === :::  === ::: :::=====      :::      :::  === :::      :::=====      ===
1257  =======  ===      ===  === ===      ======   ===      ======== ======== === ========      ======   =======  ======   ========    ===  
1258  ===  === ===      ===  === ===      === ===  ===      ===  === ===  === === === ====      ===      === ===  ===      === ====  ===    
1259  =======  ========  ======   ======= ===  ===  ======= ===  === ===  === === ===  ===      ===      ===  === ======== ===  === ========
1260                                                                                                                                                                                                                                                                                                   
1261 -------------------------------------------------------------------------------------------------
1262 
1263     About The Project -->
1264 
1265     Project Name    -> Blockchain Frenz
1266     Total Supply    -> 5,555 Pieces > ?
1267     Contract Author -> BAD SAPIENS 
1268 
1269     The Blockchain Frenz is a NFT collection consisting of 5,555 pieces and over 99 traits, 
1270     set out to bring street culture and language to the world of Web3.
1271 
1272 -------------------------------------------------------------------------------------------------
1273 */
1274 
1275 pragma solidity >=0.7.0 <0.9.0;
1276 
1277 // Minting Roadmap --> Presale Start -> Free Minting for 2000 pieces -> Presale Continues -> Presale End -> Public Sale Start -> Public Sale Ends -> Reveal ->
1278 
1279 
1280 
1281 
1282 
1283 contract BlockchainFrenz is ERC721, Ownable, ReentrancyGuard {
1284   using Strings for uint256;
1285   using Counters for Counters.Counter;
1286 
1287   Counters.Counter private supply;
1288 
1289   string public uriPrefix = "";
1290   string public uriSuffix = ".json";
1291   string public hiddenMetadataUri;
1292   
1293   // Free at the begining, then 0.009 for public mint. 
1294 
1295   uint256 public cost = 0 ether;
1296   uint256 public maxSupply = 5555;
1297   uint256 public maxMintAmountPerTx = 3;
1298 
1299   bool public paused = false;
1300   bool public revealed = false;
1301 
1302   bool public presale = false;
1303   mapping(address => bool) public whitelisted;
1304   uint256 public maxPresaleMintAmount = 3;
1305 
1306   constructor() ERC721("Blockchain Frenz", "BCF") {
1307     setHiddenMetadataUri("ipfs://bafybeiglw4va3xoj3cgz4gaur3n2dzcqql5iyun6olbhf2cfi3izhl45fa/hidden.json");
1308   }
1309 
1310   modifier mintCompliance(uint256 _mintAmount) {
1311     require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx, "Invalid mint amount!");
1312     require(supply.current() + _mintAmount < maxSupply, "Max supply exceeded!");
1313     _;
1314   }
1315 
1316   function totalSupply() public view returns (uint256) {
1317     return supply.current();
1318   }
1319 
1320   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1321     require(!paused, "The contract is paused!");
1322     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1323 
1324     _mintLoop(msg.sender, _mintAmount);
1325   }
1326   
1327   function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
1328     _mintLoop(_receiver, _mintAmount);
1329   }
1330 
1331   function walletOfOwner(address _owner)
1332     public
1333     view
1334     returns (uint256[] memory)
1335   {
1336     uint256 ownerTokenCount = balanceOf(_owner);
1337     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1338     uint256 currentTokenId = 1;
1339     uint256 ownedTokenIndex = 0;
1340 
1341     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1342       address currentTokenOwner = ownerOf(currentTokenId);
1343 
1344       if (currentTokenOwner == _owner) {
1345         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1346 
1347         ownedTokenIndex++;
1348       }
1349 
1350       currentTokenId++;
1351     }
1352 
1353     return ownedTokenIds;
1354   }
1355 
1356   function tokenURI(uint256 _tokenId)
1357     public
1358     view
1359     virtual
1360     override
1361     returns (string memory)
1362   {
1363     require(
1364       _exists(_tokenId),
1365       "ERC721Metadata: URI query for nonexistent token"
1366     );
1367 
1368     if (revealed == false) {
1369       return hiddenMetadataUri;
1370     }
1371 
1372     string memory currentBaseURI = _baseURI();
1373     return bytes(currentBaseURI).length > 0
1374         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1375         : "";
1376   }
1377 
1378   function setRevealed(bool _state) public onlyOwner {
1379     revealed = _state;
1380   }
1381 
1382   function setCost(uint256 _cost) public onlyOwner {
1383     cost = _cost;
1384   }
1385 
1386   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1387     maxMintAmountPerTx = _maxMintAmountPerTx;
1388   }
1389 
1390   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1391     hiddenMetadataUri = _hiddenMetadataUri;
1392   }
1393 
1394   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1395     uriPrefix = _uriPrefix;
1396   }
1397 
1398   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1399     uriSuffix = _uriSuffix;
1400   }
1401 
1402   function setPaused(bool _state) public onlyOwner {
1403     paused = _state;
1404   }
1405 
1406   function withdraw() public onlyOwner nonReentrant {
1407     
1408     // This will pay Can's 5% of the initial sale.
1409     // =============================================================================
1410 
1411     (bool hs, ) = payable(0x1B6c8a28005425b09387F3527D4847D1791696C3).call{value: address(this).balance * 5 / 100}("");
1412     require(hs);
1413 
1414     // =============================================================================
1415 
1416       // - This will transfer the remaining contract balance to the owner.
1417       // - Do not remove this otherwise you will not be able to withdraw the funds.
1418 
1419     // =============================================================================
1420 
1421     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1422     require(os);
1423 
1424     // =============================================================================
1425   }
1426 
1427   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1428     for (uint256 i = 0; i < _mintAmount; i++) {
1429       supply.increment();
1430       _safeMint(_receiver, supply.current());
1431     }
1432   }
1433 
1434   function _baseURI() internal view virtual override returns (string memory) {
1435     return uriPrefix;
1436   }
1437 
1438   //Murf Whitelist Functions
1439   function setPresale(bool _state) public onlyOwner {
1440       presale = _state;
1441   }
1442 
1443   function setMaxPresaleMintAmount(uint256 _max) public onlyOwner {
1444       maxPresaleMintAmount = _max;
1445   }
1446   
1447 }