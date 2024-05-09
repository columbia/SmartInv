1 /**
2 KENJIS REVENGE
3 */
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Contract module that helps prevent reentrant calls to a function.
15  *
16  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
17  * available, which can be applied to functions to make sure there are no nested
18  * (reentrant) calls to them.
19  *
20  * Note that because there is a single `nonReentrant` guard, functions marked as
21  * `nonReentrant` may not call one another. This can be worked around by making
22  * those functions `private`, and then adding `external` `nonReentrant` entry
23  * points to them.
24  *
25  * TIP: If you would like to learn more about reentrancy and alternative ways
26  * to protect against it, check out our blog post
27  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
28  */
29 abstract contract ReentrancyGuard {
30     // Booleans are more expensive than uint256 or any type that takes up a full
31     // word because each write operation emits an extra SLOAD to first read the
32     // slot's contents, replace the bits taken up by the boolean, and then write
33     // back. This is the compiler's defense against contract upgrades and
34     // pointer aliasing, and it cannot be disabled.
35 
36     // The values being non-zero value makes deployment a bit more expensive,
37     // but in exchange the refund on every call to nonReentrant will be lower in
38     // amount. Since refunds are capped to a percentage of the total
39     // transaction's gas, it is best to keep them low in cases like this one, to
40     // increase the likelihood of the full refund coming into effect.
41     uint256 private constant _NOT_ENTERED = 1;
42     uint256 private constant _ENTERED = 2;
43 
44     uint256 private _status;
45 
46     constructor() {
47         _status = _NOT_ENTERED;
48     }
49 
50     /**
51      * @dev Prevents a contract from calling itself, directly or indirectly.
52      * Calling a `nonReentrant` function from another `nonReentrant`
53      * function is not supported. It is possible to prevent this from happening
54      * by making the `nonReentrant` function external, and making it call a
55      * `private` function that does the actual work.
56      */
57     modifier nonReentrant() {
58         // On the first call to nonReentrant, _notEntered will be true
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63 
64         _;
65 
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Strings.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev String operations.
81  */
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
87      */
88     function toString(uint256 value) internal pure returns (string memory) {
89         // Inspired by OraclizeAPI's implementation - MIT licence
90         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
91 
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
112      */
113     function toHexString(uint256 value) internal pure returns (string memory) {
114         if (value == 0) {
115             return "0x00";
116         }
117         uint256 temp = value;
118         uint256 length = 0;
119         while (temp != 0) {
120             length++;
121             temp >>= 8;
122         }
123         return toHexString(value, length);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
128      */
129     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
130         bytes memory buffer = new bytes(2 * length + 2);
131         buffer[0] = "0";
132         buffer[1] = "x";
133         for (uint256 i = 2 * length + 1; i > 1; --i) {
134             buffer[i] = _HEX_SYMBOLS[value & 0xf];
135             value >>= 4;
136         }
137         require(value == 0, "Strings: hex length insufficient");
138         return string(buffer);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/Context.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes calldata) {
165         return msg.data;
166     }
167 }
168 
169 // File: @openzeppelin/contracts/access/Ownable.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Contract module which provides a basic access control mechanism, where
179  * there is an account (an owner) that can be granted exclusive access to
180  * specific functions.
181  *
182  * By default, the owner account will be the one that deploys the contract. This
183  * can later be changed with {transferOwnership}.
184  *
185  * This module is used through inheritance. It will make available the modifier
186  * `onlyOwner`, which can be applied to your functions to restrict their use to
187  * the owner.
188  */
189 abstract contract Ownable is Context {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev Initializes the contract setting the deployer as the initial owner.
196      */
197     constructor() {
198         _transferOwnership(_msgSender());
199     }
200 
201     /**
202      * @dev Returns the address of the current owner.
203      */
204     function owner() public view virtual returns (address) {
205         return _owner;
206     }
207 
208     /**
209      * @dev Throws if called by any account other than the owner.
210      */
211     modifier onlyOwner() {
212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
213         _;
214     }
215 
216     /**
217      * @dev Leaves the contract without owner. It will not be possible to call
218      * `onlyOwner` functions anymore. Can only be called by the current owner.
219      *
220      * NOTE: Renouncing ownership will leave the contract without an owner,
221      * thereby removing any functionality that is only available to the owner.
222      */
223     function renounceOwnership() public virtual onlyOwner {
224         _transferOwnership(address(0));
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Can only be called by the current owner.
230      */
231     function transferOwnership(address newOwner) public virtual onlyOwner {
232         require(newOwner != address(0), "Ownable: new owner is the zero address");
233         _transferOwnership(newOwner);
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Internal function without access restriction.
239      */
240     function _transferOwnership(address newOwner) internal virtual {
241         address oldOwner = _owner;
242         _owner = newOwner;
243         emit OwnershipTransferred(oldOwner, newOwner);
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 
250 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
251 
252 pragma solidity ^0.8.1;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      *
275      * [IMPORTANT]
276      * ====
277      * You shouldn't rely on `isContract` to protect against flash loan attacks!
278      *
279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
281      * constructor.
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize/address.code.length, which returns 0
286         // for contracts in construction, since the code is only stored at the end
287         // of the constructor execution.
288 
289         return account.code.length > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         (bool success, ) = recipient.call{value: amount}("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain `call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         require(isContract(target), "Address: call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.call{value: value}(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
396         return functionStaticCall(target, data, "Address: low-level static call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.staticcall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
423         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(isContract(target), "Address: delegate call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.delegatecall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
445      * revert reason using the provided one.
446      *
447      * _Available since v4.3._
448      */
449     function verifyCallResult(
450         bool success,
451         bytes memory returndata,
452         string memory errorMessage
453     ) internal pure returns (bytes memory) {
454         if (success) {
455             return returndata;
456         } else {
457             // Look for revert reason and bubble it up if present
458             if (returndata.length > 0) {
459                 // The easiest way to bubble the revert reason is using memory via assembly
460 
461                 assembly {
462                     let returndata_size := mload(returndata)
463                     revert(add(32, returndata), returndata_size)
464                 }
465             } else {
466                 revert(errorMessage);
467             }
468         }
469     }
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @title ERC721 token receiver interface
481  * @dev Interface for any contract that wants to support safeTransfers
482  * from ERC721 asset contracts.
483  */
484 interface IERC721Receiver {
485     /**
486      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
487      * by `operator` from `from`, this function is called.
488      *
489      * It must return its Solidity selector to confirm the token transfer.
490      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
491      *
492      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
493      */
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Interface of the ERC165 standard, as defined in the
511  * https://eips.ethereum.org/EIPS/eip-165[EIP].
512  *
513  * Implementers can declare support of contract interfaces, which can then be
514  * queried by others ({ERC165Checker}).
515  *
516  * For an implementation, see {ERC165}.
517  */
518 interface IERC165 {
519     /**
520      * @dev Returns true if this contract implements the interface defined by
521      * `interfaceId`. See the corresponding
522      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
523      * to learn more about how these ids are created.
524      *
525      * This function call must use less than 30 000 gas.
526      */
527     function supportsInterface(bytes4 interfaceId) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * ```solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * ```
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Required interface of an ERC721 compliant contract.
571  */
572 interface IERC721 is IERC165 {
573     /**
574      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
575      */
576     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
580      */
581     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
585      */
586     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
587 
588     /**
589      * @dev Returns the number of tokens in ``owner``'s account.
590      */
591     function balanceOf(address owner) external view returns (uint256 balance);
592 
593     /**
594      * @dev Returns the owner of the `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function ownerOf(uint256 tokenId) external view returns (address owner);
601 
602     /**
603      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
604      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must exist and be owned by `from`.
611      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Transfers `tokenId` token from `from` to `to`.
624      *
625      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      *
634      * Emits a {Transfer} event.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external;
641 
642     /**
643      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Approve or remove `operator` as an operator for the caller.
668      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
669      *
670      * Requirements:
671      *
672      * - The `operator` cannot be the caller.
673      *
674      * Emits an {ApprovalForAll} event.
675      */
676     function setApprovalForAll(address operator, bool _approved) external;
677 
678     /**
679      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
680      *
681      * See {setApprovalForAll}
682      */
683     function isApprovedForAll(address owner, address operator) external view returns (bool);
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes calldata data
703     ) external;
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
716  * @dev See https://eips.ethereum.org/EIPS/eip-721
717  */
718 interface IERC721Metadata is IERC721 {
719     /**
720      * @dev Returns the token collection name.
721      */
722     function name() external view returns (string memory);
723 
724     /**
725      * @dev Returns the token collection symbol.
726      */
727     function symbol() external view returns (string memory);
728 
729     /**
730      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
731      */
732     function tokenURI(uint256 tokenId) external view returns (string memory);
733 }
734 
735 // File: contracts/ERC721A.sol
736 
737 
738 // Creator: Chiru Labs
739 
740 pragma solidity ^0.8.4;
741 
742 
743 
744 
745 
746 
747 
748 
749 error ApprovalCallerNotOwnerNorApproved();
750 error ApprovalQueryForNonexistentToken();
751 error ApproveToCaller();
752 error ApprovalToCurrentOwner();
753 error BalanceQueryForZeroAddress();
754 error MintToZeroAddress();
755 error MintZeroQuantity();
756 error OwnerQueryForNonexistentToken();
757 error TransferCallerNotOwnerNorApproved();
758 error TransferFromIncorrectOwner();
759 error TransferToNonERC721ReceiverImplementer();
760 error TransferToZeroAddress();
761 error URIQueryForNonexistentToken();
762 
763 /**
764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension. Built to optimize for lower gas during batch mints.
766  *
767  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
768  *
769  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
770  *
771  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
772  */
773 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
774     using Address for address;
775     using Strings for uint256;
776 
777     // Compiler will pack this into a single 256bit word.
778     struct TokenOwnership {
779         // The address of the owner.
780         address addr;
781         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
782         uint64 startTimestamp;
783         // Whether the token has been burned.
784         bool burned;
785     }
786 
787     // Compiler will pack this into a single 256bit word.
788     struct AddressData {
789         // Realistically, 2**64-1 is more than enough.
790         uint64 balance;
791         // Keeps track of mint count with minimal overhead for tokenomics.
792         uint64 numberMinted;
793         // Keeps track of burn count with minimal overhead for tokenomics.
794         uint64 numberBurned;
795         // For miscellaneous variable(s) pertaining to the address
796         // (e.g. number of whitelist mint slots used).
797         // If there are multiple variables, please pack them into a uint64.
798         uint64 aux;
799     }
800 
801     // The tokenId of the next token to be minted.
802     uint256 internal _currentIndex;
803 
804     // The number of tokens burned.
805     uint256 internal _burnCounter;
806 
807     // Token name
808     string private _name;
809 
810     // Token symbol
811     string private _symbol;
812 
813     // Mapping from token ID to ownership details
814     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
815     mapping(uint256 => TokenOwnership) internal _ownerships;
816 
817     // Mapping owner address to address data
818     mapping(address => AddressData) private _addressData;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     constructor(string memory name_, string memory symbol_) {
827         _name = name_;
828         _symbol = symbol_;
829         _currentIndex = _startTokenId();
830     }
831 
832     /**
833      * To change the starting tokenId, please override this function.
834      */
835     function _startTokenId() internal view virtual returns (uint256) {
836         return 1;
837     }
838 
839     /**
840      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
841      */
842     function totalSupply() public view returns (uint256) {
843         // Counter underflow is impossible as _burnCounter cannot be incremented
844         // more than _currentIndex - _startTokenId() times
845         unchecked {
846             return _currentIndex - _burnCounter - _startTokenId();
847         }
848     }
849 
850     /**
851      * Returns the total amount of tokens minted in the contract.
852      */
853     function _totalMinted() internal view returns (uint256) {
854         // Counter underflow is impossible as _currentIndex does not decrement,
855         // and it is initialized to _startTokenId()
856         unchecked {
857             return _currentIndex - _startTokenId();
858         }
859     }
860 
861     /**
862      * @dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
865         return
866             interfaceId == type(IERC721).interfaceId ||
867             interfaceId == type(IERC721Metadata).interfaceId ||
868             super.supportsInterface(interfaceId);
869     }
870 
871     /**
872      * @dev See {IERC721-balanceOf}.
873      */
874     function balanceOf(address owner) public view override returns (uint256) {
875         if (owner == address(0)) revert BalanceQueryForZeroAddress();
876         return uint256(_addressData[owner].balance);
877     }
878 
879     /**
880      * Returns the number of tokens minted by `owner`.
881      */
882     function _numberMinted(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberMinted);
884     }
885 
886     /**
887      * Returns the number of tokens burned by or on behalf of `owner`.
888      */
889     function _numberBurned(address owner) internal view returns (uint256) {
890         return uint256(_addressData[owner].numberBurned);
891     }
892 
893     /**
894      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      */
896     function _getAux(address owner) internal view returns (uint64) {
897         return _addressData[owner].aux;
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         _addressData[owner].aux = aux;
906     }
907 
908     /**
909      * Gas spent here starts off proportional to the maximum mint batch size.
910      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
911      */
912     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
913         uint256 curr = tokenId;
914 
915         unchecked {
916             if (_startTokenId() <= curr && curr < _currentIndex) {
917                 TokenOwnership memory ownership = _ownerships[curr];
918                 if (!ownership.burned) {
919                     if (ownership.addr != address(0)) {
920                         return ownership;
921                     }
922                     // Invariant:
923                     // There will always be an ownership that has an address and is not burned
924                     // before an ownership that does not have an address and is not burned.
925                     // Hence, curr will not underflow.
926                     while (true) {
927                         curr--;
928                         ownership = _ownerships[curr];
929                         if (ownership.addr != address(0)) {
930                             return ownership;
931                         }
932                     }
933                 }
934             }
935         }
936         revert OwnerQueryForNonexistentToken();
937     }
938 
939     /**
940      * @dev See {IERC721-ownerOf}.
941      */
942     function ownerOf(uint256 tokenId) public view override returns (address) {
943         return _ownershipOf(tokenId).addr;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-name}.
948      */
949     function name() public view virtual override returns (string memory) {
950         return _name;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-symbol}.
955      */
956     function symbol() public view virtual override returns (string memory) {
957         return _symbol;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-tokenURI}.
962      */
963     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
964         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
965 
966         string memory baseURI = _baseURI();
967         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
968     }
969 
970     /**
971      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
972      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
973      * by default, can be overriden in child contracts.
974      */
975     function _baseURI() internal view virtual returns (string memory) {
976         return '';
977     }
978 
979     /**
980      * @dev See {IERC721-approve}.
981      */
982     function approve(address to, uint256 tokenId) public override {
983         address owner = ERC721A.ownerOf(tokenId);
984         if (to == owner) revert ApprovalToCurrentOwner();
985 
986         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
987             revert ApprovalCallerNotOwnerNorApproved();
988         }
989 
990         _approve(to, tokenId, owner);
991     }
992 
993     /**
994      * @dev See {IERC721-getApproved}.
995      */
996     function getApproved(uint256 tokenId) public view override returns (address) {
997         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved) public virtual override {
1006         if (operator == _msgSender()) revert ApproveToCaller();
1007 
1008         _operatorApprovals[_msgSender()][operator] = approved;
1009         emit ApprovalForAll(_msgSender(), operator, approved);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-isApprovedForAll}.
1014      */
1015     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1016         return _operatorApprovals[owner][operator];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-transferFrom}.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         _transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         safeTransferFrom(from, to, tokenId, '');
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) public virtual override {
1050         _transfer(from, to, tokenId);
1051         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1052             revert TransferToNonERC721ReceiverImplementer();
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      */
1063     function _exists(uint256 tokenId) internal view returns (bool) {
1064         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1065     }
1066 
1067     /**
1068      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1069      */
1070     function _safeMint(address to, uint256 quantity) internal {
1071         _safeMint(to, quantity, '');
1072     }
1073 
1074     /**
1075      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - If `to` refers to a smart contract, it must implement 
1080      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data
1089     ) internal {
1090         uint256 startTokenId = _currentIndex;
1091         if (to == address(0)) revert MintToZeroAddress();
1092         if (quantity == 0) revert MintZeroQuantity();
1093 
1094         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1095 
1096         // Overflows are incredibly unrealistic.
1097         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1098         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1099         unchecked {
1100             _addressData[to].balance += uint64(quantity);
1101             _addressData[to].numberMinted += uint64(quantity);
1102 
1103             _ownerships[startTokenId].addr = to;
1104             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1105 
1106             uint256 updatedIndex = startTokenId;
1107             uint256 end = updatedIndex + quantity;
1108 
1109             if (to.isContract()) {
1110                 do {
1111                     emit Transfer(address(0), to, updatedIndex);
1112                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1113                         revert TransferToNonERC721ReceiverImplementer();
1114                     }
1115                 } while (updatedIndex != end);
1116                 // Reentrancy protection
1117                 if (_currentIndex != startTokenId) revert();
1118             } else {
1119                 do {
1120                     emit Transfer(address(0), to, updatedIndex++);
1121                 } while (updatedIndex != end);
1122             }
1123             _currentIndex = updatedIndex;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _mint(address to, uint256 quantity) internal {
1139         uint256 startTokenId = _currentIndex;
1140         if (to == address(0)) revert MintToZeroAddress();
1141         if (quantity == 0) revert MintZeroQuantity();
1142 
1143         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1144 
1145         // Overflows are incredibly unrealistic.
1146         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1147         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1148         unchecked {
1149             _addressData[to].balance += uint64(quantity);
1150             _addressData[to].numberMinted += uint64(quantity);
1151 
1152             _ownerships[startTokenId].addr = to;
1153             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             uint256 updatedIndex = startTokenId;
1156             uint256 end = updatedIndex + quantity;
1157 
1158             do {
1159                 emit Transfer(address(0), to, updatedIndex++);
1160             } while (updatedIndex != end);
1161 
1162             _currentIndex = updatedIndex;
1163         }
1164         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1165     }
1166 
1167     /**
1168      * @dev Transfers `tokenId` from `from` to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must be owned by `from`.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _transfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) private {
1182         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1183 
1184         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1185 
1186         bool isApprovedOrOwner = (_msgSender() == from ||
1187             isApprovedForAll(from, _msgSender()) ||
1188             getApproved(tokenId) == _msgSender());
1189 
1190         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1191         if (to == address(0)) revert TransferToZeroAddress();
1192 
1193         _beforeTokenTransfers(from, to, tokenId, 1);
1194 
1195         // Clear approvals from the previous owner
1196         _approve(address(0), tokenId, from);
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             _addressData[from].balance -= 1;
1203             _addressData[to].balance += 1;
1204 
1205             TokenOwnership storage currSlot = _ownerships[tokenId];
1206             currSlot.addr = to;
1207             currSlot.startTimestamp = uint64(block.timestamp);
1208 
1209             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1210             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1211             uint256 nextTokenId = tokenId + 1;
1212             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1213             if (nextSlot.addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId != _currentIndex) {
1217                     nextSlot.addr = from;
1218                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev Equivalent to `_burn(tokenId, false)`.
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         _burn(tokenId, false);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1245         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1246 
1247         address from = prevOwnership.addr;
1248 
1249         if (approvalCheck) {
1250             bool isApprovedOrOwner = (_msgSender() == from ||
1251                 isApprovedForAll(from, _msgSender()) ||
1252                 getApproved(tokenId) == _msgSender());
1253 
1254             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1255         }
1256 
1257         _beforeTokenTransfers(from, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner
1260         _approve(address(0), tokenId, from);
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1265         unchecked {
1266             AddressData storage addressData = _addressData[from];
1267             addressData.balance -= 1;
1268             addressData.numberBurned += 1;
1269 
1270             // Keep track of who burned the token, and the timestamp of burning.
1271             TokenOwnership storage currSlot = _ownerships[tokenId];
1272             currSlot.addr = from;
1273             currSlot.startTimestamp = uint64(block.timestamp);
1274             currSlot.burned = true;
1275 
1276             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1277             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1278             uint256 nextTokenId = tokenId + 1;
1279             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1280             if (nextSlot.addr == address(0)) {
1281                 // This will suffice for checking _exists(nextTokenId),
1282                 // as a burned slot cannot contain the zero address.
1283                 if (nextTokenId != _currentIndex) {
1284                     nextSlot.addr = from;
1285                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1286                 }
1287             }
1288         }
1289 
1290         emit Transfer(from, address(0), tokenId);
1291         _afterTokenTransfers(from, address(0), tokenId, 1);
1292 
1293         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1294         unchecked {
1295             _burnCounter++;
1296         }
1297     }
1298 
1299     /**
1300      * @dev Approve `to` to operate on `tokenId`
1301      *
1302      * Emits a {Approval} event.
1303      */
1304     function _approve(
1305         address to,
1306         uint256 tokenId,
1307         address owner
1308     ) private {
1309         _tokenApprovals[tokenId] = to;
1310         emit Approval(owner, to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1315      *
1316      * @param from address representing the previous owner of the given token ID
1317      * @param to target address that will receive the tokens
1318      * @param tokenId uint256 ID of the token to be transferred
1319      * @param _data bytes optional data to send along with the call
1320      * @return bool whether the call correctly returned the expected magic value
1321      */
1322     function _checkContractOnERC721Received(
1323         address from,
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) private returns (bool) {
1328         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1329             return retval == IERC721Receiver(to).onERC721Received.selector;
1330         } catch (bytes memory reason) {
1331             if (reason.length == 0) {
1332                 revert TransferToNonERC721ReceiverImplementer();
1333             } else {
1334                 assembly {
1335                     revert(add(32, reason), mload(reason))
1336                 }
1337             }
1338         }
1339     }
1340 
1341     /**
1342      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1343      * And also called before burning one token.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` will be minted for `to`.
1353      * - When `to` is zero, `tokenId` will be burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _beforeTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 
1363     /**
1364      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1365      * minting.
1366      * And also called after one token has been burned.
1367      *
1368      * startTokenId - the first token id to be transferred
1369      * quantity - the amount to be transferred
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` has been minted for `to`.
1376      * - When `to` is zero, `tokenId` has been burned by `from`.
1377      * - `from` and `to` are never both zero.
1378      */
1379     function _afterTokenTransfers(
1380         address from,
1381         address to,
1382         uint256 startTokenId,
1383         uint256 quantity
1384     ) internal virtual {}
1385 }
1386 // File: contracts/KENJISREVENGE.sol
1387 
1388 
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 
1393 
1394 
1395 
1396 contract KENJISREVENGE is ERC721A, Ownable, ReentrancyGuard {
1397   using Address for address;
1398   using Strings for uint;
1399 
1400 
1401   string  public  baseTokenURI = "ipfs://QmbwktDoGumZ8vZPMbppSsfrVvLffo6gaE9FVv7otpiFBh/";
1402   uint256  public  maxSupply = 1800;
1403   uint256 public  MAX_MINTS_PER_TX = 10;
1404   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1405   uint256 public  NUM_FREE_MINTS = 1800;
1406   uint256 public  MAX_FREE_PER_WALLET = 1;
1407   uint256 public freeNFTAlreadyMinted = 0;
1408   bool public isPublicSaleActive = false;
1409 
1410   constructor(
1411 
1412   ) ERC721A("KENJISREVENGE", "KNJISRVNG") {
1413 
1414   }
1415 
1416 
1417   function mint(uint256 numberOfTokens)
1418       external
1419       payable
1420   {
1421     require(isPublicSaleActive, "Public sale is not open");
1422     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1423 
1424     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1425         require(
1426             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1427             "Incorrect ETH value sent"
1428         );
1429     } else {
1430         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1431         require(
1432             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1433             "Incorrect ETH value sent"
1434         );
1435         require(
1436             numberOfTokens <= MAX_MINTS_PER_TX,
1437             "Max mints per transaction exceeded"
1438         );
1439         } else {
1440             require(
1441                 numberOfTokens <= MAX_FREE_PER_WALLET,
1442                 "Max mints per transaction exceeded"
1443             );
1444             freeNFTAlreadyMinted += numberOfTokens;
1445         }
1446     }
1447     _safeMint(msg.sender, numberOfTokens);
1448   }
1449 
1450   function setBaseURI(string memory baseURI)
1451     public
1452     onlyOwner
1453   {
1454     baseTokenURI = baseURI;
1455   }
1456 
1457   function treasuryMint(uint quantity)
1458     public
1459     onlyOwner
1460   {
1461     require(
1462       quantity > 0,
1463       "Invalid mint amount"
1464     );
1465     require(
1466       totalSupply() + quantity <= maxSupply,
1467       "Maximum supply exceeded"
1468     );
1469     _safeMint(msg.sender, quantity);
1470   }
1471 
1472   function withdraw()
1473     public
1474     onlyOwner
1475     nonReentrant
1476   {
1477     Address.sendValue(payable(msg.sender), address(this).balance);
1478   }
1479 
1480   function tokenURI(uint _tokenId)
1481     public
1482     view
1483     virtual
1484     override
1485     returns (string memory)
1486   {
1487     require(
1488       _exists(_tokenId),
1489       "ERC721Metadata: URI query for nonexistent token"
1490     );
1491     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1492   }
1493 
1494   function _baseURI()
1495     internal
1496     view
1497     virtual
1498     override
1499     returns (string memory)
1500   {
1501     return baseTokenURI;
1502   }
1503 
1504   function setIsPublicSaleActive(bool _isPublicSaleActive)
1505       external
1506       onlyOwner
1507   {
1508       isPublicSaleActive = _isPublicSaleActive;
1509   }
1510 
1511   function setNumFreeMints(uint256 _numfreemints)
1512       external
1513       onlyOwner
1514   {
1515       NUM_FREE_MINTS = _numfreemints;
1516   }
1517 
1518   function setSalePrice(uint256 _price)
1519       external
1520       onlyOwner
1521   {
1522       PUBLIC_SALE_PRICE = _price;
1523   }
1524 
1525   function setMaxLimitPerTransaction(uint256 _limit)
1526       external
1527       onlyOwner
1528   {
1529       MAX_MINTS_PER_TX = _limit;
1530   }
1531 
1532   function setFreeLimitPerWallet(uint256 _limit)
1533       external
1534       onlyOwner
1535   {
1536       MAX_FREE_PER_WALLET = _limit;
1537   }
1538 }