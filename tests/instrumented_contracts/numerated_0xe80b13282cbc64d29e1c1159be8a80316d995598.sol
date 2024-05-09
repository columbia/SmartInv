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
732 // File: erc721a/contracts/IERC721A.sol
733 
734 
735 // ERC721A Contracts v3.3.0
736 // Creator: Chiru Labs
737 
738 pragma solidity ^0.8.4;
739 
740 
741 
742 /**
743  * @dev Interface of an ERC721A compliant contract.
744  */
745 interface IERC721A is IERC721, IERC721Metadata {
746     /**
747      * The caller must own the token or be an approved operator.
748      */
749     error ApprovalCallerNotOwnerNorApproved();
750 
751     /**
752      * The token does not exist.
753      */
754     error ApprovalQueryForNonexistentToken();
755 
756     /**
757      * The caller cannot approve to their own address.
758      */
759     error ApproveToCaller();
760 
761     /**
762      * The caller cannot approve to the current owner.
763      */
764     error ApprovalToCurrentOwner();
765 
766     /**
767      * Cannot query the balance for the zero address.
768      */
769     error BalanceQueryForZeroAddress();
770 
771     /**
772      * Cannot mint to the zero address.
773      */
774     error MintToZeroAddress();
775 
776     /**
777      * The quantity of tokens minted must be more than zero.
778      */
779     error MintZeroQuantity();
780 
781     /**
782      * The token does not exist.
783      */
784     error OwnerQueryForNonexistentToken();
785 
786     /**
787      * The caller must own the token or be an approved operator.
788      */
789     error TransferCallerNotOwnerNorApproved();
790 
791     /**
792      * The token must be owned by `from`.
793      */
794     error TransferFromIncorrectOwner();
795 
796     /**
797      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
798      */
799     error TransferToNonERC721ReceiverImplementer();
800 
801     /**
802      * Cannot transfer to the zero address.
803      */
804     error TransferToZeroAddress();
805 
806     /**
807      * The token does not exist.
808      */
809     error URIQueryForNonexistentToken();
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
835     /**
836      * @dev Returns the total amount of tokens stored by the contract.
837      * 
838      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
839      */
840     function totalSupply() external view returns (uint256);
841 }
842 
843 // File: erc721a/contracts/ERC721A.sol
844 
845 
846 // ERC721A Contracts v3.3.0
847 // Creator: Chiru Labs
848 
849 pragma solidity ^0.8.4;
850 
851 
852 
853 
854 
855 
856 
857 /**
858  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
859  * the Metadata extension. Built to optimize for lower gas during batch mints.
860  *
861  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
862  *
863  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
864  *
865  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
866  */
867 contract ERC721A is Context, ERC165, IERC721A {
868     using Address for address;
869     using Strings for uint256;
870 
871     // The tokenId of the next token to be minted.
872     uint256 internal _currentIndex;
873 
874     // The number of tokens burned.
875     uint256 internal _burnCounter;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to ownership details
884     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
885     mapping(uint256 => TokenOwnership) internal _ownerships;
886 
887     // Mapping owner address to address data
888     mapping(address => AddressData) private _addressData;
889 
890     // Mapping from token ID to approved address
891     mapping(uint256 => address) private _tokenApprovals;
892 
893     // Mapping from owner to operator approvals
894     mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899         _currentIndex = _startTokenId();
900     }
901 
902     /**
903      * To change the starting tokenId, please override this function.
904      */
905     function _startTokenId() internal view virtual returns (uint256) {
906         return 0;
907     }
908 
909     /**
910      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
911      */
912     function totalSupply() public view override returns (uint256) {
913         // Counter underflow is impossible as _burnCounter cannot be incremented
914         // more than _currentIndex - _startTokenId() times
915         unchecked {
916             return _currentIndex - _burnCounter - _startTokenId();
917         }
918     }
919 
920     /**
921      * Returns the total amount of tokens minted in the contract.
922      */
923     function _totalMinted() internal view returns (uint256) {
924         // Counter underflow is impossible as _currentIndex does not decrement,
925         // and it is initialized to _startTokenId()
926         unchecked {
927             return _currentIndex - _startTokenId();
928         }
929     }
930 
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
935         return
936             interfaceId == type(IERC721).interfaceId ||
937             interfaceId == type(IERC721Metadata).interfaceId ||
938             super.supportsInterface(interfaceId);
939     }
940 
941     /**
942      * @dev See {IERC721-balanceOf}.
943      */
944     function balanceOf(address owner) public view override returns (uint256) {
945         if (owner == address(0)) revert BalanceQueryForZeroAddress();
946         return uint256(_addressData[owner].balance);
947     }
948 
949     /**
950      * Returns the number of tokens minted by `owner`.
951      */
952     function _numberMinted(address owner) internal view returns (uint256) {
953         return uint256(_addressData[owner].numberMinted);
954     }
955 
956     /**
957      * Returns the number of tokens burned by or on behalf of `owner`.
958      */
959     function _numberBurned(address owner) internal view returns (uint256) {
960         return uint256(_addressData[owner].numberBurned);
961     }
962 
963     /**
964      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
965      */
966     function _getAux(address owner) internal view returns (uint64) {
967         return _addressData[owner].aux;
968     }
969 
970     /**
971      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
972      * If there are multiple variables, please pack them into a uint64.
973      */
974     function _setAux(address owner, uint64 aux) internal {
975         _addressData[owner].aux = aux;
976     }
977 
978     /**
979      * Gas spent here starts off proportional to the maximum mint batch size.
980      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
981      */
982     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
983         uint256 curr = tokenId;
984 
985         unchecked {
986             if (_startTokenId() <= curr) if (curr < _currentIndex) {
987                 TokenOwnership memory ownership = _ownerships[curr];
988                 if (!ownership.burned) {
989                     if (ownership.addr != address(0)) {
990                         return ownership;
991                     }
992                     // Invariant:
993                     // There will always be an ownership that has an address and is not burned
994                     // before an ownership that does not have an address and is not burned.
995                     // Hence, curr will not underflow.
996                     while (true) {
997                         curr--;
998                         ownership = _ownerships[curr];
999                         if (ownership.addr != address(0)) {
1000                             return ownership;
1001                         }
1002                     }
1003                 }
1004             }
1005         }
1006         revert OwnerQueryForNonexistentToken();
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-ownerOf}.
1011      */
1012     function ownerOf(uint256 tokenId) public view override returns (address) {
1013         return _ownershipOf(tokenId).addr;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-name}.
1018      */
1019     function name() public view virtual override returns (string memory) {
1020         return _name;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Metadata-symbol}.
1025      */
1026     function symbol() public view virtual override returns (string memory) {
1027         return _symbol;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Metadata-tokenURI}.
1032      */
1033     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1034         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1035 
1036         string memory baseURI = _baseURI();
1037         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overriden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return '';
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public override {
1053         address owner = ERC721A.ownerOf(tokenId);
1054         if (to == owner) revert ApprovalToCurrentOwner();
1055 
1056         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1057             revert ApprovalCallerNotOwnerNorApproved();
1058         }
1059 
1060         _approve(to, tokenId, owner);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-getApproved}.
1065      */
1066     function getApproved(uint256 tokenId) public view override returns (address) {
1067         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved) public virtual override {
1076         if (operator == _msgSender()) revert ApproveToCaller();
1077 
1078         _operatorApprovals[_msgSender()][operator] = approved;
1079         emit ApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         _transfer(from, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-safeTransferFrom}.
1102      */
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) public virtual override {
1108         safeTransferFrom(from, to, tokenId, '');
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-safeTransferFrom}.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) public virtual override {
1120         _transfer(from, to, tokenId);
1121         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1122             revert TransferToNonERC721ReceiverImplementer();
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns whether `tokenId` exists.
1128      *
1129      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1130      *
1131      * Tokens start existing when they are minted (`_mint`),
1132      */
1133     function _exists(uint256 tokenId) internal view returns (bool) {
1134         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1135     }
1136 
1137     /**
1138      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1139      */
1140     function _safeMint(address to, uint256 quantity) internal {
1141         _safeMint(to, quantity, '');
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement
1150      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data
1159     ) internal {
1160         uint256 startTokenId = _currentIndex;
1161         if (to == address(0)) revert MintToZeroAddress();
1162         if (quantity == 0) revert MintZeroQuantity();
1163 
1164         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166         // Overflows are incredibly unrealistic.
1167         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1168         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1169         unchecked {
1170             _addressData[to].balance += uint64(quantity);
1171             _addressData[to].numberMinted += uint64(quantity);
1172 
1173             _ownerships[startTokenId].addr = to;
1174             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             uint256 updatedIndex = startTokenId;
1177             uint256 end = updatedIndex + quantity;
1178 
1179             if (to.isContract()) {
1180                 do {
1181                     emit Transfer(address(0), to, updatedIndex);
1182                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1183                         revert TransferToNonERC721ReceiverImplementer();
1184                     }
1185                 } while (updatedIndex < end);
1186                 // Reentrancy protection
1187                 if (_currentIndex != startTokenId) revert();
1188             } else {
1189                 do {
1190                     emit Transfer(address(0), to, updatedIndex++);
1191                 } while (updatedIndex < end);
1192             }
1193             _currentIndex = updatedIndex;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Mints `quantity` tokens and transfers them to `to`.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `quantity` must be greater than 0.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _mint(address to, uint256 quantity) internal {
1209         uint256 startTokenId = _currentIndex;
1210         if (to == address(0)) revert MintToZeroAddress();
1211         if (quantity == 0) revert MintZeroQuantity();
1212 
1213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215         // Overflows are incredibly unrealistic.
1216         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1217         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1218         unchecked {
1219             _addressData[to].balance += uint64(quantity);
1220             _addressData[to].numberMinted += uint64(quantity);
1221 
1222             _ownerships[startTokenId].addr = to;
1223             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1224 
1225             uint256 updatedIndex = startTokenId;
1226             uint256 end = updatedIndex + quantity;
1227 
1228             do {
1229                 emit Transfer(address(0), to, updatedIndex++);
1230             } while (updatedIndex < end);
1231 
1232             _currentIndex = updatedIndex;
1233         }
1234         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1235     }
1236 
1237     /**
1238      * @dev Transfers `tokenId` from `from` to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must be owned by `from`.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _transfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) private {
1252         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1253 
1254         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1255 
1256         bool isApprovedOrOwner = (_msgSender() == from ||
1257             isApprovedForAll(from, _msgSender()) ||
1258             getApproved(tokenId) == _msgSender());
1259 
1260         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1261         if (to == address(0)) revert TransferToZeroAddress();
1262 
1263         _beforeTokenTransfers(from, to, tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, from);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             _addressData[from].balance -= 1;
1273             _addressData[to].balance += 1;
1274 
1275             TokenOwnership storage currSlot = _ownerships[tokenId];
1276             currSlot.addr = to;
1277             currSlot.startTimestamp = uint64(block.timestamp);
1278 
1279             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1280             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1281             uint256 nextTokenId = tokenId + 1;
1282             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1283             if (nextSlot.addr == address(0)) {
1284                 // This will suffice for checking _exists(nextTokenId),
1285                 // as a burned slot cannot contain the zero address.
1286                 if (nextTokenId != _currentIndex) {
1287                     nextSlot.addr = from;
1288                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(from, to, tokenId);
1294         _afterTokenTransfers(from, to, tokenId, 1);
1295     }
1296 
1297     /**
1298      * @dev Equivalent to `_burn(tokenId, false)`.
1299      */
1300     function _burn(uint256 tokenId) internal virtual {
1301         _burn(tokenId, false);
1302     }
1303 
1304     /**
1305      * @dev Destroys `tokenId`.
1306      * The approval is cleared when the token is burned.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1315         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1316 
1317         address from = prevOwnership.addr;
1318 
1319         if (approvalCheck) {
1320             bool isApprovedOrOwner = (_msgSender() == from ||
1321                 isApprovedForAll(from, _msgSender()) ||
1322                 getApproved(tokenId) == _msgSender());
1323 
1324             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1325         }
1326 
1327         _beforeTokenTransfers(from, address(0), tokenId, 1);
1328 
1329         // Clear approvals from the previous owner
1330         _approve(address(0), tokenId, from);
1331 
1332         // Underflow of the sender's balance is impossible because we check for
1333         // ownership above and the recipient's balance can't realistically overflow.
1334         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1335         unchecked {
1336             AddressData storage addressData = _addressData[from];
1337             addressData.balance -= 1;
1338             addressData.numberBurned += 1;
1339 
1340             // Keep track of who burned the token, and the timestamp of burning.
1341             TokenOwnership storage currSlot = _ownerships[tokenId];
1342             currSlot.addr = from;
1343             currSlot.startTimestamp = uint64(block.timestamp);
1344             currSlot.burned = true;
1345 
1346             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1347             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1348             uint256 nextTokenId = tokenId + 1;
1349             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1350             if (nextSlot.addr == address(0)) {
1351                 // This will suffice for checking _exists(nextTokenId),
1352                 // as a burned slot cannot contain the zero address.
1353                 if (nextTokenId != _currentIndex) {
1354                     nextSlot.addr = from;
1355                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(from, address(0), tokenId);
1361         _afterTokenTransfers(from, address(0), tokenId, 1);
1362 
1363         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1364         unchecked {
1365             _burnCounter++;
1366         }
1367     }
1368 
1369     /**
1370      * @dev Approve `to` to operate on `tokenId`
1371      *
1372      * Emits a {Approval} event.
1373      */
1374     function _approve(
1375         address to,
1376         uint256 tokenId,
1377         address owner
1378     ) private {
1379         _tokenApprovals[tokenId] = to;
1380         emit Approval(owner, to, tokenId);
1381     }
1382 
1383     /**
1384      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkContractOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1399             return retval == IERC721Receiver(to).onERC721Received.selector;
1400         } catch (bytes memory reason) {
1401             if (reason.length == 0) {
1402                 revert TransferToNonERC721ReceiverImplementer();
1403             } else {
1404                 assembly {
1405                     revert(add(32, reason), mload(reason))
1406                 }
1407             }
1408         }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1413      * And also called before burning one token.
1414      *
1415      * startTokenId - the first token id to be transferred
1416      * quantity - the amount to be transferred
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _beforeTokenTransfers(
1427         address from,
1428         address to,
1429         uint256 startTokenId,
1430         uint256 quantity
1431     ) internal virtual {}
1432 
1433     /**
1434      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1435      * minting.
1436      * And also called after one token has been burned.
1437      *
1438      * startTokenId - the first token id to be transferred
1439      * quantity - the amount to be transferred
1440      *
1441      * Calling conditions:
1442      *
1443      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1444      * transferred to `to`.
1445      * - When `from` is zero, `tokenId` has been minted for `to`.
1446      * - When `to` is zero, `tokenId` has been burned by `from`.
1447      * - `from` and `to` are never both zero.
1448      */
1449     function _afterTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 }
1456 
1457 // File: contracts/whaleeventsbayc.sol
1458 
1459 
1460 
1461 pragma solidity ^0.8.4;
1462 
1463 
1464 
1465 
1466 
1467 
1468 contract WalletValue is ERC721A, Ownable, ReentrancyGuard {
1469     using Strings for uint256;
1470     uint256 public cost;
1471     uint256 public maxSupply;
1472     string private BASE_URI;
1473     uint256 public MAX_MINT_AMOUNT_PER_TX;
1474     bool public IS_SALE_ACTIVE;
1475     mapping(address => uint256) private freeMintCountMap;
1476 
1477     constructor(
1478         uint256 price,
1479         uint256 max_Supply,
1480         string memory baseUri,
1481         uint256 maxMintPerTx,
1482         bool isSaleActive
1483     ) ERC721A("Wallet Value", "Pass") {
1484         cost = price;
1485         maxSupply = max_Supply;
1486         BASE_URI = baseUri;
1487         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1488         IS_SALE_ACTIVE = isSaleActive;
1489     }
1490 
1491     /** FREE MINT **/
1492 
1493     function updateFreeMintCount(address minter, uint256 count) private {
1494         freeMintCountMap[minter] += count;
1495     }
1496 
1497     /** GETTERS **/
1498 
1499     function _baseURI() internal view virtual override returns (string memory) {
1500         return BASE_URI;
1501     }
1502 
1503     /** SETTERS **/
1504 
1505     function setPrice(uint256 customPrice) external onlyOwner {
1506         cost = customPrice;
1507     }
1508 
1509 
1510     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1511         require(newMaxSupply > maxSupply, "Invalid new max supply");
1512         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1513         maxSupply = newMaxSupply;
1514     }
1515 
1516     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1517         BASE_URI = customBaseURI_;
1518     }
1519 
1520    
1521 
1522     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1523         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1524     }
1525 
1526     function setSaleActive(bool saleIsActive) external onlyOwner {
1527         IS_SALE_ACTIVE = saleIsActive;
1528     }
1529 
1530 
1531     /** MINT **/
1532 
1533     modifier mintCompliance(uint256 _mintAmount) {
1534         require(
1535             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1536             "Invalid mint amount!"
1537         );
1538         require(
1539             _currentIndex + _mintAmount <= maxSupply,
1540             "Max supply exceeded!"
1541         );
1542         _;
1543     }
1544 
1545     function mint(uint256 _mintAmount)
1546         public
1547         payable
1548         mintCompliance(_mintAmount)
1549     {
1550         require(IS_SALE_ACTIVE, "Sale is not active!");
1551 
1552         uint256 price = cost * _mintAmount;
1553 
1554         require(msg.value >= price, "Insufficient funds!");
1555 
1556         _safeMint(msg.sender, _mintAmount);
1557     }
1558 
1559     function godMint(address _to, uint256 _mintAmount)
1560         public
1561         mintCompliance(_mintAmount)
1562         onlyOwner
1563     {
1564         _safeMint(_to, _mintAmount);
1565     }
1566 
1567     /** PAYOUT **/
1568 
1569     function withdraw() public onlyOwner nonReentrant {
1570         uint256 balance = address(this).balance;
1571 
1572         Address.sendValue(
1573             payable(0x8F6bcD5e73823003B4dD3fA57665559eff0c59c6),
1574             balance
1575         );
1576     }
1577 }