1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and making it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
67 
68 pragma solidity ^0.8.19;
69 
70 /**
71  * @dev String operations.
72  */
73 library Strings {
74     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
78      */
79     function toString(uint256 value) internal pure returns (string memory) {
80         // Inspired by OraclizeAPI's implementation - MIT licence
81         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
82 
83         if (value == 0) {
84             return "0";
85         }
86         uint256 temp = value;
87         uint256 digits;
88         while (temp != 0) {
89             digits++;
90             temp /= 10;
91         }
92         bytes memory buffer = new bytes(digits);
93         while (value != 0) {
94             digits -= 1;
95             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
96             value /= 10;
97         }
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
103      */
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
119      */
120     function toHexString(uint256 value, uint256 length)
121         internal
122         pure
123         returns (string memory)
124     {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 pragma solidity ^0.8.19;
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/access/Ownable.sol
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.19;
168 
169 /**
170  * @dev Contract module which provides a basic access control mechanism, where
171  * there is an account (an owner) that can be granted exclusive access to
172  * specific functions.
173  *
174  * By default, the owner account will be the one that deploys the contract. This
175  * can later be changed with {transferOwnership}.
176  *
177  * This module is used through inheritance. It will make available the modifier
178  * `onlyOwner`, which can be applied to your functions to restrict their use to
179  * the owner.
180  */
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(
185         address indexed previousOwner,
186         address indexed newOwner
187     );
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(
228             newOwner != address(0),
229             "Ownable: new owner is the zero address"
230         );
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 pragma solidity ^0.8.19;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(
303             address(this).balance >= amount,
304             "Address: insufficient balance"
305         );
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(
309             success,
310             "Address: unable to send value, recipient may have reverted"
311         );
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data)
333         internal
334         returns (bytes memory)
335     {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return
370             functionCallWithValue(
371                 target,
372                 data,
373                 value,
374                 "Address: low-level call with value failed"
375             );
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(
391             address(this).balance >= value,
392             "Address: insufficient balance for call"
393         );
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(
397             data
398         );
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data)
409         internal
410         view
411         returns (bytes memory)
412     {
413         return
414             functionStaticCall(
415                 target,
416                 data,
417                 "Address: low-level static call failed"
418             );
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data)
445         internal
446         returns (bytes memory)
447     {
448         return
449             functionDelegateCall(
450                 target,
451                 data,
452                 "Address: low-level delegate call failed"
453             );
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.delegatecall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
475      * revert reason using the provided one.
476      *
477      * _Available since v4.3._
478      */
479     function verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) internal pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
505 
506 pragma solidity ^0.8.19;
507 
508 /**
509  * @title ERC721 token receiver interface
510  * @dev Interface for any contract that wants to support safeTransfers
511  * from ERC721 asset contracts.
512  */
513 interface IERC721Receiver {
514     /**
515      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
516      * by `operator` from `from`, this function is called.
517      *
518      * It must return its Solidity selector to confirm the token transfer.
519      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
520      *
521      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
522      */
523     function onERC721Received(
524         address operator,
525         address from,
526         uint256 tokenId,
527         bytes calldata data
528     ) external returns (bytes4);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
534 
535 pragma solidity ^0.8.19;
536 
537 /**
538  * @dev Interface of the ERC165 standard, as defined in the
539  * https://eips.ethereum.org/EIPS/eip-165[EIP].
540  *
541  * Implementers can declare support of contract interfaces, which can then be
542  * queried by others ({ERC165Checker}).
543  *
544  * For an implementation, see {ERC165}.
545  */
546 interface IERC165 {
547     /**
548      * @dev Returns true if this contract implements the interface defined by
549      * `interfaceId`. See the corresponding
550      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
551      * to learn more about how these ids are created.
552      *
553      * This function call must use less than 30 000 gas.
554      */
555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
561 
562 pragma solidity ^0.8.19;
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId)
583         public
584         view
585         virtual
586         override
587         returns (bool)
588     {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
596 
597 pragma solidity ^0.8.19;
598 
599 /**
600  * @dev Required interface of an ERC721 compliant contract.
601  */
602 interface IERC721 is IERC165 {
603     /**
604      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
605      */
606     event Transfer(
607         address indexed from,
608         address indexed to,
609         uint256 indexed tokenId
610     );
611 
612     /**
613      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
614      */
615     event Approval(
616         address indexed owner,
617         address indexed approved,
618         uint256 indexed tokenId
619     );
620 
621     /**
622      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
623      */
624     event ApprovalForAll(
625         address indexed owner,
626         address indexed operator,
627         bool approved
628     );
629 
630     /**
631      * @dev Returns the number of tokens in ``owner``'s account.
632      */
633     function balanceOf(address owner) external view returns (uint256 balance);
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) external view returns (address owner);
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId)
707         external
708         view
709         returns (address operator);
710 
711     /**
712      * @dev Approve or remove `operator` as an operator for the caller.
713      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool _approved) external;
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}
727      */
728     function isApprovedForAll(address owner, address operator)
729         external
730         view
731         returns (bool);
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external;
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
755 
756 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
757 
758 pragma solidity ^0.8.19;
759 
760 /**
761  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
762  * @dev See https://eips.ethereum.org/EIPS/eip-721
763  */
764 interface IERC721Metadata is IERC721 {
765     /**
766      * @dev Returns the token collection name.
767      */
768     function name() external view returns (string memory);
769 
770     /**
771      * @dev Returns the token collection symbol.
772      */
773     function symbol() external view returns (string memory);
774 
775     /**
776      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
777      */
778     function tokenURI(uint256 tokenId) external view returns (string memory);
779 }
780 
781 pragma solidity ^0.8.19;
782 
783 error ApprovalCallerNotOwnerNorApproved();
784 error ApprovalQueryForNonexistentToken();
785 error ApproveToCaller();
786 error ApprovalToCurrentOwner();
787 error BalanceQueryForZeroAddress();
788 error MintToZeroAddress();
789 error MintZeroQuantity();
790 error OwnerQueryForNonexistentToken();
791 error TransferCallerNotOwnerNorApproved();
792 error TransferFromIncorrectOwner();
793 error TransferToNonERC721ReceiverImplementer();
794 error TransferToZeroAddress();
795 error URIQueryForNonexistentToken();
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata extension. Built to optimize for lower gas during batch mints.
800  *
801  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
802  *
803  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
804  *
805  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
806  */
807 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
808     using Address for address;
809     using Strings for uint256;
810 
811     // Compiler will pack this into a single 256bit word.
812     struct TokenOwnership {
813         // The address of the owner.
814         address addr;
815         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
816         uint64 startTimestamp;
817         // Whether the token has been burned.
818         bool burned;
819     }
820 
821     // Compiler will pack this into a single 256bit word.
822     struct AddressData {
823         // Realistically, 2**64-1 is more than enough.
824         uint64 balance;
825         // Keeps track of mint count with minimal overhead for tokenomics.
826         uint64 numberMinted;
827         // Keeps track of burn count with minimal overhead for tokenomics.
828         uint64 numberBurned;
829         // For miscellaneous variable(s) pertaining to the address
830         // (e.g. number of whitelist mint slots used).
831         // If there are multiple variables, please pack them into a uint64.
832         uint64 aux;
833     }
834 
835     // The tokenId of the next token to be minted.
836     uint256 internal _currentIndex;
837 
838     // The number of tokens burned.
839     uint256 internal _burnCounter;
840 
841     // Token name
842     string private _name;
843 
844     // Token symbol
845     string private _symbol;
846 
847     // Mapping from token ID to ownership details
848     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
849     mapping(uint256 => TokenOwnership) internal _ownerships;
850 
851     // Mapping owner address to address data
852     mapping(address => AddressData) private _addressData;
853 
854     // Mapping from token ID to approved address
855     mapping(uint256 => address) private _tokenApprovals;
856 
857     // Mapping from owner to operator approvals
858     mapping(address => mapping(address => bool)) private _operatorApprovals;
859 
860     constructor(string memory name_, string memory symbol_) {
861         _name = name_;
862         _symbol = symbol_;
863         _currentIndex = _startTokenId();
864     }
865 
866     /**
867      * To change the starting tokenId, please override this function.
868      */
869     function _startTokenId() internal view virtual returns (uint256) {
870         return 0;
871     }
872 
873     /**
874      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
875      */
876     function totalSupply() public view returns (uint256) {
877         // Counter underflow is impossible as _burnCounter cannot be incremented
878         // more than _currentIndex - _startTokenId() times
879         unchecked {
880             return _currentIndex - _burnCounter - _startTokenId();
881         }
882     }
883 
884     /**
885      * Returns the total amount of tokens minted in the contract.
886      */
887     function _totalMinted() internal view returns (uint256) {
888         // Counter underflow is impossible as _currentIndex does not decrement,
889         // and it is initialized to _startTokenId()
890         unchecked {
891             return _currentIndex - _startTokenId();
892         }
893     }
894 
895     /**
896      * @dev See {IERC165-supportsInterface}.
897      */
898     function supportsInterface(bytes4 interfaceId)
899         public
900         view
901         virtual
902         override(ERC165, IERC165)
903         returns (bool)
904     {
905         return
906             interfaceId == type(IERC721).interfaceId ||
907             interfaceId == type(IERC721Metadata).interfaceId ||
908             super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view override returns (uint256) {
915         if (owner == address(0)) revert BalanceQueryForZeroAddress();
916         return uint256(_addressData[owner].balance);
917     }
918 
919     /**
920      * Returns the number of tokens minted by `owner`.
921      */
922     function _numberMinted(address owner) internal view returns (uint256) {
923         return uint256(_addressData[owner].numberMinted);
924     }
925 
926     /**
927      * Returns the number of tokens burned by or on behalf of `owner`.
928      */
929     function _numberBurned(address owner) internal view returns (uint256) {
930         return uint256(_addressData[owner].numberBurned);
931     }
932 
933     /**
934      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
935      */
936     function _getAux(address owner) internal view returns (uint64) {
937         return _addressData[owner].aux;
938     }
939 
940     /**
941      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
942      * If there are multiple variables, please pack them into a uint64.
943      */
944     function _setAux(address owner, uint64 aux) internal {
945         _addressData[owner].aux = aux;
946     }
947 
948     /**
949      * Gas spent here starts off proportional to the maximum mint batch size.
950      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
951      */
952     function _ownershipOf(uint256 tokenId)
953         internal
954         view
955         returns (TokenOwnership memory)
956     {
957         uint256 curr = tokenId;
958 
959         unchecked {
960             if (_startTokenId() <= curr && curr < _currentIndex) {
961                 TokenOwnership memory ownership = _ownerships[curr];
962                 if (!ownership.burned) {
963                     if (ownership.addr != address(0)) {
964                         return ownership;
965                     }
966                     // Invariant:
967                     // There will always be an ownership that has an address and is not burned
968                     // before an ownership that does not have an address and is not burned.
969                     // Hence, curr will not underflow.
970                     while (true) {
971                         curr--;
972                         ownership = _ownerships[curr];
973                         if (ownership.addr != address(0)) {
974                             return ownership;
975                         }
976                     }
977                 }
978             }
979         }
980         revert OwnerQueryForNonexistentToken();
981     }
982 
983     /**
984      * @dev See {IERC721-ownerOf}.
985      */
986     function ownerOf(uint256 tokenId) public view override returns (address) {
987         return _ownershipOf(tokenId).addr;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-name}.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-symbol}.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-tokenURI}.
1006      */
1007     function tokenURI(uint256 tokenId)
1008         public
1009         view
1010         virtual
1011         override
1012         returns (string memory)
1013     {
1014         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1015 
1016         string memory baseURI = _baseURI();
1017         return
1018             bytes(baseURI).length != 0
1019                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1020                 : "";
1021     }
1022 
1023     /**
1024      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1025      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1026      * by default, can be overriden in child contracts.
1027      */
1028     function _baseURI() internal view virtual returns (string memory) {
1029         return "";
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-approve}.
1034      */
1035     function approve(address to, uint256 tokenId) public override {
1036         address owner = ERC721A.ownerOf(tokenId);
1037         if (to == owner) revert ApprovalToCurrentOwner();
1038 
1039         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1040             revert ApprovalCallerNotOwnerNorApproved();
1041         }
1042 
1043         _approve(to, tokenId, owner);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId)
1050         public
1051         view
1052         override
1053         returns (address)
1054     {
1055         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved)
1064         public
1065         virtual
1066         override
1067     {
1068         if (operator == _msgSender()) revert ApproveToCaller();
1069 
1070         _operatorApprovals[_msgSender()][operator] = approved;
1071         emit ApprovalForAll(_msgSender(), operator, approved);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-isApprovedForAll}.
1076      */
1077     function isApprovedForAll(address owner, address operator)
1078         public
1079         view
1080         virtual
1081         override
1082         returns (bool)
1083     {
1084         return _operatorApprovals[owner][operator];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-transferFrom}.
1089      */
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         _transfer(from, to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-safeTransferFrom}.
1100      */
1101     function safeTransferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) public virtual override {
1106         safeTransferFrom(from, to, tokenId, "");
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-safeTransferFrom}.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) public virtual override {
1118         _transfer(from, to, tokenId);
1119         if (
1120             to.isContract() &&
1121             !_checkContractOnERC721Received(from, to, tokenId, _data)
1122         ) {
1123             revert TransferToNonERC721ReceiverImplementer();
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns whether `tokenId` exists.
1129      *
1130      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131      *
1132      * Tokens start existing when they are minted (`_mint`),
1133      */
1134     function _exists(uint256 tokenId) internal view returns (bool) {
1135         return
1136             _startTokenId() <= tokenId &&
1137             tokenId < _currentIndex &&
1138             !_ownerships[tokenId].burned;
1139     }
1140 
1141     function _safeMint(address to, uint256 quantity) internal {
1142         _safeMint(to, quantity, "");
1143     }
1144 
1145     /**
1146      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data
1159     ) internal {
1160         _mint(to, quantity, _data, true);
1161     }
1162 
1163     /**
1164      * @dev Mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _mint(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data,
1177         bool safe
1178     ) internal {
1179         uint256 startTokenId = _currentIndex;
1180         if (to == address(0)) revert MintToZeroAddress();
1181         if (quantity == 0) revert MintZeroQuantity();
1182 
1183         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1184 
1185         // Overflows are incredibly unrealistic.
1186         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1187         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1188         unchecked {
1189             _addressData[to].balance += uint64(quantity);
1190             _addressData[to].numberMinted += uint64(quantity);
1191 
1192             _ownerships[startTokenId].addr = to;
1193             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1194 
1195             uint256 updatedIndex = startTokenId;
1196             uint256 end = updatedIndex + quantity;
1197 
1198             if (safe && to.isContract()) {
1199                 do {
1200                     emit Transfer(address(0), to, updatedIndex);
1201                     if (
1202                         !_checkContractOnERC721Received(
1203                             address(0),
1204                             to,
1205                             updatedIndex++,
1206                             _data
1207                         )
1208                     ) {
1209                         revert TransferToNonERC721ReceiverImplementer();
1210                     }
1211                 } while (updatedIndex != end);
1212                 // Reentrancy protection
1213                 if (_currentIndex != startTokenId) revert();
1214             } else {
1215                 do {
1216                     emit Transfer(address(0), to, updatedIndex++);
1217                 } while (updatedIndex != end);
1218             }
1219             _currentIndex = updatedIndex;
1220         }
1221         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1222     }
1223 
1224     /**
1225      * @dev Transfers `tokenId` from `from` to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _transfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) private {
1239         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1240 
1241         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1242 
1243         bool isApprovedOrOwner = (_msgSender() == from ||
1244             isApprovedForAll(from, _msgSender()) ||
1245             getApproved(tokenId) == _msgSender());
1246 
1247         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1248         if (to == address(0)) revert TransferToZeroAddress();
1249 
1250         _beforeTokenTransfers(from, to, tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, from);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             _addressData[from].balance -= 1;
1260             _addressData[to].balance += 1;
1261 
1262             TokenOwnership storage currSlot = _ownerships[tokenId];
1263             currSlot.addr = to;
1264             currSlot.startTimestamp = uint64(block.timestamp);
1265 
1266             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1267             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1268             uint256 nextTokenId = tokenId + 1;
1269             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1270             if (nextSlot.addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId != _currentIndex) {
1274                     nextSlot.addr = from;
1275                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(from, to, tokenId);
1281         _afterTokenTransfers(from, to, tokenId, 1);
1282     }
1283 
1284     /**
1285      * @dev This is equivalent to _burn(tokenId, false)
1286      */
1287     function _burn(uint256 tokenId) internal virtual {
1288         _burn(tokenId, false);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1302         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1303 
1304         address from = prevOwnership.addr;
1305 
1306         if (approvalCheck) {
1307             bool isApprovedOrOwner = (_msgSender() == from ||
1308                 isApprovedForAll(from, _msgSender()) ||
1309                 getApproved(tokenId) == _msgSender());
1310 
1311             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1312         }
1313 
1314         _beforeTokenTransfers(from, address(0), tokenId, 1);
1315 
1316         // Clear approvals from the previous owner
1317         _approve(address(0), tokenId, from);
1318 
1319         // Underflow of the sender's balance is impossible because we check for
1320         // ownership above and the recipient's balance can't realistically overflow.
1321         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1322         unchecked {
1323             AddressData storage addressData = _addressData[from];
1324             addressData.balance -= 1;
1325             addressData.numberBurned += 1;
1326 
1327             // Keep track of who burned the token, and the timestamp of burning.
1328             TokenOwnership storage currSlot = _ownerships[tokenId];
1329             currSlot.addr = from;
1330             currSlot.startTimestamp = uint64(block.timestamp);
1331             currSlot.burned = true;
1332 
1333             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1334             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1335             uint256 nextTokenId = tokenId + 1;
1336             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1337             if (nextSlot.addr == address(0)) {
1338                 // This will suffice for checking _exists(nextTokenId),
1339                 // as a burned slot cannot contain the zero address.
1340                 if (nextTokenId != _currentIndex) {
1341                     nextSlot.addr = from;
1342                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1343                 }
1344             }
1345         }
1346 
1347         emit Transfer(from, address(0), tokenId);
1348         _afterTokenTransfers(from, address(0), tokenId, 1);
1349 
1350         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1351         unchecked {
1352             _burnCounter++;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Approve `to` to operate on `tokenId`
1358      *
1359      * Emits a {Approval} event.
1360      */
1361     function _approve(
1362         address to,
1363         uint256 tokenId,
1364         address owner
1365     ) private {
1366         _tokenApprovals[tokenId] = to;
1367         emit Approval(owner, to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1372      *
1373      * @param from address representing the previous owner of the given token ID
1374      * @param to target address that will receive the tokens
1375      * @param tokenId uint256 ID of the token to be transferred
1376      * @param _data bytes optional data to send along with the call
1377      * @return bool whether the call correctly returned the expected magic value
1378      */
1379     function _checkContractOnERC721Received(
1380         address from,
1381         address to,
1382         uint256 tokenId,
1383         bytes memory _data
1384     ) private returns (bool) {
1385         try
1386             IERC721Receiver(to).onERC721Received(
1387                 _msgSender(),
1388                 from,
1389                 tokenId,
1390                 _data
1391             )
1392         returns (bytes4 retval) {
1393             return retval == IERC721Receiver(to).onERC721Received.selector;
1394         } catch (bytes memory reason) {
1395             if (reason.length == 0) {
1396                 revert TransferToNonERC721ReceiverImplementer();
1397             } else {
1398                 assembly {
1399                     revert(add(32, reason), mload(reason))
1400                 }
1401             }
1402         }
1403     }
1404 
1405     /**
1406      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1407      * And also called before burning one token.
1408      *
1409      * startTokenId - the first token id to be transferred
1410      * quantity - the amount to be transferred
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1415      * transferred to `to`.
1416      * - When `from` is zero, `tokenId` will be minted for `to`.
1417      * - When `to` is zero, `tokenId` will be burned by `from`.
1418      * - `from` and `to` are never both zero.
1419      */
1420     function _beforeTokenTransfers(
1421         address from,
1422         address to,
1423         uint256 startTokenId,
1424         uint256 quantity
1425     ) internal virtual {}
1426 
1427     /**
1428      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1429      * minting.
1430      * And also called after one token has been burned.
1431      *
1432      * startTokenId - the first token id to be transferred
1433      * quantity - the amount to be transferred
1434      *
1435      * Calling conditions:
1436      *
1437      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1438      * transferred to `to`.
1439      * - When `from` is zero, `tokenId` has been minted for `to`.
1440      * - When `to` is zero, `tokenId` has been burned by `from`.
1441      * - `from` and `to` are never both zero.
1442      */
1443     function _afterTokenTransfers(
1444         address from,
1445         address to,
1446         uint256 startTokenId,
1447         uint256 quantity
1448     ) internal virtual {}
1449 }
1450 
1451 pragma solidity ^0.8.19;
1452 
1453 contract ASCIIEinstein is ERC721A, Ownable, ReentrancyGuard {
1454     using Strings for uint256;
1455 
1456     bool    public paused;
1457     uint256 public free = 0;
1458     uint256 public maxMint = 20;
1459     string  public _baseTokenURI;
1460     uint256 public maxFreeMint = 5;
1461     uint256 public maxSupply = 5000;
1462     uint256 public freeSupply = 3000;
1463     uint256 public price = 0.0049 ether;
1464 
1465     constructor() ERC721A("ASCIIEinstein", "AE") {}
1466 
1467     function mint(uint256 _mintAmount) public payable nonReentrant {
1468         require(!paused, "Paused");
1469         require(totalSupply() + _mintAmount <= maxSupply, "Max");
1470         require(msg.value >= price * _mintAmount, "Insufficient");
1471         require(_mintAmount > 0 && _mintAmount <= maxMint, "Invalid");
1472         _safeMint(_msgSender(), _mintAmount);
1473     }
1474 
1475     function freeMint(uint256 _mintAmount) public nonReentrant {
1476         require(!paused, "Paused");
1477         require(free + _mintAmount <= freeSupply, "Exceeded");
1478         require(totalSupply() + _mintAmount <= maxSupply, "Max");
1479         require(_mintAmount > 0 && _mintAmount <= maxFreeMint,"Invalid");
1480         _safeMint(_msgSender(), _mintAmount);
1481         free += _mintAmount;
1482     }
1483 
1484     function mintFor(uint256 _mintAmount, address _receiver) public onlyOwner {
1485         _safeMint(_receiver, _mintAmount);
1486     }
1487 
1488     function _startTokenId() internal view virtual override returns (uint256) {
1489         return 1;
1490     }
1491 
1492     function setPrice(uint256 _price) public onlyOwner {
1493         price = _price;
1494     }
1495 
1496     function setMaxMint(uint256 _amount) public onlyOwner {
1497         maxMint = _amount;
1498     }
1499 
1500     function setFreeMint(uint256 _amount) public onlyOwner {
1501         maxFreeMint = _amount;
1502     }
1503 
1504     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1505         maxSupply = _maxSupply;
1506     }
1507 
1508     function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1509         freeSupply = _freeSupply;
1510     }
1511 
1512     function setPaused(bool _state) public onlyOwner {
1513         paused = _state;
1514     }
1515 
1516     function withdraw() public onlyOwner {
1517         (bool success, ) = payable(msg.sender).call{
1518             value: address(this).balance
1519         }("");
1520         require(success);
1521     }
1522 
1523     function setBaseURI(string calldata baseURI) public onlyOwner {
1524         _baseTokenURI = baseURI;
1525     }
1526 
1527     function _baseURI() internal view virtual override returns (string memory) {
1528         return _baseTokenURI;
1529     }
1530 
1531     function tokenURI(uint256 _tokenId)
1532         public
1533         view
1534         virtual
1535         override
1536         returns (string memory)
1537     {
1538         require(_exists(_tokenId), "URI does not exist!");
1539         return
1540             bytes(_baseTokenURI).length > 0
1541                 ? string(
1542                     abi.encodePacked(
1543                         _baseTokenURI,
1544                         _tokenId.toString(),
1545                         ".json"
1546                     )
1547                 )
1548                 : "";
1549     }
1550 }