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
48 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module that helps prevent reentrant calls to a function.
57  *
58  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
59  * available, which can be applied to functions to make sure there are no nested
60  * (reentrant) calls to them.
61  *
62  * Note that because there is a single `nonReentrant` guard, functions marked as
63  * `nonReentrant` may not call one another. This can be worked around by making
64  * those functions `private`, and then adding `external` `nonReentrant` entry
65  * points to them.
66  *
67  * TIP: If you would like to learn more about reentrancy and alternative ways
68  * to protect against it, check out our blog post
69  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
70  */
71 abstract contract ReentrancyGuard {
72     // Booleans are more expensive than uint256 or any type that takes up a full
73     // word because each write operation emits an extra SLOAD to first read the
74     // slot's contents, replace the bits taken up by the boolean, and then write
75     // back. This is the compiler's defense against contract upgrades and
76     // pointer aliasing, and it cannot be disabled.
77 
78     // The values being non-zero value makes deployment a bit more expensive,
79     // but in exchange the refund on every call to nonReentrant will be lower in
80     // amount. Since refunds are capped to a percentage of the total
81     // transaction's gas, it is best to keep them low in cases like this one, to
82     // increase the likelihood of the full refund coming into effect.
83     uint256 private constant _NOT_ENTERED = 1;
84     uint256 private constant _ENTERED = 2;
85 
86     uint256 private _status;
87 
88     constructor() {
89         _status = _NOT_ENTERED;
90     }
91 
92     /**
93      * @dev Prevents a contract from calling itself, directly or indirectly.
94      * Calling a `nonReentrant` function from another `nonReentrant`
95      * function is not supported. It is possible to prevent this from happening
96      * by making the `nonReentrant` function external, and making it call a
97      * `private` function that does the actual work.
98      */
99     modifier nonReentrant() {
100         // On the first call to nonReentrant, _notEntered will be true
101         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
102 
103         // Any calls to nonReentrant after this point will fail
104         _status = _ENTERED;
105 
106         _;
107 
108         // By storing the original value once again, a refund is triggered (see
109         // https://eips.ethereum.org/EIPS/eip-2200)
110         _status = _NOT_ENTERED;
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
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
764 
765 
766 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Enumerable is IERC721 {
776     /**
777      * @dev Returns the total amount of tokens stored by the contract.
778      */
779     function totalSupply() external view returns (uint256);
780 
781     /**
782      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
783      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
784      */
785     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
786 
787     /**
788      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
789      * Use along with {totalSupply} to enumerate all tokens.
790      */
791     function tokenByIndex(uint256 index) external view returns (uint256);
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
795 
796 
797 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
798 
799 pragma solidity ^0.8.0;
800 
801 
802 /**
803  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
804  * @dev See https://eips.ethereum.org/EIPS/eip-721
805  */
806 interface IERC721Metadata is IERC721 {
807     /**
808      * @dev Returns the token collection name.
809      */
810     function name() external view returns (string memory);
811 
812     /**
813      * @dev Returns the token collection symbol.
814      */
815     function symbol() external view returns (string memory);
816 
817     /**
818      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
819      */
820     function tokenURI(uint256 tokenId) external view returns (string memory);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
824 
825 
826 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 
832 
833 
834 
835 
836 
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata extension, but not including the Enumerable extension, which is available separately as
840  * {ERC721Enumerable}.
841  */
842 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
843     using Address for address;
844     using Strings for uint256;
845 
846     // Token name
847     string private _name;
848 
849     // Token symbol
850     string private _symbol;
851 
852     // Mapping from token ID to owner address
853     mapping(uint256 => address) private _owners;
854 
855     // Mapping owner address to token count
856     mapping(address => uint256) private _balances;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     /**
865      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
866      */
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view virtual override returns (uint256) {
886         require(owner != address(0), "ERC721: address zero is not a valid owner");
887         return _balances[owner];
888     }
889 
890     /**
891      * @dev See {IERC721-ownerOf}.
892      */
893     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
894         address owner = _owners[tokenId];
895         require(owner != address(0), "ERC721: invalid token ID");
896         return owner;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-name}.
901      */
902     function name() public view virtual override returns (string memory) {
903         return _name;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-symbol}.
908      */
909     function symbol() public view virtual override returns (string memory) {
910         return _symbol;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-tokenURI}.
915      */
916     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
917         _requireMinted(tokenId);
918 
919         string memory baseURI = _baseURI();
920         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926      * by default, can be overridden in child contracts.
927      */
928     function _baseURI() internal view virtual returns (string memory) {
929         return "";
930     }
931 
932     /**
933      * @dev See {IERC721-approve}.
934      */
935     function approve(address to, uint256 tokenId) public virtual override {
936         address owner = ERC721.ownerOf(tokenId);
937         require(to != owner, "ERC721: approval to current owner");
938 
939         require(
940             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941             "ERC721: approve caller is not token owner nor approved for all"
942         );
943 
944         _approve(to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-getApproved}.
949      */
950     function getApproved(uint256 tokenId) public view virtual override returns (address) {
951         _requireMinted(tokenId);
952 
953         return _tokenApprovals[tokenId];
954     }
955 
956     /**
957      * @dev See {IERC721-setApprovalForAll}.
958      */
959     function setApprovalForAll(address operator, bool approved) public virtual override {
960         _setApprovalForAll(_msgSender(), operator, approved);
961     }
962 
963     /**
964      * @dev See {IERC721-isApprovedForAll}.
965      */
966     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
967         return _operatorApprovals[owner][operator];
968     }
969 
970     /**
971      * @dev See {IERC721-transferFrom}.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public virtual override {
978         //solhint-disable-next-line max-line-length
979         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
980 
981         _transfer(from, to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-safeTransferFrom}.
986      */
987     function safeTransferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public virtual override {
992         safeTransferFrom(from, to, tokenId, "");
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory data
1003     ) public virtual override {
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1005         _safeTransfer(from, to, tokenId, data);
1006     }
1007 
1008     /**
1009      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1010      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1011      *
1012      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1013      *
1014      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1015      * implement alternative mechanisms to perform token transfer, such as signature-based.
1016      *
1017      * Requirements:
1018      *
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must exist and be owned by `from`.
1022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _safeTransfer(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory data
1031     ) internal virtual {
1032         _transfer(from, to, tokenId);
1033         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      * and stop existing when they are burned (`_burn`).
1043      */
1044     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1045         return _owners[tokenId] != address(0);
1046     }
1047 
1048     /**
1049      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1056         address owner = ERC721.ownerOf(tokenId);
1057         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1058     }
1059 
1060     /**
1061      * @dev Safely mints `tokenId` and transfers it to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must not exist.
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _safeMint(address to, uint256 tokenId) internal virtual {
1071         _safeMint(to, tokenId, "");
1072     }
1073 
1074     /**
1075      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1076      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 tokenId,
1081         bytes memory data
1082     ) internal virtual {
1083         _mint(to, tokenId);
1084         require(
1085             _checkOnERC721Received(address(0), to, tokenId, data),
1086             "ERC721: transfer to non ERC721Receiver implementer"
1087         );
1088     }
1089 
1090     /**
1091      * @dev Mints `tokenId` and transfers it to `to`.
1092      *
1093      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1094      *
1095      * Requirements:
1096      *
1097      * - `tokenId` must not exist.
1098      * - `to` cannot be the zero address.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _mint(address to, uint256 tokenId) internal virtual {
1103         require(to != address(0), "ERC721: mint to the zero address");
1104         require(!_exists(tokenId), "ERC721: token already minted");
1105 
1106         _beforeTokenTransfer(address(0), to, tokenId);
1107 
1108         _balances[to] += 1;
1109         _owners[tokenId] = to;
1110 
1111         emit Transfer(address(0), to, tokenId);
1112 
1113         _afterTokenTransfer(address(0), to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Destroys `tokenId`.
1118      * The approval is cleared when the token is burned.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _burn(uint256 tokenId) internal virtual {
1127         address owner = ERC721.ownerOf(tokenId);
1128 
1129         _beforeTokenTransfer(owner, address(0), tokenId);
1130 
1131         // Clear approvals
1132         _approve(address(0), tokenId);
1133 
1134         _balances[owner] -= 1;
1135         delete _owners[tokenId];
1136 
1137         emit Transfer(owner, address(0), tokenId);
1138 
1139         _afterTokenTransfer(owner, address(0), tokenId);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `tokenId` token must be owned by `from`.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _transfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {
1158         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1159         require(to != address(0), "ERC721: transfer to the zero address");
1160 
1161         _beforeTokenTransfer(from, to, tokenId);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId);
1165 
1166         _balances[from] -= 1;
1167         _balances[to] += 1;
1168         _owners[tokenId] = to;
1169 
1170         emit Transfer(from, to, tokenId);
1171 
1172         _afterTokenTransfer(from, to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Approve `to` to operate on `tokenId`
1177      *
1178      * Emits an {Approval} event.
1179      */
1180     function _approve(address to, uint256 tokenId) internal virtual {
1181         _tokenApprovals[tokenId] = to;
1182         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev Approve `operator` to operate on all of `owner` tokens
1187      *
1188      * Emits an {ApprovalForAll} event.
1189      */
1190     function _setApprovalForAll(
1191         address owner,
1192         address operator,
1193         bool approved
1194     ) internal virtual {
1195         require(owner != operator, "ERC721: approve to caller");
1196         _operatorApprovals[owner][operator] = approved;
1197         emit ApprovalForAll(owner, operator, approved);
1198     }
1199 
1200     /**
1201      * @dev Reverts if the `tokenId` has not been minted yet.
1202      */
1203     function _requireMinted(uint256 tokenId) internal view virtual {
1204         require(_exists(tokenId), "ERC721: invalid token ID");
1205     }
1206 
1207     /**
1208      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1209      * The call is not executed if the target address is not a contract.
1210      *
1211      * @param from address representing the previous owner of the given token ID
1212      * @param to target address that will receive the tokens
1213      * @param tokenId uint256 ID of the token to be transferred
1214      * @param data bytes optional data to send along with the call
1215      * @return bool whether the call correctly returned the expected magic value
1216      */
1217     function _checkOnERC721Received(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory data
1222     ) private returns (bool) {
1223         if (to.isContract()) {
1224             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1225                 return retval == IERC721Receiver.onERC721Received.selector;
1226             } catch (bytes memory reason) {
1227                 if (reason.length == 0) {
1228                     revert("ERC721: transfer to non ERC721Receiver implementer");
1229                 } else {
1230                     /// @solidity memory-safe-assembly
1231                     assembly {
1232                         revert(add(32, reason), mload(reason))
1233                     }
1234                 }
1235             }
1236         } else {
1237             return true;
1238         }
1239     }
1240 
1241     /**
1242      * @dev Hook that is called before any token transfer. This includes minting
1243      * and burning.
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1251      * - `from` and `to` are never both zero.
1252      *
1253      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1254      */
1255     function _beforeTokenTransfer(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after any transfer of tokens. This includes
1263      * minting and burning.
1264      *
1265      * Calling conditions:
1266      *
1267      * - when `from` and `to` are both non-zero.
1268      * - `from` and `to` are never both zero.
1269      *
1270      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1271      */
1272     function _afterTokenTransfer(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) internal virtual {}
1277 }
1278 
1279 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1280 
1281 
1282 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 
1287 
1288 /**
1289  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1290  * enumerability of all the token ids in the contract as well as all token ids owned by each
1291  * account.
1292  */
1293 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1294     // Mapping from owner to list of owned token IDs
1295     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1296 
1297     // Mapping from token ID to index of the owner tokens list
1298     mapping(uint256 => uint256) private _ownedTokensIndex;
1299 
1300     // Array with all token ids, used for enumeration
1301     uint256[] private _allTokens;
1302 
1303     // Mapping from token id to position in the allTokens array
1304     mapping(uint256 => uint256) private _allTokensIndex;
1305 
1306     /**
1307      * @dev See {IERC165-supportsInterface}.
1308      */
1309     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1310         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1315      */
1316     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1317         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1318         return _ownedTokens[owner][index];
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Enumerable-totalSupply}.
1323      */
1324     function totalSupply() public view virtual override returns (uint256) {
1325         return _allTokens.length;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Enumerable-tokenByIndex}.
1330      */
1331     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1332         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1333         return _allTokens[index];
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before any token transfer. This includes minting
1338      * and burning.
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1346      * - `from` cannot be the zero address.
1347      * - `to` cannot be the zero address.
1348      *
1349      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1350      */
1351     function _beforeTokenTransfer(
1352         address from,
1353         address to,
1354         uint256 tokenId
1355     ) internal virtual override {
1356         super._beforeTokenTransfer(from, to, tokenId);
1357 
1358         if (from == address(0)) {
1359             _addTokenToAllTokensEnumeration(tokenId);
1360         } else if (from != to) {
1361             _removeTokenFromOwnerEnumeration(from, tokenId);
1362         }
1363         if (to == address(0)) {
1364             _removeTokenFromAllTokensEnumeration(tokenId);
1365         } else if (to != from) {
1366             _addTokenToOwnerEnumeration(to, tokenId);
1367         }
1368     }
1369 
1370     /**
1371      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1372      * @param to address representing the new owner of the given token ID
1373      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1374      */
1375     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1376         uint256 length = ERC721.balanceOf(to);
1377         _ownedTokens[to][length] = tokenId;
1378         _ownedTokensIndex[tokenId] = length;
1379     }
1380 
1381     /**
1382      * @dev Private function to add a token to this extension's token tracking data structures.
1383      * @param tokenId uint256 ID of the token to be added to the tokens list
1384      */
1385     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1386         _allTokensIndex[tokenId] = _allTokens.length;
1387         _allTokens.push(tokenId);
1388     }
1389 
1390     /**
1391      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1392      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1393      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1394      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1395      * @param from address representing the previous owner of the given token ID
1396      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1397      */
1398     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1399         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1400         // then delete the last slot (swap and pop).
1401 
1402         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1403         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1404 
1405         // When the token to delete is the last token, the swap operation is unnecessary
1406         if (tokenIndex != lastTokenIndex) {
1407             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1408 
1409             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1410             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1411         }
1412 
1413         // This also deletes the contents at the last position of the array
1414         delete _ownedTokensIndex[tokenId];
1415         delete _ownedTokens[from][lastTokenIndex];
1416     }
1417 
1418     /**
1419      * @dev Private function to remove a token from this extension's token tracking data structures.
1420      * This has O(1) time complexity, but alters the order of the _allTokens array.
1421      * @param tokenId uint256 ID of the token to be removed from the tokens list
1422      */
1423     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1424         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1425         // then delete the last slot (swap and pop).
1426 
1427         uint256 lastTokenIndex = _allTokens.length - 1;
1428         uint256 tokenIndex = _allTokensIndex[tokenId];
1429 
1430         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1431         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1432         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1433         uint256 lastTokenId = _allTokens[lastTokenIndex];
1434 
1435         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1436         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1437 
1438         // This also deletes the contents at the last position of the array
1439         delete _allTokensIndex[tokenId];
1440         _allTokens.pop();
1441     }
1442 }
1443 
1444 // File: dd.sol
1445 
1446 
1447 pragma solidity ^0.8.4;
1448 
1449 
1450 
1451 
1452 
1453 
1454 contract PeakboyMyBox is ERC721Enumerable, Ownable {
1455 	using Strings for uint256;
1456 
1457 	string public myBaseURI;
1458 	address public superMinter;
1459 	uint256 public _tokenIds;
1460 	mapping(address => uint256) public minters;
1461 
1462 	constructor(
1463 		string memory name_,
1464 		string memory symbol_,
1465 		string memory myBaseURI_
1466 	) ERC721(name_, symbol_) {
1467 		myBaseURI = myBaseURI_;
1468 		_tokenIds = 1;
1469 	}
1470 
1471 	// ---------------- onlyOwner ----------------
1472 
1473 	function setMinter(address minter_, uint256 amount_) public onlyOwner {
1474 		minters[minter_] = amount_;
1475 	}
1476 
1477 	function setSuperMinter(address newSuperMinter_) public onlyOwner {
1478 		superMinter = newSuperMinter_;
1479 	}
1480 
1481 	function setMyBaseURI(string memory uri_) public onlyOwner {
1482 		myBaseURI = uri_;
1483 	}
1484 
1485 	// ---------------- onlyOwner end ----------------
1486 
1487 	function mint(address account_) public returns (uint256) {
1488 		if (superMinter != _msgSender()) {
1489 			require(minters[_msgSender()] >= 1, "not minter");
1490 			minters[_msgSender()] -= 1;
1491 		}
1492 
1493 		uint256 tokenId = _tokenIds;
1494 		_tokenIds++;
1495 		_safeMint(account_, tokenId);
1496 		return tokenId;
1497 	}
1498 
1499 	function mintBatch(address account_, uint256 amount_) public returns (uint256[] memory tokenIds) {
1500 		if (superMinter != _msgSender()) {
1501 			require(minters[_msgSender()] >= amount_, "not minter");
1502 			minters[_msgSender()] -= amount_;
1503 		}
1504 		tokenIds = new uint256[](amount_);
1505 		uint256 tokenId = _tokenIds;
1506 		_tokenIds += amount_;
1507 		for (uint256 i; i < amount_; i++) {
1508 			tokenId += 1;
1509 			_safeMint(account_, tokenId);
1510 		}
1511 	}
1512 
1513 	function burn(uint256 tokenId_) public returns (bool) {
1514 		require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC721: burn caller is not owner nor approved");
1515 
1516 		_burn(tokenId_);
1517 		return true;
1518 	}
1519 
1520 	function burnMulti(uint256[] calldata tokenIds_) public returns (bool) {
1521 		for (uint256 i = 0; i < tokenIds_.length; ++i) {
1522 			uint256 tokenId_ = tokenIds_[i];
1523 			require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC721: burn caller is not owner nor approved");
1524 
1525 			_burn(tokenId_);
1526 		}
1527 		return true;
1528 	}
1529 
1530 	function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1531 		require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1532 		return _baseURI();
1533 	}
1534 
1535 	function _baseURI() internal view override returns (string memory) {
1536 		return myBaseURI;
1537 	}
1538 
1539 	function batchTokenInfo(address account_) public view returns (uint256[] memory tIdInfo, string[] memory uriInfo) {
1540 		uint256 amount = balanceOf(account_);
1541 		uint256 tokenId;
1542 		tIdInfo = new uint256[](amount);
1543 		uriInfo = new string[](amount);
1544 		for (uint256 i = 0; i < amount; i++) {
1545 			tokenId = tokenOfOwnerByIndex(account_, i);
1546 			tIdInfo[i] = tokenId;
1547 			uriInfo[i] = tokenURI(tokenId);
1548 		}
1549 	}
1550 }