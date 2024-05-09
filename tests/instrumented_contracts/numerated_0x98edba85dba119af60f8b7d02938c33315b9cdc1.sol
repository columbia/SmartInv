1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
248 
249 pragma solidity ^0.8.1;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      *
272      * [IMPORTANT]
273      * ====
274      * You shouldn't rely on `isContract` to protect against flash loan attacks!
275      *
276      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
277      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
278      * constructor.
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize/address.code.length, which returns 0
283         // for contracts in construction, since the code is only stored at the end
284         // of the constructor execution.
285 
286         return account.code.length > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         (bool success, ) = recipient.call{value: amount}("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain `call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         require(isContract(target), "Address: call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.call{value: value}(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
393         return functionStaticCall(target, data, "Address: low-level static call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal view returns (bytes memory) {
407         require(isContract(target), "Address: static call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.staticcall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.delegatecall(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
442      * revert reason using the provided one.
443      *
444      * _Available since v4.3._
445      */
446     function verifyCallResult(
447         bool success,
448         bytes memory returndata,
449         string memory errorMessage
450     ) internal pure returns (bytes memory) {
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @title ERC721 token receiver interface
478  * @dev Interface for any contract that wants to support safeTransfers
479  * from ERC721 asset contracts.
480  */
481 interface IERC721Receiver {
482     /**
483      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
484      * by `operator` from `from`, this function is called.
485      *
486      * It must return its Solidity selector to confirm the token transfer.
487      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
488      *
489      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
490      */
491     function onERC721Received(
492         address operator,
493         address from,
494         uint256 tokenId,
495         bytes calldata data
496     ) external returns (bytes4);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC165 standard, as defined in the
508  * https://eips.ethereum.org/EIPS/eip-165[EIP].
509  *
510  * Implementers can declare support of contract interfaces, which can then be
511  * queried by others ({ERC165Checker}).
512  *
513  * For an implementation, see {ERC165}.
514  */
515 interface IERC165 {
516     /**
517      * @dev Returns true if this contract implements the interface defined by
518      * `interfaceId`. See the corresponding
519      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
520      * to learn more about how these ids are created.
521      *
522      * This function call must use less than 30 000 gas.
523      */
524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Required interface of an ERC721 compliant contract.
568  */
569 interface IERC721 is IERC165 {
570     /**
571      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
577      */
578     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
582      */
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     /**
586      * @dev Returns the number of tokens in ``owner``'s account.
587      */
588     function balanceOf(address owner) external view returns (uint256 balance);
589 
590     /**
591      * @dev Returns the owner of the `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function ownerOf(uint256 tokenId) external view returns (address owner);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
601      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers `tokenId` token from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
644      *
645      * Requirements:
646      *
647      * - The caller must own the token or be an approved operator.
648      * - `tokenId` must exist.
649      *
650      * Emits an {Approval} event.
651      */
652     function approve(address to, uint256 tokenId) external;
653 
654     /**
655      * @dev Returns the account approved for `tokenId` token.
656      *
657      * Requirements:
658      *
659      * - `tokenId` must exist.
660      */
661     function getApproved(uint256 tokenId) external view returns (address operator);
662 
663     /**
664      * @dev Approve or remove `operator` as an operator for the caller.
665      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
666      *
667      * Requirements:
668      *
669      * - The `operator` cannot be the caller.
670      *
671      * Emits an {ApprovalForAll} event.
672      */
673     function setApprovalForAll(address operator, bool _approved) external;
674 
675     /**
676      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
677      *
678      * See {setApprovalForAll}
679      */
680     function isApprovedForAll(address owner, address operator) external view returns (bool);
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must exist and be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692      *
693      * Emits a {Transfer} event.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId,
699         bytes calldata data
700     ) external;
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Metadata is IERC721 {
716     /**
717      * @dev Returns the token collection name.
718      */
719     function name() external view returns (string memory);
720 
721     /**
722      * @dev Returns the token collection symbol.
723      */
724     function symbol() external view returns (string memory);
725 
726     /**
727      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
728      */
729     function tokenURI(uint256 tokenId) external view returns (string memory);
730 }
731 
732 // File: erc721a/contracts/ERC721A.sol
733 
734 
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.4;
738 
739 
740 
741 
742 
743 
744 
745 
746 error ApprovalCallerNotOwnerNorApproved();
747 error ApprovalQueryForNonexistentToken();
748 error ApproveToCaller();
749 error ApprovalToCurrentOwner();
750 error BalanceQueryForZeroAddress();
751 error MintToZeroAddress();
752 error MintZeroQuantity();
753 error OwnerQueryForNonexistentToken();
754 error TransferCallerNotOwnerNorApproved();
755 error TransferFromIncorrectOwner();
756 error TransferToNonERC721ReceiverImplementer();
757 error TransferToZeroAddress();
758 error URIQueryForNonexistentToken();
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
765  *
766  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
767  *
768  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
769  */
770 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
771     using Address for address;
772     using Strings for uint256;
773 
774     // Compiler will pack this into a single 256bit word.
775     struct TokenOwnership {
776         // The address of the owner.
777         address addr;
778         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
779         uint64 startTimestamp;
780         // Whether the token has been burned.
781         bool burned;
782     }
783 
784     // Compiler will pack this into a single 256bit word.
785     struct AddressData {
786         // Realistically, 2**64-1 is more than enough.
787         uint64 balance;
788         // Keeps track of mint count with minimal overhead for tokenomics.
789         uint64 numberMinted;
790         // Keeps track of burn count with minimal overhead for tokenomics.
791         uint64 numberBurned;
792         // For miscellaneous variable(s) pertaining to the address
793         // (e.g. number of whitelist mint slots used).
794         // If there are multiple variables, please pack them into a uint64.
795         uint64 aux;
796     }
797 
798     // The tokenId of the next token to be minted.
799     uint256 internal _currentIndex;
800 
801     // The number of tokens burned.
802     uint256 internal _burnCounter;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
812     mapping(uint256 => TokenOwnership) internal _ownerships;
813 
814     // Mapping owner address to address data
815     mapping(address => AddressData) private _addressData;
816 
817     // Mapping from token ID to approved address
818     mapping(uint256 => address) private _tokenApprovals;
819 
820     // Mapping from owner to operator approvals
821     mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826         _currentIndex = _startTokenId();
827     }
828 
829     /**
830      * To change the starting tokenId, please override this function.
831      */
832     function _startTokenId() internal view virtual returns (uint256) {
833         return 0;
834     }
835 
836     /**
837      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
838      */
839     function totalSupply() public view returns (uint256) {
840         // Counter underflow is impossible as _burnCounter cannot be incremented
841         // more than _currentIndex - _startTokenId() times
842         unchecked {
843             return _currentIndex - _burnCounter - _startTokenId();
844         }
845     }
846 
847     /**
848      * Returns the total amount of tokens minted in the contract.
849      */
850     function _totalMinted() internal view returns (uint256) {
851         // Counter underflow is impossible as _currentIndex does not decrement,
852         // and it is initialized to _startTokenId()
853         unchecked {
854             return _currentIndex - _startTokenId();
855         }
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC721).interfaceId ||
864             interfaceId == type(IERC721Metadata).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871     function balanceOf(address owner) public view override returns (uint256) {
872         if (owner == address(0)) revert BalanceQueryForZeroAddress();
873         return uint256(_addressData[owner].balance);
874     }
875 
876     /**
877      * Returns the number of tokens minted by `owner`.
878      */
879     function _numberMinted(address owner) internal view returns (uint256) {
880         return uint256(_addressData[owner].numberMinted);
881     }
882 
883     /**
884      * Returns the number of tokens burned by or on behalf of `owner`.
885      */
886     function _numberBurned(address owner) internal view returns (uint256) {
887         return uint256(_addressData[owner].numberBurned);
888     }
889 
890     /**
891      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      */
893     function _getAux(address owner) internal view returns (uint64) {
894         return _addressData[owner].aux;
895     }
896 
897     /**
898      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      * If there are multiple variables, please pack them into a uint64.
900      */
901     function _setAux(address owner, uint64 aux) internal {
902         _addressData[owner].aux = aux;
903     }
904 
905     /**
906      * Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
908      */
909     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
910         uint256 curr = tokenId;
911 
912         unchecked {
913             if (_startTokenId() <= curr && curr < _currentIndex) {
914                 TokenOwnership memory ownership = _ownerships[curr];
915                 if (!ownership.burned) {
916                     if (ownership.addr != address(0)) {
917                         return ownership;
918                     }
919                     // Invariant:
920                     // There will always be an ownership that has an address and is not burned
921                     // before an ownership that does not have an address and is not burned.
922                     // Hence, curr will not underflow.
923                     while (true) {
924                         curr--;
925                         ownership = _ownerships[curr];
926                         if (ownership.addr != address(0)) {
927                             return ownership;
928                         }
929                     }
930                 }
931             }
932         }
933         revert OwnerQueryForNonexistentToken();
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view override returns (address) {
940         return _ownershipOf(tokenId).addr;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-name}.
945      */
946     function name() public view virtual override returns (string memory) {
947         return _name;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-symbol}.
952      */
953     function symbol() public view virtual override returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-tokenURI}.
959      */
960     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
961         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
962 
963         string memory baseURI = _baseURI();
964         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overriden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return '';
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = ERC721A.ownerOf(tokenId);
981         if (to == owner) revert ApprovalToCurrentOwner();
982 
983         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
984             revert ApprovalCallerNotOwnerNorApproved();
985         }
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public virtual override {
1003         if (operator == _msgSender()) revert ApproveToCaller();
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, '');
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1049             revert TransferToNonERC721ReceiverImplementer();
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted (`_mint`),
1059      */
1060     function _exists(uint256 tokenId) internal view returns (bool) {
1061         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1062     }
1063 
1064     function _safeMint(address to, uint256 quantity) internal {
1065         _safeMint(to, quantity, '');
1066     }
1067 
1068     /**
1069      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 quantity,
1081         bytes memory _data
1082     ) internal {
1083         _mint(to, quantity, _data, true);
1084     }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data,
1100         bool safe
1101     ) internal {
1102         uint256 startTokenId = _currentIndex;
1103         if (to == address(0)) revert MintToZeroAddress();
1104         if (quantity == 0) revert MintZeroQuantity();
1105 
1106         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108         // Overflows are incredibly unrealistic.
1109         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1110         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1111         unchecked {
1112             _addressData[to].balance += uint64(quantity);
1113             _addressData[to].numberMinted += uint64(quantity);
1114 
1115             _ownerships[startTokenId].addr = to;
1116             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1117 
1118             uint256 updatedIndex = startTokenId;
1119             uint256 end = updatedIndex + quantity;
1120 
1121             if (safe && to.isContract()) {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex);
1124                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex != end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex != end);
1134             }
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must be owned by `from`.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _transfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) private {
1155         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1156 
1157         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1158 
1159         bool isApprovedOrOwner = (_msgSender() == from ||
1160             isApprovedForAll(from, _msgSender()) ||
1161             getApproved(tokenId) == _msgSender());
1162 
1163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1164         if (to == address(0)) revert TransferToZeroAddress();
1165 
1166         _beforeTokenTransfers(from, to, tokenId, 1);
1167 
1168         // Clear approvals from the previous owner
1169         _approve(address(0), tokenId, from);
1170 
1171         // Underflow of the sender's balance is impossible because we check for
1172         // ownership above and the recipient's balance can't realistically overflow.
1173         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1174         unchecked {
1175             _addressData[from].balance -= 1;
1176             _addressData[to].balance += 1;
1177 
1178             TokenOwnership storage currSlot = _ownerships[tokenId];
1179             currSlot.addr = to;
1180             currSlot.startTimestamp = uint64(block.timestamp);
1181 
1182             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1183             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1184             uint256 nextTokenId = tokenId + 1;
1185             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1186             if (nextSlot.addr == address(0)) {
1187                 // This will suffice for checking _exists(nextTokenId),
1188                 // as a burned slot cannot contain the zero address.
1189                 if (nextTokenId != _currentIndex) {
1190                     nextSlot.addr = from;
1191                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1192                 }
1193             }
1194         }
1195 
1196         emit Transfer(from, to, tokenId);
1197         _afterTokenTransfers(from, to, tokenId, 1);
1198     }
1199 
1200     /**
1201      * @dev This is equivalent to _burn(tokenId, false)
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1219 
1220         address from = prevOwnership.addr;
1221 
1222         if (approvalCheck) {
1223             bool isApprovedOrOwner = (_msgSender() == from ||
1224                 isApprovedForAll(from, _msgSender()) ||
1225                 getApproved(tokenId) == _msgSender());
1226 
1227             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner
1233         _approve(address(0), tokenId, from);
1234 
1235         // Underflow of the sender's balance is impossible because we check for
1236         // ownership above and the recipient's balance can't realistically overflow.
1237         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1238         unchecked {
1239             AddressData storage addressData = _addressData[from];
1240             addressData.balance -= 1;
1241             addressData.numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             TokenOwnership storage currSlot = _ownerships[tokenId];
1245             currSlot.addr = from;
1246             currSlot.startTimestamp = uint64(block.timestamp);
1247             currSlot.burned = true;
1248 
1249             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1250             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1251             uint256 nextTokenId = tokenId + 1;
1252             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1253             if (nextSlot.addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId != _currentIndex) {
1257                     nextSlot.addr = from;
1258                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, address(0), tokenId);
1264         _afterTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(
1278         address to,
1279         uint256 tokenId,
1280         address owner
1281     ) private {
1282         _tokenApprovals[tokenId] = to;
1283         emit Approval(owner, to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1288      *
1289      * @param from address representing the previous owner of the given token ID
1290      * @param to target address that will receive the tokens
1291      * @param tokenId uint256 ID of the token to be transferred
1292      * @param _data bytes optional data to send along with the call
1293      * @return bool whether the call correctly returned the expected magic value
1294      */
1295     function _checkContractOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1302             return retval == IERC721Receiver(to).onERC721Received.selector;
1303         } catch (bytes memory reason) {
1304             if (reason.length == 0) {
1305                 revert TransferToNonERC721ReceiverImplementer();
1306             } else {
1307                 assembly {
1308                     revert(add(32, reason), mload(reason))
1309                 }
1310             }
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _beforeTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1338      * minting.
1339      * And also called after one token has been burned.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 }
1359 
1360 // File: contracts/SimpsPunks.sol
1361 
1362 
1363  
1364 pragma solidity >=0.8.0 <0.9.0;
1365 
1366 
1367 
1368 
1369  
1370 contract SimpsPunks is ERC721A, Ownable, ReentrancyGuard {
1371   using Strings for uint256;
1372  
1373   string public _baseTokenURI;
1374   string public hiddenMetadataUri;
1375  
1376   uint256 public cost = 0.001 ether;
1377   uint256 public maxSupply = 4444;
1378   uint256 public freeSupply = 3280;
1379   uint256 public maxMintAmountPerTx = 5;
1380  
1381   bool public paused;
1382   bool public revealed = true;
1383   bool private parametersUpdated = false;
1384  
1385   constructor(
1386     string memory _hiddenMetadataUri
1387   ) ERC721A("SimpsPunks", "SIMSPUNK") {
1388  
1389     setHiddenMetadataUri(_hiddenMetadataUri);
1390   }
1391  
1392   function mint(uint256 _mintAmount) public payable nonReentrant {
1393     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1394     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1395     require(!paused, "The contract is paused!");
1396     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1397  
1398     if (totalSupply() >= freeSupply) {
1399       require(msg.value > 0, "Max free supply exceeded!");
1400     }
1401 
1402     _safeMint(_msgSender(), _mintAmount);
1403 
1404     if (totalSupply() >= freeSupply - 10 && !parametersUpdated) {
1405       updateParameters();
1406     }
1407 
1408   }
1409 
1410   function updateParameters() internal {
1411     cost = 0.001 ether;
1412     maxMintAmountPerTx = 100;
1413     parametersUpdated = true;
1414   }
1415 
1416   function setParametersUpdated(bool _parametersUpdated) public onlyOwner {
1417     parametersUpdated = _parametersUpdated;
1418   }
1419 
1420   function setParameters(uint256 _cost, uint256 _maxMintAmountPerTx, bool _parametersUpdated) public onlyOwner {
1421     cost = _cost;
1422     maxMintAmountPerTx = _maxMintAmountPerTx;
1423     parametersUpdated = _parametersUpdated;
1424   }
1425  
1426   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1427     _safeMint(_receiver, _mintAmount);
1428   }
1429  
1430   function _startTokenId() internal view virtual override returns (uint256) {
1431     return 1;
1432   }
1433  
1434   function setRevealed(bool _state) public onlyOwner {
1435     revealed = _state;
1436   }
1437  
1438   function setCost(uint256 _cost) public onlyOwner {
1439     cost = _cost;
1440   }
1441  
1442   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1443     maxMintAmountPerTx = _maxMintAmountPerTx;
1444   }
1445  
1446   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1447     maxSupply = _maxSupply;
1448   }
1449 
1450   function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1451     freeSupply = _freeSupply;
1452   }
1453 
1454   function setPaused(bool _state) public onlyOwner {
1455     paused = _state;
1456   }
1457  
1458   function withdraw() public onlyOwner nonReentrant {
1459     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1460     require(os);
1461   }
1462  
1463   // METADATA HANDLING
1464  
1465   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1466     hiddenMetadataUri = _hiddenMetadataUri;
1467   }
1468  
1469   function setBaseURI(string calldata baseURI) public onlyOwner {
1470     _baseTokenURI = baseURI;
1471   }
1472  
1473   function _baseURI() internal view virtual override returns (string memory) {
1474       return _baseTokenURI;
1475   }
1476  
1477   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1478       require(_exists(_tokenId), "URI does not exist!");
1479  
1480       if (revealed) {
1481           return string(abi.encodePacked(_baseURI(), _tokenId.toString()));
1482       } else {
1483           return hiddenMetadataUri;
1484       }
1485   }
1486 }