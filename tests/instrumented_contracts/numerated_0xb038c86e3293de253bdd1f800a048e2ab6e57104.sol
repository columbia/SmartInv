1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
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
47 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Contract module that helps prevent reentrant calls to a function.
56  *
57  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
58  * available, which can be applied to functions to make sure there are no nested
59  * (reentrant) calls to them.
60  *
61  * Note that because there is a single `nonReentrant` guard, functions marked as
62  * `nonReentrant` may not call one another. This can be worked around by making
63  * those functions `private`, and then adding `external` `nonReentrant` entry
64  * points to them.
65  *
66  * TIP: If you would like to learn more about reentrancy and alternative ways
67  * to protect against it, check out our blog post
68  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
69  */
70 abstract contract ReentrancyGuard {
71     // Booleans are more expensive than uint256 or any type that takes up a full
72     // word because each write operation emits an extra SLOAD to first read the
73     // slot's contents, replace the bits taken up by the boolean, and then write
74     // back. This is the compiler's defense against contract upgrades and
75     // pointer aliasing, and it cannot be disabled.
76 
77     // The values being non-zero value makes deployment a bit more expensive,
78     // but in exchange the refund on every call to nonReentrant will be lower in
79     // amount. Since refunds are capped to a percentage of the total
80     // transaction's gas, it is best to keep them low in cases like this one, to
81     // increase the likelihood of the full refund coming into effect.
82     uint256 private constant _NOT_ENTERED = 1;
83     uint256 private constant _ENTERED = 2;
84 
85     uint256 private _status;
86 
87     constructor() {
88         _status = _NOT_ENTERED;
89     }
90 
91     /**
92      * @dev Prevents a contract from calling itself, directly or indirectly.
93      * Calling a `nonReentrant` function from another `nonReentrant`
94      * function is not supported. It is possible to prevent this from happening
95      * by making the `nonReentrant` function external, and making it call a
96      * `private` function that does the actual work.
97      */
98     modifier nonReentrant() {
99         // On the first call to nonReentrant, _notEntered will be true
100         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
101 
102         // Any calls to nonReentrant after this point will fail
103         _status = _ENTERED;
104 
105         _;
106 
107         // By storing the original value once again, a refund is triggered (see
108         // https://eips.ethereum.org/EIPS/eip-2200)
109         _status = _NOT_ENTERED;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 // File: @openzeppelin/contracts/utils/Context.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Provides information about the current execution context, including the
192  * sender of the transaction and its data. While these are generally available
193  * via msg.sender and msg.data, they should not be accessed in such a direct
194  * manner, since when dealing with meta-transactions the account sending and
195  * paying for execution may not be the actual sender (as far as an application
196  * is concerned).
197  *
198  * This contract is only required for intermediate, library-like contracts.
199  */
200 abstract contract Context {
201     function _msgSender() internal view virtual returns (address) {
202         return msg.sender;
203     }
204 
205     function _msgData() internal view virtual returns (bytes calldata) {
206         return msg.data;
207     }
208 }
209 
210 // File: @openzeppelin/contracts/access/Ownable.sol
211 
212 
213 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Contract module which provides a basic access control mechanism, where
220  * there is an account (an owner) that can be granted exclusive access to
221  * specific functions.
222  *
223  * By default, the owner account will be the one that deploys the contract. This
224  * can later be changed with {transferOwnership}.
225  *
226  * This module is used through inheritance. It will make available the modifier
227  * `onlyOwner`, which can be applied to your functions to restrict their use to
228  * the owner.
229  */
230 abstract contract Ownable is Context {
231     address private _owner;
232 
233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235     /**
236      * @dev Initializes the contract setting the deployer as the initial owner.
237      */
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view virtual returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         _transferOwnership(address(0));
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(newOwner != address(0), "Ownable: new owner is the zero address");
274         _transferOwnership(newOwner);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Internal function without access restriction.
280      */
281     function _transferOwnership(address newOwner) internal virtual {
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Address.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain `call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
481      * revert reason using the provided one.
482      *
483      * _Available since v4.3._
484      */
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @title ERC721 token receiver interface
517  * @dev Interface for any contract that wants to support safeTransfers
518  * from ERC721 asset contracts.
519  */
520 interface IERC721Receiver {
521     /**
522      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
523      * by `operator` from `from`, this function is called.
524      *
525      * It must return its Solidity selector to confirm the token transfer.
526      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
527      *
528      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
529      */
530     function onERC721Received(
531         address operator,
532         address from,
533         uint256 tokenId,
534         bytes calldata data
535     ) external returns (bytes4);
536 }
537 
538 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Interface of the ERC165 standard, as defined in the
547  * https://eips.ethereum.org/EIPS/eip-165[EIP].
548  *
549  * Implementers can declare support of contract interfaces, which can then be
550  * queried by others ({ERC165Checker}).
551  *
552  * For an implementation, see {ERC165}.
553  */
554 interface IERC165 {
555     /**
556      * @dev Returns true if this contract implements the interface defined by
557      * `interfaceId`. See the corresponding
558      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
559      * to learn more about how these ids are created.
560      *
561      * This function call must use less than 30 000 gas.
562      */
563     function supportsInterface(bytes4 interfaceId) external view returns (bool);
564 }
565 
566 // File: @openzeppelin/contracts/interfaces/IERC165.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.0 (interfaces/IERC165.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.0 (interfaces/IERC2981.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Interface for the NFT Royalty Standard
584  */
585 interface IERC2981 is IERC165 {
586     /**
587      * @dev Called with the sale price to determine how much royalty is owed and to whom.
588      * @param tokenId - the NFT asset queried for royalty information
589      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
590      * @return receiver - address of who should be sent the royalty payment
591      * @return royaltyAmount - the royalty payment amount for `salePrice`
592      */
593     function royaltyInfo(uint256 tokenId, uint256 salePrice)
594         external
595         view
596         returns (address receiver, uint256 royaltyAmount);
597 }
598 
599 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
611  * for the additional interface id that will be supported. For example:
612  *
613  * ```solidity
614  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
616  * }
617  * ```
618  *
619  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
620  */
621 abstract contract ERC165 is IERC165 {
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         return interfaceId == type(IERC165).interfaceId;
627     }
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Required interface of an ERC721 compliant contract.
640  */
641 interface IERC721 is IERC165 {
642     /**
643      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
644      */
645     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
646 
647     /**
648      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
649      */
650     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
654      */
655     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
656 
657     /**
658      * @dev Returns the number of tokens in ``owner``'s account.
659      */
660     function balanceOf(address owner) external view returns (uint256 balance);
661 
662     /**
663      * @dev Returns the owner of the `tokenId` token.
664      *
665      * Requirements:
666      *
667      * - `tokenId` must exist.
668      */
669     function ownerOf(uint256 tokenId) external view returns (address owner);
670 
671     /**
672      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
673      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) external;
690 
691     /**
692      * @dev Transfers `tokenId` token from `from` to `to`.
693      *
694      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) external;
710 
711     /**
712      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
713      * The approval is cleared when the token is transferred.
714      *
715      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
716      *
717      * Requirements:
718      *
719      * - The caller must own the token or be an approved operator.
720      * - `tokenId` must exist.
721      *
722      * Emits an {Approval} event.
723      */
724     function approve(address to, uint256 tokenId) external;
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) external view returns (address operator);
734 
735     /**
736      * @dev Approve or remove `operator` as an operator for the caller.
737      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
738      *
739      * Requirements:
740      *
741      * - The `operator` cannot be the caller.
742      *
743      * Emits an {ApprovalForAll} event.
744      */
745     function setApprovalForAll(address operator, bool _approved) external;
746 
747     /**
748      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
749      *
750      * See {setApprovalForAll}
751      */
752     function isApprovedForAll(address owner, address operator) external view returns (bool);
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes calldata data
772     ) external;
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
776 
777 
778 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 
783 /**
784  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
785  * @dev See https://eips.ethereum.org/EIPS/eip-721
786  */
787 interface IERC721Metadata is IERC721 {
788     /**
789      * @dev Returns the token collection name.
790      */
791     function name() external view returns (string memory);
792 
793     /**
794      * @dev Returns the token collection symbol.
795      */
796     function symbol() external view returns (string memory);
797 
798     /**
799      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
800      */
801     function tokenURI(uint256 tokenId) external view returns (string memory);
802 }
803 
804 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
805 
806 
807 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
808 
809 pragma solidity ^0.8.0;
810 
811 
812 
813 
814 
815 
816 
817 
818 /**
819  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
820  * the Metadata extension, but not including the Enumerable extension, which is available separately as
821  * {ERC721Enumerable}.
822  */
823 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
824     using Address for address;
825     using Strings for uint256;
826 
827     // Token name
828     string private _name;
829 
830     // Token symbol
831     string private _symbol;
832 
833     // Mapping from token ID to owner address
834     mapping(uint256 => address) private _owners;
835 
836     // Mapping owner address to token count
837     mapping(address => uint256) private _balances;
838 
839     // Mapping from token ID to approved address
840     mapping(uint256 => address) private _tokenApprovals;
841 
842     // Mapping from owner to operator approvals
843     mapping(address => mapping(address => bool)) private _operatorApprovals;
844 
845     /**
846      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
847      */
848     constructor(string memory name_, string memory symbol_) {
849         _name = name_;
850         _symbol = symbol_;
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view virtual override returns (uint256) {
867         require(owner != address(0), "ERC721: balance query for the zero address");
868         return _balances[owner];
869     }
870 
871     /**
872      * @dev See {IERC721-ownerOf}.
873      */
874     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
875         address owner = _owners[tokenId];
876         require(owner != address(0), "ERC721: owner query for nonexistent token");
877         return owner;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-name}.
882      */
883     function name() public view virtual override returns (string memory) {
884         return _name;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-symbol}.
889      */
890     function symbol() public view virtual override returns (string memory) {
891         return _symbol;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-tokenURI}.
896      */
897     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
898         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
899 
900         string memory baseURI = _baseURI();
901         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
902     }
903 
904     /**
905      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
906      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
907      * by default, can be overriden in child contracts.
908      */
909     function _baseURI() internal view virtual returns (string memory) {
910         return "";
911     }
912 
913     /**
914      * @dev See {IERC721-approve}.
915      */
916     function approve(address to, uint256 tokenId) public virtual override {
917         address owner = ERC721.ownerOf(tokenId);
918         require(to != owner, "ERC721: approval to current owner");
919 
920         require(
921             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
922             "ERC721: approve caller is not owner nor approved for all"
923         );
924 
925         _approve(to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-getApproved}.
930      */
931     function getApproved(uint256 tokenId) public view virtual override returns (address) {
932         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
933 
934         return _tokenApprovals[tokenId];
935     }
936 
937     /**
938      * @dev See {IERC721-setApprovalForAll}.
939      */
940     function setApprovalForAll(address operator, bool approved) public virtual override {
941         _setApprovalForAll(_msgSender(), operator, approved);
942     }
943 
944     /**
945      * @dev See {IERC721-isApprovedForAll}.
946      */
947     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev See {IERC721-transferFrom}.
953      */
954     function transferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         //solhint-disable-next-line max-line-length
960         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
961 
962         _transfer(from, to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public virtual override {
973         safeTransferFrom(from, to, tokenId, "");
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) public virtual override {
985         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
986         _safeTransfer(from, to, tokenId, _data);
987     }
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
994      *
995      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
996      * implement alternative mechanisms to perform token transfer, such as signature-based.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _transfer(from, to, tokenId);
1014         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      * and stop existing when they are burned (`_burn`).
1024      */
1025     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1026         return _owners[tokenId] != address(0);
1027     }
1028 
1029     /**
1030      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      */
1036     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1037         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1038         address owner = ERC721.ownerOf(tokenId);
1039         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1040     }
1041 
1042     /**
1043      * @dev Safely mints `tokenId` and transfers it to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must not exist.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _safeMint(address to, uint256 tokenId) internal virtual {
1053         _safeMint(to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1058      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1059      */
1060     function _safeMint(
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) internal virtual {
1065         _mint(to, tokenId);
1066         require(
1067             _checkOnERC721Received(address(0), to, tokenId, _data),
1068             "ERC721: transfer to non ERC721Receiver implementer"
1069         );
1070     }
1071 
1072     /**
1073      * @dev Mints `tokenId` and transfers it to `to`.
1074      *
1075      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must not exist.
1080      * - `to` cannot be the zero address.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _mint(address to, uint256 tokenId) internal virtual {
1085         require(to != address(0), "ERC721: mint to the zero address");
1086         require(!_exists(tokenId), "ERC721: token already minted");
1087 
1088         _beforeTokenTransfer(address(0), to, tokenId);
1089 
1090         _balances[to] += 1;
1091         _owners[tokenId] = to;
1092 
1093         emit Transfer(address(0), to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Destroys `tokenId`.
1098      * The approval is cleared when the token is burned.
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must exist.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _burn(uint256 tokenId) internal virtual {
1107         address owner = ERC721.ownerOf(tokenId);
1108 
1109         _beforeTokenTransfer(owner, address(0), tokenId);
1110 
1111         // Clear approvals
1112         _approve(address(0), tokenId);
1113 
1114         _balances[owner] -= 1;
1115         delete _owners[tokenId];
1116 
1117         emit Transfer(owner, address(0), tokenId);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) internal virtual {
1136         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1137         require(to != address(0), "ERC721: transfer to the zero address");
1138 
1139         _beforeTokenTransfer(from, to, tokenId);
1140 
1141         // Clear approvals from the previous owner
1142         _approve(address(0), tokenId);
1143 
1144         _balances[from] -= 1;
1145         _balances[to] += 1;
1146         _owners[tokenId] = to;
1147 
1148         emit Transfer(from, to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Approve `to` to operate on `tokenId`
1153      *
1154      * Emits a {Approval} event.
1155      */
1156     function _approve(address to, uint256 tokenId) internal virtual {
1157         _tokenApprovals[tokenId] = to;
1158         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Approve `operator` to operate on all of `owner` tokens
1163      *
1164      * Emits a {ApprovalForAll} event.
1165      */
1166     function _setApprovalForAll(
1167         address owner,
1168         address operator,
1169         bool approved
1170     ) internal virtual {
1171         require(owner != operator, "ERC721: approve to caller");
1172         _operatorApprovals[owner][operator] = approved;
1173         emit ApprovalForAll(owner, operator, approved);
1174     }
1175 
1176     /**
1177      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1178      * The call is not executed if the target address is not a contract.
1179      *
1180      * @param from address representing the previous owner of the given token ID
1181      * @param to target address that will receive the tokens
1182      * @param tokenId uint256 ID of the token to be transferred
1183      * @param _data bytes optional data to send along with the call
1184      * @return bool whether the call correctly returned the expected magic value
1185      */
1186     function _checkOnERC721Received(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) private returns (bool) {
1192         if (to.isContract()) {
1193             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1194                 return retval == IERC721Receiver.onERC721Received.selector;
1195             } catch (bytes memory reason) {
1196                 if (reason.length == 0) {
1197                     revert("ERC721: transfer to non ERC721Receiver implementer");
1198                 } else {
1199                     assembly {
1200                         revert(add(32, reason), mload(reason))
1201                     }
1202                 }
1203             }
1204         } else {
1205             return true;
1206         }
1207     }
1208 
1209     /**
1210      * @dev Hook that is called before any token transfer. This includes minting
1211      * and burning.
1212      *
1213      * Calling conditions:
1214      *
1215      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1216      * transferred to `to`.
1217      * - When `from` is zero, `tokenId` will be minted for `to`.
1218      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1219      * - `from` and `to` are never both zero.
1220      *
1221      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1222      */
1223     function _beforeTokenTransfer(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) internal virtual {}
1228 }
1229 
1230 // File: OG.sol
1231 
1232 
1233 
1234 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1235 //                                                                                                                                                              //
1236 //                                                                                                                                                              //
1237 //                                                                                                                                                              //
1238 //                                                      ......                                                                                                  //
1239 //                                                    .';llcc:'..............                                                                                   //
1240 //                                                   .,:cloool:;;;;;;;::;:::::;'....                                                                            //
1241 //                                                 ..;ccclllooooolc:::;;;:cccccc::::;;,.       .''''.                                                           //
1242 //                                                ..;:cccllccclloolllcclllloolcccc::ccc:,'.....',,''.. ..                                                       //
1243 //                                                .,ccccccccccccllllllloollccc::::::::::,,,,',,,,;;;;;,,'                                                       //
1244 //                                               .';ccc:cccc::::::::::::::;;;;;::::::cc:::;,''',;ccclc:;'     .........                                         //
1245 //                                               .;cc:::::::::;;;;,;::::::;;;;;;;;:::cccc::;,,,'',;:cc::,.  ..',,;::cc:;,.......   .                            //
1246 //                                              ..,::::cc::;:::::::::;;;;;;;;;;;;;:ccc:::::::::;;,,;::::;,..,;;;;;;;::::;;;;;;,,'','                            //
1247 //                                             ..;:cccccc:::::cccc:::::;;;;;;;;;;;::::::::::::cc::;:::;;;;,,;;,,,;;;::::;,;::c:::;,.                            //
1248 //                                             .,:cc:::::::::::c:::;:cccc::::::;;;;;;;;:::;::::::::::cc:;,''''','',;:ccc::;:ccllc:;'                            //
1249 //                                             .';;;::cc:::::::;;;;,,::::;::::::::::::::::;:::::::;;::cc:;,,'..''',,;::::::::::lc::'.                           //
1250 //                                            ..,;;;;;;:::::::;;;;;;;::::;;;;:::::;;:::::::::::::::::;::ccc::,'',;;;;,,,;;:ccc:::;;,.                           //
1251 //                                           ..,;:::;;;:;;;;:;,,;:::::;;:;;;:::::::;;;;;;;;::::::;;;;;;;;;;;;;;;:::;;,,,;:cccc:cc;,,.                           //
1252 //                                          ..,;:c:;;;;;,,;,,,,,;;:cc:;:clcccc:;;;;;,;;;;::::::::;;;:;;;;;,,,,,;;::;;,',,;:::;;:::;,.                           //
1253 //                                         ...,,;:;;;;;,,,,,,;;;;:::::;;:::;::::;;;;;;;::::;;::::;::;;;;;;,,,,,;;;;;;,'',,;;;;::::;,.                           //
1254 //                    ...........   ....,,,,,,,,,,;;;;;;;;;;;;::::;;:::;;;;;;:::::;;;;;;:::::::::::::;::::;;,,,;;;;;;;;,,,,,;;::::;;..                          //
1255 //              ..'''..'',;;;,,,,,,,;;;;:::;;,,,,,,,;:::;;;;;;:::;;;:::::::;;;:cc::;;::::::;::::;;;;:::::::;;;;;;;;:::::;,,,;::cc:;'..                          //
1256 //              ..,;;;;;;:::::::::::::cc:;;,,,,,,''',,,,;;;;;;;;:;;;;;;;::;;;;;;;::;;:::;:::;;;:::;;;;;;;;;;;;;:;;;;:::::;,,;;;:::;...                          //
1257 //               .,;;;::;;;,,;;;;;;;,,,;;;:;;;;;;,,;;;;;,,,,;;;;;::;;;;;;;;::::::c::::::::::;;;;;;;;;;;,,,,;;;;::::::::::;,,,,;;;;,'..                          //
1258 //               ..,;;;;::;,,,,,,,;;;;;;;::;;;;;;:;;;;;;;,,,,;;;;;;;;;;;;;;;:::::::;;;::;;;;;;;;;;;;;;;,,'.'',;:::::::::::;,,,,;;;,'.                           //
1259 //                ..',;;;::;;;;;;;,;;:;;;:;;;;;;;;;::::;;;;;;;;;;;;:::::;;;;;;:;;;;;;;,,,,,,',;;;;;;;;;,,,''',;::;::;;;;:c::;,,;;,''.                           //
1260 //                 .',::;;;;;;;,,,,,,,,,,,'',,,,,,,,;;;;;;;;;;;;;;;;;;;;::;;;:;;;;;,,,,,,;:;;;;;;;;;;;;;;;;;,,,;;;:::;;;::::;,,;;;;,'.                          //
1261 //                ..',,,,''''''''...'''....'',,',,,,',,;;;,;;,,,,,,,,,,;;;;;;;:;,,,,,,,;;;;;;;;;;;::;;;;;,,;;;;;;;;;;;;;;;:::::;:::;;'                          //
1262 //                ....'........................'',,,,,,,,,''''..',,,''',;:cllodolllloolc;;;;;,,;;;;,,;,,,,,,,,;;;;;,,,;;;;;;;,,,,;;,;,.                         //
1263 //                 ..............................'','''''.......',;codxkOkO000000000000Okkxxdodxxolc;,,'.'','''',,,,,,,;,''..'''''''..                          //
1264 //                   ..........................................;okO0KKKKK0OOkxkkkkkkxxkxO0OOOO000OOOkxdc::lolc;''''','''...'........                            //
1265 //                   .':loooollccc:;;'..'....    .......    .'lO00K00000KK0kxxddxddxxxxxkOOOOkkOO00OO00000K0Okxdddodxddolc;,'.....                              //
1266 //                   .o000000OOOOOOkOxddxolc;,,,;:;:lllcc:::lkKK00000000K0OkddodddddddxkxkkkkkxdxxxxOOOO0KKKKXK00OO00O00K0Okdolc:'..                            //
1267 //                  .:dO00OO0000000O0OOOOOkkkxkkkOOOOOOOO00KKK00OOOkkkkOO00OdlllllodollooooooolloodxkkkOO0KKKXXK0OOkxxxxxkOkkkOO0Oxooc'...                      //
1268 //                  :xxkOOOkOOkOOO00000OOOOOOOOkOOO00KKKKKKK0OkkxxkkxkkO0KKkdoc:::ccc:cccc:;,;:cclodddxxk000KXXKOxxxddolooodxxxkOO00KK0kdl,                     //
1269 //                  ;xOOOOOkkkkkkkOOOOOOOOOOkOOO000000K0000K0kxxxxxxxkO0XX0kxolc:;;::cool:;,,;clllclddloxkOOKX0kdoooooooodddxdodxkOKKKOkxl'                     //
1270 //                  ,x0OkkxxkkkkkkkkkkOOOOkkkkO000OOOOOOOOOOOkdooddxxkOKXKOkxol:;,,;llcc:,,,,;;:cccldolodkO0K0kdolloolccllcccccoxkkO00xxl'                      //
1271 //                 .lkkOkkkkkxxxkkxxxkkxxkxxkkkOOOkkkOOOOOOkddlllloxkkkO0Oxdollc::codoodollc::;:clllollooxOKKOxoldxxdl:;;;:c:cllodxk00kxo,.                     //
1272 //                 .ldxkxxxdxxdxxxxxxxxxxkkxxxxxkkxxkkkkkkkxolcloodxkkkOOOxl:;;:cclloool:::llc::::;::::clx0XKkoloddol;;:clccclodxO000OOxo:.                     //
1273 //                 .,:loooddddooddddxddxxxxxxxxxxxxkkkxkxxkxxdlcodxxxkkOOxoollc:ccccllll:;;ccc:;;;;;,,;cokKXKOoclolc:::::cccllodk00Okolc,.                      //
1274 //                  'clllcc::::;:;;ccclllllloooodxdxdddxxxxxkOkddxddxkOOOxocclollcc:::clc::;:cc::::;;,;ldOKXKkocccclllcc::cclodkO0Okkdlc,                       //
1275 //                 .';;;;;;,;;;:c::clllolllllllllllllllooooddddooddxxkOO0koc:codoooocclllc:::cll::;,;;:dk0KK0ko:;;:::;;;;;clloxxkkkkkolc'                       //
1276 //                  .,;;;;;;;;;::::cc:;:;;;,,;:::::cclllcllloolllloxxxkO0kxdlcllcccc::;::::::ccc:;,,,:oxO00KOxl:;;;,''',,;;;:loollodxkxo:'                      //
1277 //                  ..,;;;''''','',,,'',;:c:;:::c:;;,;:;,;;::c::clldodk00Okdl:;;,,,;;;;::::::;:;,,,',:oxk0KK0kdc:cc:;,;;;;;;:llcclodxxolc'                      //
1278 //                    ..'''.''''''',,,,,;;;;,''',,,,',,,,,;;;:;:::cloox0KKOo:;,,,,;;;::::ccc:,,,,,'.';cdk0K0Oxl;,:::;;;;:;:::cldxkkkkkdlc'                      //
1279 //                      .........'.','''''''..'''.',,,,,',,,;;,',;:lodxOKKkoc::clddxddoc:::c:,'''','';lx0KK0kd:,;:::;;,;,',;:cdkOOOkkxocc,.                     //
1280 //                         .........'''..........''''...........';;clodxO00OOOkO00000OOkkxxdoc:,',,:ldkO0KXKOdc;:c::::::;,;::clodxkkxdlc,.                      //
1281 //                         .....  ...............................',;codxk0KKKKKKKK0000KKKKKK0OkkxxkkO0000KXX0ko;',,''',;;;:::;:okOkkkxol;.                      //
1282 //                                            .    ..    ........',;cclodxkkkOO0000OOO0K00KKK0KKK00OOOOO0KKK0Odc,,,''';:ccllc:ldxkxxkxoo:.                      //
1283 //                                                           ...',,;;;:::cllodxkkxkkkkkOOOOOOOOOOkkkkkO00000000Oxolc::clddolc:lodkOOxol:.                       //
1284 //                                                            ....',,;;:::cclcclllllllooooodoooddxxxxxxkkkO0000KK0000000000OkkkO00KKOxdl.                       //
1285 //                                                            ....',,,''''''',,;::::ccccc::cc:ccclllllloxkkkOOOO00000000000KK0KKK0000kxo:.                      //
1286 //                                                             ...'''..........''',,;:;::::;'';ccc::::cccllooooooooooddxxxkOOkO00OOO0OOkdl,.                    //
1287 //                                                               ...... ..    .......''.......,cc:;,,''',;;:::cccccccloxxdoooddkO00kxxddoc:.                    //
1288 //                                                                                .....     ..............',,,;:::;:odddoc;:cdk0KK0Oxo:'..                      //
1289 //                                                                                                    ........',:coddol:::cdOO0Okdl;'.                          //
1290 //                                                                                                      .......',;:;,'',;:loolc;..                              //
1291 //                                                                                                          ........ .'',;,...                                  //
1292 //                                                                                                                                                              //
1293 //                                                                                                                                                              //
1294 //    JakNFT x Kotegawa OGs                                                                                                                                     //
1295 //                                                                                                                                                              //
1296 //                                                                                                                                                              //
1297 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1298 
1299 pragma solidity ^0.8.9;
1300 
1301 
1302 
1303 
1304 
1305 
1306 
1307 contract OGsbyJakNFTxKotegawa is ERC721, IERC2981, ReentrancyGuard, Ownable {
1308   using Counters for Counters.Counter;
1309 
1310   constructor(string memory customBaseURI_)
1311     ERC721("OGs by JakNFT x Kotegawa", "OG")
1312   {
1313     customBaseURI = customBaseURI_;
1314   }
1315 
1316   /** MINTING **/
1317 
1318   uint256 public constant MAX_SUPPLY = 369;
1319 
1320   uint256 public constant PRICE = 169000000000000000;
1321 
1322   Counters.Counter private supplyCounter;
1323 
1324   function mint() public payable nonReentrant {
1325     require(saleIsActive, "Sale not active");
1326 
1327     require(totalSupply() < MAX_SUPPLY, "Exceeds max supply");
1328 
1329     require(msg.value >= PRICE, "Insufficient payment, 0.169 ETH per item");
1330 
1331     _mint(msg.sender, totalSupply());
1332 
1333     supplyCounter.increment();
1334   }
1335 
1336   function totalSupply() public view returns (uint256) {
1337     return supplyCounter.current();
1338   }
1339 
1340   /** ACTIVATION **/
1341 
1342   bool public saleIsActive = true;
1343 
1344   function setSaleIsActive(bool saleIsActive_) external onlyOwner {
1345     saleIsActive = saleIsActive_;
1346   }
1347 
1348   /** URI HANDLING **/
1349 
1350   string private customBaseURI;
1351 
1352   function setBaseURI(string memory customBaseURI_) external onlyOwner {
1353     customBaseURI = customBaseURI_;
1354   }
1355 
1356   function _baseURI() internal view virtual override returns (string memory) {
1357     return customBaseURI;
1358   }
1359 
1360   function tokenURI(uint256 tokenId) public view override
1361     returns (string memory)
1362   {
1363     return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1364   }
1365 
1366   /** PAYOUT **/
1367 
1368   function withdraw() public nonReentrant {
1369     uint256 balance = address(this).balance;
1370 
1371     Address.sendValue(payable(owner()), balance);
1372   }
1373 
1374   /** ROYALTIES **/
1375 
1376   function royaltyInfo(uint256, uint256 salePrice) external view override
1377     returns (address receiver, uint256 royaltyAmount)
1378   {
1379     return (address(this), (salePrice * 1000) / 10000);
1380   }
1381 
1382   function supportsInterface(bytes4 interfaceId)
1383     public
1384     view
1385     virtual
1386     override(ERC721, IERC165)
1387     returns (bool)
1388   {
1389     return (
1390       interfaceId == type(IERC2981).interfaceId ||
1391       super.supportsInterface(interfaceId)
1392     );
1393   }
1394 }