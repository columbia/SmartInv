1 // SPDX-License-Identifier: MIT
2 // File: KidsY00ts_flat.sol
3 
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/access/Ownable.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Contract module which provides a basic access control mechanism, where
178  * there is an account (an owner) that can be granted exclusive access to
179  * specific functions.
180  *
181  * By default, the owner account will be the one that deploys the contract. This
182  * can later be changed with {transferOwnership}.
183  *
184  * This module is used through inheritance. It will make available the modifier
185  * `onlyOwner`, which can be applied to your functions to restrict their use to
186  * the owner.
187  */
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Initializes the contract setting the deployer as the initial owner.
195      */
196     constructor() {
197         _transferOwnership(_msgSender());
198     }
199 
200     /**
201      * @dev Returns the address of the current owner.
202      */
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     /**
208      * @dev Throws if called by any account other than the owner.
209      */
210     modifier onlyOwner() {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     /**
216      * @dev Leaves the contract without owner. It will not be possible to call
217      * `onlyOwner` functions anymore. Can only be called by the current owner.
218      *
219      * NOTE: Renouncing ownership will leave the contract without an owner,
220      * thereby removing any functionality that is only available to the owner.
221      */
222     function renounceOwnership() public virtual onlyOwner {
223         _transferOwnership(address(0));
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Can only be called by the current owner.
229      */
230     function transferOwnership(address newOwner) public virtual onlyOwner {
231         require(newOwner != address(0), "Ownable: new owner is the zero address");
232         _transferOwnership(newOwner);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Internal function without access restriction.
238      */
239     function _transferOwnership(address newOwner) internal virtual {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on `isContract` to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
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
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459 
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
472 
473 
474 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @title ERC721 token receiver interface
480  * @dev Interface for any contract that wants to support safeTransfers
481  * from ERC721 asset contracts.
482  */
483 interface IERC721Receiver {
484     /**
485      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
486      * by `operator` from `from`, this function is called.
487      *
488      * It must return its Solidity selector to confirm the token transfer.
489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
490      *
491      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
492      */
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Interface of the ERC165 standard, as defined in the
510  * https://eips.ethereum.org/EIPS/eip-165[EIP].
511  *
512  * Implementers can declare support of contract interfaces, which can then be
513  * queried by others ({ERC165Checker}).
514  *
515  * For an implementation, see {ERC165}.
516  */
517 interface IERC165 {
518     /**
519      * @dev Returns true if this contract implements the interface defined by
520      * `interfaceId`. See the corresponding
521      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
522      * to learn more about how these ids are created.
523      *
524      * This function call must use less than 30 000 gas.
525      */
526     function supportsInterface(bytes4 interfaceId) external view returns (bool);
527 }
528 
529 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Implementation of the {IERC165} interface.
539  *
540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
541  * for the additional interface id that will be supported. For example:
542  *
543  * ```solidity
544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
546  * }
547  * ```
548  *
549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
550  */
551 abstract contract ERC165 is IERC165 {
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         return interfaceId == type(IERC165).interfaceId;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Required interface of an ERC721 compliant contract.
570  */
571 interface IERC721 is IERC165 {
572     /**
573      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
574      */
575     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
579      */
580     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
584      */
585     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
586 
587     /**
588      * @dev Returns the number of tokens in ``owner``'s account.
589      */
590     function balanceOf(address owner) external view returns (uint256 balance);
591 
592     /**
593      * @dev Returns the owner of the `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function ownerOf(uint256 tokenId) external view returns (address owner);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
603      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must exist and be owned by `from`.
610      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Transfers `tokenId` token from `from` to `to`.
623      *
624      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
646      *
647      * Requirements:
648      *
649      * - The caller must own the token or be an approved operator.
650      * - `tokenId` must exist.
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Returns the account approved for `tokenId` token.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      */
663     function getApproved(uint256 tokenId) external view returns (address operator);
664 
665     /**
666      * @dev Approve or remove `operator` as an operator for the caller.
667      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
668      *
669      * Requirements:
670      *
671      * - The `operator` cannot be the caller.
672      *
673      * Emits an {ApprovalForAll} event.
674      */
675     function setApprovalForAll(address operator, bool _approved) external;
676 
677     /**
678      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
679      *
680      * See {setApprovalForAll}
681      */
682     function isApprovedForAll(address owner, address operator) external view returns (bool);
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must exist and be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
694      *
695      * Emits a {Transfer} event.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId,
701         bytes calldata data
702     ) external;
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
715  * @dev See https://eips.ethereum.org/EIPS/eip-721
716  */
717 interface IERC721Metadata is IERC721 {
718     /**
719      * @dev Returns the token collection name.
720      */
721     function name() external view returns (string memory);
722 
723     /**
724      * @dev Returns the token collection symbol.
725      */
726     function symbol() external view returns (string memory);
727 
728     /**
729      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
730      */
731     function tokenURI(uint256 tokenId) external view returns (string memory);
732 }
733 
734 // File: erc721a/contracts/ERC721A.sol
735 
736 
737 // Creator: Chiru Labs
738 
739 pragma solidity ^0.8.4;
740 
741 
742 
743 
744 
745 
746 
747 
748 error ApprovalCallerNotOwnerNorApproved();
749 error ApprovalQueryForNonexistentToken();
750 error ApproveToCaller();
751 error ApprovalToCurrentOwner();
752 error BalanceQueryForZeroAddress();
753 error MintToZeroAddress();
754 error MintZeroQuantity();
755 error OwnerQueryForNonexistentToken();
756 error TransferCallerNotOwnerNorApproved();
757 error TransferFromIncorrectOwner();
758 error TransferToNonERC721ReceiverImplementer();
759 error TransferToZeroAddress();
760 error URIQueryForNonexistentToken();
761 
762 /**
763  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
764  * the Metadata extension. Built to optimize for lower gas during batch mints.
765  *
766  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
767  *
768  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
769  *
770  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
771  */
772 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
773     using Address for address;
774     using Strings for uint256;
775 
776     // Compiler will pack this into a single 256bit word.
777     struct TokenOwnership {
778         // The address of the owner.
779         address addr;
780         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
781         uint64 startTimestamp;
782         // Whether the token has been burned.
783         bool burned;
784     }
785 
786     // Compiler will pack this into a single 256bit word.
787     struct AddressData {
788         // Realistically, 2**64-1 is more than enough.
789         uint64 balance;
790         // Keeps track of mint count with minimal overhead for tokenomics.
791         uint64 numberMinted;
792         // Keeps track of burn count with minimal overhead for tokenomics.
793         uint64 numberBurned;
794         // For miscellaneous variable(s) pertaining to the address
795         // (e.g. number of whitelist mint slots used).
796         // If there are multiple variables, please pack them into a uint64.
797         uint64 aux;
798     }
799 
800     // The tokenId of the next token to be minted.
801     uint256 internal _currentIndex;
802 
803     // The number of tokens burned.
804     uint256 internal _burnCounter;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828         _currentIndex = _startTokenId();
829     }
830 
831     /**
832      * To change the starting tokenId, please override this function.
833      */
834     function _startTokenId() internal view virtual returns (uint256) {
835         return 0;
836     }
837 
838     /**
839      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
840      */
841     function totalSupply() public view returns (uint256) {
842         // Counter underflow is impossible as _burnCounter cannot be incremented
843         // more than _currentIndex - _startTokenId() times
844         unchecked {
845             return _currentIndex - _burnCounter - _startTokenId();
846         }
847     }
848 
849     /**
850      * Returns the total amount of tokens minted in the contract.
851      */
852     function _totalMinted() internal view returns (uint256) {
853         // Counter underflow is impossible as _currentIndex does not decrement,
854         // and it is initialized to _startTokenId()
855         unchecked {
856             return _currentIndex - _startTokenId();
857         }
858     }
859 
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
864         return
865             interfaceId == type(IERC721).interfaceId ||
866             interfaceId == type(IERC721Metadata).interfaceId ||
867             super.supportsInterface(interfaceId);
868     }
869 
870     /**
871      * @dev See {IERC721-balanceOf}.
872      */
873     function balanceOf(address owner) public view override returns (uint256) {
874         if (owner == address(0)) revert BalanceQueryForZeroAddress();
875         return uint256(_addressData[owner].balance);
876     }
877 
878     /**
879      * Returns the number of tokens minted by `owner`.
880      */
881     function _numberMinted(address owner) internal view returns (uint256) {
882         return uint256(_addressData[owner].numberMinted);
883     }
884 
885     /**
886      * Returns the number of tokens burned by or on behalf of `owner`.
887      */
888     function _numberBurned(address owner) internal view returns (uint256) {
889         return uint256(_addressData[owner].numberBurned);
890     }
891 
892     /**
893      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         return _addressData[owner].aux;
897     }
898 
899     /**
900      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      * If there are multiple variables, please pack them into a uint64.
902      */
903     function _setAux(address owner, uint64 aux) internal {
904         _addressData[owner].aux = aux;
905     }
906 
907     /**
908      * Gas spent here starts off proportional to the maximum mint batch size.
909      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
910      */
911     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
912         uint256 curr = tokenId;
913 
914         unchecked {
915             if (_startTokenId() <= curr && curr < _currentIndex) {
916                 TokenOwnership memory ownership = _ownerships[curr];
917                 if (!ownership.burned) {
918                     if (ownership.addr != address(0)) {
919                         return ownership;
920                     }
921                     // Invariant:
922                     // There will always be an ownership that has an address and is not burned
923                     // before an ownership that does not have an address and is not burned.
924                     // Hence, curr will not underflow.
925                     while (true) {
926                         curr--;
927                         ownership = _ownerships[curr];
928                         if (ownership.addr != address(0)) {
929                             return ownership;
930                         }
931                     }
932                 }
933             }
934         }
935         revert OwnerQueryForNonexistentToken();
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         return _ownershipOf(tokenId).addr;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
963         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
964 
965         string memory baseURI = _baseURI();
966         return bytes(baseURI).length != 1 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")): "";
967     }
968 
969     /**
970      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
971      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
972      * by default, can be overriden in child contracts.
973      */
974     function _baseURI() internal view virtual returns (string memory) {
975         return '';
976     }
977 
978     /**
979      * @dev See {IERC721-approve}.
980      */
981     function approve(address to, uint256 tokenId) public override {
982         address owner = ERC721A.ownerOf(tokenId);
983         if (to == owner) revert ApprovalToCurrentOwner();
984 
985         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
986             revert ApprovalCallerNotOwnerNorApproved();
987         }
988 
989         _approve(to, tokenId, owner);
990     }
991 
992     /**
993      * @dev See {IERC721-getApproved}.
994      */
995     function getApproved(uint256 tokenId) public view override returns (address) {
996         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
997 
998         return _tokenApprovals[tokenId];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-setApprovalForAll}.
1003      */
1004     function setApprovalForAll(address operator, bool approved) public virtual override {
1005         if (operator == _msgSender()) revert ApproveToCaller();
1006 
1007         _operatorApprovals[_msgSender()][operator] = approved;
1008         emit ApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         safeTransferFrom(from, to, tokenId, '');
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1051             revert TransferToNonERC721ReceiverImplementer();
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns whether `tokenId` exists.
1057      *
1058      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1059      *
1060      * Tokens start existing when they are minted (`_mint`),
1061      */
1062     function _exists(uint256 tokenId) internal view returns (bool) {
1063         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1064             !_ownerships[tokenId].burned;
1065     }
1066 
1067     function _safeMint(address to, uint256 quantity) internal {
1068         _safeMint(to, quantity, '');
1069     }
1070 
1071     /**
1072      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeMint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data
1085     ) internal {
1086         _mint(to, quantity, _data, true);
1087     }
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _mint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data,
1103         bool safe
1104     ) internal {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are incredibly unrealistic.
1112         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1113         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1114         unchecked {
1115             _addressData[to].balance += uint64(quantity);
1116             _addressData[to].numberMinted += uint64(quantity);
1117 
1118             _ownerships[startTokenId].addr = to;
1119             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1120 
1121             uint256 updatedIndex = startTokenId;
1122             uint256 end = updatedIndex + quantity;
1123 
1124             if (safe && to.isContract()) {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex);
1127                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1128                         revert TransferToNonERC721ReceiverImplementer();
1129                     }
1130                 } while (updatedIndex != end);
1131                 // Reentrancy protection
1132                 if (_currentIndex != startTokenId) revert();
1133             } else {
1134                 do {
1135                     emit Transfer(address(0), to, updatedIndex++);
1136                 } while (updatedIndex != end);
1137             }
1138             _currentIndex = updatedIndex;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Transfers `tokenId` from `from` to `to`.
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
1157     ) private {
1158         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1159 
1160         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1161 
1162         bool isApprovedOrOwner = (_msgSender() == from ||
1163             isApprovedForAll(from, _msgSender()) ||
1164             getApproved(tokenId) == _msgSender());
1165 
1166         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1167         if (to == address(0)) revert TransferToZeroAddress();
1168 
1169         _beforeTokenTransfers(from, to, tokenId, 1);
1170 
1171         // Clear approvals from the previous owner
1172         _approve(address(0), tokenId, from);
1173 
1174         // Underflow of the sender's balance is impossible because we check for
1175         // ownership above and the recipient's balance can't realistically overflow.
1176         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1177         unchecked {
1178             _addressData[from].balance -= 1;
1179             _addressData[to].balance += 1;
1180 
1181             TokenOwnership storage currSlot = _ownerships[tokenId];
1182             currSlot.addr = to;
1183             currSlot.startTimestamp = uint64(block.timestamp);
1184 
1185             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1186             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1187             uint256 nextTokenId = tokenId + 1;
1188             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1189             if (nextSlot.addr == address(0)) {
1190                 // This will suffice for checking _exists(nextTokenId),
1191                 // as a burned slot cannot contain the zero address.
1192                 if (nextTokenId != _currentIndex) {
1193                     nextSlot.addr = from;
1194                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1195                 }
1196             }
1197         }
1198 
1199         emit Transfer(from, to, tokenId);
1200         _afterTokenTransfers(from, to, tokenId, 1);
1201     }
1202 
1203     /**
1204      * @dev This is equivalent to _burn(tokenId, false)
1205      */
1206     function _burn(uint256 tokenId) internal virtual {
1207         _burn(tokenId, false);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1221         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1222 
1223         address from = prevOwnership.addr;
1224 
1225         if (approvalCheck) {
1226             bool isApprovedOrOwner = (_msgSender() == from ||
1227                 isApprovedForAll(from, _msgSender()) ||
1228                 getApproved(tokenId) == _msgSender());
1229 
1230             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1231         }
1232 
1233         _beforeTokenTransfers(from, address(0), tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, from);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             AddressData storage addressData = _addressData[from];
1243             addressData.balance -= 1;
1244             addressData.numberBurned += 1;
1245 
1246             // Keep track of who burned the token, and the timestamp of burning.
1247             TokenOwnership storage currSlot = _ownerships[tokenId];
1248             currSlot.addr = from;
1249             currSlot.startTimestamp = uint64(block.timestamp);
1250             currSlot.burned = true;
1251 
1252             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1253             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1254             uint256 nextTokenId = tokenId + 1;
1255             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1256             if (nextSlot.addr == address(0)) {
1257                 // This will suffice for checking _exists(nextTokenId),
1258                 // as a burned slot cannot contain the zero address.
1259                 if (nextTokenId != _currentIndex) {
1260                     nextSlot.addr = from;
1261                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1262                 }
1263             }
1264         }
1265 
1266         emit Transfer(from, address(0), tokenId);
1267         _afterTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1270         unchecked {
1271             _burnCounter++;
1272         }
1273     }
1274 
1275     /**
1276      * @dev Approve `to` to operate on `tokenId`
1277      *
1278      * Emits a {Approval} event.
1279      */
1280     function _approve(
1281         address to,
1282         uint256 tokenId,
1283         address owner
1284     ) private {
1285         _tokenApprovals[tokenId] = to;
1286         emit Approval(owner, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1291      *
1292      * @param from address representing the previous owner of the given token ID
1293      * @param to target address that will receive the tokens
1294      * @param tokenId uint256 ID of the token to be transferred
1295      * @param _data bytes optional data to send along with the call
1296      * @return bool whether the call correctly returned the expected magic value
1297      */
1298     function _checkContractOnERC721Received(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) private returns (bool) {
1304         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1305             return retval == IERC721Receiver(to).onERC721Received.selector;
1306         } catch (bytes memory reason) {
1307             if (reason.length == 0) {
1308                 revert TransferToNonERC721ReceiverImplementer();
1309             } else {
1310                 assembly {
1311                     revert(add(32, reason), mload(reason))
1312                 }
1313             }
1314         }
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1319      * And also called before burning one token.
1320      *
1321      * startTokenId - the first token id to be transferred
1322      * quantity - the amount to be transferred
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, `tokenId` will be burned by `from`.
1330      * - `from` and `to` are never both zero.
1331      */
1332     function _beforeTokenTransfers(
1333         address from,
1334         address to,
1335         uint256 startTokenId,
1336         uint256 quantity
1337     ) internal virtual {}
1338 
1339     /**
1340      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1341      * minting.
1342      * And also called after one token has been burned.
1343      *
1344      * startTokenId - the first token id to be transferred
1345      * quantity - the amount to be transferred
1346      *
1347      * Calling conditions:
1348      *
1349      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1350      * transferred to `to`.
1351      * - When `from` is zero, `tokenId` has been minted for `to`.
1352      * - When `to` is zero, `tokenId` has been burned by `from`.
1353      * - `from` and `to` are never both zero.
1354      */
1355     function _afterTokenTransfers(
1356         address from,
1357         address to,
1358         uint256 startTokenId,
1359         uint256 quantity
1360     ) internal virtual {}
1361 }
1362 
1363 // File: KidsY00ts.sol
1364 
1365 
1366 
1367 pragma solidity ^0.8.4;
1368 
1369 
1370 
1371 
1372 contract KidsYoots is ERC721A, Ownable, ReentrancyGuard {
1373     using Strings for uint256;
1374 
1375     uint256 public PRICE;
1376     uint256 public MAX_SUPPLY;
1377     string private BASE_URI;
1378     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1379     uint256 public MAX_MINT_AMOUNT_PER_TX;
1380     bool public IS_SALE_ACTIVE;
1381     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1382     bool public METADATA_FROZEN;
1383 
1384     mapping(address => uint256) private freeMintCountMap;
1385 
1386     constructor(
1387         uint256 price,
1388         uint256 maxSupply,
1389         string memory baseUri,
1390         uint256 freeMintAllowance,
1391         uint256 maxMintPerTx,
1392         bool isSaleActive,
1393         uint256 freeMintIsAllowedUntil
1394     ) ERC721A("KidsYoots", "KidsYoots") {
1395         PRICE = price;
1396         MAX_SUPPLY = maxSupply;
1397         BASE_URI = baseUri;
1398         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1399         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1400         IS_SALE_ACTIVE = isSaleActive;
1401         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1402     }
1403 
1404     /** FREE MINT **/
1405 
1406     function updateFreeMintCount(address minter, uint256 count) private {
1407         freeMintCountMap[minter] += count;
1408     }
1409 
1410     /** GETTERS **/
1411 
1412     function _baseURI() internal view virtual override returns (string memory) {
1413         return BASE_URI;
1414     }
1415 
1416     /** SETTERS **/
1417 
1418     function setPrice(uint256 customPrice) external onlyOwner {
1419         PRICE = customPrice;
1420     }
1421 
1422     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1423         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1424         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1425         MAX_SUPPLY = newMaxSupply;
1426     }
1427 
1428     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1429         require(!METADATA_FROZEN, "Metadata frozen!");
1430         BASE_URI = customBaseURI_;
1431     }
1432 
1433     function setFreeMintAllowance(uint256 freeMintAllowance)
1434         external
1435         onlyOwner
1436     {
1437         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1438     }
1439 
1440     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1441         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1442     }
1443 
1444     function setSaleActive(bool saleIsActive) external onlyOwner {
1445         IS_SALE_ACTIVE = saleIsActive;
1446     }
1447 
1448     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1449         external
1450         onlyOwner
1451     {
1452         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1453     }
1454 
1455     function freezeMetadata() external onlyOwner {
1456         METADATA_FROZEN = true;
1457     }
1458 
1459     /** MINT **/
1460 
1461     modifier mintCompliance(uint256 _mintAmount) {
1462         require(
1463             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1464             "Invalid mint amount!"
1465         );
1466         require(
1467             _currentIndex + _mintAmount <= MAX_SUPPLY,
1468             "Max supply exceeded!"
1469         );
1470         _;
1471     }
1472 
1473     function mint(uint256 _mintAmount)
1474         public
1475         payable
1476         mintCompliance(_mintAmount)
1477     {
1478         require(IS_SALE_ACTIVE, "Sale is not active!");
1479 
1480         uint256 price = PRICE * _mintAmount;
1481 
1482         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1483             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1484                 freeMintCountMap[msg.sender];
1485             if (remainingFreeMint > 0) {
1486                 if (_mintAmount >= remainingFreeMint) {
1487                     price -= remainingFreeMint * PRICE;
1488                     updateFreeMintCount(msg.sender, remainingFreeMint);
1489                 } else {
1490                     price -= _mintAmount * PRICE;
1491                     updateFreeMintCount(msg.sender, _mintAmount);
1492                 }
1493             }
1494         }
1495 
1496         require(msg.value >= price, "Insufficient funds!");
1497 
1498         _safeMint(msg.sender, _mintAmount);
1499     }
1500 
1501     function mintOwner(address _to, uint256 _mintAmount)
1502         public
1503         mintCompliance(_mintAmount)
1504         onlyOwner
1505     {
1506         _safeMint(_to, _mintAmount);
1507     }
1508 
1509     /** PAYOUT **/
1510 
1511     address private constant payoutAddress1 =
1512         0x5702d14ba1b42fF87b3E75cb4F94685D0dd90010;
1513 
1514     function withdraw() public onlyOwner nonReentrant {
1515         uint256 balance = address(this).balance;
1516         Address.sendValue(payable(payoutAddress1), balance / 1);
1517     }
1518 }