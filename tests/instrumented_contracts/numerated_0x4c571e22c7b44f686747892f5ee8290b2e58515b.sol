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
472 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
489      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
561 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
600      * @dev Safely transfers `tokenId` token from `from` to `to`.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId,
616         bytes calldata data
617     ) external;
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns the account approved for `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function getApproved(uint256 tokenId) external view returns (address operator);
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
732 // File: contracts/ERC721A.sol
733 
734 
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.0;
738 
739 
740 
741 
742 
743 
744 
745 
746 /**
747  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
748  * the Metadata extension. Built to optimize for lower gas during batch mints.
749  *
750  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
751  *
752  * Does not support burning tokens to address(0).
753  *
754  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
755  */
756 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
757     using Address for address;
758     using Strings for uint256;
759 
760     struct TokenOwnership {
761         address addr;
762         uint64 startTimestamp;
763     }
764 
765     struct AddressData {
766         uint128 balance;
767         uint128 numberMinted;
768     }
769 
770     uint256 internal currentIndex;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794     }
795 
796     function totalSupply() public view returns (uint256) {
797         return currentIndex;
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805         interfaceId == type(IERC721).interfaceId ||
806         interfaceId == type(IERC721Metadata).interfaceId ||
807         super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev See {IERC721-balanceOf}.
812      */
813     function balanceOf(address owner) public view override returns (uint256) {
814         require(owner != address(0), 'ERC721A: balance query for the zero address');
815         return uint256(_addressData[owner].balance);
816     }
817 
818     function _numberMinted(address owner) internal view returns (uint256) {
819         require(owner != address(0), 'ERC721A: number minted query for the zero address');
820         return uint256(_addressData[owner].numberMinted);
821     }
822 
823     /**
824      * Gas spent here starts off proportional to the maximum mint batch size.
825      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
826      */
827     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
828         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
829 
830     unchecked {
831         for (uint256 curr = tokenId; curr >= 0; curr--) {
832             TokenOwnership memory ownership = _ownerships[curr];
833             if (ownership.addr != address(0)) {
834                 return ownership;
835             }
836         }
837     }
838 
839         revert('ERC721A: unable to determine the owner of token');
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return ownershipOf(tokenId).addr;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public override {
886         address owner = ERC721A.ownerOf(tokenId);
887         require(to != owner, 'ERC721A: approval to current owner');
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             'ERC721A: approve caller is not owner nor approved for all'
892         );
893 
894         _approve(to, tokenId, owner);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view override returns (address) {
901         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public override {
910         require(operator != _msgSender(), 'ERC721A: approve to caller');
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public override {
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public override {
954         _transfer(from, to, tokenId);
955         require(
956             _checkOnERC721Received(from, to, tokenId, _data),
957             'ERC721A: transfer to non ERC721Receiver implementer'
958         );
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return tokenId < currentIndex;
970     }
971 
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Safely mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         _mint(to, quantity, _data, true);
992     }
993 
994     /**
995      * @dev Mints `quantity` tokens and transfers them to `to`.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data,
1008         bool safe
1009     ) internal {
1010         uint256 startTokenId = currentIndex;
1011         require(to != address(0), 'ERC721A: mint to the zero address');
1012         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1013 
1014         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1015 
1016         // Overflows are incredibly unrealistic.
1017         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1018         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1019     unchecked {
1020         _addressData[to].balance += uint128(quantity);
1021         _addressData[to].numberMinted += uint128(quantity);
1022 
1023         _ownerships[startTokenId].addr = to;
1024         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1025 
1026         uint256 updatedIndex = startTokenId;
1027 
1028         for (uint256 i; i < quantity; i++) {
1029             emit Transfer(address(0), to, updatedIndex);
1030             if (safe) {
1031                 require(
1032                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1033                     'ERC721A: transfer to non ERC721Receiver implementer'
1034                 );
1035             }
1036 
1037             updatedIndex++;
1038         }
1039 
1040         currentIndex = updatedIndex;
1041     }
1042 
1043         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must be owned by `from`.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _transfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) private {
1061         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1062 
1063         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1064         getApproved(tokenId) == _msgSender() ||
1065         isApprovedForAll(prevOwnership.addr, _msgSender()));
1066 
1067         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1068 
1069         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1070         require(to != address(0), 'ERC721A: transfer to the zero address');
1071 
1072         _beforeTokenTransfers(from, to, tokenId, 1);
1073 
1074         // Clear approvals from the previous owner
1075         _approve(address(0), tokenId, prevOwnership.addr);
1076 
1077         // Underflow of the sender's balance is impossible because we check for
1078         // ownership above and the recipient's balance can't realistically overflow.
1079         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1080     unchecked {
1081         _addressData[from].balance -= 1;
1082         _addressData[to].balance += 1;
1083 
1084         _ownerships[tokenId].addr = to;
1085         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1086 
1087         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1088         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1089         uint256 nextTokenId = tokenId + 1;
1090         if (_ownerships[nextTokenId].addr == address(0)) {
1091             if (_exists(nextTokenId)) {
1092                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1093                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1094             }
1095         }
1096     }
1097 
1098         emit Transfer(from, to, tokenId);
1099         _afterTokenTransfers(from, to, tokenId, 1);
1100     }
1101 
1102     /**
1103      * @dev Approve `to` to operate on `tokenId`
1104      *
1105      * Emits a {Approval} event.
1106      */
1107     function _approve(
1108         address to,
1109         uint256 tokenId,
1110         address owner
1111     ) private {
1112         _tokenApprovals[tokenId] = to;
1113         emit Approval(owner, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1118      * The call is not executed if the target address is not a contract.
1119      *
1120      * @param from address representing the previous owner of the given token ID
1121      * @param to target address that will receive the tokens
1122      * @param tokenId uint256 ID of the token to be transferred
1123      * @param _data bytes optional data to send along with the call
1124      * @return bool whether the call correctly returned the expected magic value
1125      */
1126     function _checkOnERC721Received(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) private returns (bool) {
1132         if (to.isContract()) {
1133             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1134                 return retval == IERC721Receiver(to).onERC721Received.selector;
1135             } catch (bytes memory reason) {
1136                 if (reason.length == 0) {
1137                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1138                 } else {
1139                     assembly {
1140                         revert(add(32, reason), mload(reason))
1141                     }
1142                 }
1143             }
1144         } else {
1145             return true;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1151      *
1152      * startTokenId - the first token id to be transferred
1153      * quantity - the amount to be transferred
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      */
1161     function _beforeTokenTransfers(
1162         address from,
1163         address to,
1164         uint256 startTokenId,
1165         uint256 quantity
1166     ) internal virtual {}
1167 
1168     /**
1169      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1170      * minting.
1171      *
1172      * startTokenId - the first token id to be transferred
1173      * quantity - the amount to be transferred
1174      *
1175      * Calling conditions:
1176      *
1177      * - when `from` and `to` are both non-zero.
1178      * - `from` and `to` are never both zero.
1179      */
1180     function _afterTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 }
1187 // File: contracts/WOOAW.sol
1188 
1189 
1190 
1191 pragma solidity ^0.8.4;
1192 
1193 
1194 
1195 
1196 contract MoonFarts is ERC721A, Ownable, ReentrancyGuard {
1197     using Strings for uint256;
1198 
1199     uint256 public PRICE = 0.005 ether; // 5000000000000000 wei cost
1200     uint256 public MAX_SUPPLY = 2222;
1201     string private BASE_URI = "ipfs://QmW35u3m7ULJ87NqZ4qsCmjKhtir9c7iFFVTpDf5AruXRD/";
1202     uint256 public FREE_MINT_LIMIT_PER_WALLET = 2;
1203     uint256 public MAX_MINT_AMOUNT_PER_TX = 10;
1204     bool public IS_SALE_ACTIVE;
1205     uint256 public FREE_MINT_IS_ALLOWED_UNTIL = 1000; // Free mint is allowed until x mint
1206     bool public METADATA_FROZEN;
1207 
1208     mapping(address => uint256) private freeMintCountMap;
1209 
1210     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintAllowance, uint256 maxMintPerTx, bool isSaleActive, uint256 freeMintIsAllowedUntil) ERC721A("MoonFarts", "MFART$") {
1211         PRICE = price;
1212         MAX_SUPPLY = maxSupply;
1213         BASE_URI = baseUri;
1214         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1215         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1216         IS_SALE_ACTIVE = isSaleActive;
1217         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1218     }
1219 
1220     /** FREE MINT **/
1221 
1222     function updateFreeMintCount(address minter, uint256 count) private {
1223         freeMintCountMap[minter] += count;
1224     }
1225 
1226     function freeMintCount(address addr) public view returns (uint256) {
1227         return freeMintCountMap[addr];
1228     }
1229 
1230     /** GETTERS **/
1231 
1232     function _baseURI() internal view virtual override returns (string memory) {
1233         return BASE_URI;
1234     }
1235 
1236     /** SETTERS **/
1237 
1238     function setPrice(uint256 customPrice) external onlyOwner {
1239         PRICE = customPrice;
1240     }
1241 
1242     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1243         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1244         require(newMaxSupply >= currentIndex, "Invalid new max supply");
1245         MAX_SUPPLY = newMaxSupply;
1246     }
1247 
1248     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1249         require(!METADATA_FROZEN, "Metadata frozen!");
1250         BASE_URI = customBaseURI_;
1251     }
1252 
1253     function setFreeMintAllowance(uint256 freeMintAllowance) external onlyOwner {
1254         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1255     }
1256 
1257     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1258         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1259     }
1260 
1261     function setSaleActive(bool saleIsActive) external onlyOwner {
1262         IS_SALE_ACTIVE = saleIsActive;
1263     }
1264 
1265     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1266         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1267     }
1268 
1269     function freezeMetadata() external onlyOwner {
1270         METADATA_FROZEN = true;
1271     }
1272 
1273     /** MINT **/
1274 
1275     modifier mintCompliance(uint256 _mintAmount) {
1276         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount!");
1277         require(currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1278         _;
1279     }
1280 
1281     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1282         require(IS_SALE_ACTIVE, "Sale is not active!");
1283 
1284         uint256 price = PRICE * _mintAmount;
1285 
1286         if (currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1287             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET - freeMintCountMap[msg.sender];
1288             if (remainingFreeMint > 0) {
1289                 if (_mintAmount >= remainingFreeMint) {
1290                     price -= remainingFreeMint * PRICE;
1291                     updateFreeMintCount(msg.sender, remainingFreeMint);
1292                 } else {
1293                     price -= _mintAmount * PRICE;
1294                     updateFreeMintCount(msg.sender, _mintAmount);
1295                 }
1296             }
1297         }
1298 
1299         require(msg.value >= price, "Insufficient funds!");
1300 
1301         _safeMint(msg.sender, _mintAmount);
1302     }
1303 
1304     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1305         _safeMint(_to, _mintAmount);
1306     }
1307 
1308     /** PAYOUT **/
1309 
1310     address private payoutAddress1 =
1311     0x9baeCd33D32d3DcDB53f838b05889bD2f77a5078;
1312 
1313     address private payoutAddress2 =
1314     0x9baeCd33D32d3DcDB53f838b05889bD2f77a5078;
1315 
1316     address private payoutAddress3 =
1317     0x9baeCd33D32d3DcDB53f838b05889bD2f77a5078;
1318 
1319     address private payoutAddress4 =
1320     0x9baeCd33D32d3DcDB53f838b05889bD2f77a5078;
1321 
1322     function withdraw() public onlyOwner nonReentrant {
1323         uint256 balance = address(this).balance;
1324 
1325         Address.sendValue(payable(payoutAddress1), balance / 4);
1326 
1327         Address.sendValue(payable(payoutAddress2), balance / 4);
1328 
1329         Address.sendValue(payable(payoutAddress3), balance / 4);
1330 
1331         Address.sendValue(payable(payoutAddress4), balance / 4);
1332     }
1333 
1334     function setPayoutAddress(address addy, uint id) external onlyOwner {
1335         if (id == 0) {
1336             payoutAddress1 = addy;
1337         } else if (id == 1) {
1338             payoutAddress2 = addy;
1339         } else if (id == 2) {
1340             payoutAddress3 = addy;
1341         } else if (id == 3) {
1342             payoutAddress4 = addy;
1343         }
1344     }
1345 }