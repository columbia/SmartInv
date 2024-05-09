1 // SPDX-License-Identifier: MIT
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
24  
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
68 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
72 
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev String operations.
82  */
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
88      */
89     function toString(uint256 value) internal pure returns (string memory) {
90         // Inspired by OraclizeAPI's implementation - MIT licence
91         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
92 
93         if (value == 0) {
94             return "0";
95         }
96         uint256 temp = value;
97         uint256 digits;
98         while (temp != 0) {
99             digits++;
100             temp /= 10;
101         }
102         bytes memory buffer = new bytes(digits);
103         while (value != 0) {
104             digits -= 1;
105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
106             value /= 10;
107         }
108         return string(buffer);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
113      */
114     function toHexString(uint256 value) internal pure returns (string memory) {
115         if (value == 0) {
116             return "0x00";
117         }
118         uint256 temp = value;
119         uint256 length = 0;
120         while (temp != 0) {
121             length++;
122             temp >>= 8;
123         }
124         return toHexString(value, length);
125     }
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
129      */
130     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
131         bytes memory buffer = new bytes(2 * length + 2);
132         buffer[0] = "0";
133         buffer[1] = "x";
134         for (uint256 i = 2 * length + 1; i > 1; --i) {
135             buffer[i] = _HEX_SYMBOLS[value & 0xf];
136             value >>= 4;
137         }
138         require(value == 0, "Strings: hex length insufficient");
139         return string(buffer);
140     }
141 }
142 
143 // File: @openzeppelin/contracts/utils/Context.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 // File: @openzeppelin/contracts/access/Ownable.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Contract module which provides a basic access control mechanism, where
180  * there is an account (an owner) that can be granted exclusive access to
181  * specific functions.
182  *
183  * By default, the owner account will be the one that deploys the contract. This
184  * can later be changed with {transferOwnership}.
185  *
186  * This module is used through inheritance. It will make available the modifier
187  * `onlyOwner`, which can be applied to your functions to restrict their use to
188  * the owner.
189  */
190 abstract contract Ownable is Context {
191     address private _owner;
192 
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195     /**
196      * @dev Initializes the contract setting the deployer as the initial owner.
197      */
198     constructor() {
199         _transferOwnership(_msgSender());
200     }
201 
202     /**
203      * @dev Returns the address of the current owner.
204      */
205     function owner() public view virtual returns (address) {
206         return _owner;
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner.
211      */
212     modifier onlyOwner() {
213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216 
217     /**
218      * @dev Leaves the contract without owner. It will not be possible to call
219      * `onlyOwner` functions anymore. Can only be called by the current owner.
220      *
221      * NOTE: Renouncing ownership will leave the contract without an owner,
222      * thereby removing any functionality that is only available to the owner.
223      */
224     function renounceOwnership() public virtual onlyOwner {
225         _transferOwnership(address(0));
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Can only be called by the current owner.
231      */
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(newOwner != address(0), "Ownable: new owner is the zero address");
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Internal function without access restriction.
240      */
241     function _transferOwnership(address newOwner) internal virtual {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on `isContract` to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * ```solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * ```
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Required interface of an ERC721 compliant contract.
572  */
573 interface IERC721 is IERC165 {
574     /**
575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
576      */
577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
581      */
582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
586      */
587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
588 
589     /**
590      * @dev Returns the number of tokens in ``owner``'s account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must exist and be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId,
620         bytes calldata data
621     ) external;
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
625      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Transfers `tokenId` token from `from` to `to`.
645      *
646      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must be owned by `from`.
653      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
665      * The approval is cleared when the token is transferred.
666      *
667      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
668      *
669      * Requirements:
670      *
671      * - The caller must own the token or be an approved operator.
672      * - `tokenId` must exist.
673      *
674      * Emits an {Approval} event.
675      */
676     function approve(address to, uint256 tokenId) external;
677 
678     /**
679      * @dev Approve or remove `operator` as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The `operator` cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns the account approved for `tokenId` token.
692      *
693      * Requirements:
694      *
695      * - `tokenId` must exist.
696      */
697     function getApproved(uint256 tokenId) external view returns (address operator);
698 
699     /**
700      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
701      *
702      * See {setApprovalForAll}
703      */
704     function isApprovedForAll(address owner, address operator) external view returns (bool);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Metadata is IERC721 {
720     /**
721      * @dev Returns the token collection name.
722      */
723     function name() external view returns (string memory);
724 
725     /**
726      * @dev Returns the token collection symbol.
727      */
728     function symbol() external view returns (string memory);
729 
730     /**
731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
732      */
733     function tokenURI(uint256 tokenId) external view returns (string memory);
734 }
735 
736 // File: ERC721A.sol
737 
738 
739 // Creator: Chiru Labs
740 
741 pragma solidity ^0.8.4;
742 
743 
744 
745 
746 
747 
748 
749 
750 error ApprovalCallerNotOwnerNorApproved();
751 error ApprovalQueryForNonexistentToken();
752 error ApproveToCaller();
753 error ApprovalToCurrentOwner();
754 error BalanceQueryForZeroAddress();
755 error MintToZeroAddress();
756 error MintZeroQuantity();
757 error OwnerQueryForNonexistentToken();
758 error TransferCallerNotOwnerNorApproved();
759 error TransferFromIncorrectOwner();
760 error TransferToNonERC721ReceiverImplementer();
761 error TransferToZeroAddress();
762 error URIQueryForNonexistentToken();
763 
764 /**
765  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
766  * the Metadata extension. Built to optimize for lower gas during batch mints.
767  *
768  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
769  *
770  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
771  *
772  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
773  */
774 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
775     using Address for address;
776     using Strings for uint256;
777 
778     // Compiler will pack this into a single 256bit word.
779     struct TokenOwnership {
780         // The address of the owner.
781         address addr;
782         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
783         uint64 startTimestamp;
784         // Whether the token has been burned.
785         bool burned;
786     }
787 
788     // Compiler will pack this into a single 256bit word.
789     struct AddressData {
790         // Realistically, 2**64-1 is more than enough.
791         uint64 balance;
792         // Keeps track of mint count with minimal overhead for tokenomics.
793         uint64 numberMinted;
794         // Keeps track of burn count with minimal overhead for tokenomics.
795         uint64 numberBurned;
796         // For miscellaneous variable(s) pertaining to the address
797         // (e.g. number of whitelist mint slots used).
798         // If there are multiple variables, please pack them into a uint64.
799         uint64 aux;
800     }
801 
802     // The tokenId of the next token to be minted.
803     uint256 internal _currentIndex;
804 
805     // The number of tokens burned.
806     uint256 internal _burnCounter;
807 
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     // Mapping from token ID to ownership details
815     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
816     mapping(uint256 => TokenOwnership) internal _ownerships;
817 
818     // Mapping owner address to address data
819     mapping(address => AddressData) private _addressData;
820 
821     // Mapping from token ID to approved address
822     mapping(uint256 => address) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     constructor(string memory name_, string memory symbol_) {
828         _name = name_;
829         _symbol = symbol_;
830         _currentIndex = _startTokenId();
831     }
832 
833     /**
834      * To change the starting tokenId, please override this function.
835      */
836     function _startTokenId() internal view virtual returns (uint256) {
837         return 1;
838     }
839 
840     /**
841      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
842      */
843     function totalSupply() public view returns (uint256) {
844         // Counter underflow is impossible as _burnCounter cannot be incremented
845         // more than _currentIndex - _startTokenId() times
846         unchecked {
847             return _currentIndex - _burnCounter - _startTokenId();
848         }
849     }
850 
851     /**
852      * Returns the total amount of tokens minted in the contract.
853      */
854     function _totalMinted() internal view returns (uint256) {
855         // Counter underflow is impossible as _currentIndex does not decrement,
856         // and it is initialized to _startTokenId()
857         unchecked {
858             return _currentIndex - _startTokenId();
859         }
860     }
861 
862     /**
863      * @dev See {IERC165-supportsInterface}.
864      */
865     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
866         return
867             interfaceId == type(IERC721).interfaceId ||
868             interfaceId == type(IERC721Metadata).interfaceId ||
869             super.supportsInterface(interfaceId);
870     }
871 
872     /**
873      * @dev See {IERC721-balanceOf}.
874      */
875     function balanceOf(address owner) public view override returns (uint256) {
876         if (owner == address(0)) revert BalanceQueryForZeroAddress();
877         return uint256(_addressData[owner].balance);
878     }
879 
880     /**
881      * Returns the number of tokens minted by `owner`.
882      */
883     function _numberMinted(address owner) internal view returns (uint256) {
884         return uint256(_addressData[owner].numberMinted);
885     }
886 
887     /**
888      * Returns the number of tokens burned by or on behalf of `owner`.
889      */
890     function _numberBurned(address owner) internal view returns (uint256) {
891         return uint256(_addressData[owner].numberBurned);
892     }
893 
894     /**
895      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
896      */
897     function _getAux(address owner) internal view returns (uint64) {
898         return _addressData[owner].aux;
899     }
900 
901     /**
902      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      * If there are multiple variables, please pack them into a uint64.
904      */
905     function _setAux(address owner, uint64 aux) internal {
906         _addressData[owner].aux = aux;
907     }
908 
909     /**
910      * Gas spent here starts off proportional to the maximum mint batch size.
911      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
912      */
913     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
914         uint256 curr = tokenId;
915 
916         unchecked {
917             if (_startTokenId() <= curr && curr < _currentIndex) {
918                 TokenOwnership memory ownership = _ownerships[curr];
919                 if (!ownership.burned) {
920                     if (ownership.addr != address(0)) {
921                         return ownership;
922                     }
923                     // Invariant:
924                     // There will always be an ownership that has an address and is not burned
925                     // before an ownership that does not have an address and is not burned.
926                     // Hence, curr will not underflow.
927                     while (true) {
928                         curr--;
929                         ownership = _ownerships[curr];
930                         if (ownership.addr != address(0)) {
931                             return ownership;
932                         }
933                     }
934                 }
935             }
936         }
937         revert OwnerQueryForNonexistentToken();
938     }
939 
940     /**
941      * @dev See {IERC721-ownerOf}.
942      */
943     function ownerOf(uint256 tokenId) public view override returns (address) {
944         return _ownershipOf(tokenId).addr;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-name}.
949      */
950     function name() public view virtual override returns (string memory) {
951         return _name;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-symbol}.
956      */
957     function symbol() public view virtual override returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-tokenURI}.
963      */
964     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
965         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
966 
967         string memory baseURI = _baseURI();
968         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
969     }
970 
971     /**
972      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974      * by default, can be overriden in child contracts.
975      */
976     function _baseURI() internal view virtual returns (string memory) {
977         return '';
978     }
979 
980     /**
981      * @dev See {IERC721-approve}.
982      */
983     function approve(address to, uint256 tokenId) public override {
984         address owner = ERC721A.ownerOf(tokenId);
985         if (to == owner) revert ApprovalToCurrentOwner();
986 
987         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
988             revert ApprovalCallerNotOwnerNorApproved();
989         }
990 
991         _approve(to, tokenId, owner);
992     }
993 
994     /**
995      * @dev See {IERC721-getApproved}.
996      */
997     function getApproved(uint256 tokenId) public view override returns (address) {
998         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
999 
1000         return _tokenApprovals[tokenId];
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-setApprovalForAll}.
1005      */
1006     function setApprovalForAll(address operator, bool approved) public virtual override {
1007         if (operator == _msgSender()) revert ApproveToCaller();
1008 
1009         _operatorApprovals[_msgSender()][operator] = approved;
1010         emit ApprovalForAll(_msgSender(), operator, approved);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-isApprovedForAll}.
1015      */
1016     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1017         return _operatorApprovals[owner][operator];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-transferFrom}.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         _transfer(from, to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         safeTransferFrom(from, to, tokenId, '');
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) public virtual override {
1051         _transfer(from, to, tokenId);
1052         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1053             revert TransferToNonERC721ReceiverImplementer();
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns whether `tokenId` exists.
1059      *
1060      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061      *
1062      * Tokens start existing when they are minted (`_mint`),
1063      */
1064     function _exists(uint256 tokenId) internal view returns (bool) {
1065         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1066     }
1067 
1068     function _safeMint(address to, uint256 quantity) internal {
1069         _safeMint(to, quantity, '');
1070     }
1071 
1072     /**
1073      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data
1086     ) internal {
1087         _mint(to, quantity, _data, true);
1088     }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _mint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data,
1104         bool safe
1105     ) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109 
1110         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1111 
1112         // Overflows are incredibly unrealistic.
1113         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1114         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1115         unchecked {
1116             _addressData[to].balance += uint64(quantity);
1117             _addressData[to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[startTokenId].addr = to;
1120             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (safe && to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Transfers `tokenId` from `from` to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) private {
1159         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1160 
1161         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1162 
1163         bool isApprovedOrOwner = (_msgSender() == from ||
1164             isApprovedForAll(from, _msgSender()) ||
1165             getApproved(tokenId) == _msgSender());
1166 
1167         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId, from);
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             _addressData[from].balance -= 1;
1180             _addressData[to].balance += 1;
1181 
1182             TokenOwnership storage currSlot = _ownerships[tokenId];
1183             currSlot.addr = to;
1184             currSlot.startTimestamp = uint64(block.timestamp);
1185 
1186             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1187             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1188             uint256 nextTokenId = tokenId + 1;
1189             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1190             if (nextSlot.addr == address(0)) {
1191                 // This will suffice for checking _exists(nextTokenId),
1192                 // as a burned slot cannot contain the zero address.
1193                 if (nextTokenId != _currentIndex) {
1194                     nextSlot.addr = from;
1195                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1196                 }
1197             }
1198         }
1199 
1200         emit Transfer(from, to, tokenId);
1201         _afterTokenTransfers(from, to, tokenId, 1);
1202     }
1203 
1204     /**
1205      * @dev This is equivalent to _burn(tokenId, false)
1206      */
1207     function _burn(uint256 tokenId) internal virtual {
1208         _burn(tokenId, false);
1209     }
1210 
1211     /**
1212      * @dev Destroys `tokenId`.
1213      * The approval is cleared when the token is burned.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1222         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1223 
1224         address from = prevOwnership.addr;
1225 
1226         if (approvalCheck) {
1227             bool isApprovedOrOwner = (_msgSender() == from ||
1228                 isApprovedForAll(from, _msgSender()) ||
1229                 getApproved(tokenId) == _msgSender());
1230 
1231             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1232         }
1233 
1234         _beforeTokenTransfers(from, address(0), tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, from);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             AddressData storage addressData = _addressData[from];
1244             addressData.balance -= 1;
1245             addressData.numberBurned += 1;
1246 
1247             // Keep track of who burned the token, and the timestamp of burning.
1248             TokenOwnership storage currSlot = _ownerships[tokenId];
1249             currSlot.addr = from;
1250             currSlot.startTimestamp = uint64(block.timestamp);
1251             currSlot.burned = true;
1252 
1253             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1254             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1255             uint256 nextTokenId = tokenId + 1;
1256             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1257             if (nextSlot.addr == address(0)) {
1258                 // This will suffice for checking _exists(nextTokenId),
1259                 // as a burned slot cannot contain the zero address.
1260                 if (nextTokenId != _currentIndex) {
1261                     nextSlot.addr = from;
1262                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(from, address(0), tokenId);
1268         _afterTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1271         unchecked {
1272             _burnCounter++;
1273         }
1274     }
1275 
1276     /**
1277      * @dev Approve `to` to operate on `tokenId`
1278      *
1279      * Emits a {Approval} event.
1280      */
1281     function _approve(
1282         address to,
1283         uint256 tokenId,
1284         address owner
1285     ) private {
1286         _tokenApprovals[tokenId] = to;
1287         emit Approval(owner, to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkContractOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1306             return retval == IERC721Receiver(to).onERC721Received.selector;
1307         } catch (bytes memory reason) {
1308             if (reason.length == 0) {
1309                 revert TransferToNonERC721ReceiverImplementer();
1310             } else {
1311                 assembly {
1312                     revert(add(32, reason), mload(reason))
1313                 }
1314             }
1315         }
1316     }
1317 
1318     /**
1319      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1320      * And also called before burning one token.
1321      *
1322      * startTokenId - the first token id to be transferred
1323      * quantity - the amount to be transferred
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, `tokenId` will be burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _beforeTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 
1340     /**
1341      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1342      * minting.
1343      * And also called after one token has been burned.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` has been minted for `to`.
1353      * - When `to` is zero, `tokenId` has been burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _afterTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 }
1363 // File: Contract.sol
1364 
1365 
1366 pragma solidity ^0.8.7;
1367 
1368 
1369 
1370 
1371 contract Aoki is ERC721A, Ownable, ReentrancyGuard {
1372     using Strings for uint256;
1373     mapping(address => uint256) public publicClaimed;
1374 
1375     string public baseURI;
1376     string public hiddenMetadataURI;
1377 
1378     uint256 public publicCost = 0.0035 ether;
1379 
1380     bool public paused = true;
1381     bool public revealed;
1382 
1383     uint256 public maxPublic = 10;
1384     uint256 public maxSupply = 7500;
1385 
1386     constructor() ERC721A("Aoki", "AOI") {}
1387 
1388     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1389 
1390     function mint(uint256 quantity) external payable nonReentrant {
1391         require(!paused, "The contract is paused!");
1392 
1393         require(quantity > 0 && totalSupply() + quantity <= maxSupply, "Invalid amount!");
1394 
1395         if (msg.sender != owner()) {
1396             require(
1397             publicClaimed[msg.sender] + quantity <= maxPublic,
1398                 "You're not allowed to mint this much!"
1399             );
1400             require(
1401                 quantity <= maxPublic,
1402                 "You're not allowed to mint more than max Mint Amount!"
1403             );
1404             if(publicClaimed[msg.sender] != 0)
1405                 require(msg.value >= publicCost * quantity, "Insufficient Funds!");
1406             else
1407                 require(msg.value >= publicCost * (quantity - 1), "Innsufficient Funds!");
1408         }
1409         publicClaimed[msg.sender] += quantity;
1410         _safeMint(msg.sender, quantity);
1411     }
1412 
1413     function _baseURI() internal view virtual override returns (string memory) {
1414         return baseURI;
1415     }
1416 
1417 
1418     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1419     function tokenURI(uint256 tokenId)
1420         public
1421         view
1422         virtual
1423         override
1424         returns (string memory)
1425     {
1426         require(
1427             _exists(tokenId),
1428             "ERC721Metadata: URI query for nonexistent token"
1429         );
1430 
1431         if (revealed == false) {
1432             return hiddenMetadataURI;
1433         }
1434 
1435         string memory currentBaseURI = _baseURI();
1436         return
1437             bytes(currentBaseURI).length > 0
1438                 ? string(
1439                     abi.encodePacked(
1440                         currentBaseURI,
1441                         tokenId.toString(),
1442                         ".json"
1443                     )
1444                 )
1445                 : "";
1446     }
1447 
1448     function setCost(uint256 _newPublicCost) external onlyOwner {
1449         publicCost = _newPublicCost;
1450     }
1451  
1452     function setMaxPublic(uint256 _newMaxPublic) external onlyOwner {
1453         maxPublic = _newMaxPublic;
1454     }
1455 
1456     function setMaxSuppy(uint256 _amount) external onlyOwner {
1457         maxSupply = _amount;
1458     }
1459 
1460     function setPaused(bool _state) external onlyOwner {
1461         paused = _state;
1462     }
1463 
1464     function setRevealed(bool _state) external onlyOwner {
1465         revealed = _state;
1466     }
1467 
1468     function setHiddenMetadataURI(string memory _URI) external onlyOwner {
1469         hiddenMetadataURI = _URI;
1470     }
1471 
1472     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1473         baseURI = _newBaseURI;
1474     }
1475 
1476     function airDrop(uint256 quantity, address _address) external onlyOwner {
1477         _safeMint(_address, quantity);
1478     }
1479     function burn(uint256 tokenId) public onlyOwner{
1480         _burn(tokenId);
1481     }
1482     function burnBatch(uint256[] memory tokenIds) public onlyOwner{
1483         for (uint256 index = 0; index < tokenIds.length; index++) {
1484                 _burn(tokenIds[index]);
1485         }
1486     }
1487 
1488     function withdraw() public onlyOwner {
1489          // Do not remove this otherwise you will not be able to withdraw the funds.
1490         // =============================================================================
1491         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
1492         require(ts);
1493         // =============================================================================
1494     }
1495 }