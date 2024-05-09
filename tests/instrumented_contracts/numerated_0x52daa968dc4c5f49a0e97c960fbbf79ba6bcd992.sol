1 // @title:  SUPER APES CLUB
2 // @desc:   10,000 SUPER APES LIVING ON THE ETHEREUM BLOCKCHAIN
3 // @url:    https://superapesclub.com
4 // @twitter: https://twitter.com/superapesclub
5 // @instagram:   https://www.instagram.com/superapesclub
6 
7 
8 pragma solidity >=0.8.0;
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
13 
14 /**
15  * @dev Contract module that helps prevent reentrant caolls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Counters.sol
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @title Counters
81  * @author Matt Condon (@shrugs)
82  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
83  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
84  *
85  * Include with `using Counters for Counters.Counter;`
86  */
87 library Counters {
88     struct Counter {
89         // This variable should never be directly accessed by users of the library: interactions must be restricted to
90         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
91         // this feature: see https://github.com/ethereum/solidity/issues/4637
92         uint256 _value; // default: 0
93     }
94 
95     function current(Counter storage counter) internal view returns (uint256) {
96         return counter._value;
97     }
98 
99     function increment(Counter storage counter) internal {
100         unchecked {
101             counter._value += 1;
102         }
103     }
104 
105     function decrement(Counter storage counter) internal {
106         uint256 value = counter._value;
107         require(value > 0, "Counter: decrement overflow");
108         unchecked {
109             counter._value = value - 1;
110         }
111     }
112 
113     function reset(Counter storage counter) internal {
114         counter._value = 0;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Strings.sol
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev String operations.
126  */
127 library Strings {
128     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
132      */
133     function toString(uint256 value) internal pure returns (string memory) {
134         // Inspired by OraclizeAPI's implementation - MIT licence
135         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
136 
137         if (value == 0) {
138             return "0";
139         }
140         uint256 temp = value;
141         uint256 digits;
142         while (temp != 0) {
143             digits++;
144             temp /= 10;
145         }
146         bytes memory buffer = new bytes(digits);
147         while (value != 0) {
148             digits -= 1;
149             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
150             value /= 10;
151         }
152         return string(buffer);
153     }
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
157      */
158     function toHexString(uint256 value) internal pure returns (string memory) {
159         if (value == 0) {
160             return "0x00";
161         }
162         uint256 temp = value;
163         uint256 length = 0;
164         while (temp != 0) {
165             length++;
166             temp >>= 8;
167         }
168         return toHexString(value, length);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
173      */
174     function toHexString(uint256 value, uint256 length)
175         internal
176         pure
177         returns (string memory)
178     {
179         bytes memory buffer = new bytes(2 * length + 2);
180         buffer[0] = "0";
181         buffer[1] = "x";
182         for (uint256 i = 2 * length + 1; i > 1; --i) {
183             buffer[i] = _HEX_SYMBOLS[value & 0xf];
184             value >>= 4;
185         }
186         require(value == 0, "Strings: hex length insufficient");
187         return string(buffer);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Context.sol
192 
193 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes calldata) {
213         return msg.data;
214     }
215 }
216 
217 // File: @openzeppelin/contracts/access/Ownable.sol
218 
219 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Contract module which provides a basic access control mechanism, where
225  * there is an account (an owner) that can be granted exclusive access to
226  * specific functions.
227  *
228  * By default, the owner account will be the one that deploys the contract. This
229  * can later be changed with {transferOwnership}.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 abstract contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(
239         address indexed previousOwner,
240         address indexed newOwner
241     );
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor() {
247         _transferOwnership(_msgSender());
248     }
249 
250     /**
251      * @dev Returns the address of the current owner.
252      */
253     function owner() public view virtual returns (address) {
254         return _owner;
255     }
256 
257     /**
258      * @dev Throws if called by any account other than the owner.
259      */
260     modifier onlyOwner() {
261         require(owner() == _msgSender(), "Ownable: caller is not the owner");
262         _;
263     }
264 
265     /**
266      * @dev Leaves the contract without owner. It will not be possible to call
267      * `onlyOwner` functions anymore. Can only be called by the current owner.
268      *
269      * NOTE: Renouncing ownership will leave the contract without an owner,
270      * thereby removing any functionality that is only available to the owner.
271      */
272     function renounceOwnership() public virtual onlyOwner {
273         _transferOwnership(address(0));
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      * Can only be called by the current owner.
279      */
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(
282             newOwner != address(0),
283             "Ownable: new owner is the zero address"
284         );
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Internal function without access restriction.
291      */
292     function _transferOwnership(address newOwner) internal virtual {
293         address oldOwner = _owner;
294         _owner = newOwner;
295         emit OwnershipTransferred(oldOwner, newOwner);
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Address.sol
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(
356             address(this).balance >= amount,
357             "Address: insufficient balance"
358         );
359 
360         (bool success, ) = recipient.call{value: amount}("");
361         require(
362             success,
363             "Address: unable to send value, recipient may have reverted"
364         );
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data)
386         internal
387         returns (bytes memory)
388     {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return
423             functionCallWithValue(
424                 target,
425                 data,
426                 value,
427                 "Address: low-level call with value failed"
428             );
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(
444             address(this).balance >= value,
445             "Address: insufficient balance for call"
446         );
447         require(isContract(target), "Address: call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.call{value: value}(
450             data
451         );
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data)
462         internal
463         view
464         returns (bytes memory)
465     {
466         return
467             functionStaticCall(
468                 target,
469                 data,
470                 "Address: low-level static call failed"
471             );
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a static call.
477      *
478      * _Available since v3.3._
479      */
480     function functionStaticCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal view returns (bytes memory) {
485         require(isContract(target), "Address: static call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.staticcall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data)
498         internal
499         returns (bytes memory)
500     {
501         return
502             functionDelegateCall(
503                 target,
504                 data,
505                 "Address: low-level delegate call failed"
506             );
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @title ERC721 token receiver interface
563  * @dev Interface for any contract that wants to support safeTransfers
564  * from ERC721 asset contracts.
565  */
566 interface IERC721Receiver {
567     /**
568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
569      * by `operator` from `from`, this function is called.
570      *
571      * It must return its Solidity selector to confirm the token transfer.
572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
573      *
574      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
575      */
576     function onERC721Received(
577         address operator,
578         address from,
579         uint256 tokenId,
580         bytes calldata data
581     ) external returns (bytes4);
582 }
583 
584 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Interface of the ERC165 standard, as defined in the
592  * https://eips.ethereum.org/EIPS/eip-165[EIP].
593  *
594  * Implementers can declare support of contract interfaces, which can then be
595  * queried by others ({ERC165Checker}).
596  *
597  * For an implementation, see {ERC165}.
598  */
599 interface IERC165 {
600     /**
601      * @dev Returns true if this contract implements the interface defined by
602      * `interfaceId`. See the corresponding
603      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
604      * to learn more about how these ids are created.
605      *
606      * This function call must use less than 30 000 gas.
607      */
608     function supportsInterface(bytes4 interfaceId) external view returns (bool);
609 }
610 
611 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Implementation of the {IERC165} interface.
619  *
620  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
621  * for the additional interface id that will be supported. For example:
622  *
623  * ```solidity
624  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
626  * }
627  * ```
628  *
629  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
630  */
631 abstract contract ERC165 is IERC165 {
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId)
636         public
637         view
638         virtual
639         override
640         returns (bool)
641     {
642         return interfaceId == type(IERC165).interfaceId;
643     }
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
647 
648 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Required interface of an ERC721 compliant contract.
654  */
655 interface IERC721 is IERC165 {
656     /**
657      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
658      */
659     event Transfer(
660         address indexed from,
661         address indexed to,
662         uint256 indexed tokenId
663     );
664 
665     /**
666      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
667      */
668     event Approval(
669         address indexed owner,
670         address indexed approved,
671         uint256 indexed tokenId
672     );
673 
674     /**
675      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
676      */
677     event ApprovalForAll(
678         address indexed owner,
679         address indexed operator,
680         bool approved
681     );
682 
683     /**
684      * @dev Returns the number of tokens in ``owner``'s account.
685      */
686     function balanceOf(address owner) external view returns (uint256 balance);
687 
688     /**
689      * @dev Returns the owner of the `tokenId` token.
690      *
691      * Requirements:
692      *
693      * - `tokenId` must exist.
694      */
695     function ownerOf(uint256 tokenId) external view returns (address owner);
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
699      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
707      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
708      *
709      * Emits a {Transfer} event.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) external;
716 
717     /**
718      * @dev Transfers `tokenId` token from `from` to `to`.
719      *
720      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must be owned by `from`.
727      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
728      *
729      * Emits a {Transfer} event.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) external;
736 
737     /**
738      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
739      * The approval is cleared when the token is transferred.
740      *
741      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
742      *
743      * Requirements:
744      *
745      * - The caller must own the token or be an approved operator.
746      * - `tokenId` must exist.
747      *
748      * Emits an {Approval} event.
749      */
750     function approve(address to, uint256 tokenId) external;
751 
752     /**
753      * @dev Returns the account approved for `tokenId` token.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      */
759     function getApproved(uint256 tokenId)
760         external
761         view
762         returns (address operator);
763 
764     /**
765      * @dev Approve or remove `operator` as an operator for the caller.
766      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
767      *
768      * Requirements:
769      *
770      * - The `operator` cannot be the caller.
771      *
772      * Emits an {ApprovalForAll} event.
773      */
774     function setApprovalForAll(address operator, bool _approved) external;
775 
776     /**
777      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
778      *
779      * See {setApprovalForAll}
780      */
781     function isApprovedForAll(address owner, address operator)
782         external
783         view
784         returns (bool);
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId,
803         bytes calldata data
804     ) external;
805 }
806 
807 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
808 
809 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
810 
811 pragma solidity ^0.8.0;
812 
813 /**
814  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
815  * @dev See https://eips.ethereum.org/EIPS/eip-721
816  */
817 interface IERC721Metadata is IERC721 {
818     /**
819      * @dev Returns the token collection name.
820      */
821     function name() external view returns (string memory);
822 
823     /**
824      * @dev Returns the token collection symbol.
825      */
826     function symbol() external view returns (string memory);
827 
828     /**
829      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
830      */
831     function tokenURI(uint256 tokenId) external view returns (string memory);
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
835 
836 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata extension, but not including the Enumerable extension, which is available separately as
843  * {ERC721Enumerable}.
844  */
845 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
846     using Address for address;
847     using Strings for uint256;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to owner address
856     mapping(uint256 => address) private _owners;
857 
858     // Mapping owner address to token count
859     mapping(address => uint256) private _balances;
860 
861     // Mapping from token ID to approved address
862     mapping(uint256 => address) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     /**
868      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
869      */
870     constructor(string memory name_, string memory symbol_) {
871         _name = name_;
872         _symbol = symbol_;
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId)
879         public
880         view
881         virtual
882         override(ERC165, IERC165)
883         returns (bool)
884     {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             super.supportsInterface(interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC721-balanceOf}.
893      */
894     function balanceOf(address owner)
895         public
896         view
897         virtual
898         override
899         returns (uint256)
900     {
901         require(
902             owner != address(0),
903             "ERC721: balance query for the zero address"
904         );
905         return _balances[owner];
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId)
912         public
913         view
914         virtual
915         override
916         returns (address)
917     {
918         address owner = _owners[tokenId];
919         require(
920             owner != address(0),
921             "ERC721: owner query for nonexistent token"
922         );
923         return owner;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId)
944         public
945         view
946         virtual
947         override
948         returns (string memory)
949     {
950         require(
951             _exists(tokenId),
952             "ERC721Metadata: URI query for nonexistent token"
953         );
954 
955         string memory baseURI = _baseURI();
956         return
957             bytes(baseURI).length > 0
958                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
959                 : "";
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return "";
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public virtual override {
975         address owner = ERC721.ownerOf(tokenId);
976         require(to != owner, "ERC721: approval to current owner");
977 
978         require(
979             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
980             "ERC721: approve caller is not owner nor approved for all"
981         );
982 
983         _approve(to, tokenId);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId)
990         public
991         view
992         virtual
993         override
994         returns (address)
995     {
996         require(
997             _exists(tokenId),
998             "ERC721: approved query for nonexistent token"
999         );
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved)
1008         public
1009         virtual
1010         override
1011     {
1012         _setApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator)
1019         public
1020         view
1021         virtual
1022         override
1023         returns (bool)
1024     {
1025         return _operatorApprovals[owner][operator];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-transferFrom}.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         //solhint-disable-next-line max-line-length
1037         require(
1038             _isApprovedOrOwner(_msgSender(), tokenId),
1039             "ERC721: transfer caller is not owner nor approved"
1040         );
1041 
1042         _transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public virtual override {
1053         safeTransferFrom(from, to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) public virtual override {
1065         require(
1066             _isApprovedOrOwner(_msgSender(), tokenId),
1067             "ERC721: transfer caller is not owner nor approved"
1068         );
1069         _safeTransfer(from, to, tokenId, _data);
1070     }
1071 
1072     /**
1073      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1074      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1075      *
1076      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1077      *
1078      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1079      * implement alternative mechanisms to perform token transfer, such as signature-based.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must exist and be owned by `from`.
1086      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeTransfer(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) internal virtual {
1096         _transfer(from, to, tokenId);
1097         require(
1098             _checkOnERC721Received(from, to, tokenId, _data),
1099             "ERC721: transfer to non ERC721Receiver implementer"
1100         );
1101     }
1102 
1103     /**
1104      * @dev Returns whether `tokenId` exists.
1105      *
1106      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1107      *
1108      * Tokens start existing when they are minted (`_mint`),
1109      * and stop existing when they are burned (`_burn`).
1110      */
1111     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1112         return _owners[tokenId] != address(0);
1113     }
1114 
1115     /**
1116      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      */
1122     function _isApprovedOrOwner(address spender, uint256 tokenId)
1123         internal
1124         view
1125         virtual
1126         returns (bool)
1127     {
1128         require(
1129             _exists(tokenId),
1130             "ERC721: operator query for nonexistent token"
1131         );
1132         address owner = ERC721.ownerOf(tokenId);
1133         return (spender == owner ||
1134             getApproved(tokenId) == spender ||
1135             isApprovedForAll(owner, spender));
1136     }
1137 
1138     /**
1139      * @dev Safely mints `tokenId` and transfers it to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must not exist.
1144      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _safeMint(address to, uint256 tokenId) internal virtual {
1149         _safeMint(to, tokenId, "");
1150     }
1151 
1152     /**
1153      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1154      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1155      */
1156     function _safeMint(
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) internal virtual {
1161         _mint(to, tokenId);
1162         require(
1163             _checkOnERC721Received(address(0), to, tokenId, _data),
1164             "ERC721: transfer to non ERC721Receiver implementer"
1165         );
1166     }
1167 
1168     /**
1169      * @dev Mints `tokenId` and transfers it to `to`.
1170      *
1171      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must not exist.
1176      * - `to` cannot be the zero address.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _mint(address to, uint256 tokenId) internal virtual {
1181         require(to != address(0), "ERC721: mint to the zero address");
1182         require(!_exists(tokenId), "ERC721: token already minted");
1183 
1184         _beforeTokenTransfer(address(0), to, tokenId);
1185 
1186         _balances[to] += 1;
1187         _owners[tokenId] = to;
1188 
1189         emit Transfer(address(0), to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         address owner = ERC721.ownerOf(tokenId);
1204 
1205         _beforeTokenTransfer(owner, address(0), tokenId);
1206 
1207         // Clear approvals
1208         _approve(address(0), tokenId);
1209 
1210         _balances[owner] -= 1;
1211         delete _owners[tokenId];
1212 
1213         emit Transfer(owner, address(0), tokenId);
1214     }
1215 
1216     /**
1217      * @dev Transfers `tokenId` from `from` to `to`.
1218      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `tokenId` token must be owned by `from`.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _transfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) internal virtual {
1232         require(
1233             ERC721.ownerOf(tokenId) == from,
1234             "ERC721: transfer of token that is not own"
1235         );
1236         require(to != address(0), "ERC721: transfer to the zero address");
1237 
1238         _beforeTokenTransfer(from, to, tokenId);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId);
1242 
1243         _balances[from] -= 1;
1244         _balances[to] += 1;
1245         _owners[tokenId] = to;
1246 
1247         emit Transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Approve `to` to operate on `tokenId`
1252      *
1253      * Emits a {Approval} event.
1254      */
1255     function _approve(address to, uint256 tokenId) internal virtual {
1256         _tokenApprovals[tokenId] = to;
1257         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1258     }
1259 
1260     /**
1261      * @dev Approve `operator` to operate on all of `owner` tokens
1262      *
1263      * Emits a {ApprovalForAll} event.
1264      */
1265     function _setApprovalForAll(
1266         address owner,
1267         address operator,
1268         bool approved
1269     ) internal virtual {
1270         require(owner != operator, "ERC721: approve to caller");
1271         _operatorApprovals[owner][operator] = approved;
1272         emit ApprovalForAll(owner, operator, approved);
1273     }
1274 
1275     /**
1276      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1277      * The call is not executed if the target address is not a contract.
1278      *
1279      * @param from address representing the previous owner of the given token ID
1280      * @param to target address that will receive the tokens
1281      * @param tokenId uint256 ID of the token to be transferred
1282      * @param _data bytes optional data to send along with the call
1283      * @return bool whether the call correctly returned the expected magic value
1284      */
1285     function _checkOnERC721Received(
1286         address from,
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) private returns (bool) {
1291         if (to.isContract()) {
1292             try
1293                 IERC721Receiver(to).onERC721Received(
1294                     _msgSender(),
1295                     from,
1296                     tokenId,
1297                     _data
1298                 )
1299             returns (bytes4 retval) {
1300                 return retval == IERC721Receiver.onERC721Received.selector;
1301             } catch (bytes memory reason) {
1302                 if (reason.length == 0) {
1303                     revert(
1304                         "ERC721: transfer to non ERC721Receiver implementer"
1305                     );
1306                 } else {
1307                     assembly {
1308                         revert(add(32, reason), mload(reason))
1309                     }
1310                 }
1311             }
1312         } else {
1313             return true;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before any token transfer. This includes minting
1319      * and burning.
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1327      * - `from` and `to` are never both zero.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) internal virtual {}
1336 }
1337 
1338 // File: HCW.sol
1339 
1340 //SPDX-License-Identifier: MIT
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 contract SuperApesClub is ERC721, Ownable, ReentrancyGuard {
1345     using Counters for Counters.Counter;
1346     Counters.Counter public totalSupply;
1347 
1348     mapping(address => bool) whitelist;
1349     mapping(address => bool) presaleWhitelist;
1350 
1351     string private baseURI; 
1352     string private unrevealedTokenURI; 
1353     uint256 public maxTokens = 10000;
1354     uint256 public maxPresaleTokens = 6000; 
1355     uint256 public maxTokensPerWallet = 4; 
1356     uint256 public maxMintPerTxPresale = 4; 
1357     uint256 public maxMintPerTx = 4; 
1358     uint256 public tokensReserved = 90;
1359     uint256 public presalePrice = 0.07 ether;
1360     uint256 public price = 0.07 ether;
1361 
1362     bool public revealed = false;
1363     bool public paused = true;
1364     bool public presaleActive = true;
1365     bool public publicSaleActive = false;
1366 
1367     string public SAC_PROVENANCE;
1368 
1369     address a1 = 0xC2FFb0534d3173Cb787e6e2B352621205cA8f0B0;
1370     address a2 = 0x7059b23395781590DC869ee72c599C2B0C91ad49;
1371 
1372     event TokenMinted(uint256 tokenId);
1373 
1374     constructor() ERC721("SuperApesClub", "SAC") {}
1375 
1376     modifier whitelistFunction(address[] memory _addresses, bool _presale) {
1377         if (_presale) {
1378             require(!publicSaleActive, "Presale already ended!");
1379         }
1380         require(
1381             _addresses.length >= 1,
1382             "You need to send at least one address!"
1383         );
1384         _;
1385     }
1386 
1387     function setMaxPresaleTokens(uint256 _maxPresaleTokens)
1388         external
1389         onlyOwner
1390     {
1391         maxPresaleTokens = _maxPresaleTokens;
1392     }
1393 
1394 
1395     /*
1396     * set Max Tokens limit Per Wallet
1397     */
1398     function setMaxTokensPerWallet(uint256 _maxTokensPerWallet)
1399         external
1400         onlyOwner
1401     {
1402         maxTokensPerWallet = _maxTokensPerWallet;
1403     }
1404 
1405 
1406     /*
1407     * set Max Mint Per Tx pre sale
1408     */
1409     function setMaxMintPerTxPresale(uint256 _maxMintPerTxPresale)
1410         external
1411         onlyOwner
1412     {
1413         maxMintPerTxPresale = _maxMintPerTxPresale;
1414     }
1415 
1416 
1417     /*
1418     * set Max Mint Per Tx public sale
1419     */
1420     function setMaxMintPerTx(uint256 _maxMintPerTx) external onlyOwner {
1421         maxMintPerTx = _maxMintPerTx;
1422     }
1423 
1424 
1425     /*
1426     * setUnrevealedTokenURI
1427     */
1428     function setUnrevealedTokenURI(string memory _unrevealedTokenURI)
1429         external
1430         onlyOwner
1431     {
1432         unrevealedTokenURI = _unrevealedTokenURI;
1433     }
1434 
1435     /*
1436      * Pause sale if active, make active if paused
1437      */
1438     function toggleMinting() public onlyOwner {
1439         paused = !paused;
1440     }
1441 
1442 
1443     /*
1444     * Reveals token once all tokens are minted
1445     */    
1446     function reveal() external onlyOwner {
1447         revealed = true;
1448     }
1449 
1450 
1451     /*
1452     * Set Base URI 
1453     */
1454     function setBaseURI(string memory _URI) external onlyOwner {
1455         baseURI = _URI;
1456     }
1457 
1458     /*
1459      * Set provenance immediately upon deployment of the contract, prior to starting the pre-sale
1460      */
1461     function setProvenance(string memory _provenance) public onlyOwner {
1462         SAC_PROVENANCE = _provenance;
1463     }
1464 
1465     /*
1466      *end presale
1467      */
1468     function endPresale() public onlyOwner {
1469         require(presaleActive, "Presale is not active!");
1470         presaleActive = false;
1471     }
1472 
1473     /*
1474      *startPublicSale
1475      */
1476     function startPublicSale() public onlyOwner {
1477         require(
1478             !presaleActive,
1479             "Presale is still active! End it first with calling endPresale() function."
1480         );
1481         require(!publicSaleActive, "Public sale is already active!");
1482         publicSaleActive = true;
1483     }
1484 
1485     /*
1486      *addToWhitelist
1487      */
1488 
1489     function addToWhitelist(address[] memory _addresses, bool _presale)
1490         public
1491         onlyOwner
1492         whitelistFunction(_addresses, _presale)
1493     {
1494         if (_presale) {
1495             require(presaleActive, "Presale is not active anymore!");
1496         }
1497         for (uint256 i = 0; i < _addresses.length; i++) {
1498             if (_presale) {
1499                 presaleWhitelist[_addresses[i]] = true;
1500             } else {
1501                 whitelist[_addresses[i]] = true;
1502             }
1503         }
1504     }
1505 
1506     /*
1507      *removeFromwhitelist
1508      */
1509 
1510     function removeFromwhitelist(address[] memory _addresses, bool _presale)
1511         public
1512         onlyOwner
1513         whitelistFunction(_addresses, _presale)
1514     {
1515         for (uint256 i = 0; i < _addresses.length; i++) {
1516             if (_presale) {
1517                 presaleWhitelist[_addresses[i]] = false;
1518             } else {
1519                 whitelist[_addresses[i]] = false;
1520             }
1521         }
1522     }
1523 
1524     /*
1525      *_baseURI
1526      */
1527 
1528     function _baseURI() internal view virtual override returns (string memory) {
1529         return baseURI;
1530     }
1531 
1532     /*
1533      *tokenURI
1534      */
1535 
1536     function tokenURI(uint256 tokenId)
1537         public
1538         view
1539         virtual
1540         override
1541         returns (string memory)
1542     {
1543         require(_exists(tokenId), "URI query for nonexistent token");
1544 
1545         if (revealed) {
1546             return
1547                 string(
1548                     abi.encodePacked(
1549                         _baseURI(),
1550                         Strings.toString(tokenId),
1551                         ".json"
1552                     )
1553                 );
1554         } else {
1555             return unrevealedTokenURI;
1556         }
1557     }
1558 
1559     /*
1560      *checkAddressForPresale
1561      */
1562     function checkAddressForPresale(address _address)
1563         public
1564         view
1565         returns (bool)
1566     {
1567         if (presaleWhitelist[_address]) {
1568             return true;
1569         } else {
1570             return false;
1571         }
1572     }
1573 
1574     /*
1575      *checkAddressForPublicSale
1576      */
1577     function checkAddressForPublicSale(address _address)
1578         public
1579         view
1580         returns (bool)
1581     {
1582         if (whitelist[_address]) {
1583             return true;
1584         } else {
1585             return false;
1586         }
1587     }
1588 
1589     /*
1590      * claims reserved
1591      */
1592 
1593     function claimReserved(uint256 _amount) public onlyOwner {
1594         require(
1595             _amount <= tokensReserved,
1596             "Can't claim more than reserved tokens left."
1597         );
1598 
1599         for (uint256 i = 0; i < _amount; i++) {
1600             totalSupply.increment();
1601             uint256 newItemId = totalSupply.current();
1602             _safeMint(msg.sender, newItemId);
1603             emit TokenMinted(newItemId);
1604         }
1605 
1606         tokensReserved = tokensReserved - _amount;
1607     }
1608 
1609     /**
1610      * Mints Super Apes
1611      */
1612     function mintSuperApe(uint256 _amount) public payable {
1613         require(!paused, "Minting is paused!");
1614 
1615         require(
1616             presaleActive || publicSaleActive,
1617             "Public sale has not started yet!"
1618         );
1619 
1620         if (presaleActive) {
1621             if (owner() != msg.sender) {
1622                 require(
1623                     presaleWhitelist[msg.sender],
1624                     "You are not whitelisted to participate on presale!"
1625                 );
1626                 require(
1627                     _amount > 0 && _amount <= maxMintPerTxPresale,
1628                     string(
1629                         abi.encodePacked(
1630                             "You can't buy more than ",
1631                             Strings.toString(maxMintPerTxPresale),
1632                             " tokens per transaction"
1633                         )
1634                     )
1635                 );
1636             }
1637 
1638             require(
1639                 maxPresaleTokens >= _amount + totalSupply.current(),
1640                 "Not enough presale tokens left!"
1641             );
1642             require(
1643                 msg.value >= presalePrice * _amount,
1644                 string(
1645                     abi.encodePacked(
1646                         "Not enough ETH! At least ",
1647                         Strings.toString(presalePrice * _amount),
1648                         " wei has to be sent!"
1649                     )
1650                 )
1651             );
1652         } else {
1653             if (owner() != msg.sender) {
1654                 require(
1655                     whitelist[msg.sender],
1656                     "You are not whitelisted to participate on public sale!"
1657                 );
1658                 require(
1659                     _amount > 0 && _amount <= maxMintPerTx,
1660                     string(
1661                         abi.encodePacked(
1662                             "You can't buy more than ",
1663                             Strings.toString(maxMintPerTx),
1664                             " tokens per transaction."
1665                         )
1666                     )
1667                 );
1668             }
1669 
1670             require(
1671                 maxTokens >= _amount + totalSupply.current(),
1672                 "Not enough tokens left!"
1673             );
1674             require(
1675                 msg.value >= price * _amount,
1676                 string(
1677                     abi.encodePacked(
1678                         "Not enough ETH! At least ",
1679                         Strings.toString(price * _amount),
1680                         " wei has to be sent!"
1681                     )
1682                 )
1683             );
1684         }
1685 
1686         if (owner() != msg.sender) {
1687             require(
1688                 maxTokens >= _amount + totalSupply.current() + tokensReserved,
1689                 "Not enough tokens left!"
1690             );
1691             
1692             require(
1693                 maxTokensPerWallet >= balanceOf(msg.sender) + _amount,
1694                 "Max token count per wallet exceeded!"
1695             );
1696         }
1697         for (uint256 i = 0; i < _amount; i++) {
1698             totalSupply.increment();
1699             uint256 newItemId = totalSupply.current();
1700             _safeMint(msg.sender, newItemId);
1701             emit TokenMinted(newItemId);
1702         }
1703     }
1704 
1705     /*
1706      *withdrawAll
1707      */
1708 
1709     function withdrawAll() public onlyOwner nonReentrant {
1710         (bool success, ) = payable(owner()).call{value: address(this).balance}(
1711             ""
1712         );
1713         require(success, "");
1714     }
1715 
1716     /*
1717      *withdraw
1718      */
1719     function withdraw(uint256 _weiAmount, address _to)
1720         public
1721         onlyOwner
1722         nonReentrant
1723     {
1724         require(_to == a1 || _to == a2, "This address is not in allowed list");
1725 
1726         require(
1727             address(this).balance >= _weiAmount,
1728             "Not enough ETH to withdraw!"
1729         );
1730 
1731         (bool success, ) = payable(_to).call{value: _weiAmount}("");
1732         require(success, "");
1733     }
1734 }