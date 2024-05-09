1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts@4.4.0/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
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
68 // File: @openzeppelin/contracts@4.4.0/utils/Counters.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
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
114 // File: @openzeppelin/contracts@4.4.0/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 // File: @openzeppelin/contracts@4.4.0/utils/Context.sol
185 
186 
187 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 // File: @openzeppelin/contracts@4.4.0/access/Ownable.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor() {
240         _transferOwnership(_msgSender());
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view virtual returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * NOTE: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public virtual onlyOwner {
266         _transferOwnership(address(0));
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         _transferOwnership(newOwner);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Internal function without access restriction.
281      */
282     function _transferOwnership(address newOwner) internal virtual {
283         address oldOwner = _owner;
284         _owner = newOwner;
285         emit OwnershipTransferred(oldOwner, newOwner);
286     }
287 }
288 
289 // File: @openzeppelin/contracts@4.4.0/utils/Address.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain `call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: @openzeppelin/contracts@4.4.0/token/ERC721/IERC721Receiver.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @title ERC721 token receiver interface
518  * @dev Interface for any contract that wants to support safeTransfers
519  * from ERC721 asset contracts.
520  */
521 interface IERC721Receiver {
522     /**
523      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
524      * by `operator` from `from`, this function is called.
525      *
526      * It must return its Solidity selector to confirm the token transfer.
527      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
528      *
529      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
530      */
531     function onERC721Received(
532         address operator,
533         address from,
534         uint256 tokenId,
535         bytes calldata data
536     ) external returns (bytes4);
537 }
538 
539 // File: @openzeppelin/contracts@4.4.0/utils/introspection/IERC165.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Interface of the ERC165 standard, as defined in the
548  * https://eips.ethereum.org/EIPS/eip-165[EIP].
549  *
550  * Implementers can declare support of contract interfaces, which can then be
551  * queried by others ({ERC165Checker}).
552  *
553  * For an implementation, see {ERC165}.
554  */
555 interface IERC165 {
556     /**
557      * @dev Returns true if this contract implements the interface defined by
558      * `interfaceId`. See the corresponding
559      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
560      * to learn more about how these ids are created.
561      *
562      * This function call must use less than 30 000 gas.
563      */
564     function supportsInterface(bytes4 interfaceId) external view returns (bool);
565 }
566 
567 // File: @openzeppelin/contracts@4.4.0/utils/introspection/ERC165.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
579  * for the additional interface id that will be supported. For example:
580  *
581  * ```solidity
582  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
584  * }
585  * ```
586  *
587  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
588  */
589 abstract contract ERC165 is IERC165 {
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594         return interfaceId == type(IERC165).interfaceId;
595     }
596 }
597 
598 // File: @openzeppelin/contracts@4.4.0/token/ERC721/IERC721.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Required interface of an ERC721 compliant contract.
608  */
609 interface IERC721 is IERC165 {
610     /**
611      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
612      */
613     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
614 
615     /**
616      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
617      */
618     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
622      */
623     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
624 
625     /**
626      * @dev Returns the number of tokens in ``owner``'s account.
627      */
628     function balanceOf(address owner) external view returns (uint256 balance);
629 
630     /**
631      * @dev Returns the owner of the `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function ownerOf(uint256 tokenId) external view returns (address owner);
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
641      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Transfers `tokenId` token from `from` to `to`.
661      *
662      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      *
671      * Emits a {Transfer} event.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
681      * The approval is cleared when the token is transferred.
682      *
683      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
684      *
685      * Requirements:
686      *
687      * - The caller must own the token or be an approved operator.
688      * - `tokenId` must exist.
689      *
690      * Emits an {Approval} event.
691      */
692     function approve(address to, uint256 tokenId) external;
693 
694     /**
695      * @dev Returns the account approved for `tokenId` token.
696      *
697      * Requirements:
698      *
699      * - `tokenId` must exist.
700      */
701     function getApproved(uint256 tokenId) external view returns (address operator);
702 
703     /**
704      * @dev Approve or remove `operator` as an operator for the caller.
705      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
706      *
707      * Requirements:
708      *
709      * - The `operator` cannot be the caller.
710      *
711      * Emits an {ApprovalForAll} event.
712      */
713     function setApprovalForAll(address operator, bool _approved) external;
714 
715     /**
716      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
717      *
718      * See {setApprovalForAll}
719      */
720     function isApprovedForAll(address owner, address operator) external view returns (bool);
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
732      *
733      * Emits a {Transfer} event.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes calldata data
740     ) external;
741 }
742 
743 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/IERC721Enumerable.sol
744 
745 
746 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
753  * @dev See https://eips.ethereum.org/EIPS/eip-721
754  */
755 interface IERC721Enumerable is IERC721 {
756     /**
757      * @dev Returns the total amount of tokens stored by the contract.
758      */
759     function totalSupply() external view returns (uint256);
760 
761     /**
762      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
763      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
764      */
765     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
766 
767     /**
768      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
769      * Use along with {totalSupply} to enumerate all tokens.
770      */
771     function tokenByIndex(uint256 index) external view returns (uint256);
772 }
773 
774 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/IERC721Metadata.sol
775 
776 
777 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
784  * @dev See https://eips.ethereum.org/EIPS/eip-721
785  */
786 interface IERC721Metadata is IERC721 {
787     /**
788      * @dev Returns the token collection name.
789      */
790     function name() external view returns (string memory);
791 
792     /**
793      * @dev Returns the token collection symbol.
794      */
795     function symbol() external view returns (string memory);
796 
797     /**
798      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
799      */
800     function tokenURI(uint256 tokenId) external view returns (string memory);
801 }
802 
803 // File: @openzeppelin/contracts@4.4.0/token/ERC721/ERC721.sol
804 
805 
806 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 
811 
812 
813 
814 
815 
816 
817 /**
818  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
819  * the Metadata extension, but not including the Enumerable extension, which is available separately as
820  * {ERC721Enumerable}.
821  */
822 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
823     using Address for address;
824     using Strings for uint256;
825 
826     // Token name
827     string private _name;
828 
829     // Token symbol
830     string private _symbol;
831 
832     // Mapping from token ID to owner address
833     mapping(uint256 => address) private _owners;
834 
835     // Mapping owner address to token count
836     mapping(address => uint256) private _balances;
837 
838     // Mapping from token ID to approved address
839     mapping(uint256 => address) private _tokenApprovals;
840 
841     // Mapping from owner to operator approvals
842     mapping(address => mapping(address => bool)) private _operatorApprovals;
843 
844     /**
845      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
846      */
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
856         return
857             interfaceId == type(IERC721).interfaceId ||
858             interfaceId == type(IERC721Metadata).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865     function balanceOf(address owner) public view virtual override returns (uint256) {
866         require(owner != address(0), "ERC721: balance query for the zero address");
867         return _balances[owner];
868     }
869 
870     /**
871      * @dev See {IERC721-ownerOf}.
872      */
873     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
874         address owner = _owners[tokenId];
875         require(owner != address(0), "ERC721: owner query for nonexistent token");
876         return owner;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-name}.
881      */
882     function name() public view virtual override returns (string memory) {
883         return _name;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-symbol}.
888      */
889     function symbol() public view virtual override returns (string memory) {
890         return _symbol;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-tokenURI}.
895      */
896     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
897         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
898 
899         string memory baseURI = _baseURI();
900         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
901     }
902 
903     /**
904      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
905      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
906      * by default, can be overriden in child contracts.
907      */
908     function _baseURI() internal view virtual returns (string memory) {
909         return "";
910     }
911 
912     /**
913      * @dev See {IERC721-approve}.
914      */
915     function approve(address to, uint256 tokenId) public virtual override {
916         address owner = ERC721.ownerOf(tokenId);
917         require(to != owner, "ERC721: approval to current owner");
918 
919         require(
920             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
921             "ERC721: approve caller is not owner nor approved for all"
922         );
923 
924         _approve(to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-getApproved}.
929      */
930     function getApproved(uint256 tokenId) public view virtual override returns (address) {
931         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
932 
933         return _tokenApprovals[tokenId];
934     }
935 
936     /**
937      * @dev See {IERC721-setApprovalForAll}.
938      */
939     function setApprovalForAll(address operator, bool approved) public virtual override {
940         _setApprovalForAll(_msgSender(), operator, approved);
941     }
942 
943     /**
944      * @dev See {IERC721-isApprovedForAll}.
945      */
946     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
947         return _operatorApprovals[owner][operator];
948     }
949 
950     /**
951      * @dev See {IERC721-transferFrom}.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         //solhint-disable-next-line max-line-length
959         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
960 
961         _transfer(from, to, tokenId);
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId
971     ) public virtual override {
972         safeTransferFrom(from, to, tokenId, "");
973     }
974 
975     /**
976      * @dev See {IERC721-safeTransferFrom}.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) public virtual override {
984         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
985         _safeTransfer(from, to, tokenId, _data);
986     }
987 
988     /**
989      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
990      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
991      *
992      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
993      *
994      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
995      * implement alternative mechanisms to perform token transfer, such as signature-based.
996      *
997      * Requirements:
998      *
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must exist and be owned by `from`.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeTransfer(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) internal virtual {
1012         _transfer(from, to, tokenId);
1013         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1014     }
1015 
1016     /**
1017      * @dev Returns whether `tokenId` exists.
1018      *
1019      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1020      *
1021      * Tokens start existing when they are minted (`_mint`),
1022      * and stop existing when they are burned (`_burn`).
1023      */
1024     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1025         return _owners[tokenId] != address(0);
1026     }
1027 
1028     /**
1029      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      */
1035     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1036         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1037         address owner = ERC721.ownerOf(tokenId);
1038         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1039     }
1040 
1041     /**
1042      * @dev Safely mints `tokenId` and transfers it to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must not exist.
1047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeMint(address to, uint256 tokenId) internal virtual {
1052         _safeMint(to, tokenId, "");
1053     }
1054 
1055     /**
1056      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1057      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) internal virtual {
1064         _mint(to, tokenId);
1065         require(
1066             _checkOnERC721Received(address(0), to, tokenId, _data),
1067             "ERC721: transfer to non ERC721Receiver implementer"
1068         );
1069     }
1070 
1071     /**
1072      * @dev Mints `tokenId` and transfers it to `to`.
1073      *
1074      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must not exist.
1079      * - `to` cannot be the zero address.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _mint(address to, uint256 tokenId) internal virtual {
1084         require(to != address(0), "ERC721: mint to the zero address");
1085         require(!_exists(tokenId), "ERC721: token already minted");
1086 
1087         _beforeTokenTransfer(address(0), to, tokenId);
1088 
1089         _balances[to] += 1;
1090         _owners[tokenId] = to;
1091 
1092         emit Transfer(address(0), to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Destroys `tokenId`.
1097      * The approval is cleared when the token is burned.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _burn(uint256 tokenId) internal virtual {
1106         address owner = ERC721.ownerOf(tokenId);
1107 
1108         _beforeTokenTransfer(owner, address(0), tokenId);
1109 
1110         // Clear approvals
1111         _approve(address(0), tokenId);
1112 
1113         _balances[owner] -= 1;
1114         delete _owners[tokenId];
1115 
1116         emit Transfer(owner, address(0), tokenId);
1117     }
1118 
1119     /**
1120      * @dev Transfers `tokenId` from `from` to `to`.
1121      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) internal virtual {
1135         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1136         require(to != address(0), "ERC721: transfer to the zero address");
1137 
1138         _beforeTokenTransfer(from, to, tokenId);
1139 
1140         // Clear approvals from the previous owner
1141         _approve(address(0), tokenId);
1142 
1143         _balances[from] -= 1;
1144         _balances[to] += 1;
1145         _owners[tokenId] = to;
1146 
1147         emit Transfer(from, to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev Approve `to` to operate on `tokenId`
1152      *
1153      * Emits a {Approval} event.
1154      */
1155     function _approve(address to, uint256 tokenId) internal virtual {
1156         _tokenApprovals[tokenId] = to;
1157         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Approve `operator` to operate on all of `owner` tokens
1162      *
1163      * Emits a {ApprovalForAll} event.
1164      */
1165     function _setApprovalForAll(
1166         address owner,
1167         address operator,
1168         bool approved
1169     ) internal virtual {
1170         require(owner != operator, "ERC721: approve to caller");
1171         _operatorApprovals[owner][operator] = approved;
1172         emit ApprovalForAll(owner, operator, approved);
1173     }
1174 
1175     /**
1176      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1177      * The call is not executed if the target address is not a contract.
1178      *
1179      * @param from address representing the previous owner of the given token ID
1180      * @param to target address that will receive the tokens
1181      * @param tokenId uint256 ID of the token to be transferred
1182      * @param _data bytes optional data to send along with the call
1183      * @return bool whether the call correctly returned the expected magic value
1184      */
1185     function _checkOnERC721Received(
1186         address from,
1187         address to,
1188         uint256 tokenId,
1189         bytes memory _data
1190     ) private returns (bool) {
1191         if (to.isContract()) {
1192             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1193                 return retval == IERC721Receiver.onERC721Received.selector;
1194             } catch (bytes memory reason) {
1195                 if (reason.length == 0) {
1196                     revert("ERC721: transfer to non ERC721Receiver implementer");
1197                 } else {
1198                     assembly {
1199                         revert(add(32, reason), mload(reason))
1200                     }
1201                 }
1202             }
1203         } else {
1204             return true;
1205         }
1206     }
1207 
1208     /**
1209      * @dev Hook that is called before any token transfer. This includes minting
1210      * and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` will be minted for `to`.
1217      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1218      * - `from` and `to` are never both zero.
1219      *
1220      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1221      */
1222     function _beforeTokenTransfer(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) internal virtual {}
1227 }
1228 
1229 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/ERC721Enumerable.sol
1230 
1231 
1232 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 
1237 
1238 /**
1239  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1240  * enumerability of all the token ids in the contract as well as all token ids owned by each
1241  * account.
1242  */
1243 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1244     // Mapping from owner to list of owned token IDs
1245     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1246 
1247     // Mapping from token ID to index of the owner tokens list
1248     mapping(uint256 => uint256) private _ownedTokensIndex;
1249 
1250     // Array with all token ids, used for enumeration
1251     uint256[] private _allTokens;
1252 
1253     // Mapping from token id to position in the allTokens array
1254     mapping(uint256 => uint256) private _allTokensIndex;
1255 
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1260         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1265      */
1266     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1267         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1268         return _ownedTokens[owner][index];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-totalSupply}.
1273      */
1274     function totalSupply() public view virtual override returns (uint256) {
1275         return _allTokens.length;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-tokenByIndex}.
1280      */
1281     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1282         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1283         return _allTokens[index];
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before any token transfer. This includes minting
1288      * and burning.
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _beforeTokenTransfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) internal virtual override {
1306         super._beforeTokenTransfer(from, to, tokenId);
1307 
1308         if (from == address(0)) {
1309             _addTokenToAllTokensEnumeration(tokenId);
1310         } else if (from != to) {
1311             _removeTokenFromOwnerEnumeration(from, tokenId);
1312         }
1313         if (to == address(0)) {
1314             _removeTokenFromAllTokensEnumeration(tokenId);
1315         } else if (to != from) {
1316             _addTokenToOwnerEnumeration(to, tokenId);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1322      * @param to address representing the new owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1324      */
1325     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1326         uint256 length = ERC721.balanceOf(to);
1327         _ownedTokens[to][length] = tokenId;
1328         _ownedTokensIndex[tokenId] = length;
1329     }
1330 
1331     /**
1332      * @dev Private function to add a token to this extension's token tracking data structures.
1333      * @param tokenId uint256 ID of the token to be added to the tokens list
1334      */
1335     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1336         _allTokensIndex[tokenId] = _allTokens.length;
1337         _allTokens.push(tokenId);
1338     }
1339 
1340     /**
1341      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1342      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1343      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1344      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1345      * @param from address representing the previous owner of the given token ID
1346      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1347      */
1348     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1349         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1350         // then delete the last slot (swap and pop).
1351 
1352         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1353         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1354 
1355         // When the token to delete is the last token, the swap operation is unnecessary
1356         if (tokenIndex != lastTokenIndex) {
1357             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1358 
1359             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1360             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1361         }
1362 
1363         // This also deletes the contents at the last position of the array
1364         delete _ownedTokensIndex[tokenId];
1365         delete _ownedTokens[from][lastTokenIndex];
1366     }
1367 
1368     /**
1369      * @dev Private function to remove a token from this extension's token tracking data structures.
1370      * This has O(1) time complexity, but alters the order of the _allTokens array.
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list
1372      */
1373     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1374         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = _allTokens.length - 1;
1378         uint256 tokenIndex = _allTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1381         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1382         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1383         uint256 lastTokenId = _allTokens[lastTokenIndex];
1384 
1385         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1386         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _allTokensIndex[tokenId];
1390         _allTokens.pop();
1391     }
1392 }
1393 
1394 // File: contracts/OnChainTarzan.sol
1395 
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 
1400 
1401 
1402 
1403 /// [MIT License]
1404 /// @title Base64
1405 /// @notice Provides a function for encoding some bytes in base64
1406 /// @author Brecht Devos <brecht@loopring.org>
1407 library Base64 {
1408     bytes internal constant TABLE =
1409         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1410 
1411     /// @notice Encodes some bytes to the base64 representation
1412     function encode(bytes memory data) internal pure returns (string memory) {
1413         uint256 len = data.length;
1414         if (len == 0) return "";
1415 
1416         // multiply by 4/3 rounded up
1417         uint256 encodedLen = 4 * ((len + 2) / 3);
1418 
1419         // Add some extra buffer at the end
1420         bytes memory result = new bytes(encodedLen + 32);
1421         bytes memory table = TABLE;
1422 
1423         assembly {
1424             let tablePtr := add(table, 1)
1425             let resultPtr := add(result, 32)
1426             for {
1427                 let i := 0
1428             } lt(i, len) {
1429 
1430             } {
1431                 i := add(i, 3)
1432                 let input := and(mload(add(data, i)), 0xffffff)
1433                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1434                 out := shl(8, out)
1435                 out := add(
1436                     out,
1437                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1438                 )
1439                 out := shl(8, out)
1440                 out := add(
1441                     out,
1442                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1443                 )
1444                 out := shl(8, out)
1445                 out := add(
1446                     out,
1447                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
1448                 )
1449                 out := shl(224, out)
1450                 mstore(resultPtr, out)
1451                 resultPtr := add(resultPtr, 4)
1452             }
1453             switch mod(len, 3)
1454             case 1 {
1455                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1456             }
1457             case 2 {
1458                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1459             }
1460             mstore(result, encodedLen)
1461         }
1462         return string(result);
1463     }
1464 }
1465 
1466 contract OnChainTarzan is ERC721Enumerable, ReentrancyGuard, Ownable {
1467     using Counters for Counters.Counter;
1468     using Strings for uint256;
1469     using Base64 for bytes;
1470 
1471     Counters.Counter private _tokenIdCounter;
1472 
1473     string[] private skinC = [
1474         "FFFFFF",
1475         "A0522D",
1476         "8d5524",
1477         "FFFAFA",
1478         "DEB887",
1479         "FFF5EE",
1480         "593123",
1481         "8B4513",
1482         "FAEBD7",
1483         "eac086",
1484         "D2B48C",
1485         "242424"
1486     ];
1487     string[] private skinCN = [
1488         "White",
1489         "Sienna",
1490         "Brown",
1491         "Snow",
1492         "Burly Wood",
1493         "SeaShell",
1494         "Black Brown",
1495         "Saddle Brown",
1496         "Antique White",
1497         "Caucasian",
1498         "Tan",
1499         "Black"
1500     ];
1501     uint16[] private skinCD = [
1502         512,
1503         512,
1504         512,
1505         512,
1506         512,
1507         512,
1508         512,
1509         512,
1510         1024,
1511         1024,
1512         1024,
1513         1024
1514     ];
1515 
1516     string[] private eyes = [
1517         "M7,10H8V11H9V12H15V11H16V10H17V11H16V12H8V11H7Z",
1518         "M7,12V11H8V10H16V11H17V12H16V11H15V10H9V11H8V12Z"
1519     ];
1520     string[] private eyesC = ["5d0070", "06f006", "fc9320", "aaa000"];
1521     string[] private eyesCN = ["Green", "Blue", "Brown", "Black"];
1522     uint16[] private eyesCD = [2, 1, 2, 1];
1523 
1524     string[] private earrings = [
1525         "M3,14V13H4V14Z",
1526         "M20,14V13H21V14Z",
1527         "M3,14V13H21V14H20V13H4V14Z"
1528     ];
1529     string[] private earringsN = ["Right", "Left", "Both"];
1530     uint16[] private earringsD = [3, 2, 2];
1531     string[] private earringsC = [
1532         "1F45FC",
1533         "FDD017",
1534         "6960EC",
1535         "00FFFF",
1536         "E41B17",
1537         "4AA02C",
1538         "F9B7FF",
1539         "59E817",
1540         "F6358A"
1541     ];
1542     string[] private earringsCN = [
1543         "Blue Orchid",
1544         "Bright Gold",
1545         "Blue Lotus",
1546         "Cyan",
1547         "Love Red",
1548         "Blossom Pink",
1549         "Spring Green",
1550         "Nebula Green",
1551         "Violet Red"
1552     ];
1553     uint16[] private earringsCD = [
1554         1,
1555         2,
1556         5,
1557         3,
1558         7,
1559         11,
1560         13,
1561         17,
1562         19
1563     ];
1564 
1565     string[] private tattoos = [
1566         "M15,6V5H16V6H17V7H16V6Z",
1567         "M10,22V21H11V22H13V21H14V22H13V23H11V22Z",
1568         "M10,23V22H11V21H13V22H14V23H13V22H11V23Z",
1569         "M9,22V21H10V22H11V21H13V22H14V21H15V22H14V23H13V22H11V23H10V22Z",
1570         "M9,23V22H10V21H11V22H13V21H14V22H15V23H14V22H13V23H11V22H10V23Z"
1571     ];
1572     string[] private tattoosN = ["I", "II", "III", "IV", "V"];
1573     uint16[] private tattoosD = [3, 7, 5, 11, 13];
1574     string[] private tattoosC = ["333333", "881111"];
1575     string[] private tattoosCN = ["Gray", "Blood"];
1576     uint16[] private tattoosCD = [5, 3];
1577 
1578     string[] private eyePatches = [
1579         "M4,10V8H20V10H17V9H15V10H14V12H15V13H17V12H18V10H20V14H3V16H1V14H3V13H4V11H6V12H7V13H9V12H10V10H9V9H7V10H6V11H4Z",
1580         "M3,10V9H21V10H19V13H13V10H11V13H5V10Z",
1581         "M3,10V9H21V10H19V12H18V13H14V12H13V10H11V12H10V13H6V12H5V10Z",
1582         "M3,9V8H21V9H11V12H10V13H9V14H8V13H7V12H6V9Z",
1583         "M3,9V8H21V9H18V12H17V13H16V14H15V13H14V12H13V9Z"
1584     ];
1585     string[] private eyePatchesN = [
1586         "Ninja",
1587         "Sun Glasses I",
1588         "Sun Glasses II",
1589         "Right Pirate Patch",
1590         "Left Pirate Patch"
1591     ];
1592     uint16[] private eyePatchesD = [3, 5, 5, 7, 11];
1593     string[] private eyePatchesC = [
1594         "827839",
1595         "C35817",
1596         "2B65EC",
1597         "8C001A",
1598         "7D0552",
1599         "43C6DB",
1600         "FCDFFF",
1601         "FF00FF",
1602         "347C2C",
1603         "4B0082",
1604         "493D26",
1605         "C9BE62",
1606         "54C571",
1607         "342D7E",
1608         "25383C",
1609         "2C3539"
1610     ];
1611     string[] private eyePatchesCN = [
1612         "Moccasin",
1613         "Red Fox",
1614         "Ocean Blue",
1615         "Burgundy",
1616         "Plum Velvet",
1617         "Turquoise",
1618         "Cotton Candy",
1619         "Magenta",
1620         "Jungle Green",
1621         "Indigo",
1622         "Mocha",
1623         "Ginger Brown",
1624         "Zombie Green",
1625         "Blue Whale",
1626         "Dark Slate Gray",
1627         "Gunmetal"
1628     ];
1629     uint16[] private eyePatchesCD = [
1630         2,
1631         2,
1632         3,
1633         3,
1634         3,
1635         5,
1636         7,
1637         5,
1638         7,
1639         11,
1640         13,
1641         3,
1642         7,
1643         13,
1644         7,
1645         17
1646     ];
1647 
1648     string[] private hairs = [
1649         "M6,4V1H18V4Z",
1650         "M4,6V4H5V3H6V2H18V3H19V4H20V6H18V5H17V4H7V5H6V6Z",
1651         "M4,13V9H3V5H4V4H5V3H6V2H18V3H19V4H20V5H21V9H20V13H19V6H18V5H17V4H7V5H6V6H5V13Z",
1652         "M2,20V6H3V5H4V4H5V3H6V2H18V3H19V4H20V5H21V6H22V17H22V20H21V18H20V22H19V20H18V24H17V20H18V19H19V17H20V13H21V10H20V9H19V6H18V5H17V4H7V5H6V6H5V9H4V10H3V13H4V18H5V19H6V20H7V24H6V20H5V22H4V18H3V20H2V6Z",
1653         "M2,20V6H3V5H4V4H5V3H6V2H18V3H19V4H20V5H21V6H22V17H22V20H21V18H20V22H19V20H18V24H17V20H18V19H19V17H20V13H21V10H20V9H19V6H18V5H17V4H11V7H10V4H9V8H8V4H7V8H6V6H5V9H4V10H3V13H4V18H5V19H6V20H7V24H6V20H5V22H4V18H3V20H2V6Z",
1654         "M2,20V6H3V5H4V4H5V3H6V2H18V3H19V4H20V5H21V6H22V20H21V21H20V22H19V23H18V24H17V20H18V19H19V18H20V13H21V10H20V9H19V6H18V5H17V4H7V5H6V6H5V9H4V10H3V13H4V18H5V19H6V20H7V24H6V23H5V22H4V21H3V20Z",
1655         "M2,20V6H3V5H4V4H5V3H6V2H18V3H19V4H20V5H21V6H22V20H21V21H20V22H19V23H18V24H17V20H18V19H19V18H20V13H21V10H20V9H19V6H18V5H17V4H15V6H13V8H11V10H9V12H7V14H5V16H4V18H5V19H6V20H7V24H6V23H5V22H4V21H3V20Z"
1656     ];
1657     string[] private hairsN = [
1658         "Classic Fade",
1659         "High Fade",
1660         "Pompadour",
1661         "Long Pushed Back",
1662         "Tarzan Cut",
1663         "Hockey",
1664         "Macho Long"
1665     ];
1666     uint16[] private hairsD = [23, 27, 19, 5, 17, 13, 31];
1667     string[] private hairsC = [
1668         "000000",
1669         "625D5D",
1670         "EDDA74",
1671         "616D7E",
1672         "806517",
1673         "FFF8C6",
1674         "C68E17",
1675         "835C3B",
1676         "FFD801",
1677         "7E3817",
1678         "EBDDE2"
1679     ];
1680     string[] private hairsCN = [
1681         "Black",
1682         "Carbon Gray",
1683         "Goldenrod",
1684         "Jet Gray",
1685         "Oak Brown",
1686         "Lemon Chiffon",
1687         "Caramel",
1688         "Brown Bear",
1689         "Golden",
1690         "Sangria",
1691         "Lavender Pinocchio"
1692     ];
1693     uint16[] private hairsCD = [
1694         43,
1695         7,
1696         37,
1697         17,
1698         11,
1699         53,
1700         71,
1701         13,
1702         7,
1703         7,
1704         103
1705     ];
1706 
1707     string[] private hats = [
1708         "XXX",
1709         "M3,8V4H4V3H5V2H6V1H7V0H17V1H18V2H19V3H20V4H21V8Z",
1710         "M3,6V4H5V0H19V4H21V6Z",
1711         "M1,5V6H20V1H4V5Z"
1712     ];
1713     string[] private hatsN = ["None", "Beret", "Panama", "Cap"];
1714     uint16[] private hatsD = [997, 101, 103, 307];
1715     string[] private hatsC = [
1716         "893BFF",
1717         "7D0541",
1718         "4C787E",
1719         "483C32",
1720         "9E7BFF",
1721         "AF9B60",
1722         "4863A0",
1723         "736AFF",
1724         "483C32",
1725         "000080",
1726         "800517"
1727     ];
1728     string[] private hatsCN = [
1729         "Aztech Purple",
1730         "Plum Pie",
1731         "Beetle Green",
1732         "Taupe",
1733         "Purple Mimosa",
1734         "Bullet Shell",
1735         "Steel Blue",
1736         "Light Slate Blue",
1737         "Sunrise Orange",
1738         "Navy Blue",
1739         "Firebrick"
1740     ];
1741     uint16[] private hatsCD = [
1742         7,
1743         5,
1744         37,
1745         23,
1746         101,
1747         71,
1748         43,
1749         17,
1750         137,
1751         743,
1752         103
1753     ];
1754 
1755     string[] private beard = [
1756         "M9,19V16H15V19H14V17H10V19Z",
1757         "M9,20V16H15V20H14V17H10V18H13V19H11V18H10V20Z",
1758         "M9,20V16H15V21H14V22H13V23H11V22H10V21H9V20H11V18H13V20H14V17H10V20Z",
1759         "M9,20H7V19H6V18H5V15H6V16H7V17H9V16H15V17H17V16H18V15H19V18H18V19H17V20H15V21H14V22H13V23H11V22H10V21H9V20H11V18H13V20H14V17H10V20Z",
1760         "M10,17H7V16H6V15H5V18H6V19H7V20H8V21H16V20H17V19H18V18H19V15H18V16H17V17H15V16H9V17H14V19H13V18H11V19H10V17Z",
1761         "M10,17H7V16H6V15H5V14H4V19H5V20H6V21H7V22H9V23H11V24H13V23H15V22H17V21H18V20H19V19H20V14H19V15H18V16H17V17H15V16H9V17H14V18H10V17Z"
1762     ];
1763     string[] private beardN = [
1764         "Fu Manchu",
1765         "Zappa",
1766         "Van Dyke",
1767         "Ducktail",
1768         "Boxed",
1769         "Full Untouched"
1770     ];
1771     uint16[] private beardD = [43, 19, 71, 83, 13, 131];
1772     string[] private beardC = [
1773         "806517",
1774         "FFF8C6",
1775         "000000",
1776         "EDDA74",
1777         "616D7E",
1778         "625D5D",
1779         "FFD801",
1780         "C68E17",
1781         "835C3B",
1782         "7E3817",
1783         "EBDDE2"
1784     ];
1785     string[] private beardCN = [
1786         "Oak Brown",
1787         "Lemon Chiffon",
1788         "Black",
1789         "Goldenrod",
1790         "Jet Gray",
1791         "Carbon Gray",
1792         "Golden",
1793         "Caramel",
1794         "Brown Bear",
1795         "Sangria",
1796         "Lavender Pinocchio"
1797     ];
1798     uint16[] private beardCD = [
1799         23,
1800         31,
1801         43,
1802         53,
1803         71,
1804         83,
1805         103,
1806         211,
1807         313,
1808         149,
1809         179
1810     ];
1811 
1812     function getTrait(uint256 tokenId, uint16[] memory traitD, uint256 weight)
1813         private
1814         pure
1815         returns (uint256)
1816     {
1817         uint256 tokenHash = uint256(keccak256(bytes(tokenId.toString()))) %
1818             weight;
1819         uint i = 0;
1820         uint256 currentBound = traitD[i];
1821         while (tokenHash > currentBound) {
1822             i++;
1823             currentBound += traitD[i];
1824         }
1825         return i;
1826     }
1827 
1828     function genFace(uint256 tokenId)
1829         private
1830         view
1831         returns (string memory, string memory)
1832     {
1833         uint256 selectedTrait = getTrait(tokenId, skinCD, 8192);
1834         string memory svg = string(
1835             abi.encodePacked(
1836                 '<path d="M5,6H6V5H7V4H17V5H18V6H19V18H18V19H17V20H16V24H8V20H7V19H6V18H5Z" fill="#',
1837                 skinC[selectedTrait],
1838                 '" />',
1839                 '<path d="M8,24V20H7V19H6V18H5V6H6V5H7V4H17V5H18V6H19V18H18V19H17V20H16V24H17V20H18V19H19V18H20V13H21V9H20V6H19V5H18V4H17V3H7V4H6V5H5V6H4V9H3V13H4V18H5V19H6V20H7V24Z" fill="#333" />',
1840                 '<path d="M7,13V12H6V11H5V10H7V9H9V10H10V11H11V12H13V11H14V10H15V9H17V10H19V11H18V12H17V13H15V12H9V13Z" fill="#DDD"/>',
1841                 '<path d="M12,16H11V15H13V16H12V17H14V18H10V17H12V16Z" fill="#333"/>'
1842             )
1843         );
1844         string memory trait = string(
1845             abi.encodePacked(
1846                 '{"trait_type":"Skin","value":"',
1847                 skinCN[selectedTrait],
1848                 '"}'
1849             )
1850         );
1851         return (svg, trait);
1852     }
1853 
1854     function genEyes(uint256 tokenId)
1855         private
1856         view
1857         returns (string memory, string memory)
1858     {
1859         string memory svg;
1860         uint256 selectedTrait = getTrait(tokenId, eyesCD, 6);
1861         string memory eyesColorSet = eyesC[selectedTrait];
1862         bytes memory eyesColorSetBytes = bytes(eyesColorSet);
1863         string memory firstEyesColor = string(
1864             abi.encodePacked(
1865                 eyesColorSetBytes[0],
1866                 eyesColorSetBytes[1],
1867                 eyesColorSetBytes[2]
1868             )
1869         );
1870         string memory secondEyesColor = string(
1871             abi.encodePacked(
1872                 eyesColorSetBytes[3],
1873                 eyesColorSetBytes[4],
1874                 eyesColorSetBytes[5]
1875             )
1876         );
1877         svg = string(
1878             abi.encodePacked(
1879                 '<path d="',
1880                 eyes[0],
1881                 '" fill="#',
1882                 firstEyesColor,
1883                 '" />',
1884                 '<path d="',
1885                 eyes[1],
1886                 '" fill="#',
1887                 secondEyesColor,
1888                 '" />'
1889             )
1890         );
1891         string memory trait = string(
1892             abi.encodePacked(
1893                 '{"trait_type":"Eyes","value":"',
1894                 eyesCN[selectedTrait],
1895                 '"}'
1896             )
1897         );
1898         return (svg, trait);
1899     }
1900 
1901     function genEarrings(uint256 tokenId)
1902         private
1903         view
1904         returns (string memory, string memory)
1905     {
1906         string memory svg;
1907         string memory trait;
1908         uint selectedTrait = getTrait(tokenId, earringsD, 7);
1909         uint selectedTraitColor = getTrait(tokenId, earringsCD, 78);
1910         svg = string(
1911             abi.encodePacked(
1912                 '<path d="',
1913                 earrings[selectedTrait],
1914                 '" fill="#',
1915                 earringsC[selectedTraitColor],
1916                 '" />'
1917             )
1918         );
1919         trait = string(
1920             abi.encodePacked(
1921                 '{"trait_type":"Earring","value":"',
1922                 earringsCN[selectedTraitColor],
1923                 " ",
1924                 earringsN[selectedTrait],
1925                 '"}'
1926             )
1927         );
1928         return (svg, trait);
1929     }
1930 
1931     function genTattoos(uint256 tokenId)
1932         private
1933         view
1934         returns (string memory, string memory)
1935     {
1936         string memory svg;
1937         string memory trait;
1938         uint selectedTrait = getTrait(tokenId, tattoosD, 39);
1939         uint selectedTraitColor = getTrait(tokenId, tattoosCD, 8);
1940         svg = string(
1941             abi.encodePacked(
1942                 '<path d="',
1943                 tattoos[selectedTrait],
1944                 '" fill="#',
1945                 tattoosC[selectedTraitColor],
1946                 '" />'
1947             )
1948         );
1949         trait = string(
1950             abi.encodePacked(
1951                 '{"trait_type":"Tattoo","value":"',
1952                 tattoosCN[selectedTraitColor],
1953                 " ",
1954                 tattoosN[selectedTrait],
1955                 '"}'
1956             )
1957         );
1958         return (svg, trait);
1959     }
1960 
1961     function genEyePatches(uint256 tokenId)
1962         private
1963         view
1964         returns (string memory, string memory)
1965     {
1966         string memory svg;
1967         string memory trait;
1968         uint selectedTrait = getTrait(tokenId, eyePatchesD, 31);
1969         uint selectedTraitColor = getTrait(tokenId, eyePatchesCD, 108);
1970         svg = string(
1971             abi.encodePacked(
1972                 '<path d="',
1973                 eyePatches[selectedTrait],
1974                 '" fill="#',
1975                 eyePatchesC[selectedTraitColor],
1976                 '" />'
1977             )
1978         );
1979 
1980         trait = string(
1981             abi.encodePacked(
1982                 '{"trait_type":"Eyepatch","value":"',
1983                 eyePatchesCN[selectedTraitColor],
1984                 " ",
1985                 eyePatchesN[selectedTrait],
1986                 '"}'
1987             )
1988         );
1989         return (svg, trait);
1990     }
1991 
1992     function genHairs(uint256 tokenId)
1993         private
1994         view
1995         returns (string memory, string memory)
1996     {
1997         string memory svg;
1998         string memory trait;
1999         uint selectedTrait = getTrait(tokenId, hairsD, 135);
2000         uint selectedTraitColor = getTrait(tokenId, hairsCD, 369);
2001         svg = string(
2002             abi.encodePacked(
2003                 '<path d="',
2004                 hairs[selectedTrait],
2005                 '" fill="#',
2006                 hairsC[selectedTraitColor],
2007                 '" />'
2008             )
2009         );
2010         trait = string(
2011             abi.encodePacked(
2012                 '{"trait_type":"Hair","value":"',
2013                 hairsCN[selectedTraitColor],
2014                 " ",
2015                 hairsN[selectedTrait],
2016                 '"}'
2017             )
2018         );
2019         return (svg, trait);
2020     }
2021 
2022     function genHats(uint256 tokenId)
2023         private
2024         view
2025         returns (string memory, string memory)
2026     {
2027         string memory svg;
2028         string memory trait;
2029         uint selectedTrait = getTrait(tokenId, hatsD, 1508);
2030         if (keccak256("XXX") != keccak256(bytes(hats[selectedTrait]))) {
2031             uint selectedTraitColor = getTrait(tokenId, hatsCD, 1287);
2032             svg = string(
2033                 abi.encodePacked(
2034                     '<path d="',
2035                     hats[selectedTrait],
2036                     '" fill="#',
2037                     hatsC[selectedTraitColor],
2038                     '" />'
2039                 )
2040             );
2041             trait = string(
2042                 abi.encodePacked(
2043                     '{"trait_type":"Hat","value":"',
2044                     hatsCN[selectedTraitColor],
2045                     " ",
2046                     hatsN[selectedTrait],
2047                     '"}'
2048                 )
2049             );
2050         } else {
2051             svg = "";
2052             trait = string(
2053                 abi.encodePacked(bytes('{"trait_type":"Hat","value":"None"}'))
2054             );
2055         }
2056         return (svg, trait);
2057     }
2058 
2059     function genBeard(uint256 tokenId)
2060         private
2061         view
2062         returns (string memory, string memory)
2063     {
2064         string memory svg;
2065         string memory trait;
2066         uint selectedTrait = getTrait(tokenId, beardD, 360);
2067         uint selectedTraitColor = getTrait(tokenId, beardCD, 1259);
2068         svg = string(
2069             abi.encodePacked(
2070                 '<path d="',
2071                 beard[selectedTrait],
2072                 '" fill="#',
2073                 beardC[selectedTraitColor],
2074                 '" />'
2075             )
2076         );
2077         trait = string(
2078             abi.encodePacked(
2079                 '{"trait_type":"Beard","value":"',
2080                 beardCN[selectedTraitColor],
2081                 " ",
2082                 beardN[selectedTrait],
2083                 '"}'
2084             )
2085         );
2086         return (svg, trait);
2087     }
2088 
2089     function tokenURI(uint256 tokenId)
2090         public
2091         view
2092         override
2093         returns (string memory)
2094     {
2095         require(_exists(tokenId), "ERC721Metadata: Deed does not exist!");
2096         string memory partialSVG;
2097         string memory partialAttributes;
2098         string
2099             memory svg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" shape-rendering="crispEdges" viewBox="0 0 24 24">';
2100         string memory attributes = "[";
2101         (partialSVG, partialAttributes) = genFace(tokenId);
2102         attributes = string(
2103             abi.encodePacked(attributes, partialAttributes, ",")
2104         );
2105         svg = string(abi.encodePacked(svg, partialSVG));
2106         (partialSVG, partialAttributes) = genEyes(tokenId);
2107         attributes = string(
2108             abi.encodePacked(attributes, partialAttributes, ",")
2109         );
2110         svg = string(abi.encodePacked(svg, partialSVG));
2111         (partialSVG, partialAttributes) = genEarrings(tokenId);
2112         attributes = string(
2113             abi.encodePacked(attributes, partialAttributes, ",")
2114         );
2115         svg = string(abi.encodePacked(svg, partialSVG));
2116         (partialSVG, partialAttributes) = genTattoos(tokenId);
2117         attributes = string(
2118             abi.encodePacked(attributes, partialAttributes, ",")
2119         );
2120         svg = string(abi.encodePacked(svg, partialSVG));
2121         (partialSVG, partialAttributes) = genEyePatches(tokenId);
2122         attributes = string(
2123             abi.encodePacked(attributes, partialAttributes, ",")
2124         );
2125         svg = string(abi.encodePacked(svg, partialSVG));
2126         (partialSVG, partialAttributes) = genHairs(tokenId);
2127         attributes = string(
2128             abi.encodePacked(attributes, partialAttributes, ",")
2129         );
2130         svg = string(abi.encodePacked(svg, partialSVG));
2131         (partialSVG, partialAttributes) = genHats(tokenId);
2132         attributes = string(
2133             abi.encodePacked(attributes, partialAttributes, ",")
2134         );
2135         svg = string(abi.encodePacked(svg, partialSVG));
2136         (partialSVG, partialAttributes) = genBeard(tokenId);
2137         attributes = string(abi.encodePacked(attributes, partialAttributes));
2138         svg = string(abi.encodePacked(svg, partialSVG));
2139 
2140         svg = string(abi.encodePacked(svg, "</svg>"));
2141         attributes = string(abi.encodePacked(attributes, "]"));
2142 
2143         string memory _tokenURI = string(
2144             abi.encodePacked(
2145                 "data:application/json;base64,",
2146                 Base64.encode(
2147                     abi.encodePacked(
2148                         '{"name": "OnChainTarzan #',
2149                         tokenId.toString(),
2150                         '", "description": "OnChainTarzan is building a Metaverse FULLY Onchain! All the metadata and images are generated and stored 100% on-chain. No IPFS, no API. Merely Ethereum blockchain.", "image": "data:image/svg+xml;base64,',
2151                         Base64.encode(bytes(svg)),
2152                         '","attributes":',
2153                         attributes,
2154                         "}"
2155                     )
2156                 )
2157             )
2158         );
2159         return _tokenURI;
2160     }
2161 
2162     function safeMint() public nonReentrant {
2163         uint256 tokenId = _tokenIdCounter.current();
2164         require(tokenId < 7680);
2165         _tokenIdCounter.increment();
2166         _safeMint(_msgSender(), tokenId);
2167     }
2168 
2169     function safeMintOwner(uint256 tokenId) public nonReentrant onlyOwner {
2170         require(tokenId > 7679 && tokenId < 8192);
2171         _safeMint(owner(), tokenId);
2172     }
2173 
2174     constructor() ERC721("OnChainTarzan", "OCTRZN") Ownable() {}
2175 }