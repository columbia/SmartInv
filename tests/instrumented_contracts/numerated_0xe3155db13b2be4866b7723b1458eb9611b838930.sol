1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
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
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @title Counters
76  * @author Matt Condon (@shrugs)
77  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
78  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
79  *
80  * Include with `using Counters for Counters.Counter;`
81  */
82 library Counters {
83     struct Counter {
84         // This variable should never be directly accessed by users of the library: interactions must be restricted to
85         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
86         // this feature: see https://github.com/ethereum/solidity/issues/4637
87         uint256 _value; // default: 0
88     }
89 
90     function current(Counter storage counter) internal view returns (uint256) {
91         return counter._value;
92     }
93 
94     function increment(Counter storage counter) internal {
95         unchecked {
96             counter._value += 1;
97         }
98     }
99 
100     function decrement(Counter storage counter) internal {
101         uint256 value = counter._value;
102         require(value > 0, "Counter: decrement overflow");
103         unchecked {
104             counter._value = value - 1;
105         }
106     }
107 
108     function reset(Counter storage counter) internal {
109         counter._value = 0;
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
566 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @dev Implementation of the {IERC165} interface.
576  *
577  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
578  * for the additional interface id that will be supported. For example:
579  *
580  * ```solidity
581  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
583  * }
584  * ```
585  *
586  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
587  */
588 abstract contract ERC165 is IERC165 {
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593         return interfaceId == type(IERC165).interfaceId;
594     }
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @dev Required interface of an ERC721 compliant contract.
607  */
608 interface IERC721 is IERC165 {
609     /**
610      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
611      */
612     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
613 
614     /**
615      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
616      */
617     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
618 
619     /**
620      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
621      */
622     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
623 
624     /**
625      * @dev Returns the number of tokens in ``owner``'s account.
626      */
627     function balanceOf(address owner) external view returns (uint256 balance);
628 
629     /**
630      * @dev Returns the owner of the `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function ownerOf(uint256 tokenId) external view returns (address owner);
637 
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Transfers `tokenId` token from `from` to `to`.
660      *
661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
680      * The approval is cleared when the token is transferred.
681      *
682      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
683      *
684      * Requirements:
685      *
686      * - The caller must own the token or be an approved operator.
687      * - `tokenId` must exist.
688      *
689      * Emits an {Approval} event.
690      */
691     function approve(address to, uint256 tokenId) external;
692 
693     /**
694      * @dev Returns the account approved for `tokenId` token.
695      *
696      * Requirements:
697      *
698      * - `tokenId` must exist.
699      */
700     function getApproved(uint256 tokenId) external view returns (address operator);
701 
702     /**
703      * @dev Approve or remove `operator` as an operator for the caller.
704      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
705      *
706      * Requirements:
707      *
708      * - The `operator` cannot be the caller.
709      *
710      * Emits an {ApprovalForAll} event.
711      */
712     function setApprovalForAll(address operator, bool _approved) external;
713 
714     /**
715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
716      *
717      * See {setApprovalForAll}
718      */
719     function isApprovedForAll(address owner, address operator) external view returns (bool);
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes calldata data
739     ) external;
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
752  * @dev See https://eips.ethereum.org/EIPS/eip-721
753  */
754 interface IERC721Enumerable is IERC721 {
755     /**
756      * @dev Returns the total amount of tokens stored by the contract.
757      */
758     function totalSupply() external view returns (uint256);
759 
760     /**
761      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
762      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
763      */
764     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
765 
766     /**
767      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
768      * Use along with {totalSupply} to enumerate all tokens.
769      */
770     function tokenByIndex(uint256 index) external view returns (uint256);
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 /**
782  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
783  * @dev See https://eips.ethereum.org/EIPS/eip-721
784  */
785 interface IERC721Metadata is IERC721 {
786     /**
787      * @dev Returns the token collection name.
788      */
789     function name() external view returns (string memory);
790 
791     /**
792      * @dev Returns the token collection symbol.
793      */
794     function symbol() external view returns (string memory);
795 
796     /**
797      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
798      */
799     function tokenURI(uint256 tokenId) external view returns (string memory);
800 }
801 
802 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
803 
804 
805 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 
810 
811 
812 
813 
814 
815 
816 /**
817  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
818  * the Metadata extension, but not including the Enumerable extension, which is available separately as
819  * {ERC721Enumerable}.
820  */
821 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
822     using Address for address;
823     using Strings for uint256;
824 
825     // Token name
826     string private _name;
827 
828     // Token symbol
829     string private _symbol;
830 
831     // Mapping from token ID to owner address
832     mapping(uint256 => address) private _owners;
833 
834     // Mapping owner address to token count
835     mapping(address => uint256) private _balances;
836 
837     // Mapping from token ID to approved address
838     mapping(uint256 => address) private _tokenApprovals;
839 
840     // Mapping from owner to operator approvals
841     mapping(address => mapping(address => bool)) private _operatorApprovals;
842 
843     /**
844      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
845      */
846     constructor(string memory name_, string memory symbol_) {
847         _name = name_;
848         _symbol = symbol_;
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return
856             interfaceId == type(IERC721).interfaceId ||
857             interfaceId == type(IERC721Metadata).interfaceId ||
858             super.supportsInterface(interfaceId);
859     }
860 
861     /**
862      * @dev See {IERC721-balanceOf}.
863      */
864     function balanceOf(address owner) public view virtual override returns (uint256) {
865         require(owner != address(0), "ERC721: balance query for the zero address");
866         return _balances[owner];
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
873         address owner = _owners[tokenId];
874         require(owner != address(0), "ERC721: owner query for nonexistent token");
875         return owner;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-name}.
880      */
881     function name() public view virtual override returns (string memory) {
882         return _name;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-symbol}.
887      */
888     function symbol() public view virtual override returns (string memory) {
889         return _symbol;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-tokenURI}.
894      */
895     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
896         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
897 
898         string memory baseURI = _baseURI();
899         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
900     }
901 
902     /**
903      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
904      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
905      * by default, can be overriden in child contracts.
906      */
907     function _baseURI() internal view virtual returns (string memory) {
908         return "";
909     }
910 
911     /**
912      * @dev See {IERC721-approve}.
913      */
914     function approve(address to, uint256 tokenId) public virtual override {
915         address owner = ERC721.ownerOf(tokenId);
916         require(to != owner, "ERC721: approval to current owner");
917 
918         require(
919             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
920             "ERC721: approve caller is not owner nor approved for all"
921         );
922 
923         _approve(to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-getApproved}.
928      */
929     function getApproved(uint256 tokenId) public view virtual override returns (address) {
930         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
931 
932         return _tokenApprovals[tokenId];
933     }
934 
935     /**
936      * @dev See {IERC721-setApprovalForAll}.
937      */
938     function setApprovalForAll(address operator, bool approved) public virtual override {
939         _setApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         //solhint-disable-next-line max-line-length
958         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
959 
960         _transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, "");
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
984         _safeTransfer(from, to, tokenId, _data);
985     }
986 
987     /**
988      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
989      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
990      *
991      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
992      *
993      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
994      * implement alternative mechanisms to perform token transfer, such as signature-based.
995      *
996      * Requirements:
997      *
998      * - `from` cannot be the zero address.
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must exist and be owned by `from`.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeTransfer(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) internal virtual {
1011         _transfer(from, to, tokenId);
1012         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1013     }
1014 
1015     /**
1016      * @dev Returns whether `tokenId` exists.
1017      *
1018      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1019      *
1020      * Tokens start existing when they are minted (`_mint`),
1021      * and stop existing when they are burned (`_burn`).
1022      */
1023     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1024         return _owners[tokenId] != address(0);
1025     }
1026 
1027     /**
1028      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1035         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1036         address owner = ERC721.ownerOf(tokenId);
1037         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1038     }
1039 
1040     /**
1041      * @dev Safely mints `tokenId` and transfers it to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must not exist.
1046      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _safeMint(address to, uint256 tokenId) internal virtual {
1051         _safeMint(to, tokenId, "");
1052     }
1053 
1054     /**
1055      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1056      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) internal virtual {
1063         _mint(to, tokenId);
1064         require(
1065             _checkOnERC721Received(address(0), to, tokenId, _data),
1066             "ERC721: transfer to non ERC721Receiver implementer"
1067         );
1068     }
1069 
1070     /**
1071      * @dev Mints `tokenId` and transfers it to `to`.
1072      *
1073      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - `to` cannot be the zero address.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _mint(address to, uint256 tokenId) internal virtual {
1083         require(to != address(0), "ERC721: mint to the zero address");
1084         require(!_exists(tokenId), "ERC721: token already minted");
1085 
1086         _beforeTokenTransfer(address(0), to, tokenId);
1087 
1088         _balances[to] += 1;
1089         _owners[tokenId] = to;
1090 
1091         emit Transfer(address(0), to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Destroys `tokenId`.
1096      * The approval is cleared when the token is burned.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _burn(uint256 tokenId) internal virtual {
1105         address owner = ERC721.ownerOf(tokenId);
1106 
1107         _beforeTokenTransfer(owner, address(0), tokenId);
1108 
1109         // Clear approvals
1110         _approve(address(0), tokenId);
1111 
1112         _balances[owner] -= 1;
1113         delete _owners[tokenId];
1114 
1115         emit Transfer(owner, address(0), tokenId);
1116     }
1117 
1118     /**
1119      * @dev Transfers `tokenId` from `from` to `to`.
1120      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must be owned by `from`.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) internal virtual {
1134         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1135         require(to != address(0), "ERC721: transfer to the zero address");
1136 
1137         _beforeTokenTransfer(from, to, tokenId);
1138 
1139         // Clear approvals from the previous owner
1140         _approve(address(0), tokenId);
1141 
1142         _balances[from] -= 1;
1143         _balances[to] += 1;
1144         _owners[tokenId] = to;
1145 
1146         emit Transfer(from, to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Approve `to` to operate on `tokenId`
1151      *
1152      * Emits a {Approval} event.
1153      */
1154     function _approve(address to, uint256 tokenId) internal virtual {
1155         _tokenApprovals[tokenId] = to;
1156         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev Approve `operator` to operate on all of `owner` tokens
1161      *
1162      * Emits a {ApprovalForAll} event.
1163      */
1164     function _setApprovalForAll(
1165         address owner,
1166         address operator,
1167         bool approved
1168     ) internal virtual {
1169         require(owner != operator, "ERC721: approve to caller");
1170         _operatorApprovals[owner][operator] = approved;
1171         emit ApprovalForAll(owner, operator, approved);
1172     }
1173 
1174     /**
1175      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1176      * The call is not executed if the target address is not a contract.
1177      *
1178      * @param from address representing the previous owner of the given token ID
1179      * @param to target address that will receive the tokens
1180      * @param tokenId uint256 ID of the token to be transferred
1181      * @param _data bytes optional data to send along with the call
1182      * @return bool whether the call correctly returned the expected magic value
1183      */
1184     function _checkOnERC721Received(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) private returns (bool) {
1190         if (to.isContract()) {
1191             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1192                 return retval == IERC721Receiver.onERC721Received.selector;
1193             } catch (bytes memory reason) {
1194                 if (reason.length == 0) {
1195                     revert("ERC721: transfer to non ERC721Receiver implementer");
1196                 } else {
1197                     assembly {
1198                         revert(add(32, reason), mload(reason))
1199                     }
1200                 }
1201             }
1202         } else {
1203             return true;
1204         }
1205     }
1206 
1207     /**
1208      * @dev Hook that is called before any token transfer. This includes minting
1209      * and burning.
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` will be minted for `to`.
1216      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1217      * - `from` and `to` are never both zero.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {}
1226 }
1227 
1228 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1229 
1230 
1231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 
1236 
1237 /**
1238  * @title ERC721 Burnable Token
1239  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1240  */
1241 abstract contract ERC721Burnable is Context, ERC721 {
1242     /**
1243      * @dev Burns `tokenId`. See {ERC721-_burn}.
1244      *
1245      * Requirements:
1246      *
1247      * - The caller must own `tokenId` or be an approved operator.
1248      */
1249     function burn(uint256 tokenId) public virtual {
1250         //solhint-disable-next-line max-line-length
1251         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1252         _burn(tokenId);
1253     }
1254 }
1255 
1256 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1257 
1258 
1259 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 /**
1266  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1267  * enumerability of all the token ids in the contract as well as all token ids owned by each
1268  * account.
1269  */
1270 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1271     // Mapping from owner to list of owned token IDs
1272     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1273 
1274     // Mapping from token ID to index of the owner tokens list
1275     mapping(uint256 => uint256) private _ownedTokensIndex;
1276 
1277     // Array with all token ids, used for enumeration
1278     uint256[] private _allTokens;
1279 
1280     // Mapping from token id to position in the allTokens array
1281     mapping(uint256 => uint256) private _allTokensIndex;
1282 
1283     /**
1284      * @dev See {IERC165-supportsInterface}.
1285      */
1286     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1287         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1294         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1295         return _ownedTokens[owner][index];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-totalSupply}.
1300      */
1301     function totalSupply() public view virtual override returns (uint256) {
1302         return _allTokens.length;
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Enumerable-tokenByIndex}.
1307      */
1308     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1309         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1310         return _allTokens[index];
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before any token transfer. This includes minting
1315      * and burning.
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      *
1326      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1327      */
1328     function _beforeTokenTransfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual override {
1333         super._beforeTokenTransfer(from, to, tokenId);
1334 
1335         if (from == address(0)) {
1336             _addTokenToAllTokensEnumeration(tokenId);
1337         } else if (from != to) {
1338             _removeTokenFromOwnerEnumeration(from, tokenId);
1339         }
1340         if (to == address(0)) {
1341             _removeTokenFromAllTokensEnumeration(tokenId);
1342         } else if (to != from) {
1343             _addTokenToOwnerEnumeration(to, tokenId);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1349      * @param to address representing the new owner of the given token ID
1350      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1351      */
1352     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1353         uint256 length = ERC721.balanceOf(to);
1354         _ownedTokens[to][length] = tokenId;
1355         _ownedTokensIndex[tokenId] = length;
1356     }
1357 
1358     /**
1359      * @dev Private function to add a token to this extension's token tracking data structures.
1360      * @param tokenId uint256 ID of the token to be added to the tokens list
1361      */
1362     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1363         _allTokensIndex[tokenId] = _allTokens.length;
1364         _allTokens.push(tokenId);
1365     }
1366 
1367     /**
1368      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1369      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1370      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1371      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1372      * @param from address representing the previous owner of the given token ID
1373      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1374      */
1375     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1376         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1377         // then delete the last slot (swap and pop).
1378 
1379         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1380         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1381 
1382         // When the token to delete is the last token, the swap operation is unnecessary
1383         if (tokenIndex != lastTokenIndex) {
1384             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1385 
1386             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1387             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1388         }
1389 
1390         // This also deletes the contents at the last position of the array
1391         delete _ownedTokensIndex[tokenId];
1392         delete _ownedTokens[from][lastTokenIndex];
1393     }
1394 
1395     /**
1396      * @dev Private function to remove a token from this extension's token tracking data structures.
1397      * This has O(1) time complexity, but alters the order of the _allTokens array.
1398      * @param tokenId uint256 ID of the token to be removed from the tokens list
1399      */
1400     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1401         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1402         // then delete the last slot (swap and pop).
1403 
1404         uint256 lastTokenIndex = _allTokens.length - 1;
1405         uint256 tokenIndex = _allTokensIndex[tokenId];
1406 
1407         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1408         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1409         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1410         uint256 lastTokenId = _allTokens[lastTokenIndex];
1411 
1412         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1413         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1414 
1415         // This also deletes the contents at the last position of the array
1416         delete _allTokensIndex[tokenId];
1417         _allTokens.pop();
1418     }
1419 }
1420 
1421 // File: SHIBABEAST.sol
1422 
1423 
1424 // SHIBABEAST PROJECT
1425 // CODE BY SHIBABEAST | KING @kinginthecode
1426 pragma solidity ^0.8.11;
1427 
1428 // @name:    SHIBABEAST
1429 // @symbol:  SB
1430 // @desc:    8K HIGH-QUALITY, 6000 FASHION SHIBAS
1431 // @founder: https://twitter.com/SMITH_SHIBA
1432 // @artist:  https://www.instagram.com/kreoarts/
1433 // @dev:     https://twitter.com/kinginthecode
1434 // @project: https://twitter.com/shibabeast_nft
1435 // @project: https://www.instagram.com/shibabeast_nft/
1436 // @url:     https://www.shiba-beast.io/
1437 
1438 /* * * * * * * * * *
1439 * ███████╗██████╗  *
1440 * ██╔════╝██╔══██╗ *
1441 * ███████╗██████╔╝ *
1442 * ╚════██║██╔══██╗ *
1443 * ███████║██████╔╝ *
1444 * ╚══════╝╚═════╝  *
1445 * * * * * * * * * */
1446 
1447 
1448 
1449 
1450 
1451 
1452 contract SHIBABEAST is ERC721Enumerable, Ownable, ReentrancyGuard {
1453   using Strings for uint256;
1454   using Counters for Counters.Counter;
1455 
1456   // ========== SB CONTRACT VARIABLES ==========
1457   bool public PAUSE = false;
1458   bool public REVEAL = false;
1459   uint256 public COST = 0.3 ether;
1460   uint256 public SUPPLY = 6000;
1461   string public REVEALED_URI;
1462   string public NOT_REVEALED_URI;
1463   Counters.Counter private _TOKEN_IDS;
1464   
1465   // ========== SB CONTRACT CONSTRUCTOR ==========
1466   constructor(
1467     string memory _INIT_REVEALED_URI,
1468     string memory _INIT_NOT_REVEALED_URI
1469   ) ERC721("SHIBABEAST", "SB") {
1470     SET_REVEALED_URI(_INIT_REVEALED_URI);
1471     SET_NOT_REVEALED_URI(_INIT_NOT_REVEALED_URI);
1472     SHIBABEAST_MINT(9);
1473   }
1474 
1475   // ========== SB CONTRACT URI RETURN ==========
1476   function _baseURI() internal view virtual override returns (string memory) {
1477     return REVEALED_URI;
1478   }
1479 
1480   // ========== SB CONTRACT MINTER ==========
1481   function SHIBABEAST_MINT(uint256 _MINT_AMOUNT) public payable nonReentrant {
1482     require(!PAUSE, "SHIBABEAST CONTRACT IS PAUSED");
1483     uint256 MINTED_SUPPLY = totalSupply();
1484     require(_MINT_AMOUNT > 0, "MINT AMOUNT SHOULD BE AT LEAST 1");
1485     require(MINTED_SUPPLY + _MINT_AMOUNT <= SUPPLY, "MAX SUPPLY EXCEEDED");
1486 
1487     if (msg.sender != owner()) {
1488       require(_MINT_AMOUNT <= 5, "MAX PER TRANSACTION EXCEEDED");
1489       require(msg.value >= COST * _MINT_AMOUNT, "INSUFFICIENT FUNDS");
1490     }
1491 
1492     uint256 _NEW_TOKEN_ID;
1493     for (uint256 i = 1; i <= _MINT_AMOUNT; i++) {
1494       _TOKEN_IDS.increment();
1495       _NEW_TOKEN_ID = _TOKEN_IDS.current();
1496       _safeMint(msg.sender, _NEW_TOKEN_ID);
1497     }
1498   }
1499 
1500   // ========== SB CONTRACT NFT RETURN ==========
1501   function tokenURI(uint256 TOKEN_ID) public view virtual override returns (string memory) {
1502     require(_exists(TOKEN_ID));
1503 
1504     if(REVEAL == false) {
1505       return NOT_REVEALED_URI;
1506     }
1507 
1508     string memory CURRENT_BASE_URI = _baseURI();
1509     return bytes(CURRENT_BASE_URI).length > 0 ? string(abi.encodePacked(CURRENT_BASE_URI, TOKEN_ID.toString())) : "";
1510   }
1511 
1512   // ========== SB CONTRACT OWNER FUNCTIONS ==========
1513   function SET_REVEALED_URI(string memory _NEW_REVEALED_URI) public onlyOwner {
1514     REVEALED_URI = _NEW_REVEALED_URI;
1515   }
1516 
1517   function SET_NOT_REVEALED_URI(string memory _NEW_NOT_REVEALED_URI) public onlyOwner {
1518     NOT_REVEALED_URI = _NEW_NOT_REVEALED_URI;
1519   }
1520 
1521   function SET_SUPPLY(uint256 _NEW_SUPPLY) public onlyOwner {
1522     SUPPLY = _NEW_SUPPLY;
1523   }
1524 
1525   function SET_PAUSE(bool _NEW_PAUSE_STATE) public onlyOwner {
1526     PAUSE = _NEW_PAUSE_STATE;
1527   }
1528 
1529   function SET_REVEAL(bool _NEW_REVEAL_STATE) public onlyOwner {
1530     REVEAL = _NEW_REVEAL_STATE;
1531   }
1532 
1533   // ========== SB CONTRACT WITHDRAW ==========
1534   function WITHDRAW() public payable onlyOwner {
1535     uint256 _BALANCE = address(this).balance;
1536     uint256 _FOUNDER_BALANCE = _BALANCE * 14 / 100;
1537     uint256 _PARTNER_BALANCE = _BALANCE * 7 / 100;
1538     uint256 _CMUNITY_BALANCE = _BALANCE * 9 / 100;
1539     payable(0xb2016Edc04236866E81138B7aa68bd1Bcc2Cb4BD).transfer(_FOUNDER_BALANCE); /* == SB|KREOARTS ==== */
1540     payable(0x889121F5D5D675874e4605218040F33198a16319).transfer(_FOUNDER_BALANCE); /* == SB|KING ======== */
1541     payable(0x6129b64Ec39Fc57A1bf9fCf454334F1f7c448E30).transfer(_FOUNDER_BALANCE); /* == SB|SMITH ======= */
1542     payable(0x5a3A7511fF72f72f1AA95f5Ff50F90C6BBa760C6).transfer(_FOUNDER_BALANCE); /* == SB|EVA ========= */
1543     payable(0x56348105ec4F8bd3F1feABF584c6841C2ba25f1A).transfer(_FOUNDER_BALANCE); /* == SB|SONIA ======= */
1544     payable(0xf2338226c18D6BDD3Fdf58EFb7b19E92F79F0d67).transfer(_FOUNDER_BALANCE); /* == SB|NITRO ======= */
1545     payable(0xD8Aa5E8842b09d5B596D22F62C65e47b00F3E6E2).transfer(_PARTNER_BALANCE); /* == SB|KJ ========== */
1546     payable(0x61c9651b626B0aed8476243D2d27F4cdd0D2d881).transfer(_CMUNITY_BALANCE); /* == SB|CMUNITY ===== */
1547   }
1548 }