1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 
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
475 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
492      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
564 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
603      * @dev Safely transfers `tokenId` token from `from` to `to`.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must exist and be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId,
619         bytes calldata data
620     ) external;
621 
622     /**
623      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
624      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must exist and be owned by `from`.
631      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633      *
634      * Emits a {Transfer} event.
635      */
636     function safeTransferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external;
641 
642     /**
643      * @dev Transfers `tokenId` token from `from` to `to`.
644      *
645      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must be owned by `from`.
652      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
653      *
654      * Emits a {Transfer} event.
655      */
656     function transferFrom(
657         address from,
658         address to,
659         uint256 tokenId
660     ) external;
661 
662     /**
663      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
664      * The approval is cleared when the token is transferred.
665      *
666      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
667      *
668      * Requirements:
669      *
670      * - The caller must own the token or be an approved operator.
671      * - `tokenId` must exist.
672      *
673      * Emits an {Approval} event.
674      */
675     function approve(address to, uint256 tokenId) external;
676 
677     /**
678      * @dev Approve or remove `operator` as an operator for the caller.
679      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
680      *
681      * Requirements:
682      *
683      * - The `operator` cannot be the caller.
684      *
685      * Emits an {ApprovalForAll} event.
686      */
687     function setApprovalForAll(address operator, bool _approved) external;
688 
689     /**
690      * @dev Returns the account approved for `tokenId` token.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must exist.
695      */
696     function getApproved(uint256 tokenId) external view returns (address operator);
697 
698     /**
699      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
700      *
701      * See {setApprovalForAll}
702      */
703     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
735 // File: erc721a/contracts/IERC721A.sol
736 
737 
738 // ERC721A Contracts v3.3.0
739 // Creator: Chiru Labs
740 
741 pragma solidity ^0.8.4;
742 
743 
744 
745 /**
746  * @dev Interface of an ERC721A compliant contract.
747  */
748 interface IERC721A is IERC721, IERC721Metadata {
749     /**
750      * The caller must own the token or be an approved operator.
751      */
752     error ApprovalCallerNotOwnerNorApproved();
753 
754     /**
755      * The token does not exist.
756      */
757     error ApprovalQueryForNonexistentToken();
758 
759     /**
760      * The caller cannot approve to their own address.
761      */
762     error ApproveToCaller();
763 
764     /**
765      * The caller cannot approve to the current owner.
766      */
767     error ApprovalToCurrentOwner();
768 
769     /**
770      * Cannot query the balance for the zero address.
771      */
772     error BalanceQueryForZeroAddress();
773 
774     /**
775      * Cannot mint to the zero address.
776      */
777     error MintToZeroAddress();
778 
779     /**
780      * The quantity of tokens minted must be more than zero.
781      */
782     error MintZeroQuantity();
783 
784     /**
785      * The token does not exist.
786      */
787     error OwnerQueryForNonexistentToken();
788 
789     /**
790      * The caller must own the token or be an approved operator.
791      */
792     error TransferCallerNotOwnerNorApproved();
793 
794     /**
795      * The token must be owned by `from`.
796      */
797     error TransferFromIncorrectOwner();
798 
799     /**
800      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
801      */
802     error TransferToNonERC721ReceiverImplementer();
803 
804     /**
805      * Cannot transfer to the zero address.
806      */
807     error TransferToZeroAddress();
808 
809     /**
810      * The token does not exist.
811      */
812     error URIQueryForNonexistentToken();
813 
814     // Compiler will pack this into a single 256bit word.
815     struct TokenOwnership {
816         // The address of the owner.
817         address addr;
818         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
819         uint64 startTimestamp;
820         // Whether the token has been burned.
821         bool burned;
822     }
823 
824     // Compiler will pack this into a single 256bit word.
825     struct AddressData {
826         // Realistically, 2**64-1 is more than enough.
827         uint64 balance;
828         // Keeps track of mint count with minimal overhead for tokenomics.
829         uint64 numberMinted;
830         // Keeps track of burn count with minimal overhead for tokenomics.
831         uint64 numberBurned;
832         // For miscellaneous variable(s) pertaining to the address
833         // (e.g. number of whitelist mint slots used).
834         // If there are multiple variables, please pack them into a uint64.
835         uint64 aux;
836     }
837 
838     /**
839      * @dev Returns the total amount of tokens stored by the contract.
840      * 
841      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
842      */
843     function totalSupply() external view returns (uint256);
844 }
845 
846 // File: erc721a/contracts/ERC721A.sol
847 
848 
849 // ERC721A Contracts v3.3.0
850 // Creator: Chiru Labs
851 
852 pragma solidity ^0.8.4;
853 
854 
855 
856 
857 
858 
859 
860 /**
861  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
862  * the Metadata extension. Built to optimize for lower gas during batch mints.
863  *
864  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
865  *
866  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
867  *
868  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
869  */
870 contract ERC721A is Context, ERC165, IERC721A {
871     using Address for address;
872     using Strings for uint256;
873 
874     // The tokenId of the next token to be minted.
875     uint256 internal _currentIndex;
876 
877     // The number of tokens burned.
878     uint256 internal _burnCounter;
879 
880     // Token name
881     string private _name;
882 
883     // Token symbol
884     string private _symbol;
885 
886     // Mapping from token ID to ownership details
887     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
888     mapping(uint256 => TokenOwnership) internal _ownerships;
889 
890     // Mapping owner address to address data
891     mapping(address => AddressData) private _addressData;
892 
893     // Mapping from token ID to approved address
894     mapping(uint256 => address) private _tokenApprovals;
895 
896     // Mapping from owner to operator approvals
897     mapping(address => mapping(address => bool)) private _operatorApprovals;
898 
899     constructor(string memory name_, string memory symbol_) {
900         _name = name_;
901         _symbol = symbol_;
902         _currentIndex = _startTokenId();
903     }
904 
905     /**
906      * To change the starting tokenId, please override this function.
907      */
908     function _startTokenId() internal view virtual returns (uint256) {
909         return 0;
910     }
911 
912     /**
913      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
914      */
915     function totalSupply() public view override returns (uint256) {
916         // Counter underflow is impossible as _burnCounter cannot be incremented
917         // more than _currentIndex - _startTokenId() times
918         unchecked {
919             return _currentIndex - _burnCounter - _startTokenId();
920         }
921     }
922 
923     /**
924      * Returns the total amount of tokens minted in the contract.
925      */
926     function _totalMinted() internal view returns (uint256) {
927         // Counter underflow is impossible as _currentIndex does not decrement,
928         // and it is initialized to _startTokenId()
929         unchecked {
930             return _currentIndex - _startTokenId();
931         }
932     }
933 
934     /**
935      * @dev See {IERC165-supportsInterface}.
936      */
937     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
938         return
939             interfaceId == type(IERC721).interfaceId ||
940             interfaceId == type(IERC721Metadata).interfaceId ||
941             super.supportsInterface(interfaceId);
942     }
943 
944     /**
945      * @dev See {IERC721-balanceOf}.
946      */
947     function balanceOf(address owner) public view override returns (uint256) {
948         if (owner == address(0)) revert BalanceQueryForZeroAddress();
949         return uint256(_addressData[owner].balance);
950     }
951 
952     /**
953      * Returns the number of tokens minted by `owner`.
954      */
955     function _numberMinted(address owner) internal view returns (uint256) {
956         return uint256(_addressData[owner].numberMinted);
957     }
958 
959     /**
960      * Returns the number of tokens burned by or on behalf of `owner`.
961      */
962     function _numberBurned(address owner) internal view returns (uint256) {
963         return uint256(_addressData[owner].numberBurned);
964     }
965 
966     /**
967      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
968      */
969     function _getAux(address owner) internal view returns (uint64) {
970         return _addressData[owner].aux;
971     }
972 
973     /**
974      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
975      * If there are multiple variables, please pack them into a uint64.
976      */
977     function _setAux(address owner, uint64 aux) internal {
978         _addressData[owner].aux = aux;
979     }
980 
981     /**
982      * Gas spent here starts off proportional to the maximum mint batch size.
983      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
984      */
985     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
986         uint256 curr = tokenId;
987 
988         unchecked {
989             if (_startTokenId() <= curr) if (curr < _currentIndex) {
990                 TokenOwnership memory ownership = _ownerships[curr];
991                 if (!ownership.burned) {
992                     if (ownership.addr != address(0)) {
993                         return ownership;
994                     }
995                     // Invariant:
996                     // There will always be an ownership that has an address and is not burned
997                     // before an ownership that does not have an address and is not burned.
998                     // Hence, curr will not underflow.
999                     while (true) {
1000                         curr--;
1001                         ownership = _ownerships[curr];
1002                         if (ownership.addr != address(0)) {
1003                             return ownership;
1004                         }
1005                     }
1006                 }
1007             }
1008         }
1009         revert OwnerQueryForNonexistentToken();
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-ownerOf}.
1014      */
1015     function ownerOf(uint256 tokenId) public view override returns (address) {
1016         return _ownershipOf(tokenId).addr;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-name}.
1021      */
1022     function name() public view virtual override returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Metadata-symbol}.
1028      */
1029     function symbol() public view virtual override returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Metadata-tokenURI}.
1035      */
1036     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1037         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1038 
1039         string memory baseURI = _baseURI();
1040         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")): "";
1041     }
1042 
1043     /**
1044      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1045      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1046      * by default, can be overriden in child contracts.
1047      */
1048     function _baseURI() internal view virtual returns (string memory) {
1049         return '';
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-approve}.
1054      */
1055     function approve(address to, uint256 tokenId) public override {
1056         address owner = ERC721A.ownerOf(tokenId);
1057         if (to == owner) revert ApprovalToCurrentOwner();
1058 
1059         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1060             revert ApprovalCallerNotOwnerNorApproved();
1061         }
1062 
1063         _approve(to, tokenId, owner);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-getApproved}.
1068      */
1069     function getApproved(uint256 tokenId) public view override returns (address) {
1070         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1071 
1072         return _tokenApprovals[tokenId];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-setApprovalForAll}.
1077      */
1078     function setApprovalForAll(address operator, bool approved) public virtual override {
1079         if (operator == _msgSender()) revert ApproveToCaller();
1080 
1081         _operatorApprovals[_msgSender()][operator] = approved;
1082         emit ApprovalForAll(_msgSender(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-isApprovedForAll}.
1087      */
1088     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1089         return _operatorApprovals[owner][operator];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-transferFrom}.
1094      */
1095     function transferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         safeTransferFrom(from, to, tokenId, '');
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public virtual override {
1123         _transfer(from, to, tokenId);
1124         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1125             revert TransferToNonERC721ReceiverImplementer();
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns whether `tokenId` exists.
1131      *
1132      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1133      *
1134      * Tokens start existing when they are minted (`_mint`),
1135      */
1136     function _exists(uint256 tokenId) internal view returns (bool) {
1137         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1138     }
1139 
1140     /**
1141      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1142      */
1143     function _safeMint(address to, uint256 quantity) internal {
1144         _safeMint(to, quantity, '');
1145     }
1146 
1147     /**
1148      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - If `to` refers to a smart contract, it must implement
1153      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1154      * - `quantity` must be greater than 0.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeMint(
1159         address to,
1160         uint256 quantity,
1161         bytes memory _data
1162     ) internal {
1163         uint256 startTokenId = _currentIndex;
1164         if (to == address(0)) revert MintToZeroAddress();
1165         if (quantity == 0) revert MintZeroQuantity();
1166 
1167         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1168 
1169         // Overflows are incredibly unrealistic.
1170         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1171         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1172         unchecked {
1173             _addressData[to].balance += uint64(quantity);
1174             _addressData[to].numberMinted += uint64(quantity);
1175 
1176             _ownerships[startTokenId].addr = to;
1177             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1178 
1179             uint256 updatedIndex = startTokenId;
1180             uint256 end = updatedIndex + quantity;
1181 
1182             if (to.isContract()) {
1183                 do {
1184                     emit Transfer(address(0), to, updatedIndex);
1185                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1186                         revert TransferToNonERC721ReceiverImplementer();
1187                     }
1188                 } while (updatedIndex < end);
1189                 // Reentrancy protection
1190                 if (_currentIndex != startTokenId) revert();
1191             } else {
1192                 do {
1193                     emit Transfer(address(0), to, updatedIndex++);
1194                 } while (updatedIndex < end);
1195             }
1196             _currentIndex = updatedIndex;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     /**
1202      * @dev Mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `quantity` must be greater than 0.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _mint(address to, uint256 quantity) internal {
1212         uint256 startTokenId = _currentIndex;
1213         if (to == address(0)) revert MintToZeroAddress();
1214         if (quantity == 0) revert MintZeroQuantity();
1215 
1216         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1217 
1218         // Overflows are incredibly unrealistic.
1219         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1220         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1221         unchecked {
1222             _addressData[to].balance += uint64(quantity);
1223             _addressData[to].numberMinted += uint64(quantity);
1224 
1225             _ownerships[startTokenId].addr = to;
1226             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1227 
1228             uint256 updatedIndex = startTokenId;
1229             uint256 end = updatedIndex + quantity;
1230 
1231             do {
1232                 emit Transfer(address(0), to, updatedIndex++);
1233             } while (updatedIndex < end);
1234 
1235             _currentIndex = updatedIndex;
1236         }
1237         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1238     }
1239 
1240     /**
1241      * @dev Transfers `tokenId` from `from` to `to`.
1242      *
1243      * Requirements:
1244      *
1245      * - `to` cannot be the zero address.
1246      * - `tokenId` token must be owned by `from`.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _transfer(
1251         address from,
1252         address to,
1253         uint256 tokenId
1254     ) private {
1255         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1256 
1257         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1258 
1259         bool isApprovedOrOwner = (_msgSender() == from ||
1260             isApprovedForAll(from, _msgSender()) ||
1261             getApproved(tokenId) == _msgSender());
1262 
1263         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1264         if (to == address(0)) revert TransferToZeroAddress();
1265 
1266         _beforeTokenTransfers(from, to, tokenId, 1);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId, from);
1270 
1271         // Underflow of the sender's balance is impossible because we check for
1272         // ownership above and the recipient's balance can't realistically overflow.
1273         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1274         unchecked {
1275             _addressData[from].balance -= 1;
1276             _addressData[to].balance += 1;
1277 
1278             TokenOwnership storage currSlot = _ownerships[tokenId];
1279             currSlot.addr = to;
1280             currSlot.startTimestamp = uint64(block.timestamp);
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1286             if (nextSlot.addr == address(0)) {
1287                 // This will suffice for checking _exists(nextTokenId),
1288                 // as a burned slot cannot contain the zero address.
1289                 if (nextTokenId != _currentIndex) {
1290                     nextSlot.addr = from;
1291                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, to, tokenId);
1297         _afterTokenTransfers(from, to, tokenId, 1);
1298     }
1299 
1300     /**
1301      * @dev Equivalent to `_burn(tokenId, false)`.
1302      */
1303     function _burn(uint256 tokenId) internal virtual {
1304         _burn(tokenId, false);
1305     }
1306 
1307     /**
1308      * @dev Destroys `tokenId`.
1309      * The approval is cleared when the token is burned.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1318         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1319 
1320         address from = prevOwnership.addr;
1321 
1322         if (approvalCheck) {
1323             bool isApprovedOrOwner = (_msgSender() == from ||
1324                 isApprovedForAll(from, _msgSender()) ||
1325                 getApproved(tokenId) == _msgSender());
1326 
1327             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1328         }
1329 
1330         _beforeTokenTransfers(from, address(0), tokenId, 1);
1331 
1332         // Clear approvals from the previous owner
1333         _approve(address(0), tokenId, from);
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1338         unchecked {
1339             AddressData storage addressData = _addressData[from];
1340             addressData.balance -= 1;
1341             addressData.numberBurned += 1;
1342 
1343             // Keep track of who burned the token, and the timestamp of burning.
1344             TokenOwnership storage currSlot = _ownerships[tokenId];
1345             currSlot.addr = from;
1346             currSlot.startTimestamp = uint64(block.timestamp);
1347             currSlot.burned = true;
1348 
1349             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1350             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1351             uint256 nextTokenId = tokenId + 1;
1352             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1353             if (nextSlot.addr == address(0)) {
1354                 // This will suffice for checking _exists(nextTokenId),
1355                 // as a burned slot cannot contain the zero address.
1356                 if (nextTokenId != _currentIndex) {
1357                     nextSlot.addr = from;
1358                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1359                 }
1360             }
1361         }
1362 
1363         emit Transfer(from, address(0), tokenId);
1364         _afterTokenTransfers(from, address(0), tokenId, 1);
1365 
1366         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1367         unchecked {
1368             _burnCounter++;
1369         }
1370     }
1371 
1372     /**
1373      * @dev Approve `to` to operate on `tokenId`
1374      *
1375      * Emits a {Approval} event.
1376      */
1377     function _approve(
1378         address to,
1379         uint256 tokenId,
1380         address owner
1381     ) private {
1382         _tokenApprovals[tokenId] = to;
1383         emit Approval(owner, to, tokenId);
1384     }
1385 
1386     /**
1387      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1388      *
1389      * @param from address representing the previous owner of the given token ID
1390      * @param to target address that will receive the tokens
1391      * @param tokenId uint256 ID of the token to be transferred
1392      * @param _data bytes optional data to send along with the call
1393      * @return bool whether the call correctly returned the expected magic value
1394      */
1395     function _checkContractOnERC721Received(
1396         address from,
1397         address to,
1398         uint256 tokenId,
1399         bytes memory _data
1400     ) private returns (bool) {
1401         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1402             return retval == IERC721Receiver(to).onERC721Received.selector;
1403         } catch (bytes memory reason) {
1404             if (reason.length == 0) {
1405                 revert TransferToNonERC721ReceiverImplementer();
1406             } else {
1407                 assembly {
1408                     revert(add(32, reason), mload(reason))
1409                 }
1410             }
1411         }
1412     }
1413 
1414     /**
1415      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1416      * And also called before burning one token.
1417      *
1418      * startTokenId - the first token id to be transferred
1419      * quantity - the amount to be transferred
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` will be minted for `to`.
1426      * - When `to` is zero, `tokenId` will be burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _beforeTokenTransfers(
1430         address from,
1431         address to,
1432         uint256 startTokenId,
1433         uint256 quantity
1434     ) internal virtual {}
1435 
1436     /**
1437      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1438      * minting.
1439      * And also called after one token has been burned.
1440      *
1441      * startTokenId - the first token id to be transferred
1442      * quantity - the amount to be transferred
1443      *
1444      * Calling conditions:
1445      *
1446      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1447      * transferred to `to`.
1448      * - When `from` is zero, `tokenId` has been minted for `to`.
1449      * - When `to` is zero, `tokenId` has been burned by `from`.
1450      * - `from` and `to` are never both zero.
1451      */
1452     function _afterTokenTransfers(
1453         address from,
1454         address to,
1455         uint256 startTokenId,
1456         uint256 quantity
1457     ) internal virtual {}
1458 }
1459 
1460 // File: contracts/gtburgers.sol
1461 
1462 
1463 
1464 pragma solidity ^0.8.4;
1465 
1466 
1467 
1468 
1469 contract FerretFlightClub is ERC721A, Ownable, ReentrancyGuard {
1470     using Strings for uint256;
1471 
1472     uint256 public PRICE;
1473     uint256 public MAX_SUPPLY;
1474     string private BASE_URI;
1475     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1476     uint256 public MAX_MINT_AMOUNT_PER_TX;
1477     bool public IS_SALE_ACTIVE;
1478     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1479     bool public METADATA_FROZEN;
1480 
1481     mapping(address => uint256) private freeMintCountMap;
1482 
1483     constructor(
1484         uint256 price,
1485         uint256 maxSupply,
1486         string memory baseUri,
1487         uint256 freeMintAllowance,
1488         uint256 maxMintPerTx,
1489         bool isSaleActive,
1490         uint256 freeMintIsAllowedUntil
1491     ) ERC721A("FerretFlightClub", "FFC") {
1492         PRICE = price;
1493         MAX_SUPPLY = maxSupply;
1494         BASE_URI = baseUri;
1495         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1496         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1497         IS_SALE_ACTIVE = isSaleActive;
1498         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1499     }
1500 
1501     /** FREE MINT **/
1502 
1503     function updateFreeMintCount(address minter, uint256 count) private {
1504         freeMintCountMap[minter] += count;
1505     }
1506 
1507     /** GETTERS **/
1508 
1509     function _baseURI() internal view virtual override returns (string memory) {
1510         return BASE_URI;
1511     }
1512 
1513     /** SETTERS **/
1514 
1515     function setPrice(uint256 customPrice) external onlyOwner {
1516         PRICE = customPrice;
1517     }
1518 
1519     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1520         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1521         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1522         MAX_SUPPLY = newMaxSupply;
1523     }
1524 
1525     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1526         require(!METADATA_FROZEN, "Metadata frozen!");
1527         BASE_URI = customBaseURI_;
1528     }
1529 
1530     function setFreeMintAllowance(uint256 freeMintAllowance)
1531         external
1532         onlyOwner
1533     {
1534         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1535     }
1536 
1537     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1538         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1539     }
1540 
1541     function setSaleActive(bool saleIsActive) external onlyOwner {
1542         IS_SALE_ACTIVE = saleIsActive;
1543     }
1544 
1545     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1546         external
1547         onlyOwner
1548     {
1549         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1550     }
1551 
1552     function freezeMetadata() external onlyOwner {
1553         METADATA_FROZEN = true;
1554     }
1555 
1556     /** MINT **/
1557 
1558     modifier mintCompliance(uint256 _mintAmount) {
1559         require(
1560             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1561             "Invalid mint amount!"
1562         );
1563         require(
1564             _currentIndex + _mintAmount <= MAX_SUPPLY,
1565             "Max supply exceeded!"
1566         );
1567         _;
1568     }
1569 
1570     function mint(uint256 _mintAmount)
1571         public
1572         payable
1573         mintCompliance(_mintAmount)
1574     {
1575         require(IS_SALE_ACTIVE, "Sale is not active!");
1576 
1577         uint256 price = PRICE * _mintAmount;
1578 
1579         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1580             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1581                 freeMintCountMap[msg.sender];
1582             if (remainingFreeMint > 0) {
1583                 if (_mintAmount >= remainingFreeMint) {
1584                     price -= remainingFreeMint * PRICE;
1585                     updateFreeMintCount(msg.sender, remainingFreeMint);
1586                 } else {
1587                     price -= _mintAmount * PRICE;
1588                     updateFreeMintCount(msg.sender, _mintAmount);
1589                 }
1590             }
1591         }
1592 
1593         require(msg.value >= price, "Insufficient funds!");
1594 
1595         _safeMint(msg.sender, _mintAmount);
1596     }
1597 
1598     function mintOwner(address _to, uint256 _mintAmount)
1599         public
1600         mintCompliance(_mintAmount)
1601         onlyOwner
1602     {
1603         _safeMint(_to, _mintAmount);
1604     }
1605 
1606     /** PAYOUT **/
1607 
1608     address private constant payoutAddress1 =
1609         0x1c74936Ef23CE582f18ed1e3E6999634b38bB892;
1610 
1611     function withdraw() public onlyOwner nonReentrant {
1612         uint256 balance = address(this).balance;
1613         Address.sendValue(payable(payoutAddress1), balance / 1);
1614     }
1615 }